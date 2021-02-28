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

ESX                             = nil
local PlayerData                = {}
local incollect                 = false
local onplace                 = false
local coords            = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterCommand('stealcashregister', function(source, args, raw)
  TriggerServerEvent('esx_robcashregister:startsteal')
end)

function OpenCashregister()
  exports['mythic_progbar']:Progress({
      name = "cash_Register_opening",
      duration = 10000,
      label = 'Opening the cash register...',
      useWhileDead = true,
      canCancel = true,
      controlDisables = {
          disableMovement = true,
          disableCarMovement = true,
          disableMouse = false,
          disableCombat = true,
      },
      animation = {
          animDict = "melee@large_wpn@streamed_core",
          anim = "ground_attack_on_spot",
          flags = 49,
      },
      prop = {
        model = "v_ind_cm_crowbar",
      },
  }, function(cancelled)
      if not cancelled then
          startRobbing()
      else
      end
  end)
end


RegisterNetEvent('esx_robcashregister:startstealcash')
AddEventHandler('esx_robcashregister:startstealcash', function()
  if onplace then
    ESX.TriggerServerCallback('esx_robcashregister:countpolice', function(countPolice)
      if countPolice >=1 then -- CHANGE THE 1 FOR THE COPS YOU WANT
        OpenCashregister()
        Citizen.Wait(9999)
        exports['mythic_notify']:SendAlert('inform', 'Cash register opened')
        TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 30.0, 'alarm', 0.3) -- IF YOU WANT TO USE ALARM SOUND CHANGE THE SOUND OF "ALARM" TO YOUR FILE NAME
      else
        exports['mythic_notify']:SendAlert('error', 'No cops')
      end
    end)
  end
end)


Citizen.CreateThread(function()
    while true do
        Wait(0)
		local coords = GetEntityCoords(GetPlayerPed(-1))
		for k,v in pairs(Config.Zone) do
		if (GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 1.0) then
        if (GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 1.0) then
        onplace = true
        coords = v
      else
        onplace = false
        coords = {}
    end
  end
  end
end
end)

function countpolice ()
  TriggerServerEvent('esx_robcashregister:servicepolice')
end

function startRobbing ()
  exports['mythic_progbar']:Progress({
      name = "unique_action_name",
      duration = 150000,
      label = 'Stealing the cash from the cash register...',
      useWhileDead = true,
      canCancel = true,
      controlDisables = {
          disableMovement = true,
          disableCarMovement = true,
          disableMouse = false,
          disableCombat = true,
      },
      animation = {
          animDict = "oddjobs@shop_robbery@rob_till",
          anim = "loop",
          flags = 49,
      },
  }, function(cancelled)
      if not cancelled then
          TriggerServerEvent('esx_robcashregister:givemoney')
      else
          --nada
      end
  end)
end



function DrawText3D(x, y, z, text, scale)
local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
	SetTextScale(scale, scale)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextEntry("STRING")
	SetTextCentre(1)
	SetTextColour(255, 255, 255, 255)
	SetTextOutline()
	AddTextComponentString(text)
	DrawText(_x, _y)
  local factor = (string.len(text)) / 370
  DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 90)
end
