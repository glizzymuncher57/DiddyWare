return {
    ['version'] = 'version-689e359b09ad43b0',

    ['Path2D'] = {
        ['Visible'] = {type = bool, offset = 0x115},
    },
    ['Instance'] = {
        ['AttributeToNext'] = {Type = 'pointer', Offset = 0x58},
        ['AttributeContainer'] = {Type = 'pointer', Offset = 0x48},
        ['AttributeToValue'] = {Type = 'any', Offset = 0x18},
        ['AttributeList'] = {Type = 'pointer', Offset = 0x18},
    },
    ['Camera'] = {
        ['Rotation'] = {Type = 'float', Offset = 0xF8},
    },
    ['Primitive'] = {
        ['Rotation'] = {Type = 'float', Offset = 0xC0},
        ['Position'] = {Type = 'float', X = 0xE4, Y = 0xE8, Z = 0xEC},
    },
    ['ImageButton'] = {
        ['Image'] = {Type = 'string', Offset = 0xCC8},
    },
    ['Animation'] = {
        ['AnimationId'] = {Type = 'string', Offset = 0xD0},
    },
    ['CylinderHandleAdornment'] = {
        ['Visible'] = {type = bool, offset = 0x100},
        ['Rotation'] = {Type = 'float', Offset = 0x130},
        ['Height'] = {Type = 'float', Offset = 0x1C4},
        ['Transparency'] = {Type = 'float', Offset = 0xFC},
    },
    ['Animator'] = {
        ['AnimationTrackList'] = {Type = 'pointer', Offset = 0x850},
    },
    ['BasePart'] = {
        ['Primitive'] = {Type = 'pointer', Offset = 0x148},
    },
    ['ScreenGui'] = {
        ['Enabled'] = {type = bool, offset = 0x4CC},
    },
    ['AnimationTrack'] = {
        ['Animation'] = {Type = 'pointer', Offset = 0xD0},
        ['Speed'] = {Type = 'float', Offset = 0xE4},
        ['TimePosition'] = {Type = 'float', Offset = 0xE8},
        ['Looped'] = {Type = 'bool', Offset = 0xF5},
    },
    ['GuiObject'] = {
        ['Visible'] = {type = bool, offset = 0x5B5},
        ['Size'] = {Type = 'float', X = 0x538, Y = 0x540},
        ['Position'] = {Type = 'float', X = 0x518, Y = 0x520},
    },
}
