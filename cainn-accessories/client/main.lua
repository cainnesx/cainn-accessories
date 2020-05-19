ESX								= nil
local HasAlreadyEnteredMarker	= false
local LastZone					= nil
local CurrentAction				= nil
local CurrentActionMsg			= ''
local CurrentActionData			= {}
local isDead					= false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function OpenAccessoryMenu()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'set_unset_accessory',
	{
		title = _U('set_unset'),
		align = 'top-left',
		elements = {
			{label = _U('helmet'), value = 'Helmet'},
			{label = _U('ears'), value = 'Ears'},
			{label = _U('mask'), value = 'Mask'},
			{label = _U('glasses'), value = 'Glasses'}
		}
	}, function(data, menu)
		menu.close()
		SetUnsetAccessory(data.current.value)

	end, function(data, menu)
		menu.close()
	end)
end


RegisterCommand('m', function ()
	SetUnsetAccessory('Mask')
end)

RegisterCommand('c', function ()
	SetUnsetAccessory('Helmet')
end)

RegisterCommand('o', function ()
	SetUnsetAccessory('Glasses')
end)

RegisterCommand('ouv', function ()
	SetUnsetAccessory('Ears')
end)

function SetUnsetAccessory(accessory)
	ESX.TriggerServerCallback('cainn-accessories:get', function(hasAccessory, accessorySkin)
		local _accessory = string.lower(accessory)

		if hasAccessory then
			TriggerEvent('skinchanger:getSkin', function(skin)
				local ped = PlayerPedId()
				local mAccessory = -1
				local mColor = 0

				if _accessory == "mask" then
					mAccessory = 0
				end

				if skin[_accessory .. '_1'] == mAccessory then
					mAccessory = accessorySkin[_accessory .. '_1']
					mColor = accessorySkin[_accessory .. '_2']
				end

				local accessorySkin = {}
				accessorySkin[_accessory .. '_1'] = mAccessory
				accessorySkin[_accessory .. '_2'] = mColor

				if accessory == 'Mask' then
					local mascarilha = skin.mask_1

					if mascarilha > 0 then 
						anim("missfbi4","takeoff_mask")
						Citizen.Wait(1000)

					else
						anim("veh@common@fp_helmet@", "put_on_helmet")
						Citizen.Wait(1400)
					
					end
				end

				if accessory == 'Helmet' then
					local helmetfudido = skin.helmet_1

					if helmetfudido > 0 then 
						
						anim("missheist_agency2ahelmet","take_off_helmet_stand")
						Citizen.Wait(500)

					else
					anim("veh@common@fp_helmet@", "put_on_helmet")  
						Citizen.Wait(1200)
					
					end
				end

				if accessory == 'Glasses' then
					local oculoszao = skin.glasses_1

					if oculoszao > 0 then 
						animoculos("clothingspecs","take_off")


					else
						animtiraroculos("clothingspecs", "try_glasses_positive_a")

					
					end
				end

				if accessory == 'Ears' then
					local ouvidosmalucos = skin.ears_1

					if ouvidosmalucos > 0 then 


					else

					
					end
				end


				TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)



			end)

		else
			ESX.ShowNotification(_U('no_' .. _accessory))
		end


	end, accessory)
end

function animoculos(dict, anim)
	local ped = PlayerPedId()

	--local dict = "anim@mp_player_intmenu@key_fob@"
    
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(100)
    end

	  TaskPlayAnim(GetPlayerPed(-1), dict, anim, 8.0, 8.0, -1, 48, 1, false, false, false)
	  Citizen.Wait(1400)
	  ClearPedTasks(ped)

	  
end

function animtiraroculos(dict, anim)
	local ped = PlayerPedId()

	--local dict = "anim@mp_player_intmenu@key_fob@"
    
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(100)
    end

	  TaskPlayAnim(GetPlayerPed(-1), dict, anim, 8.0, 8.0, -1, 48, 1, false, false, false)
	  Citizen.Wait(1500)
	  ClearPedTasks(ped)

	  
end


TriggerEvent('chat:addSuggestion', '/m', 'Tirar/Por Mascaras', {
	{name = 'name', help = 'Colocar e tirar mascaras compradas na loja de mascaras.'}
})

TriggerEvent('chat:addSuggestion', '/m', 'Tirar/Por Mascaras Compradas')

TriggerEvent('chat:addSuggestion', '/c', 'Tirar/Por Capacete', {
	{name = 'name', help = 'Colocar e tirar capacete comprado.'}
})

TriggerEvent('chat:addSuggestion', '/c', 'Tirar/Por Capacete Compradas')

TriggerEvent('chat:addSuggestion', '/o', 'Tirar/Por Oculos', {
	{name = 'name', help = 'Colocar e tirar Oculos comprados.'}
})

TriggerEvent('chat:addSuggestion', '/o', 'Tirar/Por Oculos Compradas')

TriggerEvent('chat:addSuggestion', '/ea', 'Tirar/Por Acessorios de Ouvido', {
	{name = 'name', help = 'Colocar e tirar Acessorios de ouvido comprados.'}
})

TriggerEvent('chat:addSuggestion', '/ea', 'Tirar/Por Acessorios de Ouvido Comprados')

function anim(dict, anim)

    
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(100)
    end

      TaskPlayAnim(GetPlayerPed(-1), dict, anim, 8.0, 8.0, -1, 48, 1, false, false, false)
end

function OpenShopMenu(accessory)
	local _accessory = string.lower(accessory)
	local restrict = {}

	restrict = { _accessory .. '_1', _accessory .. '_2' }
	
	TriggerEvent('esx_skin:openRestrictedMenu', function(data, menu)

		menu.close()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm',
		{
			title = _U('valid_purchase'),
			align = 'top-left',
			elements = {
				{label = _U('no'), value = 'no'},
				{label = _U('yes', ESX.Math.GroupDigits(Config.Price)), value = 'yes'}
			}
		}, function(data, menu)
			menu.close()
			if data.current.value == 'yes' then
				ESX.TriggerServerCallback('cainn-accessories:checkMoney', function(hasEnoughMoney)
					if hasEnoughMoney then
						TriggerServerEvent('cainn-accessories:pay')
						TriggerEvent('skinchanger:getSkin', function(skin)
							TriggerServerEvent('cainn-accessories:save', skin, accessory)
						end)
					else
						TriggerEvent('esx_skin:getLastSkin', function(skin)
							TriggerEvent('skinchanger:loadSkin', skin)
						end)
						ESX.ShowNotification(_U('not_enough_money'))
					end
				end)
			end

			if data.current.value == 'no' then
				local player = PlayerPedId()
				TriggerEvent('esx_skin:getLastSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
				end)
				if accessory == "Ears" then
					ClearPedProp(player, 2)
				elseif accessory == "Mask" then
					SetPedComponentVariation(player, 1, 0 ,0, 2)
				elseif accessory == "Helmet" then
					ClearPedProp(player, 0)
				elseif accessory == "Glasses" then
					SetPedPropIndex(player, 1, -1, 0, 0)
				end
			end
			CurrentAction     = 'shop_menu'
			CurrentActionMsg  = _U('press_access')
			CurrentActionData = {}
		end, function(data, menu)
			menu.close()
			CurrentAction     = 'shop_menu'
			CurrentActionMsg  = _U('press_access')
			CurrentActionData = {}

		end)
	end, function(data, menu)
		menu.close()
		CurrentAction     = 'shop_menu'
		CurrentActionMsg  = _U('press_access')
		CurrentActionData = {}
	end, restrict)
end

AddEventHandler('playerSpawned', function()
	isDead = false
end)

AddEventHandler('esx:onPlayerDeath', function()
	isDead = true
end)

AddEventHandler('cainn-accessories:hasEnteredMarker', function(zone)
	CurrentAction     = 'shop_menu'
	CurrentActionMsg  = _U('press_access')
	CurrentActionData = { accessory = zone }
end)

AddEventHandler('cainn-accessories:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

-- Create Blips --
Citizen.CreateThread(function()
	for k,v in pairs(Config.ShopsBlips) do
		if v.Pos ~= nil then
			for i=1, #v.Pos, 1 do
				local blip = AddBlipForCoord(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)

				SetBlipSprite (blip, v.Blip.sprite)
				SetBlipDisplay(blip, 4)
				SetBlipScale  (blip, 1.0)
				SetBlipColour (blip, v.Blip.color)
				SetBlipAsShortRange(blip, true)

				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(_U('shop', _U(string.lower(k))))
				EndTextCommandSetBlipName(blip)
			end
		end
	end
end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(PlayerPedId())
		for k,v in pairs(Config.Zones.Ears.Pos) do
				if(Config.Type ~= -1 and GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < Config.DrawDistance) then
					DrawText3Ds(v.x, v.y, v.z +1.0, "~r~[E]~s~ Ouvidos")
					--DrawMarker(Config.Type, v.x, v.y, v.z - 0.1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.Size.x, Config.Size.y, Config.Size.z, Config.Color.r, Config.Color.g, Config.Color.b, 100, false, true, 2, false, false, false, false)
				end
		end

		for k,v in pairs(Config.Zones.Helmet.Pos) do
				if(Config.Type ~= -1 and GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < Config.DrawDistance) then
					DrawText3Ds(v.x, v.y, v.z +1.0, "~r~[E]~s~ Chapeus")
					--DrawMarker(Config.Type, v.x, v.y, v.z - 0.1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.Size.x, Config.Size.y, Config.Size.z, Config.Color.r, Config.Color.g, Config.Color.b, 100, false, true, 2, false, false, false, false)
				end
		end

		for k,v in pairs(Config.Zones.Mask.Pos) do
				if(Config.Type ~= -1 and GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < Config.DrawDistance) then
					DrawText3Ds(v.x, v.y, v.z , "~r~[E]~s~ Máscaras")
					--DrawMarker(Config.Type, v.x, v.y, v.z - 0.95, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.Size.x, Config.Size.y, Config.Size.z, Config.Color.r, Config.Color.g, Config.Color.b, 100, false, true, 2, false, false, false, false)
				end
		end

		for k,v in pairs(Config.Zones.Glasses.Pos) do
			if(Config.Type ~= -1 and GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < Config.DrawDistance) then
				DrawText3Ds(v.x, v.y, v.z +1.0, "~r~[E]~s~ Óculos")
				--DrawMarker(Config.Type, v.x, v.y, v.z - 0.1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.Size.x, Config.Size.y, Config.Size.z, Config.Color.r, Config.Color.g, Config.Color.b, 100, false, true, 2, false, false, false, false)
			end
	end


	end
end)

function DrawText3Ds(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*1
    local fov = (1/GetGameplayCamFov())*100
    local scale = 0.9
   
    if onScreen then
        SetTextScale(0.38, 0.38)
        SetTextFont(4)
        SetTextProportional(1)
        --SetTextScale(0.0, 0.3)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(0, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.03+ factor, 0.03, 0, 0, 0, 68)
    end
end


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(200)

		local coords      = GetEntityCoords(PlayerPedId())
		local isInMarker  = false
		local currentZone = nil
		for k,v in pairs(Config.Zones) do
			for i = 1, #v.Pos, 1 do
				if GetDistanceBetweenCoords(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, true) < 2.0 then
					isInMarker  = true
					currentZone = k
				end
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker = true
			LastZone = currentZone
			TriggerEvent('cainn-accessories:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('cainn-accessories:hasExitedMarker', LastZone)
		end

	end
end)

-- Key controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		
		if CurrentAction ~= nil then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) and CurrentActionData.accessory then
				OpenShopMenu(CurrentActionData.accessory)
				CurrentAction = nil
			end
		elseif CurrentAction == nil and not Config.EnableControls then
			Citizen.Wait(500)
		end

		---if Config.EnableControls then
		--	if IsControlJustReleased(0, 311) and IsInputDisabled(0) and not isDead then
		----		OpenAccessoryMenu()
		--	end
		--end

	end
end)

--------------------------
---- CRIADO POR CAINN ----
--------------------------