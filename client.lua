local QBCore = exports['qb-core']:GetCoreObject()
local autoLockEnabled = false
local lastDriven = nil
local lockState = false

-- Sync Auto-Lock toggle state
RegisterNetEvent('tcz-autolock:toggle', function(state)
    autoLockEnabled = state
    QBCore.Functions.Notify(state and Config.Notifications.autolock_activated or Config.Notifications.autolock_deactivated, "success")

    -- Play sound effect when toggling Auto-Lock
    local sound, soundSet = state and "CONFIRM_BEEP" or "Beep_Red", state and "HUD_MINI_GAME_SOUNDSET" or "DLC_HEIST_HACKING_SNAKE_SOUNDS"
    PlaySoundFrontend(-1, sound, soundSet, true)
end)

-- Track the last driven vehicle
CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)

        if veh ~= 0 and GetPedInVehicleSeat(veh, -1) == ped then
            lastDriven = { netId = NetworkGetNetworkIdFromEntity(veh), plate = GetVehicleNumberPlateText(veh) }
        end

        Wait(Config.LastVehicleTrackTime) -- Polling interval for tracking last driven vehicle
    end
end)

-- Distance-based locking/unlocking
CreateThread(function()
    while true do
        if autoLockEnabled and lastDriven then
            local ped = PlayerPedId()
            local lastVeh = NetworkGetEntityFromNetworkId(lastDriven.netId)
            local playerCoords = GetEntityCoords(ped)

            if DoesEntityExist(lastVeh) then
                local vehCoords = GetEntityCoords(lastVeh)
                local distance = #(playerCoords - vehCoords)
                local occupantCount = GetVehicleNumberOfPassengers(lastVeh) + (IsVehicleSeatFree(lastVeh, -1) and 0 or 1)

                -- Lock vehicle if the player is beyond AutoLockDistance
                if distance > Config.AutoLockDistance and occupantCount == 0 and not lockState then
                    LockVehicle(lastVeh, true) -- Lock the vehicle
                    lockState = true
                    QBCore.Functions.Notify(Config.Notifications.vehicle_autolocked, "success")

                -- Unlock vehicle if the player is within AutoUnlockDistance
                elseif distance < Config.AutoUnlockDistance and lockState then
                    LockVehicle(lastVeh, false) -- Unlock the vehicle
                    lockState = false
                    QBCore.Functions.Notify(Config.Notifications.vehicle_autounlocked, "success")
                end
            else
                -- Reset if the vehicle no longer exists
                lastDriven = nil
                lockState = false
            end
        end

        Wait(Config.DistanceCheckInterval) -- Interval for checking distance
    end
end)

-- Function to lock or unlock a vehicle
function LockVehicle(veh, lock)
    local lockState = lock and 2 or 1 -- 2 = Locked, 1 = Unlocked
    TriggerServerEvent('qb-vehiclekeys:server:setVehLockState', NetworkGetNetworkIdFromEntity(veh), lockState)

    -- Flash vehicle lights as feedback
    SetVehicleLights(veh, 2)
    Wait(250)
    SetVehicleLights(veh, 1)
    Wait(200)
    SetVehicleLights(veh, 0)

    -- Play lock/unlock sound
    local sound = lock and "Remote_Control_Close" or "Remote_Control_Open"
    PlaySoundFromEntity(-1, sound, veh, "PI_Menu_Sounds", 0, 0)
end

AddEventHandler('QBCore:Client:OnPlayerLoaded', function ()
    if Config.Persistent then
        QBCore.Functions.GetPlayerData(function(PlayerData)
            if PlayerData.metadata['tcz-autolock'] then
                autoLockEnabled = PlayerData.metadata['tcz-autolock'] or false
            end
        end)
    end
end)
