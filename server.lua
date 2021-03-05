ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

isrobbing = {}

ESX.RegisterServerCallback('esx_robcashregister:countpolice', function(source, cb)

	local xPlayers = ESX.GetPlayers()
 	local pcountPolice = 0

    for i=1, #xPlayers, 1 do
        local Player = ESX.GetPlayerFromId(xPlayers[i])
        if Player.job.name == 'police' then
           pcountPolice = pcountPolice + 1
        end
    end

	cb(pcountPolice)
end)

RegisterServerEvent('esx_robcashregister:startsteal')
AddEventHandler('esx_robcashregister:startsteal', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer.getInventoryItem('WEAPON_CROWBAR').count >= 1 then
		isrobbing[source] = {
			true
		}
		TriggerClientEvent('esx_robcashregister:startstealcash', _source)

	else
		TriggerClientEvent('mythic_notify:client:SendAlert', source , { type = 'error', text = 'First open the cash register.'})
	end

end)

RegisterServerEvent('esx_robcashregister:givemoney')
AddEventHandler('esx_robcashregister:givemoney', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local money = math.random(1500, 2500)
	if isrobbing[source] then
		if Config.UseBlackMoney = false and Config.UseNormalMoney = true then
			xPlayer.addMoney(money)
			TriggerClientEvent('mythic_notify:client:SendAlert', source , { type = 'inform', text = 'You steal  $' ..money })
			isrobbing[source] = nil
		else
			if Config.UseNormalMoney = false and Config.UseBlackMoney = true then
				xPlayer.addAccountMoney('black_money', money)
				TriggerClientEvent('mythic_notify:client:SendAlert', source , { type = 'inform', text = 'You steal  $' ..money })
				isrobbing[source] = nil
			else
				if Config.UseNormalMoney = false and Config.UseBlackMoney = false then
					xPlayer.addAccountMoney('black_money', money)
					TriggerClientEvent('mythic_notify:client:SendAlert', source , { type = 'inform', text = 'You steal  $' ..money })
					isrobbing[source] = nil
				else
					print("Cheater: " .. GetPlayerName(source))
				end
			end
		end
	end
end)


AddEventHandler("playerDropped", function(source)
	local source = source
    if isrobbing[source] then
        isrobbing[source] = nil
    end
end)

RegisterServerEvent("esx_robcashregister:cancelled")
AddEventHandler("esx_robcashregister:cancelled", function()
	local source = source
    if isrobbing[source] then
        isrobbing[source] = nil
    end
end)

RegisterServerEvent('robberyNotif')
AddEventHandler('robberyNotif', function()
end)

RegisterServerEvent('robberyNotif')
AddEventHandler('robberyNotif', function(street1, street2, sex)
	local _source = source
	local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			-- ADD NOTIFICATION MESSAGE HERE
		end
    end
end)

RegisterServerEvent('robberyPosition')
AddEventHandler('robberyPosition', function(gx, gy, gz)
	TriggerClientEvent('robberyBlip', -1, gx, gy, gz)
end)

RegisterServerEvent('robberyOnGoing')
AddEventHandler('robberyOnGoing', function(gx, gy, gz)
	TriggerClientEvent('robberyBlip', -1, gx, gy, gz)
end)
