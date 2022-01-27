local QBCore = exports['qb-core']:GetCoreObject()
local onDuty = false
isLoggedIn = false
PlayerJob = {}

function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
        if PlayerData.job.onduty then
            if PlayerData.job.name == "burgershot" then
                TriggerServerEvent("QBCore:ToggleDuty")
            end
        end
    end)
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    onDuty = PlayerJob.onduty
end)

RegisterNetEvent('QBCore:Client:SetDuty', function(duty)
	onDuty = duty
end)

CreateThread(function()
    BurgerShot = AddBlipForCoord(-1197.32, -897.655, 13.995)
    SetBlipSprite (BurgerShot, 124)
    SetBlipDisplay(BurgerShot, 4)
    SetBlipScale  (BurgerShot, 0.5)
    SetBlipAsShortRange(BurgerShot, true)
    SetBlipColour(BurgerShot, 75)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Cửa Hàng McDonald's")
    EndTextCommandSetBlipName(BurgerShot)
end) 

RegisterNetEvent("qb-burgershot:DutyB", function()
    TriggerServerEvent("QBCore:ToggleDuty")
end)

RegisterNetEvent("qb-burgershot:Tray1", function()
    TriggerEvent("inventory:client:SetCurrentStash", "burgertray1")
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "burgertray1", {
        maxweight = 10000,
        slots = 6,
    })
end)

RegisterNetEvent("qb-burgershot:Tray4", function()
    TriggerEvent("inventory:client:SetCurrentStash", "burgertray4")
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "burgertray4", {
        maxweight = 10000,
        slots = 6,
    })
end)

RegisterNetEvent("qb-burgershot:Tray3", function()
    TriggerEvent("inventory:client:SetCurrentStash", "burgertray3")
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "burgertray3", {
        maxweight = 10000,
        slots = 6,
    })
end)

RegisterNetEvent("qb-burgershot:Storage", function()
    TriggerEvent("inventory:client:SetCurrentStash", "burgerstorage")
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "burgerstorage", {
        maxweight = 250000,
        slots = 40,
    })
end)

RegisterNetEvent("qb-burgershot:Storage2", function()
    TriggerEvent("inventory:client:SetCurrentStash", "burgerstorage2")
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "burgerstorage2", {
        maxweight = 250000,
        slots = 40,
    })
end)

--Meal Creations
RegisterNetEvent("qb-burgershot:MurderMeal", function()
	local randomToy = math.random(10,10)
	--remove box
	TriggerServerEvent('QBCore:Server:RemoveItem', "burger-murdermeal", 1)
	--add items from box
	TriggerServerEvent('QBCore:Server:AddItem', "burger-heartstopper", 1)
	TriggerServerEvent('QBCore:Server:AddItem', "burger-softdrink", 1)
	TriggerServerEvent('QBCore:Server:AddItem', "burger-fries", 1)

	if randomToy < 4 then
				TriggerServerEvent('QBCore:Server:AddItem', "bs_coupon-ten", 1)
				
	elseif randomToy == 4 then
				TriggerServerEvent('QBCore:Server:AddItem', "burger-toy1", 1)
				
	elseif randomToy < 10 and randomToy > 4 then
				TriggerServerEvent('QBCore:Server:AddItem', "bs_coupon-fifteen", 1)
				
	elseif randomToy == 10 then
				TriggerServerEvent('QBCore:Server:AddItem', "burger-toy2", 1)
				
	elseif randomToy > 10 and randomToy < 15 then
				QBCore.Functions.Notify("không có đồ chơi trong hộp", "error")
	elseif randomToy == 15 then
				TriggerServerEvent('QBCore:Server:AddItem', "bs_coupon-25", 1)
							
	end
end)

RegisterNetEvent("qb-burgershot:CreateMurderMeal", function()
    if onDuty then
    	QBCore.Functions.TriggerCallback('qb-burgershot:server:get:ingredientMurderMeal', function(HasItems)  
    		if HasItems then
				QBCore.Functions.Progressbar("pickup_sla", "Đang Làm Một Suất Ăn...", 4000, false, true, {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				}, {
					animDict = "mp_common",
					anim = "givetake1_a",
					flags = 8,
				}, {}, {}, function() -- Done
					TriggerServerEvent('QBCore:Server:RemoveItem', "burger-fries", 1)
                  	TriggerServerEvent('QBCore:Server:RemoveItem', "burger-heartstopper", 1)
					TriggerServerEvent('QBCore:Server:RemoveItem', "burger-softdrink", 1)
					TriggerServerEvent('QBCore:Server:AddItem', "burger-murdermeal", 1)
					TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["burger-murdermeal"], "add")
					QBCore.Functions.Notify("đã làm một hộp bánh", "success")
				end, function()
					QBCore.Functions.Notify("bị hủy..", "error")
				end)
			else
   				QBCore.Functions.Notify("không đủ nguyên liệu để làm", "error")
			end
		end)
	else 
		QBCore.Functions.Notify("bạn cần onduty để làm việc này", "error")
	end  
end)

RegisterNetEvent("qb-burgershot:BleederBurger", function()
    if onDuty then
    	QBCore.Functions.TriggerCallback('qb-burgershot:server:get:ingredientBurger', function(HasItems)  
    		if HasItems then
				QBCore.Functions.Progressbar("pickup_sla", "Đang Làm Burger Cỡ Nhỏ..", 4000, false, true, {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				}, {
					animDict = "mp_common",
					anim = "givetake1_a",
					flags = 8,
				}, {}, {}, function() -- Done
					TriggerServerEvent('QBCore:Server:RemoveItem', "burger-meat", 1)
					TriggerServerEvent('QBCore:Server:RemoveItem', "burger-lettuce", 1)
					TriggerServerEvent('QBCore:Server:RemoveItem', "burger-bun", 1)
					TriggerServerEvent('QBCore:Server:RemoveItem', "burger-tomato", 1)
					TriggerServerEvent('QBCore:Server:AddItem', "burger-bleeder", 1)
					TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["burger-bleeder"], "add")
					QBCore.Functions.Notify("Đã Làm Một Chiếc Burger Nhỏ", "success")
				end, function()
					QBCore.Functions.Notify("bị hủy..", "error")
				end)
			else
   				QBCore.Functions.Notify("Bạn không có thành phần để thực hiện việc này", "error")
			end
		end)
	else 
		QBCore.Functions.Notify("bạn cần onduty để làm việc này", "error")
	end
end)

RegisterNetEvent("qb-burgershot:MoneyShot", function()
    if onDuty then
    	QBCore.Functions.TriggerCallback('qb-burgershot:server:get:ingredientBurger', function(HasItems)  
    		if HasItems then
				QBCore.Functions.Progressbar("pickup_sla", "Đang Làm Burger Cỡ Lớn..", 4000, false, true, {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				}, {
					animDict = "mp_common",
					anim = "givetake1_a",
					flags = 8,
				}, {}, {}, function() -- Done
					TriggerServerEvent('QBCore:Server:RemoveItem', "burger-meat", 1)
					TriggerServerEvent('QBCore:Server:RemoveItem', "burger-lettuce", 1)
					TriggerServerEvent('QBCore:Server:RemoveItem', "burger-bun", 1)
					TriggerServerEvent('QBCore:Server:RemoveItem', "burger-tomato", 1)
					TriggerServerEvent('QBCore:Server:AddItem', "burger-moneyshot", 1)
                    			TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["burger-moneyshot"], "add")
                    			QBCore.Functions.Notify("Đã Làm Burger Cỡ Lớn", "success")
				end, function()
					QBCore.Functions.Notify("bị hủy..", "error")
				end)
			else
   				QBCore.Functions.Notify("bạn không có nguyên liệu cần thiết để làm", "error")
			end
		end)
	else 
		QBCore.Functions.Notify("bạn cần onduty để làm việc này", "error")
	end
end)

RegisterNetEvent("qb-burgershot:HeartStopper", function()
    if onDuty then
    	QBCore.Functions.TriggerCallback('qb-burgershot:server:get:ingredientBurger', function(HasItems)  
    		if HasItems then
				QBCore.Functions.Progressbar("pickup_sla", "đang làm burger đặc biệt..", 4000, false, true, {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				}, {
					animDict = "mp_common",
					anim = "givetake1_a",
					flags = 8,
				}, {}, {}, function() -- Done
					TriggerServerEvent('QBCore:Server:RemoveItem', "burger-meat", 1)
					TriggerServerEvent('QBCore:Server:RemoveItem', "burger-lettuce", 1)
					TriggerServerEvent('QBCore:Server:RemoveItem', "burger-bun", 1)
					TriggerServerEvent('QBCore:Server:RemoveItem', "burger-tomato", 1)
					TriggerServerEvent('QBCore:Server:AddItem', "burger-heartstopper", 1)
					TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["burger-heartstopper"], "add")
					QBCore.Functions.Notify("đã làm burger đặc biệt", "success")
				end, function()
					QBCore.Functions.Notify("bị hủy..", "error")
				end)
			else
   				QBCore.Functions.Notify("bạn không có nguyên liệu cần thiết để làm", "error")
			end
		end)
	else 
		QBCore.Functions.Notify("bạn cần onduty để làm việc này", "error")
	end
end)

RegisterNetEvent("qb-burgershot:Torpedo", function()
    if onDuty then
    	QBCore.Functions.TriggerCallback('qb-burgershot:server:get:ingredientTorpedo', function(HasItems)  
    		if HasItems then
				QBCore.Functions.Progressbar("pickup_sla", "Đang Làm bánh mì pate..", 4000, false, true, {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				}, {
					animDict = "mp_common",
					anim = "givetake1_a",
					flags = 8,
				}, {}, {}, function() -- Done
					TriggerServerEvent('QBCore:Server:RemoveItem', "burger-meat", 1)
					TriggerServerEvent('QBCore:Server:RemoveItem', "burger-bun", 1)
					TriggerServerEvent('QBCore:Server:AddItem', "burger-torpedo", 1)
					TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["burger-torpedo"], "add")
					QBCore.Functions.Notify("đã làm bánh mì pate", "success")
				end, function()
					QBCore.Functions.Notify("bị hủy..", "error")
				end)
			else
   				QBCore.Functions.Notify("bạn không có nguyên liệu cần thiết để làm", "error")
			end
		end)
	else 
		QBCore.Functions.Notify("bạn cần onduty để làm việc này", "error")
	end  
end)

RegisterNetEvent("qb-burgershot:MeatFree", function()
    if onDuty then
    	QBCore.Functions.TriggerCallback('qb-burgershot:server:get:ingredientMeatfree', function(HasItems)  
    		if HasItems then
				QBCore.Functions.Progressbar("pickup_sla", "Đang Làm burger giá rẻ..", 4000, false, true, {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				}, {
					animDict = "mp_common",
					anim = "givetake1_a",
					flags = 8,
				}, {}, {}, function() -- Done
					TriggerServerEvent('QBCore:Server:RemoveItem', "burger-tomato", 1)
					TriggerServerEvent('QBCore:Server:RemoveItem', "burger-lettuce", 1)
					TriggerServerEvent('QBCore:Server:RemoveItem', "burger-bun", 1)
					TriggerServerEvent('QBCore:Server:AddItem', "burger-meatfree", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["burger-meatfree"], "add")
                    QBCore.Functions.Notify("đã làm burger giá rẻ", "success")
				end, function()
					QBCore.Functions.Notify("Đã Hủy..", "error")
				end)
			else
   				QBCore.Functions.Notify("bạn không có nguyên liệu cần thiết để làm", "error")
			end
		end)
	else 
		QBCore.Functions.Notify("bạn cần onduty để làm việc này", "error")
	end  
end)

RegisterNetEvent("qb-burgershot:SoftDrink", function()
    if onDuty then
    QBCore.Functions.TriggerCallback('QBCore:HasItem', function(HasItem)
        if HasItem then
           MakeSoftDrink()
        else
            QBCore.Functions.Notify("cần siro soda..", "error")
        end
      end, 'burger-sodasyrup')
    else
        QBCore.Functions.Notify("bạn cần onduty để làm việc này", "error")
    end
end)

RegisterNetEvent("qb-burgershot:mShake", function()
    if onDuty then
    QBCore.Functions.TriggerCallback('QBCore:HasItem', function(HasItem)
        if HasItem then
           MakeMShake()
        else
            QBCore.Functions.Notify("cần Kem Sữa..", "error")
        end
      end, 'burger-mshakeformula')
    else
        QBCore.Functions.Notify("bạn cần onduty để làm việc này", "error")
    end
end)

RegisterNetEvent("qb-burgershot:Fries", function()
    if onDuty then
    QBCore.Functions.TriggerCallback('QBCore:HasItem', function(HasItem)
        if HasItem then
           MakeFries()
        else
            QBCore.Functions.Notify("Bạn không có khoai tây..", "error")
        end
      end, 'burger-potato')
    else
        QBCore.Functions.Notify("bạn cần onduty để làm việc này", "error")
    end
end)

RegisterNetEvent("qb-burgershot:PattyFry", function()
    if onDuty then
    QBCore.Functions.TriggerCallback('QBCore:HasItem', function(HasItem)
        if HasItem then
           MakePatty()
        else
            QBCore.Functions.Notify("cần thịt sống..", "error")
        end
      end, 'burger-raw')
    else
        QBCore.Functions.Notify("bạn cần onduty để làm việc này", "error")
    end
end)

function MakeFries()
	TriggerServerEvent('QBCore:Server:RemoveItem', "burger-potato", 1)
	QBCore.Functions.Progressbar("pickup", "Đang chiên khoai tây..", 4000, false, true, {
	    disableMovement = true,
	    disableCarMovement = true,
	    disableMouse = false,
	    disableCombat = true,
	},{
	    animDict = "amb@prop_human_bbq@male@base",
	    anim = "base",
	    flags = 8,
	    }, {
		model = "prop_cs_fork",
		bone = 28422,
		coords = vector3(-0.005, 0.00, 0.00),
		rotation = vector3(175.0, 160.0, 0.0),
	    }
	)
	Wait(4000)
	TriggerServerEvent('QBCore:Server:AddItem', "burger-fries", 4)
	TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["burger-fries"], "add")
	QBCore.Functions.Notify("bạn nhận được 4 hộp khoai", "success")
	StopAnimTask(PlayerPedId(), "amb@prop_human_bbq@male@base", "base", 1.0)
end

function MakePatty()
    TriggerServerEvent('QBCore:Server:RemoveItem', "burger-raw", 1)
    QBCore.Functions.Progressbar("pickup", "Đang nướng thịt..", 4000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    },{
        animDict = "amb@prop_human_bbq@male@base",
        anim = "base",
        flags = 8,
    }, {
        model = "prop_cs_fork",
        bone = 28422,
        coords = vector3(-0.005, 0.00, 0.00),
        rotation = vector3(175.0, 160.0, 0.0),
    })
    Wait(4000)
    TriggerServerEvent('QBCore:Server:AddItem', "burger-meat", 1)
    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["burger-meat"], "add")
    QBCore.Functions.Notify("bạn nhận được thịt nướng", "success")
    StopAnimTask(PlayerPedId(), "amb@prop_human_bbq@male@base", "base", 1.0)
end

function MakeSoftDrink()
    TriggerServerEvent('QBCore:Server:RemoveItem', "burger-sodasyrup", 1)
    QBCore.Functions.Progressbar("pickup", "Đang Lấy Nước..", 4000, false, true, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = false,
    })
    Wait(4000)
    TriggerServerEvent('QBCore:Server:AddItem', "burger-softdrink", 1)
    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["burger-softdrink"], "add")
    QBCore.Functions.Notify("Bạn Nhận Được Ly Soda", "success")
end  

function MakeMShake()
    TriggerServerEvent('QBCore:Server:RemoveItem', "burger-mshakeformula", 1)
    QBCore.Functions.Progressbar("pickup", "Đang lấy nước..", 4000, false, true, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = false,
    })
    Wait(4000)
    TriggerServerEvent('QBCore:Server:AddItem', "burger-mshake", 1)
    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["burger-mshake"], "add")
    QBCore.Functions.Notify("bạn nhận được trà sữa", "success")
end  

RegisterNetEvent("qb-burgershot:shop", function()
    TriggerServerEvent("inventory:server:OpenInventory", "shop", "burgershot", Config.Items)
end)
