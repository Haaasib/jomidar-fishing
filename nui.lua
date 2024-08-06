-- client.lua

local entries = {}

-- Function to update the leaderboard display
function updateLeaderboard()
    -- Sort entries by length in descending order
    table.sort(entries, function(a, b) return b.length > a.length end)
    
    -- Update the leaderboard display
    for i, entry in ipairs(entries) do
        local index = i

        -- Ensure the elements exist before updating their content
        SendNUIMessage({
            type = 'updateEntry',
            index = index,
            rank = '#' .. index,
            length = string.format('%.1f', entry.length),
            name = entry.player_name,
            time = entry.caught_time
        })
    end
end
RegisterNetEvent("qb-uwucafe:client:openShop", function()
    TriggerServerEvent("inventory:server:OpenInventory", "shop", "FishingShop", Config.Items)
end)
-- Register NUI callback to handle showing and hiding the leaderboard
RegisterNUICallback('toggleLeaderboard', function(data, cb)
    toggleLeaderboard()
    cb('ok')
end)

-- Function to toggle leaderboard visibility
function toggleLeaderboard()
    SetNuiFocus(1, 1)
    SendNUIMessage({
        type = 'toggleLeaderboard'
    })
end

-- Event to receive leaderboard data from the server
RegisterNetEvent('leaderboard:sendData')
AddEventHandler('leaderboard:sendData', function(data)
    entries = data
    updateLeaderboard()
    toggleLeaderboard() -- Show the leaderboard when data is received
end)

RegisterNUICallback("close", function()
    SetNuiFocus(0, 0)
end)