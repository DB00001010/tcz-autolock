Config = {}

Config.AutoLockDistance = 10.0 -- Distance to lock the vehicle

Config.AutoUnlockDistance = 5.0 -- Distance to unlock the vehicle

Config.DistanceCheckInterval = 1000 -- Timer interval for distance checks (in ms)

Config.LastVehicleTrackTime = 500 -- Timer interval for last vehicle tracking (in ms)

Config.Persistent = true

Config.Notifications = {
    autolock_activated = "Auto-Lock Activated",
    autolock_deactivated = "Auto-Lock Deactivated",
    vehicle_autolocked = "Vehicle Auto-Locked",
    vehicle_autounlocked = "Vehicle Auto-Unlocked",
}
