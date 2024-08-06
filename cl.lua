local QBCore = exports[Config.Core]:GetCoreObject()



function SpawnFishBasketProp()
    local propName = Config.FishBasket.prop
    local coords = Config.FishBasket.coords

    -- Load the prop model
    RequestModel(propName)
    while not HasModelLoaded(propName) do
        Citizen.Wait(0)
    end

    -- Create the prop at the specified coordinates
    local prop = CreateObject(GetHashKey(propName), coords.x, coords.y, coords.z, true, true, false)
    SetEntityHeading(prop, coords.w)

    -- Optionally, freeze the prop in place
    FreezeEntityPosition(prop, true)

    -- Add 3D Text UI
    exports[Config.Textui]:create3DTextUIOnEntity(prop, {
        displayDist = 6.0,
        interactDist = 2.0,
        enableKeyClick = true, -- If true when you near it and click key it will trigger the event that you write inside triggerData
        keyNum = 38,
        key = "E",
        text = "Open",
        theme = "green", -- or red
        triggerData = {
            triggerName = "fishbasket:openMenu",
            args = {}
        }
    })
end

function getRandomDeliverySpot()
    local deliverySpots = Config.DeliveryLoc.deliveryspots
    local randomIndex = math.random(#deliverySpots)
    return deliverySpots[randomIndex].coords
end



local function generateUniqueId()
    local playerName = GetPlayerName(PlayerId())
    return playerName -- Using player name as the unique ID
end



function createDeliveryUI()
    -- Get a random delivery location
    local deliveryCoords = getRandomDeliverySpot()
    local uniqueId = generateUniqueId()

    -- Create the 3D text UI
    exports[Config.Textui]:create3DTextUI(uniqueId, {
        coords = deliveryCoords,
        displayDist = 6.0,
        interactDist = 2.0,
        enableKeyClick = true,
        keyNum = 38,
        key = "E",
        text = "Deliver",
        theme = "green", -- or "red"
        job = "all", -- or specify the job
        canInteract = function()
            return true
        end,
        triggerData = {
            triggerName = "delivery:jomidar",
            args = {}
        }
    })

    -- Create the blip and waypoint
    local blip = AddBlipForCoord(deliveryCoords)
    SetBlipSprite(blip, 1) -- Set blip sprite
    SetBlipColour(blip, 1) -- Set blip color to red
    SetBlipRoute(blip, true)
    SetBlipRouteColour(blip, 1)
    
    -- Remove the blip and waypoint once the player reaches the location
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1000)
            local playerCoords = GetEntityCoords(PlayerPedId())
            local distance = #(playerCoords - deliveryCoords)
            if distance < 2.0 then
                RemoveBlip(blip)
                break
            end
        end
    end)
end

RegisterNetEvent('delivery:start', function(data)
    local hasItem = QBCore.Functions.HasItem("fishcontainer")
    if hasItem then

    exports['jomidar-ui']:Show("Waiting For Delivery")

    local mintime = Config.FishBasket.mintime -- minimum time in seconds
    local maxtime = Config.FishBasket.maxtime -- maximum time in seconds
    local waitTime = math.random(mintime * 1000, maxtime * 1000)
        
        -- Wait for the generated random time
    Citizen.Wait(waitTime)

    exports['jomidar-ui']:Show("Fishing", "🚚 You Started Fish Delivery 🚚\n🐟 Head Over To Delivery Locaton🐟 ")

    createDeliveryUI()
    else
        QBCore.Functions.Notify("You don't have enough item on you", "error")
    end
end)

RegisterNetEvent('delivery:jomidar', function(data)
    local hasItem = QBCore.Functions.HasItem("fishcontainer")
    if hasItem then
        QBCore.Functions.Progressbar("random_task", "Talking With Buyer", 5000, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
         }, {
            animDict = "mp_car_bomb",
            anim = "car_bomb_mechanic",
            flags = 49,
         }, {}, {}, function()
        local uniqueId = generateUniqueId()
        exports[Config.Textui]:delete3DTextUI(uniqueId)
        TriggerServerEvent('jomidar:delivery')
        exports['jomidar-ui']:Close()
         end, function()
            
            QBCore.Functions.Notify("You Stopped Delivery", "error")
        end)
    else
        QBCore.Functions.Notify("You don't have enough item on you", "error")
    end
end)

RegisterNetEvent('fishbasket:openMenu', function()
    local menuItems = {}
    for i, fish in ipairs(Config.Fishes) do
        table.insert(menuItems, {
            header = fish.name .. " Basket",
            txt = "Craft a basket of " .. fish.name,
            params = {
                event = 'fishbasket:craftBasket',
                args = {
                    fishName = fish.name,
                    requiredAmount = Config.FishBasket.amount -- Required amount of fish to craft the basket
                }
            }
        })
    end

    exports[Config.Menu]:openMenu(menuItems)
end)

RegisterNetEvent('fishbasket:craftBasket', function(data)
    local hasItem = QBCore.Functions.HasItem(data.fishName, data.requiredAmount)
    if hasItem then
        local propCoords = vector4(1301.32, 4221.47, 33.75, 235.53)
        local propModel = 'hei_prop_heist_box'

        RequestModel(propModel)
        while not HasModelLoaded(propModel) do
            Wait(0)
        end

        local prop = CreateObject(propModel, propCoords.x, propCoords.y, propCoords.z, true, true, false)
        SetEntityHeading(prop, propCoords.w)

        QBCore.Functions.Progressbar("random_task", "Doing something", 5000, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
         }, {
            animDict = "mp_car_bomb",
            anim = "car_bomb_mechanic",
            flags = 49,
         }, {}, {}, function()
            TriggerServerEvent('fishbasket:craft', data.fishName, data.requiredAmount)
            DeleteObject(prop)
         end, function()
            DeleteObject(prop)
            QBCore.Functions.Notify("You Stopped Making " .. data.fishName .. " Basket", "error")
        end)
    else
        QBCore.Functions.Notify("You don't have enough " .. data.fishName .. " on you", "error")
    end
end)

local alreadyFishing = false
RegisterNetEvent('jomidar-fishing:start', function(data) 
    local HasItem = QBCore.Functions.HasItem('fishingrod')
    if not HasItem then
        QBCore.Functions.Notify("You don't have any fishing bait or you are not near water...", "error")
        return
    end

    if alreadyFishing then
        QBCore.Functions.Notify("You are already fishing!", "error")
        return
    end
    exports['jomidar-ui']:Show("Fishing", "You Started Fishing")
    local time = math.random(1000, 5000)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    alreadyFishing = true

    if GetWaterHeight(pos.x, pos.y, pos.z-2, pos.z - 3.0) then
        hasStartedFishing = true
        local animDict = "amb@world_human_stand_fishing@idle_a"
        local animName = "idle_c"
        local pedPos = GetEntityCoords(ped)
        local fishingRodHash = `prop_fishing_rod_01`
        local bone = GetPedBoneIndex(ped, 18905)
                
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Wait(100)
        end
        TaskPlayAnim(ped, animDict, animName, 1.0, -1.0, 1.0, 11, 0, 0, 0, 0)   
        rodHandle = CreateObject(fishingRodHash, pedPos, true)
        AttachEntityToEntity(rodHandle, ped, bone, 0.1, 0.05, 0, 80.0, 120.0, 160.0, true, true, false, true, 1, true)

        Wait(time)
        exports['jomidar-ui']:Show("Fishing", "You Got Fish")
        exports['skillchecks']:startAlphabetGame(Config.MinigameTime, Config.MinigameCorrectWord, function(success)
            if success then
                TriggerServerEvent('jomidar-fishing:reward')
                TriggerServerEvent('leaderboard:insert')
                exports['jomidar-ui']:Close()
            else
                TriggerServerEvent('jomidar-fishing:removebait')
                QBCore.Functions.Notify('The fish escaped...', 'error', 7500)
                exports['jomidar-ui']:Close()
            end
            ClearPedTasks(ped)
            DeleteObject(rodHandle)
            alreadyFishing = false
        end)
    else
        QBCore.Functions.Notify("You are not near water...", "error")
        alreadyFishing = false
    end
end)


AddEventHandler('onClientResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        SpawnFishBasketProp()
    end
end)