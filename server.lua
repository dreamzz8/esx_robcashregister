ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('esx_robcashregister:countpolice', function(source, cb)

	local xPlayers = ESX.GetPlayers()
 	local pcountPolice = 0

    for i=1, #xPlayers, 1 do
        local Player = ESX.GetPlayerFromId(xPlayers[i])
        if Player.job.name == 'police' then
           pcountPolice = pcountPolice + 3
        end
    end

	cb(pcountPolice)
end)

RegisterServerEvent('esx_robcashregister:startsteal')
AddEventHandler('esx_robcashregister:startsteal', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer.getInventoryItem('WEAPON_CROWBAR').count >= 1 then
		TriggerClientEvent('esx_robcashregister:startstealcash', _source)

	else
		TriggerClientEvent('mythic_notify:client:SendAlert', source , { type = 'error', text = 'First open the cash register.'})
	end

end)

RegisterServerEvent('esx_robcashregister:givemoney')
AddEventHandler('esx_robcashregister:givemoney', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local money = math.random(1500, 2500)
	xPlayer.addMoney(money)
	--TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Recebes-te  '..money..'€', length = 2500, style = { ['background-color'] = '#000000', ['color'] = '#ffffff' } })
	TriggerClientEvent('mythic_notify:client:SendAlert', source , { type = 'inform', text = 'You steal  $' ..money })
end)
