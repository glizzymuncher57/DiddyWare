return {
    ['version'] = 'version-ae421f0582e54718',

    ['Animation'] = {
        ['AnimationId'] = {Type = 'string', Offset = 0xD0},
    },
    ['ScreenGui'] = {
        ['Enabled'] = {Type = 'bool', Offset = 0x4CC},
    },
    ['DoubleConstrainedValue'] = {
        ['Value'] = {Type = 'double', Offset = 0xE0},
    },
    ['Animator'] = {
        ['AnimationTrackList'] = {Type = 'pointer', Offset = 0x868},
    },
    ['GuiObject'] = {
        ['Position'] = {Type = 'float', X = 0x518, Y = 0x520},
        ['Rotation'] = {Type = 'float', Offset = 0x188},
        ['Size'] = {Type = 'float', X = 0x538, Y = 0x540},
        ['AbsoluteSize'] = {Type = 'float', X = 0x118, Y = 0x11C},
        ['AbsolutePosition'] = {Type = 'float', X = 0x110, Y = 0x114},
        ['Visible'] = {Type = 'bool', Offset = 0x5B5},
    },
    ['AnimationTrack'] = {
        ['Looped'] = {Type = 'bool', Offset = 0xF5},
        ['Animation'] = {Type = 'pointer', Offset = 0xD0},
        ['Speed'] = {Type = 'float', Offset = 0xE4},
        ['TimePosition'] = {Type = 'float', Offset = 0xE8},
    },
}