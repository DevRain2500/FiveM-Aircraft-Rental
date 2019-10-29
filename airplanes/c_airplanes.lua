--
-- This script is built for a server using a custom interface. All of the menu options will need to be replaced
-- with whatever your server uses to display menus. This script also uses some proprietary functions.
-- Script also contains optional TokoVOIP integration for pilots to communicate.
--
local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
local enabled = true -- Toggle the entire script
local debug = false  -- Toggles Debug prints
local blipsCreated = false
local whitelisted = false 
local whitelistedAdv = false 
local vehicleIn = nil
local playerPed = nil 
local playerCoords = nil 
local interactCoords = {x = -941.177, y = -2954.494, z = 14.0, head = 330.262} -- Coords of where you want the player to get the plane from.
local vehicleSpawn = {x = -962.616, y = -2985.150, z = 13.945, head = 60.162} -- Coords of where you want the aircraft to spawn.
local vehicleReturn = {x = -962.616, y = -2985.150, z = 12.6} -- Coords of where you want the aircraft to be returned.
local modShop = {x = -961.970, y = -3030.213, z = 13.945} -- Basic Modication shop that enables simple commands.
local vehicleList = { -- List of aircraft you want to be purchasable.
    -- PLANES
    {name = "Cuban 800", hash = "cuban800", price = 3000},
    {name = "[S] Dodo", hash = "dodo", price = 4000},
    {name = "Mallard", hash = "stunt", price = 3000},
    {name = "Mammatus", hash = "Mammatus", price = 2000},
    {name = "[S] Mammatus Seaplane", hash = "mammatus2", price = 2250},
    {name = "Mammoth Scamp", hash = "scamp", price = 2750},
    {name = "Nimbus", hash = "nimbus", price = 30000},
    {name = "[S] Seabreeze", hash = "seabreeze", price = 4000},
    {name = "Velum", hash = "velum", price = 4500},
    {name = "Velum 5 Seater", hash = "velum2", price = 6000},
    {name = "Vestra", hash = "vestra", price = 8000},
}
local vehicleListAdv = { -- Optional "Advanced" whitelist enabling bigger aircraft.
    -- PLANES
    {name = "Alpha-Z1", hash = "alphaz1", price = 1},
    {name = "Duster", hash = "duster", price = 1},
    {name = "Howard NX-25", hash = "howard", price = 1},
    {name = "Luxor", hash = "luxor", price = 1},
    {name = "Luxor Deluxe", hash = "luxor2", price = 1},
    {name = "Miljet", hash = "miljet", price = 1},
    {name = "Shamal", hash = "shamal", price = 1},
    {name = "Ultralight", hash = "microlight", price = 1},
    -- HELICOPTERS
    {name = "Frogger", hash = "frogger", price = 1},
    {name = "Frogger 2", hash = "frogger2", price = 1},
    {name = "Havok", hash = "havpk", price = 1},
    {name = "Maverick", hash = "maverick", price = 1},
    {name = "[S] Sea Sparrow ", hash = "seasparrow", price = 1},
    {name = "Super Volito", hash = "supervolito", price = 1},
    {name = "Super Volito Carbon", hash = "supervolito2", price = 1},
    {name = "Swift", hash = "swift", price = 1},
    {name = "Swift Deluxe", hash = "swift2", price = 1},
    {name = "Volatus", hash = "volatus", price = 1},
}
local whitelist = {
    "Value Here", -- Replace this with the identifier of who you want to be whitelisted.
}
local advancedWhitelist = {
    "Value Here", -- Replace this with the identifier of who you want to be whitelisted.
}
local flightRestrictions = { -- Basic Circles around specific areas to show "no-fly zones"
    {name = "Ft. Zancudo",              x = -2141.586,  y = 3178.877,   z = 32.81013, radius = 800.0, color = 1},
    {name = "Legion Square",            x = 31.39226,   y = -765.3126,  z = 44.23602, radius = 400.0, color = 1},
    {name = "Grapeseed Airstrip",       x = 2025.654,   y = 4761.278,   z = 41.06352, radius = 200.0, color = 5},
    {name = "Sandy Shores Airfield",    x = 1405.581,   y = 3137.786,   z = 40.77586, radius = 400.0, color = 5},
    {name = "LSIA",                     x = -1200.354,  y = -2825.568,  z = 13.94915, radius = 800.0, color = 2},
    {name = "PBSO Heli Pad",            x = -475.5216,  y = 5988.752,   z = 31.33669, radius = 30.0, color = 3},
    {name = "PBMC Heli Pad",            x = -237.6033,  y = 6256.987,   z = 33.32935, radius = 30.0, color = 3},
    {name = "SSMC Heli Pad",            x = 1799.038,   y = 3720.97,    z = 35.89063, radius = 30.0, color = 3},
    {name = "PBMC Heli Pad",            x = 351.9945,   y = -588.4936,  z = 74.16557, radius = 30.0, color = 3},
    {name = "MRPD Heli Pad",            x = 449.3239,   y = -981.2422,  z = 43.6917,  radius = 30.0, color = 3},
    {name = "VPD Heli Pad",             x = -1095.537,  y = -834.9784,  z = 37.63285, radius = 30.0, color = 3},
    {name = "BBSP Heli Pad",            x = 1690.902,   y = 2604.603,   z = 50.00000, radius = 30.0, color = 3},
    {name = "BBSPD",                    x = 1690.902,   y = 2604.603,   z = 47.44394, radius = 200.0, color = 1},
}

local function setWhitelisted()
    whitelisted = true
end

local function setAdvWhitelist()
    whitelistedAdv = true
end

local function TakeMoney(amount)
    -- Insert function for removing money here.
    -- There is currently no check for how much money the player has. Only removal. Or you can just leave this blank.
end

local function spawnPlane(idx, adv)
    if adv ~= "adv" then
        TakeMoney(vehicleList[idx].price)
        RequestModel(GetHashKey(vehicleList[idx].hash))
        while not HasModelLoaded(GetHashKey(vehicleList[idx].hash)) do
            Wait(5)
        end
        plane = exports.GTALife:createRentedVehicle(vehicleList[idx].hash, vehicleSpawn.x, vehicleSpawn.y, vehicleSpawn.z, vehicleSpawn.head)
        SetModelAsNoLongerNeeded(GetHashKey(vehicleList[idx].hash))
        local reg = math.random(10000,99999)
        SetVehicleNumberPlateText(plane, "N"..reg)
    else
        TakeMoney(vehicleListAdv[idx].price)
        RequestModel(GetHashKey(vehicleListAdv[idx].hash))
        while not HasModelLoaded(GetHashKey(vehicleListAdv[idx].hash)) do
            Wait(5)
        end
        plane = exports.GTALife:createRentedVehicle(vehicleListAdv[idx].hash, vehicleSpawn.x, vehicleSpawn.y, vehicleSpawn.z, vehicleSpawn.head)
        SetModelAsNoLongerNeeded(GetHashKey(vehicleListAdv[idx].hash))
        local reg = math.random(10000,99999)
        SetVehicleNumberPlateText(plane, "N"..reg)
    end
end

local function openMainMenu()
	exports.interface:reset();
	exports.interface:newMenu("ListVehicleOptions", "ListVehicleOptions", false);
	exports.interface:addButtonToMenu("ListVehicleOptions", "ListVehicleOptions:closeMenu", "<span style='color:#ff0000;'>Close</span>", [[Interface.hide()]]);
    exports.interface:addButtonToMenu("ListVehicleOptions", "ListVehicleOptions:WIP", "<font color='orange'>Page is WIP</font>", function() end);
    for veh = 1, #vehicleList do
        exports.interface:addButtonToMenu("ListVehicleOptions", "ListVehicleOptions:"..veh.."", "<div style='text-align: left;'>Price: <font color='lightgreen'>$"..vehicleList[veh].price.."</font> "..vehicleList[veh].name.."</div>", function() exports.interface:hide(); spawnPlane(veh); end);
    end
    exports.interface:addButtonToMenu("ListVehicleOptions", "ListVehicleOptions:WIP2", "<font color='orange'>Developer Section:</font>", function() end);
    if whitelistedAdv then
        for veh = 1, #vehicleListAdv do
            exports.interface:addButtonToMenu("ListVehicleOptions", "ListVehicleOptions:"..veh.."Adv", "<div style='text-align: left;'>Price: <font color='lightgreen'>$"..vehicleListAdv[veh].price.."</font>"..vehicleListAdv[veh].name.."</div>", function() exports.interface:hide(); spawnPlane(veh, "adv"); end);
        end
    end
    exports.interface:addButtonToMenu("ListVehicleOptions", "ListVehicleOptions:parachute", "Grab a parachute", function() exports.interface:hide(); GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("gadget_parachute"), 1, false, false); end);
	exports.interface:show("ListVehicleOptions");
end

local function planeWhitelistLoop()
    while enabled do
        Citizen.Wait(5000)
        for i = 1, #whitelist do
            --                 Replace this export with whatever your server uses to identify people.
            if whitelist[i] == exports.GTALife:GetPlayerRPNameFromSteamName(GetPlayerName(PlayerId())) then 
                setWhitelisted()
            end
        end
        for i = 1, #advancedWhitelist do
            --                         Replace this export with whatever your server uses to identify people.
            if advancedWhitelist[i] == exports.GTALife:GetPlayerRPNameFromSteamName(GetPlayerName(PlayerId())) then 
                setAdvWhitelist()
            end
        end
    end
end

local function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
  SetTextFont(font)
  SetTextProportional(0)
  SetTextScale(scale, scale)
  SetTextColour(r, g, b, a)
  SetTextDropShadow(0, 0, 0, 0,255)
  SetTextEdge(1, 0, 0, 0, 255)
  SetTextDropShadow()
  SetTextOutline()
  SetTextCentre(centre)
  SetTextEntry("STRING")
  AddTextComponentString(text)
  DrawText(x , y) 
end

local function displayColorOptions()
    local currentX = 0.01
    local currentY = 0.20
    drawTxt("Color List:\n https://wiki.gtanet.work/index.php?title=Vehicle_Colors", 4, false, currentX, currentY-0.01, 0.25, 255, 255, 255, 255)
end

local function CreateTheBlip()
    local interactBlip = AddBlipForCoord(interactCoords.x, interactCoords.y, interactCoords.z)
    SetBlipSprite(interactBlip, 251)
    SetBlipColour(interactBlip, 3)
    SetBlipAsShortRange(interactBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('SA Aviation Center')
    EndTextCommandSetBlipName(interactBlip)
end

Citizen.CreateThread(function()
    CreateTheBlip()
    while true do
        Wait(5)
        playerPed = GetPlayerPed(-1)
        playerCoords = GetEntityCoords(playerPed, true)
        vehicleIn = GetVehiclePedIsIn(playerPed, false)
        if whitelisted then
            if not blipsCreated then
                for i = 1, #flightRestrictions do 
                    local blip = AddBlipForRadius(flightRestrictions[i].x, flightRestrictions[i].y, flightRestrictions[i].z, flightRestrictions[i].radius)
                    SetBlipColour(blip, flightRestrictions[i].color)
                    SetBlipAlpha(blip, 150)
                end
                blipsCreated = true 
            end
            if GetDistanceBetweenCoords(playerCoords, interactCoords.x, interactCoords.y, interactCoords.z, true) < 20 then
                DrawMarker(33, interactCoords.x, interactCoords.y, interactCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, interactCoords.head, 1.0, 1.0, 1.0, 255, 255, 255, 255, true, false, 2, false, null, null, false)
            end
            if GetDistanceBetweenCoords(playerCoords, interactCoords.x, interactCoords.y, interactCoords.z, true) < 2 then
                drawTxt('Press ~g~[E]~s~ to select an aircraft.',0,1,0.5,0.8,0.6,255,255,255,255)
                if IsControlJustPressed(0, Keys['E']) then
                    openMainMenu()
                end
            end
            if GetDistanceBetweenCoords(playerCoords, vehicleReturn.x, vehicleReturn.y, vehicleReturn.z, true) < 50 and (IsPedInAnyPlane(playerPed) or IsPedInAnyHeli(playerPed)) then
                DrawMarker(1, vehicleReturn.x, vehicleReturn.y, vehicleReturn.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 20.0, 20.0, 1.0, 255, 0, 0, 255, false, false, 2, false, null, null, false)
                if GetDistanceBetweenCoords(playerCoords, vehicleReturn.x, vehicleReturn.y, vehicleReturn.z, true) < 20 then
                    drawTxt('Press ~g~[E]~s~ to return this aircraft.',0,1,0.5,0.8,0.6,255,255,255,255)
                    if IsControlJustPressed(0, Keys['E']) then
                        DeleteEntity(GetVehiclePedIsIn(playerPed, false))
                    end
                end
            end
            if GetDistanceBetweenCoords(playerCoords, modShop.x, modShop.y, modShop.z) < 50 and (IsPedInAnyPlane(playerPed) or IsPedInAnyHeli(playerPed)) then
                DrawMarker(1, modShop.x, modShop.y, modShop.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 10.0, 10.0, 1.0, 0, 0, 255, 255, false, false, 2, false, null, null, false)
                if GetDistanceBetweenCoords(playerCoords, modShop.x, modShop.y, modShop.z) < 20 then
                    drawTxt('/setpaint # # # or /setlivery #',0,1,0.5,0.8,0.6,255,255,255,255)
                    displayColorOptions()
                end
            end
        end
        if debug then
            --print("||c_airplanes.lua|| Whitelisted? "..tostring(whitelisted))
            --print(GetDistanceBetweenCoords(playerCoords, iX, iY, iZ, true))
            --print(playerCoords)
            --print(vehicleSpawn.x)
            --print(GetVehiclePedIsIn(playerPed, false))
        end
    end
end)

RegisterCommand('setpaint', function(source, args, rawCommand)
    if GetDistanceBetweenCoords(playerCoords, modShop.x, modShop.y, modShop.z) < 10 then
        SetVehicleColours(vehicleIn, tonumber(args[1]), tonumber(args[2]))
        if args[3] ~= nil then
            SetVehicleExtraColours(vehicleIn, tonumber(args[3]))
        end
    else 
        TriggerEvent("ShowInformationLeft", 5000, "Not near a mod shop.")
    end
end, false)

RegisterCommand('setlivery', function(source, args, rawCommand)
    TriggerEvent("ShowInformationLeft", 5000, "Possible Liveries: "..GetVehicleLiveryCount(vehicleIn, false))
    if GetDistanceBetweenCoords(playerCoords, modShop.x, modShop.y, modShop.z) < 10 then
        if args[1] ~= nil then
            SetVehicleLivery(vehicleIn, tonumber(args[1]))
        end
    else 
        TriggerEvent("ShowInformationLeft", 5000, "Not near a mod shop.")
    end
end, false)

local onRadio = false
RegisterCommand('atc', function(source, args, rawCommand)
    
    if whitelisted and not onRadio then
        exports.tokovoip_script:addPlayerToRadio(11)
        TriggerEvent("ShowInformationLeft", 2000, "Joining ATC")
        onRadio = true
    else
        exports.tokovoip_script:removePlayerFromRadio(11)
        TriggerEvent("ShowInformationLeft", 2000, "Leaving ATC")
        onRadio = false
    end

end, false)

local function RunPlaneThread()
    Citizen.CreateThread(planeWhitelistLoop)
end

AddEventHandler("playerSpawned", RunPlaneThread)

RegisterCommand('manuallystartairplanescauseimtoolazytorestartframework', function(source, args, rawCommand)
    -- This command resets the whitelist check for when the resource is restarted without leaving the game.
    RunPlaneThread()
    
end, false)
