local json = {}
do
	local encode

	local ESCAPE_CHARS = {
		["\\"] = "\\",
		['"'] = '"',
		["\b"] = "b",
		["\f"] = "f",
		["\n"] = "n",
		["\r"] = "r",
		["\t"] = "t",
	}

	local UNESCAPE_CHARS = { ["/"] = "/" }
	for k, v in pairs(ESCAPE_CHARS) do
		UNESCAPE_CHARS[v] = k
	end

	local function escape_char(c)
		return "\\" .. (ESCAPE_CHARS[c] or string.format("u%04x", c:byte()))
	end

	local function encode_nil()
		return "null"
	end
	local function encode_string(v)
		return '"' .. v:gsub('[%z\1-\31\\"]', escape_char) .. '"'
	end
	local function encode_number(v)
		if v ~= v or v <= -math.huge or v >= math.huge then
			error("unexpected number value '" .. tostring(v) .. "'")
		end
		return string.format("%.14g", v)
	end

	local function encode_table(val, stack)
		stack = stack or {}
		if stack[val] then
			error("circular reference")
		end
		stack[val] = true
		local res = {}
		if rawget(val, 1) ~= nil or next(val) == nil then
			local n = 0
			for k in pairs(val) do
				if type(k) ~= "number" then
					error("invalid table: mixed or invalid key types")
				end
				n = n + 1
			end
			if n ~= #val then
				error("invalid table: sparse array")
			end
			for _, v in ipairs(val) do
				table.insert(res, encode(v, stack))
			end
			stack[val] = nil
			return "[" .. table.concat(res, ",") .. "]"
		else
			for k, v in pairs(val) do
				if type(k) ~= "string" then
					error("invalid table: mixed or invalid key types")
				end
				table.insert(res, encode(k, stack) .. ":" .. encode(v, stack))
			end
			stack[val] = nil
			return "{" .. table.concat(res, ",") .. "}"
		end
	end

	local TYPE_ENCODERS = {
		["nil"] = encode_nil,
		["table"] = encode_table,
		["string"] = encode_string,
		["number"] = encode_number,
		["boolean"] = tostring,
	}

	encode = function(val, stack)
		local f = TYPE_ENCODERS[type(val)]
		if f then
			return f(val, stack)
		end
		error("unexpected type '" .. type(val) .. "'")
	end

	function json.encode(val)
		return (encode(val))
	end

	local parse
	local function create_set(...)
		local res = {}
		for i = 1, select("#", ...) do
			res[select(i, ...)] = true
		end
		return res
	end

	local SPACE_CHARS = create_set(" ", "\t", "\r", "\n")
	local DELIM_CHARS = create_set(" ", "\t", "\r", "\n", "]", "}", ",")
	local ESCAPE_VALID = create_set("\\", "/", '"', "b", "f", "n", "r", "t", "u")
	local LITERALS = create_set("true", "false", "null")
	local LITERAL_VALUES = { ["true"] = true, ["false"] = false, ["null"] = nil }

	local function next_char(str, idx, set, negate)
		for i = idx, #str do
			if set[str:sub(i, i)] ~= negate then
				return i
			end
		end
		return #str + 1
	end

	local function decode_error(str, idx, msg)
		local line, col = 1, 1
		for i = 1, idx - 1 do
			col = col + 1
			if str:sub(i, i) == "\n" then
				line = line + 1
				col = 1
			end
		end
		error(string.format("%s at line %d col %d", msg, line, col))
	end

	local function codepoint_to_utf8(n)
		local f = math.floor
		if n <= 0x7f then
			return string.char(n)
		elseif n <= 0x7ff then
			return string.char(f(n / 64) + 192, n % 64 + 128)
		elseif n <= 0xffff then
			return string.char(f(n / 4096) + 224, f(n % 4096 / 64) + 128, n % 64 + 128)
		elseif n <= 0x10ffff then
			return string.char(f(n / 262144) + 240, f(n % 262144 / 4096) + 128, f(n % 4096 / 64) + 128, n % 64 + 128)
		end
		error(string.format("invalid unicode codepoint '%x'", n))
	end

	local function parse_unicode_escape(s)
		local n1 = tonumber(s:sub(1, 4), 16)
		local n2 = tonumber(s:sub(7, 10), 16)
		if n2 then
			return codepoint_to_utf8((n1 - 0xd800) * 0x400 + (n2 - 0xdc00) + 0x10000)
		end
		return codepoint_to_utf8(n1)
	end

	local function parse_string(str, i)
		local res, j, k = "", i + 1, i + 1
		while j <= #str do
			local x = str:byte(j)
			if x < 32 then
				decode_error(str, j, "control character in string")
			elseif x == 92 then
				res = res .. str:sub(k, j - 1)
				j = j + 1
				local c = str:sub(j, j)
				if c == "u" then
					local hex = str:match("^[dD][89aAbB]%x%x\\u%x%x%x%x", j + 1)
						or str:match("^%x%x%x%x", j + 1)
						or decode_error(str, j - 1, "invalid unicode escape in string")
					res = res .. parse_unicode_escape(hex)
					j = j + #hex
				else
					if not ESCAPE_VALID[c] then
						decode_error(str, j - 1, "invalid escape char '" .. c .. "' in string")
					end
					res = res .. UNESCAPE_CHARS[c]
				end
				k = j + 1
			elseif x == 34 then
				return res .. str:sub(k, j - 1), j + 1
			end
			j = j + 1
		end
		decode_error(str, i, "expected closing quote for string")
	end

	local function parse_number(str, i)
		local x = next_char(str, i, DELIM_CHARS)
		local s = str:sub(i, x - 1)
		local n = tonumber(s)
		if not n then
			decode_error(str, i, "invalid number '" .. s .. "'")
		end
		return n, x
	end

	local function parse_literal(str, i)
		local x = next_char(str, i, DELIM_CHARS)
		local word = str:sub(i, x - 1)
		if not LITERALS[word] then
			decode_error(str, i, "invalid literal '" .. word .. "'")
		end
		return LITERAL_VALUES[word], x
	end

	local function parse_array(str, i)
		local res, n = {}, 1
		i = i + 1
		while true do
			i = next_char(str, i, SPACE_CHARS, true)
			if str:sub(i, i) == "]" then
				return res, i + 1
			end
			local x
			x, i = parse(str, i)
			res[n] = x
			n = n + 1
			i = next_char(str, i, SPACE_CHARS, true)
			local chr = str:sub(i, i)
			i = i + 1
			if chr == "]" then
				break
			end
			if chr ~= "," then
				decode_error(str, i, "expected ']' or ','")
			end
		end
		return res, i
	end

	local function parse_object(str, i)
		local res = {}
		i = i + 1
		while true do
			i = next_char(str, i, SPACE_CHARS, true)
			if str:sub(i, i) == "}" then
				return res, i + 1
			end
			if str:sub(i, i) ~= '"' then
				decode_error(str, i, "expected string for key")
			end
			local key
			key, i = parse(str, i)
			i = next_char(str, i, SPACE_CHARS, true)
			if str:sub(i, i) ~= ":" then
				decode_error(str, i, "expected ':' after key")
			end
			i = next_char(str, i + 1, SPACE_CHARS, true)
			local val
			val, i = parse(str, i)
			res[key] = val
			i = next_char(str, i, SPACE_CHARS, true)
			local chr = str:sub(i, i)
			i = i + 1
			if chr == "}" then
				break
			end
			if chr ~= "," then
				decode_error(str, i, "expected '}' or ','")
			end
		end
		return res, i
	end

	local CHAR_PARSERS = {
		['"'] = parse_string,
		["-"] = parse_number,
		["t"] = parse_literal,
		["f"] = parse_literal,
		["n"] = parse_literal,
		["["] = parse_array,
		["{"] = parse_object,
	}
	for d = 0, 9 do
		CHAR_PARSERS[tostring(d)] = parse_number
	end

	parse = function(str, idx)
		local chr = str:sub(idx, idx)
		local f = CHAR_PARSERS[chr]
		if f then
			return f(str, idx)
		end
		decode_error(str, idx, "unexpected character '" .. chr .. "'")
	end

	function json.decode(str)
		if type(str) ~= "string" then
			error("expected argument of type string, got " .. type(str))
		end
		local res, idx = parse(str, next_char(str, 1, SPACE_CHARS, true))
		idx = next_char(str, idx, SPACE_CHARS, true)
		if idx <= #str then
			decode_error(str, idx, "trailing garbage")
		end
		return res
	end
end

return json
