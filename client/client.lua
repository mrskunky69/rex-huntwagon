local RSGCore = exports['rsg-core']:GetCoreObject()
local hutingwagonspawned = false
local currentHuntingWagon = nil
local currentHuntingPlate = nil
local closestWagonStore = nil
local showingprompt = false
local wagonBlip = nil

-------------------------------------------------------------------------------------------
-- blips
-------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    for _, v in pairs(Config.HunterLocations) do
        if v.showblip == true then
            local HunterBlip = BlipAddForCoords(1664425300, v.coords)
            SetBlipSprite(HunterBlip,  joaat(Config.Blip.blipSprite), true)
            SetBlipScale(Config.Blip.blipScale, 0.2)
            SetBlipName(HunterBlip, Config.Blip.blipName)
        end
    end
end)

-------------------------------------------------------------------------------------------
-- hunter camp main menu
-------------------------------------------------------------------------------------------
RegisterNetEvent('rex-huntwagon:client:openhuntermenu', function(location, wagonspawn)

    lib.registerContext({
        id = 'hunter_mainmenu',
        title = Lang:t('client.lang_2'),
        options = {
            {
                title = Lang:t('client.lang_3')..Config.WagonPrice..')',
                description = Lang:t('client.lang_4'),
                icon = 'fa-solid fa-horse-head',
                serverEvent = 'rex-huntwagon:server:buyhuntingcart',
                args = { huntingcamp = location },
                arrow = true
            },
            {
                title = Lang:t('client.lang_5'),
                description = Lang:t('client.lang_6'),
                icon = 'fa-solid fa-eye',
                event = 'rex-huntwagon:client:spawnwagon',
                args = { huntingcamp = location, spawncoords = wagonspawn },
                arrow = true
            },
            {
                title = Lang:t('client.lang_39'),
                icon = 'fa-solid fa-basket-shopping',
                event = 'rex-huntwagon:client:openshop',
                arrow = true
            },
        }
    })
    lib.showContext('hunter_mainmenu')

end)

---------------------------------------------------------------------
-- get wagon
---------------------------------------------------------------------
RegisterNetEvent('rex-huntwagon:client:spawnwagon', function(data)
    RSGCore.Functions.TriggerCallback('rex-huntwagon:server:getwagons', function(results)
        if results == nil then return lib.notify({ title = Lang:t('client.lang_7'), description = Lang:t('client.lang_8'), type = 'inform', duration = 5000 }) end
        if hutingwagonspawned then return lib.notify({ title = Lang:t('client.lang_9'), description = Lang:t('client.lang_10'), type = 'error', duration = 5000 }) end
        
        local options = {}
        for i = 1, #results do
            local wagon = results[i]
            table.insert(options, {
                title = "Wagon " .. wagon.plate,
                description = wagon.huntingcamp .. (wagon.damaged == 1 and " (Damaged)" or ""),
                event = 'rex-huntwagon:client:spawnSelectedWagon',
                args = { wagon = wagon, spawncoords = data.spawncoords }
            })
        end

        if #options == 0 then
            return lib.notify({ title = Lang:t('client.lang_14'), description = Lang:t('client.lang_15'), type = 'inform', duration = 5000 })
        end

        lib.registerContext({
            id = 'wagon_selection_menu',
            title = 'Select a Wagon',
            options = options
        })
        lib.showContext('wagon_selection_menu')
    end)
end)

RegisterNetEvent('rex-huntwagon:client:spawnSelectedWagon', function(data)
    local wagon = data.wagon
    if wagon.damaged == 1 then
        lib.notify({ title = Lang:t('client.lang_12'), description = Lang:t('client.lang_13'), type = 'error', duration = 5000 })
        TriggerEvent('rex-huntwagon:client:fixwagon', wagon.plate)
        return
    end

    local carthash = joaat('huntercart01')
    local propset = joaat('pg_mp005_huntingWagonTarp01')
    local lightset = joaat('pg_teamster_cart06_lightupgrade3')

    if wagonBlip then
        RemoveBlip(wagonBlip)
    end

    if IsModelAVehicle(carthash) then
        Citizen.CreateThread(function()
            RequestModel(carthash)
            while not HasModelLoaded(carthash) do
                Citizen.Wait(0)
            end
            local huntingcart = CreateVehicle(carthash, data.spawncoords, true, false)
            Citizen.InvokeNative(0x06FAACD625D80CAA, huntingcart)
            SetVehicleOnGroundProperly(huntingcart)
            currentHuntingWagon = huntingcart
            currentHuntingPlate = wagon.plate
            Wait(200)
            Citizen.InvokeNative(0x75F90E4051CC084C, huntingcart, propset)
            Citizen.InvokeNative(0xC0F0417A90402742, huntingcart, lightset)
            Citizen.InvokeNative(0xF89D82A0582E46ED, huntingcart, 5)
            Citizen.InvokeNative(0x8268B098F6FCA4E2, huntingcart, 2)
            Citizen.InvokeNative(0x06FAACD625D80CAA, huntingcart)

            wagonBlip = Citizen.InvokeNative(0x23F74C2FDA6E7C61, -1749618580, huntingcart)
            Citizen.InvokeNative(0x9CB1A1623062F402, wagonBlip, 'Hunting Wagon')

            SetEntityVisible(huntingcart, true)
            SetModelAsNoLongerNeeded(carthash)

            Wait(1000)

            -- Set hunting wagon tarp
            RSGCore.Functions.TriggerCallback('rex-huntwagon:server:gettarpinfo', function(results)
                local percentage = results * Config.TotalAnimalsStored / 100
                Citizen.InvokeNative(0x31F343383F19C987, huntingcart, tonumber(percentage), 1)
            end, wagon.plate)

            -- Target setup (same as before)
            exports['rsg-target']:AddTargetEntity(huntingcart, {
                options = {
                    {
                        icon = 'fas fa-eye',
                        label = Lang:t('client.lang_16'),
                        targeticon = 'fas fa-eye',
                        action = function()
                            TriggerEvent('rex-huntwagon:client:openmenu')
                        end
                    },
                },
                distance = Config.TargetDistance,
            })

            lib.notify({ title = 'Hunting Wagon Spawned', description = Lang:t('client.lang_11'), type = 'inform', duration = 5000 })
            hutingwagonspawned = true
        end)
    end
end)
---------------------------------------------------------------------
-- get closest hunter camp to store wagon
---------------------------------------------------------------------
local function SetClosestStoreLocation()
    local pos = GetEntityCoords(PlayerPedId(), true)
    local current = nil
    local dist = nil

    for k, v in pairs(Config.HunterLocations) do
        local dest = vector3(v.coords.x, v.coords.y, v.coords.z)
        local dist2 = #(pos - dest)

        if current then
            if dist2 < dist then
                current = v.location
                dist = dist2
            end
        else
            dist = dist2
            current = v.location
        end
    end

    if current ~= closestWagonStore then
        closestWagonStore = current
    end
end

---------------------------------------------------------------------
-- get wagon state
---------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Wait(1000)
        if hutingwagonspawned then
            local drivable = Citizen.InvokeNative(0xB86D29B10F627379, currentHuntingWagon, false, false) -- IsVehicleDriveable
            if not drivable then
                lib.notify({ title = Lang:t('client.lang_17'), description = Lang:t('client.lang_18'), type = 'inform', duration = 10000 })
                DeleteVehicle(currentHuntingWagon)
                SetEntityAsNoLongerNeeded(currentHuntingWagon)
                hutingwagonspawned = false
                SetClosestStoreLocation()
                TriggerServerEvent('rex-huntwagon:server:damagedwagon', closestWagonStore, currentHuntingPlate)
                lib.hideTextUI()
            end
        end
    end
end)

---------------------------------------------------------------------
-- store wagon
---------------------------------------------------------------------
RegisterNetEvent('rex-huntwagon:client:storewagon', function(data)
    if hutingwagonspawned then
        DeleteVehicle(currentHuntingWagon)
        SetEntityAsNoLongerNeeded(currentHuntingWagon)
        hutingwagonspawned = false
        SetClosestStoreLocation()
        TriggerServerEvent('rex-huntwagon:server:updatewagonstore', closestWagonStore, currentHuntingPlate)
        if wagonBlip then
            RemoveBlip(wagonBlip)
        end
    end
end)

---------------------------------------------------------------------
-- hunting wagon menu
---------------------------------------------------------------------
RegisterNetEvent('rex-huntwagon:client:openmenu', function(data)
    local sellprice = (Config.WagonPrice * Config.WagonSellRate)
    lib.registerContext({
        id = 'hunterwagon_menu',
        title = Lang:t('client.lang_19'),
        options = {
            {
                title = Lang:t('client.lang_20'),
                description = Lang:t('client.lang_21'),
                icon = 'fa-solid fa-circle-down',
                iconColor = 'green',
                event = 'rex-huntwagon:client:addanimal',
                args = { plate = currentHuntingPlate },
                arrow = true
            },
            {
                title = Lang:t('client.lang_22'),
                description = Lang:t('client.lang_23'),
                icon = 'fa-solid fa-circle-up',
                iconColor = 'red',
                event = 'rex-huntwagon:client:getHuntingWagonStore',
                args = { plate = currentHuntingPlate },
                arrow = true
            },
            {
                title = Lang:t('client.lang_24'),
                description = Lang:t('client.lang_25'),
                icon = 'fa-solid fa-box',
                iconColor = 'yellow',
                event = 'rex-huntwagon:client:getHuntingWagonInventory',
                args = { plate = currentHuntingPlate },
                arrow = true
            },
            {
                title = Lang:t('client.lang_26'),
                description = Lang:t('client.lang_27'),
                icon = 'fa-solid fa-circle-xmark',
                event = 'rex-huntwagon:client:storewagon',
                arrow = true
            },
            {
                title = Lang:t('client.lang_28')..sellprice..')',
                description = Lang:t('client.lang_29'),
                icon = 'fa-solid fa-dollar-sign',
                iconColor = 'red',
                event = 'rex-huntwagon:client:sellwagoncheck',
                args = { plate = currentHuntingPlate },
                arrow = true
            },
        }
    })
    lib.showContext('hunterwagon_menu')

end)

---------------------------------------------------------------------
-- sell wagon check
---------------------------------------------------------------------
RegisterNetEvent('rex-huntwagon:client:sellwagoncheck', function(data)
    local input = lib.inputDialog(Lang:t('client.lang_30'), {
        { 
            label = Lang:t('client.lang_31'),
            type = 'select',
            options = { 
                { value = 'yes', label = Lang:t('client.lang_32') },
                { value = 'no', label = Lang:t('client.lang_33') }
            },
            required = true,
            icon = 'fa-solid fa-circle-question'
        },
    })

    if not input then
        return
    end

    if input[1] == 'no' then
        return
    end

    if input[1] == 'yes' then
        TriggerServerEvent('rex-huntwagon:server:sellhuntingcart', data.plate )
        if hutingwagonspawned then
            DeleteVehicle(currentHuntingWagon)
            SetEntityAsNoLongerNeeded(currentHuntingWagon)
            hutingwagonspawned = false
            exports['rsg-core']:deletePrompt(string.lower(currentHuntingPlate))
            showingprompt = false
        end
    end
end)

---------------------------------------------------------------------
-- add animal to the database
---------------------------------------------------------------------
RegisterNetEvent('rex-huntwagon:client:addanimal', function(data)
    local ped = PlayerPedId()
    local holding = Citizen.InvokeNative(0xD806CD2A4F2C2996, ped)
    local holdinghash = GetEntityModel(holding)
    local holdinganimal = Citizen.InvokeNative(0x9A100F1CF4546629, holding)
    local holdinglooted = Citizen.InvokeNative(0x8DE41E9902E85756, holding)

    if Config.Debug == true then
        print("holding: "..tostring(holding))
        print("holdinghash: "..tostring(holdinghash))
        print("holdinganimal: "..tostring(holdinganimal))
        print("wagon: "..tostring(data.plate))
        print("holdinglooted: "..tostring(holdinglooted))
    end

    if holding ~= false and holdinganimal == 1 then
        for i = 1, #Config.Animals do
            if Config.Animals[i].modelhash == holdinghash then
                local modelhash = Config.Animals[i].modelhash
                local modellabel = Config.Animals[i].modellabel
                local modellooted = holdinglooted
                local deleted = DeleteThis(holding)
                if deleted then
                    TriggerServerEvent('rex-huntwagon:server:addanimal', modelhash, modellabel, modellooted, data.plate)
                else
                    lib.notify({ title = Lang:t('client.lang_34'), description = Lang:t('client.lang_35'), type = 'error', duration = 5000 })
                end
            end
        end
    end
    
    -- update hunting wagon tarp
    RSGCore.Functions.TriggerCallback('rex-huntwagon:server:gettarpinfo', function(results)
        local change = (results + 1)
        local percentage = change * Config.TotalAnimalsStored / 100
        Citizen.InvokeNative(0x31F343383F19C987, currentHuntingWagon, tonumber(percentage), 1)
    end, currentHuntingPlate)
    
end)

---------------------------------------------------------------------
-- delete animal player is holding
---------------------------------------------------------------------
function DeleteThis(holding)
    NetworkRequestControlOfEntity(holding)
    SetEntityAsMissionEntity(holding, true, true)
    Wait(100)
    DeleteEntity(holding)
    Wait(500)
    local entitycheck = Citizen.InvokeNative(0xD806CD2A4F2C2996, PlayerPedId())
    local holdingcheck = GetPedType(entitycheck)
    if holdingcheck == 0 then
        return true
    else
        return false
    end
end

---------------------------------------------------------------------
-- get what is stored in the hunting wagon / remove carcus
---------------------------------------------------------------------
RegisterNetEvent('rex-huntwagon:client:getHuntingWagonStore', function(data)
    RSGCore.Functions.TriggerCallback('rex-huntwagon:server:getwagonstore', function(results)
        local options = {}
        for k, v in ipairs(results) do
            options[#options + 1] = {
                title = v.animallabel,
                description = '',
                icon = 'fa-solid fa-box',
                serverEvent = 'rex-huntwagon:server:removeanimal',
                args = {
                    id = v.id,
                    plate = v.plate,
                    animallooted = v.animallooted,
                    animalhash = v.animalhash,
                },
                arrow = true,
            }
        end
        lib.registerContext({
            id = 'hunting_inv_menu',
            title = Lang:t('client.lang_36'),
            position = 'top-right',
            options = options
        })
        lib.showContext('hunting_inv_menu')
    end, data.plate)
end)

---------------------------------------------------------------------
-- takeout animal
---------------------------------------------------------------------
RegisterNetEvent('rex-huntwagon:client:takeoutanimal', function(animalhash, animallooted)
    local pos = GetOffsetFromEntityInWorldCoords(currentHuntingWagon, 0.0, -3.0, 0.0)
    
    modelHash = tonumber(animalhash)

    if not HasModelLoaded(modelHash) then
        RequestModel(modelHash)
        while not HasModelLoaded(modelHash) do
            Wait(1)
        end
    end

    animal = CreatePed(modelHash, pos.x, pos.y, pos.z, true, true, true)
    Citizen.InvokeNative(0x77FF8D35EEC6BBC4, animal, 0, false)

    if animallooted == 1 then
        Citizen.InvokeNative(0x6BCF5F3D8FFE988D, animal, animallooted)
        SetEntityHealth(animal, 0, 0)
        SetEntityAsMissionEntity(animal, true, true)
    else
        SetEntityHealth(animal, 0, 0)
        SetEntityAsMissionEntity(animal, true, true)
    end
    
    -- update hunting wagon tarp
    RSGCore.Functions.TriggerCallback('rex-huntwagon:server:gettarpinfo', function(results)
        local change = (results - 1)
        local percentage = change * Config.TotalAnimalsStored / 100
        Citizen.InvokeNative(0x31F343383F19C987, currentHuntingWagon, tonumber(percentage), 1)
    end, currentHuntingPlate)

end)

---------------------------------------------------------------------
-- fix hunting wagon
---------------------------------------------------------------------
RegisterNetEvent('rex-huntwagon:client:fixwagon', function(plate)
    local fixprice = (Config.WagonPrice * Config.WagonFixRate)
    local input = lib.inputDialog(Lang:t('client.lang_37'), {
        { 
            label = Lang:t('client.lang_38')..fixprice,
            type = 'select',
            options = { 
                { value = 'yes', label = Lang:t('client.lang_32') },
                { value = 'no', label = Lang:t('client.lang_33') }
            },
            required = true,
            icon = 'fa-solid fa-circle-question'
        },
    })

    if not input then
        return
    end

    if input[1] == 'no' then
        return
    end

    if input[1] == 'yes' then
        TriggerServerEvent('rex-huntwagon:server:fixhuntingwagon', plate, fixprice )
    end
end)

---------------------------------------------------------------------
-- hunting wagon storage
---------------------------------------------------------------------
RegisterNetEvent('rex-huntwagon:client:getHuntingWagonInventory', function(data)
    TriggerServerEvent("inventory:server:OpenInventory", "stash", data.plate, { maxweight = Config.WagonInventoryMaxWeight, slots = Config.WagonInventorySlots })
    TriggerEvent("inventory:client:SetCurrentStash", data.plate)
end)

-----------------------------------------------------------------
-- hunting shop
-----------------------------------------------------------------
RegisterNetEvent('rex-huntwagon:client:openshop')
AddEventHandler('rex-huntwagon:client:openshop', function()
    local ShopItems = {}
    ShopItems.label = Lang:t('client.lang_39')
    ShopItems.items = Config.HuntingShop
    ShopItems.slots = #Config.HuntingShop
    TriggerServerEvent('inventory:server:OpenInventory', 'shop', 'HuntingShop_'..math.random(1, 99), ShopItems)
end)
