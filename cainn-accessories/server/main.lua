ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('cainn-accessories:pay')
AddEventHandler('cainn-accessories:pay', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeMoney(Config.Price)
	TriggerClientEvent('esx:showNotification', _source, _U('you_paid', Config.Price))

end)

RegisterServerEvent('cainn-accessories:save')
AddEventHandler('cainn-accessories:save', function(skin, accessory)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerEvent('esx_datastore:getDataStore', 'user_' .. string.lower(accessory), xPlayer.identifier, function(store)
		
		store.set('has' .. accessory, true)

		local itemSkin = {}
		local item1 = string.lower(accessory) .. '_1'
		local item2 = string.lower(accessory) .. '_2'
		itemSkin[item1] = skin[item1]
		itemSkin[item2] = skin[item2]
		store.set('skin', itemSkin)

	end)

end)

ESX.RegisterServerCallback('cainn-accessories:get', function(source, cb, accessory)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'user_' .. string.lower(accessory), xPlayer.identifier, function(store)
		
		local hasAccessory = (store.get('has' .. accessory) and store.get('has' .. accessory) or false)
		local skin = (store.get('skin') and store.get('skin') or {})

		cb(hasAccessory, skin)

	end)

end)

ESX.RegisterServerCallback('cainn-accessories:checkMoney', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.get('money') >= Config.Price then
		cb(true)
	else
		cb(false)
	end

end)

--------------------------
---- CRIADO POR CAINN ----
--------------------------