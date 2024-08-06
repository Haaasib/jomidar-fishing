Config = {}

Config.Core = 'qb-core'
Config.Menu = 'qb-menu'
Config.Textui = 'j-textui'
Config.MinigameCorrectWord = 10  
Config.MinigameTime = 10000
Config.DeliveryLoc = {
    ["deliveryspots"] = {
        [1] = {coords = vector3(1691.42, 3866.65, 34.91)},
        [2] = {coords = vector3(1720.49, 3852.06, 34.79)},
        [3] = {coords = vector3(1728.59, 3851.70, 34.78)},
        [4] = {coords = vector3(1763.84, 3823.68, 34.77)},
        [5] = {coords = vector3(1760.18, 3821.54, 34.77)},
        [6] = {coords = vector3(1746.08, 3788.33, 34.83)},
        [7] = {coords = vector3(1748.80, 3783.57, 34.83)},
        [8] = {coords = vector3(1774.61, 3742.91, 34.66)},
        [9] = {coords = vector3(1777.41, 3738.04, 34.66)},
        [10] = {coords = vector3(1743.08, 3702.23, 34.20)},
        [11] = {coords = vector3(1724.59, 3696.48, 34.41)},
        [12] = {coords = vector3(1687.10, 3755.26, 34.33)},
    }
}
Config.FishBasket = {
    amount = 10, --- fish need to create basket
    mintime = 10, --- min time for getting delivery sec
    maxtime = 20, --- max time for getting delivery sec
    mindeliveryreward = 1000, ---1k cash 
    maxdeliveryreward = 2000,  --- 2k csh
    coords = vector4(1301.43, 4221.44, 32.91, 72.21),  -- coords of table 
    progresstime = 1000, -- time to make basket
    prop = "bkr_prop_weed_table_01b" -- dont touch
}
Config.Fishes = {
    [1] = {name = "sturgeon", amount = {1, 3}},  ------ its rnd
    [2] = {name = "whitefish", amount = {1, 3}},
    [3] = {name = "codfish", amount = {1, 3}},
    [4] = {name = "mackerel", amount = {1, 3}},
    [5] = {name = "alewife", amount = {1, 3}},
    [6] = {name = "carp", amount = {1, 3}},
    [7] = {name = "catfish", amount = {1, 3}},
    [8] = {name = "whitesucker", amount = {1, 3}},
    [9] = {name = "redhorse", amount = {1, 3}},
    [10] = {name = "salmon", amount = {1, 3}},
    [11] = {name = "herring", amount = {1, 3}},
    [12] = {name = "bass", amount = {1, 3}}
}

Config.Items = {
    label = "Fishing Shop",
        slots = 2,
        items = {
            [1] = {
                name = "fishbait",
                price = 5,
                amount = 20,
                info = {},
                type = "item",
                slot = 1,
            },
            [2] = {
                name = "fishingrod",
                price = 5,
                amount = 20,
                info = {},
                type = "item",
                slot = 2,
            },
        }
}