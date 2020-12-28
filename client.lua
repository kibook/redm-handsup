local dict = 'script_proc@robberies@homestead@lonnies_shack@deception'
local anim = 'hands_up_loop'
local control = 0x4CC0E2FE
local enabled = false
local speed = 4.0

RegisterNetEvent('handsup:toggle')

function IsUsingKeyboard(padIndex)
	return Citizen.InvokeNative(0xA571D46727E2B718, padIndex)
end

function SwitchToUnarmed()
	GiveWeaponToPed_2(PlayerPedId(), `WEAPON_UNARMED`, 0, true, false, 0, false, 0.5, 1.0, 0, false, 0.0, false)
end

function RaiseHands()
	TaskPlayAnim(PlayerPedId(), dict, anim, speed, speed, -1, 25, 0, false, false, false, '', false)
end

function LowerHands()
	StopAnimTask(PlayerPedId(), dict, anim, speed)
end

function ToggleRaiseHands()
	enabled = not enabled

	if not enabled then
		LowerHands()
	end
end

RegisterCommand('handsup', function(source, args, raw)
	ToggleRaiseHands()
end, false)

AddEventHandler('handsup:toggle', ToggleRaiseHands)

AddEventHandler('onResourceStop', function(resource)
	if GetCurrentResourceName() == resource then
		enabled = false
		LowerHands()
	end
end)

CreateThread(function()
	TriggerEvent('chat:addSuggestion', '/handsup', 'Raise/lower your hands', {})

	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(0)
	end

	while control do
		Wait(0)
	
		if IsUsingKeyboard(0) and IsControlJustPressed(0, control) then
			ToggleRaiseHands()
		end

		if enabled then
			DisableControlAction(0, 0x07CE1E61, true)
			DisableControlAction(0, 0xB2F377E8, true)
			DisableControlAction(0, 0x018C47CF, true)
			DisableControlAction(0, 0x2277FAE9, true)

			SwitchToUnarmed()

			if not IsEntityPlayingAnim(PlayerPedId(), dict, anim, 25) then
				RaiseHands()
			end
		end
	end
end)
