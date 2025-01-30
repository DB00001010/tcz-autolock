local QBCore = exports['qb-core']:GetCoreObject()
local autoLockEnabled = {}

-- Command to toggle Auto-Lock
QBCore.Commands.Add("autolock", "Toggle Auto-Lock", {}, false, function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    -- Toggle Auto-Lock state
    autoLockEnabled[src] = not autoLockEnabled[src]
    TriggerClientEvent('tcz-autolock:toggle', src, autoLockEnabled[src]) -- Let the client handle the notification
end)

-- Cleanup on player disconnect
AddEventHandler('playerDropped', function()
    local src = source
    autoLockEnabled[src] = nil
end)
