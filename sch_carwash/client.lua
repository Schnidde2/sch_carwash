-- Created by Schnidde
local ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

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

local display = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if Config.ServerLogo then
			SendNUIMessage({action = "showLogo"})
			Citizen.Wait(5000000)
		else
			SendNUIMessage({action = "hideLogo"})
			Citizen.Wait(5000000)
		end
	end
end)

Citizen.CreateThread(function()
	for i=1, #Config.Locations, 1 do
		carWashLocation = Config.Locations[i]

		local blip = AddBlipForCoord(carWashLocation)
		SetBlipSprite(blip, 100)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentString(('Carwash'))
		EndTextCommandSetBlipName(blip)
	end
	Citizen.Wait(500000000)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local canSleep = true

		function hintToDisplay(text, bool)
			BeginTextCommandDisplayHelp("STRING")
			AddTextComponentString(text)
			DisplayHelpTextFromStringLabel(0, 0, bool, -1)
		end

		if CanWashVehicle() then

			for i=1, #Config.Locations, 1 do
				local carWashLocation = Config.Locations[i]
				local distance = GetDistanceBetweenCoords(coords, carWashLocation, true)

				if distance < 50 then
					DrawMarker(1, carWashLocation, 0, 0, 0, 0, 0, 0, 5.0, 5.0, 2.0, 0, 157, 0, 155, false, false, 2, false, false, false, false)
					canSleep = false
				end

				if distance < 5 then
					canSleep = false
					hintToDisplay('Drücke ~INPUT_CONTEXT~ um die Autowäsche zu öffnen', false)

					if IsControlJustReleased(0, 38) then
						if Config.FixPremium then
							SendNUIMessage({action = "showPremium"})
                       		SendNUIMessage({action = "setStandard", pr = Config.StandardPreis})
                       		SendNUIMessage({action = "setPremium", pr = Config.PremiumPreis})
                        	SetDisplay(not display)
						else
							SendNUIMessage({action = "showNormal"})
                        	SendNUIMessage({action = "setStandard", pr = Config.StandardPreis})
                        	SendNUIMessage({action = "setPremium", pr = Config.PremiumPreis})
                        	SetDisplay(not display)
						end
					end
				end
			end

			if canSleep then
				Citizen.Wait(5000)
			end

		else
			Citizen.Wait(5000)
		end
	end
end)

function CanWashVehicle()
	local playerPed = PlayerPedId()

	if IsPedSittingInAnyVehicle(playerPed) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)

		if GetPedInVehicleSeat(vehicle, -1) == playerPed then
			return true
		end
	end

	return false
end

RegisterNUICallback("WashVehicle", function()
	local vehicle = GetVehiclePedIsIn(PlayerPedId())
	if GetVehicleDirtLevel(vehicle) > 3.0 then
		ESX.TriggerServerCallback('esx_carwash:canAfford2', function(canAfford2)
			if canAfford2 then
				if Config.FixPremium then
					local vehicle = GetVehiclePedIsIn(PlayerPedId())
					SetVehicleDirtLevel(vehicle, 0.1)
					SetVehicleFixed(vehicle)
					TriggerEvent('notifications', 'rgb(0, 255, 0)', 'AUTOWÄSCHE', 'Du hast dein Fahrzeug erfolgreich mit der Premium-Wäsche gewaschen!')
					SetDisplay(false)
					Citizen.Wait(50000)
				else
					local vehicle = GetVehiclePedIsIn(PlayerPedId())
					SetVehicleDirtLevel(vehicle, 0.1)
					TriggerEvent('notifications', 'rgb(0, 255, 0)', 'AUTOWÄSCHE', 'Du hast dein Fahrzeug erfolgreich mit der Premium-Wäsche gewaschen!')
					SetDisplay(false)
					Citizen.Wait(50000)
				end
			else
				SetDisplay(false)
				TriggerEvent('notifications', 'rgb(255, 0, 0)', 'AUTOWÄSCHE', 'Du hast nicht genug Geld dabei!')
				Citizen.Wait(50000)
			end
		end)
	else
		SetDisplay(false)
		TriggerEvent('notifications', 'rgb(255, 0, 0)', 'AUTOWÄSCHE', 'Dein Fahrzeug ist noch nicht schmutzig genug!')
		Citizen.Wait(50000)
	end
end)

RegisterNUICallback("WashHalfVehicle", function()
	local vehicle = GetVehiclePedIsIn(PlayerPedId())
	if GetVehicleDirtLevel(vehicle) > 3.0 then
		ESX.TriggerServerCallback('esx_carwash:canAfford', function(canAfford)
			if canAfford then
				local vehicle = GetVehiclePedIsIn(PlayerPedId())
				SetVehicleDirtLevel(vehicle, 1.5)
				TriggerEvent('notifications', 'rgb(0, 255, 0)', 'AUTOWÄSCHE', 'Du hast dein Fahrzeug erfolgreich mit der Standard-Wäsche gewaschen!')
				SetDisplay(false)
				Citizen.Wait(50000)
			else
				SetDisplay(false)
				TriggerEvent('notifications', 'rgb(255, 0, 0)', 'AUTOWÄSCHE', 'Du hast nicht genug Geld dabei!')
				Citizen.Wait(50000)
			end
		end)
	else
		SetDisplay(false)
		TriggerEvent('notifications', 'rgb(255, 0, 0)', 'AUTOWÄSCHE', 'Dein Fahrzeug ist noch nicht schmutzig genug!')
		Citizen.Wait(50000)
	end
end)

RegisterNUICallback("exit", function(data)
    SetDisplay(false)
end)


function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })
end