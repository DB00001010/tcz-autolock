local QBCore = exports['qb-core']:GetCoreObject()
local autoLockEnabled = {}

-- Command to toggle Auto-Lock
QBCore.Commands.Add("autolock", "Toggle Auto-Lock", {}, false, function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if not Player then return end

    -- Toggle Auto-Lock state
    if Config.Persistent then
        local autolockState = Player.Functions.GetMetaData('tcz-autolock') or false

        autoLockEnabled[src] = not autolockState

        Player.Functions.SetMetaData('tcz-autolock', autoLockEnabled[src])
    else
        autoLockEnabled[src] = not autoLockEnabled[src]
    end

    TriggerClientEvent('tcz-autolock:toggle', src, autoLockEnabled[src]) -- Let the client handle the notification
end)

-- Cleanup on player disconnect
AddEventHandler('playerDropped', function()
    local src = source
    autoLockEnabled[src] = nil
end)
