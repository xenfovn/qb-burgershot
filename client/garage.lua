local QBCore = exports['qb-core']:GetCoreObject()
local pedspawned = false
PlayerData = {}

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
    PlayerData.job = job
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
	PlayerData = val
end)

CreateThread(function()
	while true do
		Wait(1000)
		for k, v in pairs(Config.GaragePedLocations) do
			local pos = GetEntityCoords(PlayerPedId())	
			local dist = #(pos - vector3(v.coords.x, v.coords.y, v.coords.z))
			
			if dist < 40 and not pedspawned then
				TriggerEvent('qb-burgershot:spawn:ped', v.coords)
				pedspawned = true
			end
			if dist >= 35 then
				pedspawned = false
				DeletePed(npc)
			end
		end
	end
end)

RegisterNetEvent('qb-burgershot:spawn:ped',function(coords)
	local hash = `ig_floyd`

	RequestModel(hash)
	while not HasModelLoaded(hash) do 
		Wait(10)
	end

    pedspawned = true
    npc = CreatePed(5, hash, coords.x, coords.y, coords.z - 1.0, coords.w, false, false)
    FreezeEntityPosition(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    loadAnimDict("amb@world_human_cop_idles@male@idle_b") 
    TaskPlayAnim(npc, "amb@world_human_cop_idles@male@idle_b", "idle_e", 8.0, 1.0, -1, 17, 0, 0, 0, 0)
end)

function loadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(5)
    end
end

RegisterNetEvent('qb-burgershot:garage', function(bs)
    local vehicle = bs.vehicle
    local coords = vector4(-1172.861, -888.4072, 13.940833, 40.516719)
    if PlayerData.job.name == "burgershot" then
        if vehicle == 'stalion2' then		
            QBCore.Functions.SpawnVehicle(vehicle, function(veh)
                SetVehicleNumberPlateText(veh, "BURGER"..tostring(math.random(1000, 9999)))
                exports['LegacyFuel']:SetFuel(veh, 100.0)
                SetEntityHeading(veh, coords.w)
                TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
                SetVehicleEngineOn(veh, true, true)
            end, coords, true)
        end
    else
        QBCore.Functions.Notify('bạn không phải nhân viên.', 'error')
    end
end)

RegisterNetEvent('qb-burgershot:storecar', function()
    QBCore.Functions.Notify('đã cất xe công ty!')
    local car = GetVehiclePedIsIn(PlayerPedId(),true)
    NetworkFadeOutEntity(car, true,false)
    Wait(2000)
    QBCore.Functions.DeleteVehicle(car)
end)

RegisterNetEvent('garage:BurgerShotGarage', function()
    exports['qb-menu']:openMenu({
        {
            header = "| Kho xe cửa hàng |",
            isMenuHeader = true, -- Set to true to make a nonclickable title
        },
        {
            header = "• Xe giao hàng",
            txt = "Xe Giao Hàng",
            params = {
                event = "qb-burgershot:garage",
                args = {
                    vehicle = 'stalion2',
                }
            }
        },
        {
            header = "• Cất Xe",
            txt = "cất xe giao hàng",
            params = {
                event = "qb-burgershot:storecar",
                args = {
                    
                }
            }
        },	
        {
            header = "đóng (ESC)",
            isMenuHeader = true,
        },	
    })
end)
