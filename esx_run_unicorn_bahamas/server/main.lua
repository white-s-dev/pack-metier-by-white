-----------------------------------------
-- Created and modify by L'ile Légale RP
-- SenSi and Kaminosekai
-----------------------------------------
ESX = nil
local PlayersTransformingFarm, PlayersSelling, PlayersHarvesting = {}, {}, {}, {}
local caisse_traiter = 1

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local function Harvest(source, zone)
	if PlayersHarvesting[source] == true then

		local xPlayer  = ESX.GetPlayerFromId(source)
		if zone == "CaisseFarm" then
			local itemQuantity = xPlayer.getInventoryItem('caisse_alcool').count
			if itemQuantity >= 100 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_place'))
				return
			else
				SetTimeout(1800, function()
					xPlayer.addInventoryItem('caisse_alcool', 1)
					Harvest(source, zone)
				end)
			end
		end
	end
end

RegisterServerEvent('esx_run_unicorn_bahamas:startHarvest')
AddEventHandler('esx_run_unicorn_bahamas:startHarvest', function(zone)
	local _source = source
  	
	if PlayersHarvesting[_source] == false then
		TriggerClientEvent('esx:showNotification', _source, '~r~C\'est pas bien de glitch ~w~')
		PlayersHarvesting[_source]=false
	else
		PlayersHarvesting[_source]=true
		TriggerClientEvent('esx:showNotification', _source, _U('caisse_taken'))  
		Harvest(_source,zone)
	end
end)

RegisterServerEvent('esx_run_unicorn_bahamas:stopHarvest')
AddEventHandler('esx_run_unicorn_bahamas:stopHarvest', function()
	local _source = source
	
	if PlayersHarvesting[_source] == true then
		PlayersHarvesting[_source]=false
		TriggerClientEvent('esx:showNotification', _source, 'Vous sortez de la ~r~zone')
	else
		TriggerClientEvent('esx:showNotification', _source, 'Vous pouvez ~g~récolter')
		PlayersHarvesting[_source]=true
	end
end)

local function TransformFarm(source, zone)

	if PlayersTransformingFarm[source] == true then

		local xPlayer  = ESX.GetPlayerFromId(source)
		if zone == "TraitementCaisseFarm" then
			local itemQuantity = xPlayer.getInventoryItem('caisse_alcool').count

			if itemQuantity <= 0 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_caisse'))
				return
			else
				SetTimeout(1800, function()
					xPlayer.removeInventoryItem('caisse_alcool', 1)
					xPlayer.addInventoryItem('caisse_traiter', 1)
					TransformFarm(source, zone)
				end)
			end
		end
	end	
end

RegisterServerEvent('esx_run_unicorn_bahamas:startTransformFarm')
AddEventHandler('esx_run_unicorn_bahamas:startTransformFarm', function(zone)
	local _source = source
  	
	if PlayersTransformingFarm[_source] == false then
		TriggerClientEvent('esx:showNotification', _source, '~r~C\'est pas bien de glitch ~w~')
		PlayersTransformingFarm[_source]=false
	else
		PlayersTransformingFarm[_source]=true
		TriggerClientEvent('esx:showNotification', _source, _U('transforming_in_progress')) 
		TransformFarm(_source,zone)
	end
end)

RegisterServerEvent('esx_run_unicorn_bahamas:stopTransformFarm')
AddEventHandler('esx_run_unicorn_bahamas:stopTransformFarm', function()
	local _source = source
	
	if PlayersTransformingFarm[_source] == true then
		PlayersTransformingFarm[_source]=false
		TriggerClientEvent('esx:showNotification', _source, 'Vous sortez de la ~r~zone')
		
	else
		TriggerClientEvent('esx:showNotification', _source, 'Vous pouvez ~g~transformer vos caisses')
		PlayersTransformingFarm[_source]=true
	end
end)

local function Sell(source, zone)

	if PlayersSelling[source] == true then
		local xPlayer  = ESX.GetPlayerFromId(source)
		
		if zone == 'SellFarm' then
			if xPlayer.getInventoryItem('caisse_traiter').count <= 0 then
				TriggerClientEvent('esx:showNotification', source, _U('no_caisse_traiter_sale'))
				caisse_traiter = 0
				return
			else
				if (caisse_traiter == 1) then
					SetTimeout(1100, function()
						local money = math.random(2,2)
						xPlayer.removeInventoryItem('caisse_traiter', 1)

						xPlayer.addMoney(money)
						TriggerClientEvent('esx:showNotification', source, _U('comp_earned') .. money)
						Sell(source,zone)
					end)
				end
			end
		end
	end
end

RegisterServerEvent('esx_run_unicorn_bahamas:startSell')
AddEventHandler('esx_run_unicorn_bahamas:startSell', function(zone)
	local _source = source

	if PlayersSelling[_source] == false then
		TriggerClientEvent('esx:showNotification', _source, '~r~C\'est pas bien de glitch ~w~')
		PlayersSelling[_source]=false
	else
		PlayersSelling[_source]=true
		TriggerClientEvent('esx:showNotification', _source, _U('sale_in_prog'))
		Sell(_source, zone)
	end
end)

RegisterServerEvent('esx_run_unicorn_bahamas:stopSell')
AddEventHandler('esx_run_unicorn_bahamas:stopSell', function()
	local _source = source
	
	if PlayersSelling[_source] == true then
		PlayersSelling[_source]=false
		TriggerClientEvent('esx:showNotification', _source, 'Vous sortez de la ~r~zone')
		
	else
		TriggerClientEvent('esx:showNotification', _source, 'Vous pouvez ~g~vendre')
		PlayersSelling[_source]=true
	end
end)

ESX.RegisterServerCallback('esx_run_unicorn_bahamas:getPlayerInventory', function(source, cb)
	local xPlayer    = ESX.GetPlayerFromId(source)
	local items      = xPlayer.inventory

	cb({
		items      = items
	})
end)
