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
		xPlayer.addMoney(money)
		TriggerClientEvent('mythic_notify:client:SendAlert', source , { type = 'inform', text = 'You steal  $' ..money })
		isrobbing[source] = nil
	else
		print("Cheater: " .. GetPlayerName(source))
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

