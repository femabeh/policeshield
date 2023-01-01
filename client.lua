ESX = nil
local CurrentAction	= nil

local shieldActive = false
local shieldEntity = nil
local hadPistol = false

Citizen.CreateThread(function()
	while ESX == nil do
		ESX = exports["es_extended"]:getSharedObject()
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

-- ANIM
local animDict = "combat@gestures@gang@pistol_1h@beckon"
local animName = "0"
local prop = "prop_ballistic_shield"

RegisterCommand(Config.Command, function()
    TriggerEvent("policeshield:shield")
end)

RegisterNetEvent('policeshield:shield')
AddEventHandler('policeshield:shield', function()
    ESX.TriggerServerCallback('policeshield:getItemAmount', function(qtty)
        if qtty > 0 then
            if shieldActive then
                DisableShield()
            else
                EnableShield()
            end
        else
            ESX.ShowNotification(_U('noshield'))
        end
    end, Config.Item)
end)

function EnableShield()
    for k,v in pairs(Config.Jobs) do
        if ESX.PlayerData.job.name == v then
            shieldActive = true
            local ped = GetPlayerPed(-1)
            local pedPos = GetEntityCoords(ped, false)
    
            RequestAnimDict(animDict)
            while not HasAnimDictLoaded(animDict) do
                Citizen.Wait(100)
            end
    
            TaskPlayAnim(ped, animDict, animName, 8.0, -8.0, -1, (2 + 16 + 32), 0.0, 0, 0, 0)
    
            RequestModel(GetHashKey(prop))
            while not HasModelLoaded(GetHashKey(prop)) do
                Citizen.Wait(100)
            end
    
            local shield = CreateObject(GetHashKey(prop), pedPos.x, pedPos.y, pedPos.z, 1, 1, 1)
            shieldEntity = shield
            AttachEntityToEntity(shieldEntity, ped, GetEntityBoneIndexByName(ped, "IK_L_Hand"), 0.0, -0.05, -0.10, -30.0, 180.0, 40.0, 0, 0, 1, 0, 0, 1)
            SetWeaponAnimationOverride(ped, GetHashKey("Gang1H"))
        end
    end
end

function DisableShield()
    local ped = GetPlayerPed(-1)
    DeleteEntity(shieldEntity)
    ClearPedTasksImmediately(ped)
    SetWeaponAnimationOverride(ped, GetHashKey("Default"))

    SetEnableHandcuffs(ped, false)
    shieldActive = false
end

Citizen.CreateThread(function()
    while true do
        if shieldActive then
            local ped = GetPlayerPed(-1)
            if not IsEntityPlayingAnim(ped, animDict, animName, 1) then
                RequestAnimDict(animDict)
                while not HasAnimDictLoaded(animDict) do
                    Citizen.Wait(100)
                end

                TaskPlayAnim(ped, animDict, animName, 8.0, -8.0, -1, (2 + 16 + 32), 0.0, 0, 0, 0)
            end
        end
        Citizen.Wait(500)
    end
end)
