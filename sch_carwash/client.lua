-- Created by Schnidde
local ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

CreateThread(function()
	if Config.ServerLogo then
		SendNUIMessage({action = "showLogo"})
	end
	SendNUIMessage({
		action = "SetValues", 
		sp = Config.StandardPreis,
		pp = Config.PremiumPreis
	})
	if Config.FixPremium then
		SendNUIMessage({action = "ShowDetails", type = "premium"})
	else
		SendNUIMessage({action = "showNormal", type = "normal"})
	end
end)

CreateThread(function()
	for (k, v in pairs(Config.Locations)) do
		local blip = AddBlipForCoord(v)
		SetBlipSprite(blip, 100)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentString(('Carwash'))
		EndTextCommandSetBlipName(blip)
	end
end)

function hintToDisplay(text, bool)
	BeginTextCommandDisplayHelp("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, bool, -1)
end

CreateThread(function()
	while true do
		Wait(0)
		if CanWashVehicle() then
			for (k, v in pairs(Config.Locations)) do
				local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v, true)
				if distance < 50 then
					DrawMarker(1, v, 0, 0, 0, 0, 0, 0, 5.0, 5.0, 2.0, 0, 157, 0, 155, false, false, 2, false, false, false, false)
					if distance < 5 then
						hintToDisplay('Drücke ~INPUT_CONTEXT~ um die Autowäsche zu öffnen', false)
						if IsControlJustReleased(0, 38) then
							local vehicle = GetVehiclePedIsIn(PlayerPedId())
							if GetVehicleDirtLevel(vehicle) > 3.0 then
								SetNuiFocus(true, true)
								SendNUIMessage({
									type = "UI",
									bool = true,
								})
							else
								TriggerEvent('notifications', 'rgb(255, 0, 0)', 'AUTOWÄSCHE', 'Dein Fahrzeug ist noch nicht schmutzig genug!')
							end
						end
					end
				end
			end
		else
			Wait(5000)
		end
	end
end)

function CanWashVehicle()
	if IsPedSittingInAnyVehicle(PlayerPedId()) then
		if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId() then
			return true
		end
	end
	return false
end

RegisterNUICallback("WashVehicle", function()
	local vehicle = GetVehiclePedIsIn(PlayerPedId())
	ESX.TriggerServerCallback('esx_carwash:canAfford', function(canAfford)
		if canAfford then
			if Config.FixPremium then
				SetVehicleDirtLevel(vehicle, 0.1)
				SetVehicleFixed(vehicle)
				TriggerEvent('notifications', 'rgb(0, 255, 0)', 'AUTOWÄSCHE', 'Du hast dein Fahrzeug erfolgreich mit der Premium-Wäsche gewaschen!')
				HideUI(false)
			else
				SetVehicleDirtLevel(vehicle, 0.1)
				TriggerEvent('notifications', 'rgb(0, 255, 0)', 'AUTOWÄSCHE', 'Du hast dein Fahrzeug erfolgreich mit der Premium-Wäsche gewaschen!')
				HideUI(false)
			end
		else
			HideUI(false)
			TriggerEvent('notifications', 'rgb(255, 0, 0)', 'AUTOWÄSCHE', 'Du hast nicht genug Geld dabei!')
		end
	end, "premium")
end)

RegisterNUICallback("WashHalfVehicle", function()
	local vehicle = GetVehiclePedIsIn(PlayerPedId())
	ESX.TriggerServerCallback('esx_carwash:canAfford', function(canAfford)
		if canAfford then
			SetVehicleDirtLevel(vehicle, 1.5)
			TriggerEvent('notifications', 'rgb(0, 255, 0)', 'AUTOWÄSCHE', 'Du hast dein Fahrzeug erfolgreich mit der Standard-Wäsche gewaschen!')
			HideUI(false)
		else
			HideUI(false)
			TriggerEvent('notifications', 'rgb(255, 0, 0)', 'AUTOWÄSCHE', 'Du hast nicht genug Geld dabei!')
		end
	end, "standard")
end)

RegisterNUICallback("exit", function(data)
    SetNuiFocus(false, false)
end)

function HideUI()
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "UI",
        bool = false,
    })
end