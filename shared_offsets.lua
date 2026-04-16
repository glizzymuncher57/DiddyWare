return {
    ['version'] = 'version-9d412f44a6fe4081',

    ['ImageButton'] = {
        ['Image'] = {Type = 'string', Offset = 0xCC8},
    },
    ['Instance'] = {
        ['AttributeList'] = {Type = 'pointer', Offset = 0x18},
        ['AttributeToNext'] = {Type = 'pointer', Offset = 0x58},
        ['AttributeContainer'] = {Type = 'pointer', Offset = 0x48},
        ['AttributeToValue'] = {Type = 'any', Offset = 0x18},
    },
    ['CylinderHandleAdornment'] = {
        ['Height'] = {Type = 'float', Offset = 0x1C4},
        ['Rotation'] = {Type = 'float', Offset = 0x130},
        ['Transparency'] = {Type = 'float', Offset = 0xFC},
        ['Visible'] = {Type = 'bool', Offset = 0x100},
    },
    ['BasePart'] = {
        ['Primitive'] = {Type = 'pointer', Offset = 0x148},
    },
    ['Animator'] = {
        ['AnimationTrackList'] = {Type = 'pointer', Offset = 0x850},
    },
    ['Camera'] = {
        ['Rotation'] = {Type = 'float', Offset = 0xF8},
    },
    ['GuiObject'] = {
        ['Position'] = {Type = 'float', X = 0x518, Y = 0x520},
        ['Visible'] = {Type = 'bool', Offset = 0x5B5},
        ['Size'] = {Type = 'float', X = 0x538, Y = 0x540},
        ['AbsoluteSize'] = {Type = 'float', X = 0x118, Y = 0x11C},
        ['Rotation'] = {Type = 'float', Offset = 0x188},
        ['AbsolutePosition'] = {Type = 'float', X = 0x110, Y = 0x114},
    },
    ['ScreenGui'] = {
        ['Enabled'] = {Type = 'bool', Offset = 0x4CC},
    },
    ['Humanoid'] = {
        ['HipHeight'] = {Type = 'float', Offset = 0x1A0},
    },
    ['Path2D'] = {
        ['Visible'] = {Type = 'bool', Offset = 0x115},
    },
    ['Primitive'] = {
        ['Rotation'] = {Type = 'float', Offset = 0xC0},
    },
    ['Animation'] = {
        ['AnimationId'] = {Type = 'string', Offset = 0xD0},
    },
    ['AnimationTrack'] = {
        ['TimePosition'] = {Type = 'float', Offset = 0xE8},
        ['Looped'] = {Type = 'bool', Offset = 0xF5},
        ['Animation'] = {Type = 'pointer', Offset = 0xD0},
        ['Speed'] = {Type = 'float', Offset = 0xE4},
    },
}
