local AircraftData = {}

RegisterServerEvent("airplanes:updateTransponder")
AddEventHandler("airplanes:updateTransponder", function(data)
    local aircraft = data.aircraft
    local altitude = data.altitude
    local coords = data.coords
    local netID = data.netID

    AircraftData[netID] = {
        aircraft = aircraft,
        coords = coords,
        altitude = altitude
    }
end)

Citizen.CreateThread(function()
    while true do 
        Wait(10000)
        TriggerClientEvent("airplanes:updateTransponders", -1, AircraftData)
        AircraftData = {}
    end
end)
