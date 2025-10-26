BLUE = {
	[25] = "#f0fdff",
	[50] = "#edfbfe",
	[100] = "#d3f4fa",
	[200] = "#ace8f5",
	[300] = "#53cbea",
	[400] = "#32b9de",
	[500] = "#169cc4",
	[600] = "#157ca5",
	[700] = "#186486",
	[800] = "#1c536e",
	[900] = "#1c455d"
}

GREEN = {
	[25] = "#f0fdf4",
	[50] = "#ebfef5",
	[100] = "#cffce6",
	[200] = "#a3f7d1",
	[300] = "#53eab0",
	[400] = "#2dda9d",
	[500] = "#08c186",
	[600] = "#009d6e",
	[700] = "#007d5b",
	[800] = "#026349",
	[900] = "#03513e"
}

ORANGE = {
	[25] = "#fff4ed",
	[50] = "#fd8ef",
	[100] = "#fbefd9",
	[200] = "#f6dbb2",
	[300] = "#f0c381",
	[400] = "#eaa353",
	[500] = "#e4862b",
	[600] = "#d56c21",
	[700] = "#b1541d",
	[800] = "#8d431f",
	[900] = "#72391c"
}

RED = {
	[25] = "#fff1f1",
	[50] = "#fef2f2",
	[100] = "#fde3e3",
	[200] = "#fccccc",
	[300] = "#f9a8a8",
	[400] = "#f37676",
	[500] = "#ea5353",
	[600] = "#d62c2c",
	[700] = "#b32222",
	[800] = "#951f1f",
	[900] = "#7c2020"
}

GRAY = {
	[900] = "#121214",
	[800] = "#202024",
	[700] = "#181818",
	[600] = "#323238",
	[500] = "#2e2e2e",
	[400] = "#666666",
	[300] = "#a8a8b3",
	[200] = "#c4c4cc",
	[100] = "#e1e1e6",
	[50] = "#f0f0f5",
	[25] = "#f5f5fa"
}

WHITE = {
	[900] = "#FFFFFF",
	[800] = "#efefef",
	[700] = "#dcdcdc",
	[600] = "#bdbdbd",
	[500] = "#989898",
	[400] = "#7c7c7c",
	[300] = "#656565",
	[200] = "#121214",
	[100] = "#464646",
	[50] = "#3d3d3d",
	[25] = "#333333"
}

LIGHT = {
	[25] = "#1f1f1f",
	[50] = "#262626",
	[100] = "#434343",
	[200] = "#595959",
	[300] = "#8c8c8c",
	[400] = "#bfbfbf",
	[500] = "#d9d9d9",
	[600] = "#f5f5f5",
	[700] = "#fafafa",
	[800] = "#FFFFFF",
	[900] = "#FFFFFF"
}

PURPLE = {
	[25] = "#F7F5FF",
	[50] = "#F3ECFF",
	[100] = "#E9D8FD",
	[200] = "#D6BCFA",
	[300] = "#B794F4",
	[400] = "#9F7AEA",
	[500] = "#805AD5",
	[600] = "#6B46C1",
	[700] = "#553C9A",
	[800] = "#44337A",
	[900] = "#322659"
}

YELLOW = {
	[25] = "#fffdf2",
	[50] = "#fcfcea",
	[100] = "#f9f8c8",
	[200] = "#f5ee93",
	[300] = "#efdf55",
	[400] = "#e7ca1f",
	[500] = "#d8b51a",
	[600] = "#ba8d14",
	[700] = "#956713",
	[800] = "#7c5217",
	[900] = "#69431a"
}

WHITEP = {
	[25] = "#FFFFFF",
	[50] = "#efefef",
	[100] = "#dcdcdc",
	[200] = "#bdbdbd",
	[300] = "#989898",
	[400] = "#7c7c7c",
	[500] = "#656565",
	[600] = "#525252",
	[700] = "#464646",
	[800] = "#3d3d3d",
	[900] = "#333333"
}

BROWN = {
	[900] = "#6b3e2e",
	[800] = "#8c5e4b",
	[700] = "#a67b5b",
	[600] = "#c19c7b",
	[500] = "#c19c7b",
	[400] = "#e8d4b3",
	[300] = "#f0e3c4",
	[200] = "#f6e9d0",
	[100] = "#fbf0dc",
	[50] = "#fdf6e7",
	[25] = "#fef9f3"
}

BACKGROUND = {
	BODY = GRAY[900],
	SURFACE = "#09090D",
	LEVEL1 = GRAY[800],
	LEVEL2 = GRAY[700],
	LEVEL3 = GRAY[600],
	TOOLTIP = GRAY[600]
}

COLORS_BY_NAME = {
    blue = BLUE,
    green = GREEN,
    orange = ORANGE,
    red = RED,
    gray = GRAY,
    light = LIGHT,
    purple = PURPLE,
    yellow = YELLOW,
    white = WHITE,
    whitep = WHITEP,
	brown = BROWN,
    background = BACKGROUND
}

BLACK = "#000000"
WHITE = "#FFFFFF"
FULL_OPACITY = "#FFFFFF00"

DEFAULT_RADIUS = 8

palette = {
    dark = {
        text = {
            primary = rgba(GRAY[50], 1),
            secondary = rgba(GRAY[200], 1),
            disabled = rgba(GRAY[400], 1),
        },
        background = {
            paper = GRAY[900],
            neutral = GRAY[700],
        }
    },
    light = {
        text = {
            primary = rgba(GRAY[900]),
            secondary = rgba(GRAY[600]),
            disabled = rgba(GRAY[400]),
        },
        background = {
            paper = rgba(GRAY[50], 0.9),
            neutral = rgba(GRAY[100], 0.8),
        }
    }
}