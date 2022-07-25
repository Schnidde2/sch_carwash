ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('esx_carwash:canAfford', function(source, cb, type)
	local xPlayer = ESX.GetPlayerFromId(source)
	if type == "standard" then
		if xPlayer.getMoney() >= Config.StandardPreis then
			xPlayer.removeMoney(Config.StandardPreis)
			cb(true)
		else
			cb(false)
		end
	elseif type == "premium" then
		if xPlayer.getMoney() >= Config.PremiumPreis then
			xPlayer.removeMoney(Config.PremiumPreis)
			cb(true)
		else
			cb(false)
		end
	end
end)