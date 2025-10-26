local skinsMale = {3, 15, 58, 63, 66, 72, 78, 79, 94, 95, 96, 97, 99, 117, 118, 120, 127, 132, 133, 134, 135, 136, 137, 142, 156, 158, 162, 168, 174, 179, 180, 181, 182, 183, 184, 185, 186, 187, 153, 161, 163, 212, 223, 222, 250, 291, 292, 293, 294, 295}
local skinsFemale = {1, 2, 4, 5, 7, 8, 10, 11, 14, 23, 27, 30, 36, 37, 39, 41, 73, 75, 77, 87, 88, 89, 90, 92, 138, 139, 140, 141, 145, 148, 150, 151, 152, 157, 169, 178, 191, 201, 207, 231, 232, 237, 238, 243, 244, 245, 246, 247, 248, 249, 256, 257, 262, 263}

local skinGenders = {
    [1] = 1, [2] = 1, [3] = 0, [4] = 1, [5] = 1, [7] = 1, [8] = 1, [10] = 1, [11] = 1, [14] = 1, [15] = 0, 
    [16] = 0, [17] = 0, [18] = 0, [19] = 0, [20] = 0, [21] = 0, [22] = 0, [23] = 1, [24] = 0, [25] = 0, [26] = 0, 
    [27] = 1, [28] = 0, [29] = 0, [30] = 1, [32] = 0, [33] = 0, [34] = 0, [35] = 0, [36] = 1, [37] = 1, [39] = 1, 
    [41] = 1, [43] = 0, [44] = 0, [45] = 0, [46] = 0, [47] = 0, [48] = 0, [49] = 0, [50] = 0, [51] = 0, [52] = 0, 
    [57] = 0, [58] = 0, [59] = 0, [60] = 0, [61] = 0, [62] = 0, [63] = 0, [66] = 0, [67] = 0, [68] = 0, [70] = 0, 
    [71] = 0, [72] = 0, [73] = 1, [75] = 1, [77] = 1, [78] = 0, [79] = 0, [80] = 0, [81] = 0, [82] = 0, [83] = 0, 
    [84] = 0, [94] = 0, [95] = 0, [96] = 0, [97] = 0, [98] = 0, [99] = 0, [100] = 0, [101] = 0, [102] = 0, [103] = 0, 
    [104] = 0, [105] = 0, [106] = 0, [107] = 0, [108] = 0, [109] = 0, [110] = 0, [111] = 0, [112] = 0, [113] = 0, 
    [114] = 0, [115] = 0, [116] = 0, [117] = 0, [118] = 0, [120] = 0, [121] = 0, [122] = 0, [123] = 0, [124] = 0, 
    [125] = 0, [126] = 0, [127] = 0, [128] = 0, [129] = 0, [130] = 0, [131] = 0, [132] = 0, [133] = 0, [134] = 0, 
    [135] = 0, [136] = 0, [137] = 0, [138] = 1, [139] = 1, [140] = 1, [141] = 1, [142] = 0, [145] = 1, [148] = 1, 
    [150] = 1, [151] = 1, [152] = 1, [153] = 0, [156] = 0, [157] = 1, [158] = 0, [161] = 0, [162] = 0, [163] = 0, 
    [168] = 0, [169] = 1, [174] = 0, [178] = 1, [179] = 0, [180] = 0, [181] = 0, [182] = 0, [183] = 0, [184] = 0, 
    [185] = 0, [186] = 0, [187] = 0, [190] = 0, [191] = 1, [192] = 0, [193] = 0, [194] = 0, [196] = 0, [201] = 1, 
    [207] = 1, [211] = 0, [212] = 0, [215] = 0, [216] = 0, [219] = 0, [222] = 0, [223] = 0, [224] = 0, [225] = 0, 
    [226] = 0, [231] = 1, [232] = 1, [233] = 0, [234] = 0, [235] = 0, [237] = 1, [238] = 1, [240] = 0, [243] = 1, 
	[244] = 1, [245] = 1, [246] = 1, [247] = 1, [248] = 1, [249] = 1, [250] = 0, [256] = 1, [257] = 1, [258] = 0, 
	[259] = 0, [262] = 1, [263] = 1, [263] = 0, [291] = 0, [292] = 0, [293] = 0, [294] = 0, [295] = 0
}

local genders = {
    "male", 
    "female"
}

local males = {
    "James", "John", "Robert", "Michael", "William", "David", "Richard", "Joseph", "Charles", "Thomas", 
    "Christopher", "Daniel", "Matthew", "Anthony", "Donald", "Mark", "Paul", "Steven", "Andrew", "Kenneth", 
    "George", "Joshua", "Kevin", "Brian", "Edward", "Ronald", "Timothy", "Jason", "Jeffrey", "Ryan", 
    "Jacob", "Gary", "Nicholas"
}

local females = {
    "Mary", "Patricia", "Jennifer", "Linda", "Elizabeth", "Barbara", "Susan", "Jessica", "Sarah", "Karen", 
    "Nancy", "Lisa", "Margaret", "Betty", "Sandra", "Ashley", "Kimberly", "Emily", "Donna", "Michelle", 
    "Dorothy", "Carol", "Amanda", "Melissa", "Deborah", "Stephanie", "Rebecca", "Sharon", "Laura", "Cynthia", 
    "Kathleen", "Amy", "Angela"
}

local lastNames = {
    "Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia", "Miller", "Davis", "Rodriguez", "Martinez", 
    "Hernandez", "Lopez", "Gonzalez", "Wilson", "Anderson", "Thomas", "Taylor", "Moore", "Jackson", "Martin", 
    "Lee", "Perez", "Thompson", "White", "Harris", "Sanchez", "Clark", "Ramirez", "Lewis", "Robinson", 
    "Walker", "Young", "Allen"
}

function getRandomSkin(gender)
    if gender then
        if gender == 0 then
            return skinsMale[math.random(#skinsMale)]
        elseif gender == 1 then
            return skinsFemale[math.random(#skinsFemale)]
        end
    end
    return false
end

function getRandomName(type, gender)
    if gender then
        if gender == 0 then
            gender = "male"
        elseif gender == 1 then
            gender = "female"
        end
    end

    if not type then
        type = "full"
    end

    if type == "full" then
        if not gender then
            gender = genders[math.random(#genders)]
        end
        local randFirstname
        if gender == "male" then
            randFirstname = males[math.random(#males)]
        elseif gender == "female" then
            randFirstname = females[math.random(#females)]
        end
        local randLastname = lastNames[math.random(#lastNames)]
        local name = tostring(randFirstname .. " " .. randLastname)
        return name
    elseif type == "last" then
        local randLastname = lastNames[math.random(#lastNames)]
        return randLastname
    elseif type == "first" then
        if not gender then
            gender = genders[math.random(#genders)]
        end
        local randFirstname
        if gender == "male" then
            randFirstname = males[math.random(#males)]
        elseif gender == "female" then
            randFirstname = females[math.random(#females)]
        end
        return randFirstname
    elseif type == "gender" then
        gender = genders[math.random(#genders)]
        if gender == "male" then
            return 0
        elseif gender == "female" then
            return 1
        end
    end
end

function getGenderFromSkin(skin)
    skin = tonumber(skin) or false
    if not skin then return false end
    return skinGenders[skin] or false
end

function getSkinGender(skin)
    skin = tonumber(skin) or false
    if not skin then return false end
    return skinGenders[skin] or false
end

function getSkinsMale()
	return skinsMale
end

function getSkinsFemale()
	return skinsFemale
end