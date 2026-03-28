local Dumper = {
	Callbacks = {},
}

local Animations = require("@InstanceList/Animations")
local Callbacks = require("@Utility/Callbacks")

local ScanRange = 10000
local FloatMargin = 0.025
local PointerScanRange = 0x2000
local FloatScanRange = 0x500
local InnerStringScanRange = 0x2000
local Phase2ScanRange = 0x2000
local RequiredConfirms = 3

local function GetValue(TextLabel, ToNumber)
	if TextLabel and TextLabel.Value then
		return ToNumber and tonumber(TextLabel.Value) or TextLabel.Value
	end
	return nil
end

local function CountTable(Table)
	local Count = 0
	for _ in pairs(Table) do
		Count = Count + 1
	end
	return Count
end

local function IsValidTrack(Track)
	local SpeedValue = GetValue(Animations.AnimationTrack.Speed[3], true)
	local TimeValue = GetValue(Animations.AnimationTrack.TimePosition[3], true)

	if not SpeedValue or not TimeValue then
		return false, nil, nil
	end

	local SpeedMatch, TimeMatch = nil, nil

	for i = 0, FloatScanRange, 4 do
		local Value = memory.Read("float", Track + i)
		if Value then
			if not SpeedMatch and math.abs(Value - SpeedValue) < FloatMargin then
				SpeedMatch = i
			end
			if not TimeMatch and math.abs(Value - TimeValue) < FloatMargin then
				TimeMatch = i
			end
		end
		if SpeedMatch and TimeMatch then
			break
		end
	end

	if not SpeedMatch or not TimeMatch then
		return false, nil, nil
	end

	return true, Track, { Speed = SpeedMatch, TimePosition = TimeMatch }
end

function Dumper:GetOffsets()
	local Offsets = {}
	local Finished = false

	local Base = Animations.Animator.AnimationTrackList[1].Address

	local CurrentOffset = 0
	local CurrentList = nil
	local CurrentIterator = nil
	local CurrentChecked = 0
	local FirstTrack = nil
	local FirstOffsets = nil
	local ValidTracks = 0
	local ConfirmedOffset = nil
	local ConfirmCount = 0

	local Phase2Active = false
	local CallbackIndex = nil

	local function StartPhase3()
		local Phase3CallbackIndex = nil
		local Phase3Offset = 0

		Phase3CallbackIndex = Callbacks.Add("onUpdate", function()
			if Finished then
				Callbacks.Remove("onUpdate", Phase3CallbackIndex)
				return
			end

			if FirstOffsets.Animation or Phase3Offset > PointerScanRange then
				if FirstOffsets.Animation then
					Offsets["AnimationTrack"]["Animation"] =
						{ Offset = string.format("0x%X", FirstOffsets.Animation), Type = "pointer" }
					print(
						string.format(
							"[AnimationTrack.Animation] offset: %s",
							string.format("0x%X", FirstOffsets.Animation)
						)
					)
				end
				if FirstOffsets.AnimationId then
					Offsets["Animation"] = {
						["AnimationId"] = { Offset = string.format("0x%X", FirstOffsets.AnimationId), Type = "string" },
					}
					print(
						string.format(
							"[Animation.AnimationId] offset: %s",
							string.format("0x%X", FirstOffsets.AnimationId)
						)
					)
				end

				Finished = true
				Callbacks.Remove("onUpdate", Phase3CallbackIndex)
				Dumper:Finished(Offsets)
				return
			end

			local i = Phase3Offset
			Phase3Offset = Phase3Offset + 8

			local Candidate = memory.Read("pointer", FirstTrack + i)
			if Candidate and Candidate ~= 0 then
				local Label = Animations.AnimationTrack.AnimationId[3]
				local CurrentId = Label and Label.Value or nil
				if CurrentId then
					for j = 0, InnerStringScanRange, 4 do
						local Str = memory.Read("string", Candidate + j)
						if Str and #Str > 3 and not Str:match("^%s*$") then
							local StrippedExpected = CurrentId:gsub("rbxassetid://", "")
							local StrippedStr = Str:gsub("rbxassetid://", "")
							if Str == CurrentId or StrippedStr == StrippedExpected then
								FirstOffsets.Animation = i
								FirstOffsets.AnimationId = j
								break
							end
						end
					end
				end
			end
		end)
	end

	local function StartPhase2()
		Phase2Active = true

		local LoopedState = { Candidates = nil, Found = false, Rounds = 0 }
		local LastLooped = nil
		local Phase2CallbackIndex = nil

		Phase2CallbackIndex = Callbacks.Add("onUpdate", function()
			if Finished then
				Callbacks.Remove("onUpdate", Phase2CallbackIndex)
				return
			end

			local LoopedValue = GetValue(Animations.AnimationTrack.Looped[3], true)
			if not LoopedValue or LoopedValue == LastLooped then
				return
			end

			LastLooped = LoopedValue
			local LoopedNum = tonumber(LoopedValue)

			if not LoopedState.Found then
				if LoopedState.Candidates == nil then
					LoopedState.Candidates = {}
					for i = 0, Phase2ScanRange, 1 do
						local Value = memory.Read("byte", FirstTrack + i)
						if Value and Value == LoopedNum then
							LoopedState.Candidates[i] = true
						end
					end
					LoopedState.Rounds = 1
				else
					for i in pairs(LoopedState.Candidates) do
						local Value = memory.Read("byte", FirstTrack + i)
						if not Value or Value ~= LoopedNum then
							LoopedState.Candidates[i] = nil
						end
					end
					LoopedState.Rounds = LoopedState.Rounds + 1

					local LoopedCount = CountTable(LoopedState.Candidates)
					if LoopedCount == 0 then
						LoopedState.Candidates = nil
						LoopedState.Rounds = 0
					elseif LoopedCount == 1 then
						for Offset in pairs(LoopedState.Candidates) do
							FirstOffsets.Looped = Offset
							LoopedState.Found = true
						end
					end
				end
			end

			if LoopedState.Found then
				Offsets["AnimationTrack"]["Looped"] =
					{ Offset = string.format("0x%X", FirstOffsets.Looped), Type = "bool" }
				print(string.format("[AnimationTrack.Looped] offset: %s", string.format("0x%X", FirstOffsets.Looped)))
				Callbacks.Remove("onUpdate", Phase2CallbackIndex)
				StartPhase3()
			end
		end)
	end

	CallbackIndex = Callbacks.Add("onUpdate", function()
		if Finished or Phase2Active then
			Callbacks.Remove("onUpdate", CallbackIndex)
			return
		end

		if CurrentIterator and CurrentIterator ~= 0 and CurrentIterator ~= CurrentList and CurrentChecked < 5 then
			for _, PtrOffset in ipairs({ 0x8, 0x10, 0x18, 0x20 }) do
				local Candidate = memory.Read("pointer", CurrentIterator + PtrOffset)
				if Candidate and Candidate ~= 0 then
					local Valid, TrackAddr, Fields = IsValidTrack(Candidate)
					if Valid then
						ValidTracks = ValidTracks + 1
						if not FirstTrack then
							FirstTrack = TrackAddr
							FirstOffsets = Fields
						end
						break
					end
				end
			end

			CurrentIterator = memory.Read("pointer", CurrentIterator)
			CurrentChecked = CurrentChecked + 1
			return
		end

		if ValidTracks >= 1 and FirstTrack then
			local FoundOffset = CurrentOffset - 8

			if ConfirmedOffset == nil then
				ConfirmedOffset = FoundOffset
				ConfirmCount = 1
			elseif ConfirmedOffset == FoundOffset then
				ConfirmCount = ConfirmCount + 1
			else
				ConfirmedOffset = FoundOffset
				ConfirmCount = 1
				FirstTrack = nil
				FirstOffsets = nil
				ValidTracks = 0
			end

			if ConfirmCount >= RequiredConfirms then
				Offsets["Animator"] = {
					["AnimationTrackList"] = { Offset = string.format("0x%X", ConfirmedOffset), Type = "pointer" },
				}
				Offsets["AnimationTrack"] = {
					["Speed"] = { Offset = string.format("0x%X", FirstOffsets.Speed), Type = "float" },
					["TimePosition"] = { Offset = string.format("0x%X", FirstOffsets.TimePosition), Type = "float" },
				}

				print(string.format("[Animator.AnimationTrackList] offset: %s", string.format("0x%X", ConfirmedOffset)))
				print(string.format("[AnimationTrack.Speed] offset: %s", string.format("0x%X", FirstOffsets.Speed)))
				print(
					string.format(
						"[AnimationTrack.TimePosition] offset: %s",
						string.format("0x%X", FirstOffsets.TimePosition)
					)
				)

				StartPhase2()
				return
			end

			CurrentList = nil
			CurrentIterator = nil
			CurrentChecked = 0
			ValidTracks = 0
			CurrentOffset = ConfirmedOffset
			return
		end

		CurrentList = nil
		CurrentIterator = nil
		CurrentChecked = 0
		FirstTrack = nil
		FirstOffsets = nil
		ValidTracks = 0

		if CurrentOffset > ScanRange then
			Finished = true
			Dumper:Finished(Offsets)
			return
		end

		local List = memory.Read("pointer", Base + CurrentOffset)
		CurrentOffset = CurrentOffset + 8

		if List and List ~= 0 then
			local Iterator = memory.Read("pointer", List)
			if Iterator and Iterator ~= 0 and Iterator ~= List then
				CurrentList = List
				CurrentIterator = Iterator
				CurrentChecked = 0
			end
		end
	end)
end

function Dumper:Initialise()
	print("--- SCANNING ANIMATIONS ---")
	Dumper:GetOffsets()
end

function Dumper:Finished(Result)
	for _, Callback in pairs(Dumper.Callbacks) do
		Callback(Result)
	end
end

function Dumper:OnFinished(Callback)
	table.insert(Dumper.Callbacks, Callback)
end

return Dumper