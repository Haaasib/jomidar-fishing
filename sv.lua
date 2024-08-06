local QBCore = exports[Config.Core]:GetCoreObject()

-- Function to get the current date and time
local function getCurrentDateTime()
    return os.date('%Y-%m-%d %H:%M:%S')
end

-- Function to generate a random length
local function generateRandomLength()
    return math.random() * 50 -- Random length between 0 and 50
end

-- Function to insert a new entry into the database
local function insertLeaderboardEntry(playerName)
    local length = generateRandomLength()
    local time = getCurrentDateTime()
    
    local sql = [[
        INSERT INTO leaderboard (player_name, length, caught_time)
        VALUES (?, ?, ?)
    ]]
    exports.oxmysql:insert(sql, {playerName, length, time}, function(id)
        if id then
            print(('Leaderboard entry added: %s, %f, %s'):format(playerName, length, time))
        else
            print('Failed to add leaderboard entry')
        end
    end)
end

-- Command to insert a new leaderboard entry
RegisterNetEvent('leaderboard:insert')
AddEventHandler('leaderboard:insert', function()
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    local playerName = player.PlayerData.charinfo.firstname .. " " .. player.PlayerData.charinfo.lastname

    if playerName and playerName ~= '' then
        insertLeaderboardEntry(playerName)
    else
        print('Invalid player name')
    end
end)

-- Function to get leaderboard data from the database
local function getLeaderboardData(cb)
    local sql = [[
        SELECT player_name, length, DATE_FORMAT(caught_time, '%h:%i:%s %p') as caught_time
        FROM leaderboard
        ORDER BY length DESC
        LIMIT 12
    ]]
    exports.oxmysql:execute(sql, {}, function(results)
        if results then
            cb(results)
        else
            cb({})
        end
    end)
end


RegisterNetEvent('leaderboard:open')
AddEventHandler('leaderboard:open', function()
    local src = source
    getLeaderboardData(function(data)
        TriggerClientEvent('leaderboard:sendData', src, data)
    end)
end)

-- Eventos
QBCore.Functions.CreateUseableItem("fishingrod", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('jomidar-fishing:start', source)
    end
end)

RegisterNetEvent('jomidar-fishing:removebait', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local quantity = 1

    Player.Functions.RemoveItem('fishbait', quantity)
end)

RegisterNetEvent('jomidar-fishing:reward', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    -- Select a random fish from the Config.Fishes list
    local fishData = Config.Fishes[math.random(#Config.Fishes)]
    local quantity = math.random(fishData.amount[1], fishData.amount[2])  -- Random amount within the specified range

    if Player.Functions.AddItem(fishData.name, quantity) then
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[fishData.name], 'add')
    else
        TriggerClientEvent('QBCore:Notify', src, 'You have full pockets.', 'error')
    end
end)

RegisterNetEvent('fishbasket:craft', function(fishName, requiredAmount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    print('Received data on server:', fishName, requiredAmount)
    if Player then
        local hasFish = Player.Functions.GetItemByName(fishName, requiredAmount)
        if hasFish then
            Player.Functions.RemoveItem(fishName, requiredAmount)
            Player.Functions.AddItem('fishcontainer', 1)
            TriggerClientEvent('QBCore:Notify', src, 'You crafted a ' .. fishName .. ' basket!', 'success')
        else
            TriggerClientEvent('QBCore:Notify', src, 'You do not have enough ' .. fishName .. ' to craft a basket!', 'error')
        end
    end
end)

RegisterNetEvent('jomidar:delivery', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local mindeliveryreward = Config.FishBasket.mindeliveryreward 
    local maxdeliveryreward = Config.FishBasket.maxdeliveryreward
    local price = math.random(mindeliveryreward, maxdeliveryreward)
    if Player then
        local hasFish = Player.Functions.GetItemByName("fishcontainer")
        if hasFish then
            Player.Functions.RemoveItem('fishcontainer', 1)
            Player.Functions.AddMoney('cash', price)
            TriggerClientEvent('QBCore:Notify', src, 'You Sold Fish Basket For'..price..'$', 'success')
        else
            TriggerClientEvent('QBCore:Notify', src, 'You didnt sell', 'error')
        end
    end
end)

