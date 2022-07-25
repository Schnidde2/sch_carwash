ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('esx_carwash:canAfford', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
		if xPlayer.getMoney() >= Config.StandardPreis then
			xPlayer.removeMoney(Config.StandardPreis)
			cb(true)
		else
			cb(false)
		end
end)

ESX.RegisterServerCallback('esx_carwash:canAfford2', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
		if xPlayer.getMoney() >= Config.PremiumPreis then
			xPlayer.removeMoney(Config.PremiumPreis)
			cb(true)
		else
			cb(false)
		end
end)