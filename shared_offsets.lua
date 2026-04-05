return {
    ['version'] = 'version-689e359b09ad43b0',

    ['Path2D'] = {
        ['Visible'] = {Type = 'bool', Offset = 0x115},
    },
    ['ImageButton'] = {
        ['Image'] = {Type = 'string', Offset = 0xCC8},
    },
    ['Animator'] = {
        ['AnimationTrackList'] = {Type = 'pointer', Offset = 0x850},
    },
    ['AnimationTrack'] = {
        ['Animation'] = {Type = 'pointer', Offset = 0xD0},
        ['Speed'] = {Type = 'float', Offset = 0xE4},
        ['TimePosition'] = {Type = 'float', Offset = 0xE8},
        ['Looped'] = {Type = 'bool', Offset = 0xF5},
    },
    ['Animation'] = {
        ['AnimationId'] = {Type = 'string', Offset = 0xD0},
    },
    ['ScreenGui'] = {
        ['Enabled'] = {Type = 'bool', Offset = 0x4CC},
    },
    ['Primitive'] = {
        ['Position'] = {Type = 'float', X = 0xE4, Y = 0xE8, Z = 0xEC},
        ['Rotation'] = {Type = 'float', Offset = 0xC0},
    },
    ['SphereHandleAdornment'] = {
        ['Position'] = {Type = 'float', X = 0x154, Y = 0x158, Z = 0x15C},
        ['Transparency'] = {Type = 'float', Offset = 0xFC},
    },
    ['CylinderHandleAdornment'] = {
        ['Position'] = {Type = 'float', X = 0x154, Y = 0x158, Z = 0x15C},
        ['Transparency'] = {Type = 'float', Offset = 0xFC},
    },
    ['GuiObject'] = {
        ['Visible'] = {Type = 'bool', Offset = 0x5B5},
        ['AbsolutePosition'] = {Type = 'float', X = 0x110, Y = 0x114},
        ['Rotation'] = {Type = 'float', Offset = 0x188},
        ['AbsoluteSize'] = {Type = 'float', X = 0x118, Y = 0x11C},
        ['Position'] = {Type = 'float', X = 0x518, Y = 0x520},
        ['Size'] = {Type = 'float', X = 0x538, Y = 0x540},
    },
    ['BasePart'] = {
        ['Primitive'] = {Type = 'pointer', Offset = 0x148},
    },
}
