local RSGCore = exports['rsg-core']:GetCoreObject()

----------------------------------------------------
-- buy and add hunting cart
----------------------------------------------------
RegisterServerEvent('rex-huntwagon:server:buyhuntingcart', function(data)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid
    local cashBalance = Player.PlayerData.money["cash"]
    
    if cashBalance >= Config.WagonPrice then
        local result = MySQL.prepare.await("SELECT COUNT(*) as count FROM rex_hunting_wagons WHERE citizenid = ?", { citizenid })
        
        -- Remove the check for existing wagons
        local plate = GeneratePlate()
        MySQL.insert('INSERT INTO rex_hunting_wagons(citizenid, plate, huntingcamp, damaged, active) VALUES(@citizenid, @plate, @huntingcamp, @damaged, @active)', {
            ['@citizenid'] = citizenid,
            ['@plate'] = plate,
            ['@huntingcamp'] = data.huntingcamp,
            ['@damaged'] = 0,
            ['@active'] = 1,
        })
        Player.Functions.RemoveMoney("cash", Config.WagonPrice, "hunting-wagon")
        
        -- Modify the success message to include the number of wagons owned
        local newCount = result + 1
        TriggerClientEvent('ox_lib:notify', src, {title = Lang:t('server.lang_1'), description = Lang:t('server.lang_2') .. " You now own " .. newCount .. " wagon(s).", type = 'success', duration = 5000 })
    else
        TriggerClientEvent('ox_lib:notify', src, {title = Lang:t('server.lang_5'), description = '$'..Config.WagonPrice..Lang:t('server.lang_6'), type = 'error', duration = 7000 })
    end
end)

----------------------------------------------------
-- get wagons
----------------------------------------------------
RSGCore.Functions.CreateCallback('rex-huntwagon:server:getwagons', function(source, cb)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid
    local wagon = MySQL.query.await('SELECT * FROM rex_hunting_wagons WHERE citizenid=@citizenid', { ['@citizenid'] = citizenid })
    if wagon[1] == nil then return end
    cb(wagon)
end)

----------------------------------------------------
-- get wagon store
----------------------------------------------------
RSGCore.Functions.CreateCallback('rex-huntwagon:server:getwagonstore', function(source, cb, plate)
    local wagonstore = MySQL.query.await('SELECT * FROM rex_hunting_inventory WHERE plate=@plate', { ['@plate'] = plate })
    if wagonstore[1] == nil then return end
    cb(wagonstore)
end)

----------------------------------------------------
-- get tarp info
----------------------------------------------------
RSGCore.Functions.CreateCallback('rex-huntwagon:server:gettarpinfo', function(source, cb, plate)
    local result = MySQL.prepare.await("SELECT COUNT(*) as count FROM rex_hunting_inventory WHERE plate = ?", { plate })
    cb(result)
end)

----------------------------------------------------
-- store good hunting wagon
----------------------------------------------------
RegisterServerEvent('rex-huntwagon:server:updatewagonstore', function(location, plate)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid
    local newLocation = MySQL.query.await('UPDATE rex_hunting_wagons SET huntingcamp = ? WHERE plate = ?' , { location, plate })

    if newLocation == nil then
        TriggerClientEvent('ox_lib:notify', src, {title = Lang:t('server.lang_7'), description = Lang:t('server.lang_8'), type = 'error', duration = 5000 })
        return
    end
    
    TriggerClientEvent('ox_lib:notify', src, {title = Lang:t('server.lang_9'), description = Lang:t('server.lang_10')..location, type = 'success', duration = 5000 })
end)

----------------------------------------------------
-- store damaged hunting wagon
----------------------------------------------------
RegisterServerEvent('rex-huntwagon:server:damagedwagon', function(location, plate)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid
    local newLocation = MySQL.query.await('UPDATE rex_hunting_wagons SET huntingcamp = ? WHERE plate = ?' , { location, plate })
    local newDamage = MySQL.query.await('UPDATE rex_hunting_wagons SET damaged = ? WHERE plate = ?' , { 1, plate })

    if (newLocation == nil) or (newDamage == nil) then
        TriggerClientEvent('ox_lib:notify', src, {title = Lang:t('server.lang_11'), description = Lang:t('server.lang_12'), type = 'error', duration = 5000 })
        return
    end
    
    TriggerClientEvent('ox_lib:notify', src, {title = Lang:t('server.lang_13'), description = Lang:t('server.lang_14')..location, type = 'success', duration = 5000 })
end)

----------------------------------------------------
-- fix damaged hunting wagon
----------------------------------------------------
RegisterServerEvent('rex-huntwagon:server:fixhuntingwagon', function(plate, price)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local cashBalance = Player.PlayerData.money["cash"]
    if cashBalance >= price then
        Player.Functions.RemoveMoney("cash", price, "fix-hunting-wagon")
        MySQL.update('UPDATE rex_hunting_wagons SET damaged = ? WHERE plate = ?' , { 0, plate })
        TriggerClientEvent('ox_lib:notify', src, {title = Lang:t('server.lang_15'), description = Lang:t('server.lang_16'), type = 'success', duration = 5000 })
    else
        TriggerClientEvent('ox_lib:notify', src, {title = Lang:t('server.lang_17'), description = Lang:t('server.lang_18'), type = 'error', duration = 5000 })
    end
end)

----------------------------------------------------
-- add holding animal to database
----------------------------------------------------
RegisterServerEvent('rex-huntwagon:server:addanimal', function(animalhash, animallabel, animallooted, plate)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid
    local result = MySQL.prepare.await("SELECT COUNT(*) as count FROM rex_hunting_inventory WHERE plate = ?", { plate })
    if result < Config.TotalAnimalsStored then
        MySQL.insert('INSERT INTO rex_hunting_inventory(animalhash, animallabel, animallooted, citizenid, plate) VALUES(@animalhash, @animallabel, @animallooted, @citizenid, @plate)', {
            ['@animalhash'] = animalhash,
            ['@animallabel'] = animallabel,
            ['@animallooted'] = animallooted,
            ['@citizenid'] = citizenid,
            ['@plate'] = plate
        })
        TriggerClientEvent('ox_lib:notify', src, {title = Lang:t('server.lang_19'), description = animallabel..Lang:t('server.lang_20'), type = 'success', duration = 5000 })
    else
        TriggerClientEvent('ox_lib:notify', src, {title = Lang:t('server.lang_21'), description = Lang:t('server.lang_22')..Config.TotalAnimalsStored..Lang:t('server.lang_23'), type = 'error', duration = 5000 })
    end
end)

RegisterServerEvent('rex-huntwagon:server:removeanimal', function(data)
    local src = source
    MySQL.update('DELETE FROM rex_hunting_inventory WHERE id = ? AND plate = ?', { data.id, data.plate })
    TriggerClientEvent('rex-huntwagon:client:takeoutanimal', src, data.animalhash, data.animallooted)
end)

----------------------------------------------------
-- sell hunting wagon
----------------------------------------------------
RegisterServerEvent('rex-huntwagon:server:sellhuntingcart')
AddEventHandler('rex-huntwagon:server:sellhuntingcart', function(plate)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid

    local sellPrice = (Config.WagonPrice * Config.WagonSellRate)

    local wagon = MySQL.query.await("SELECT * FROM rex_hunting_wagons WHERE citizenid=@citizenid AND plate=@plate", {
        ['@citizenid'] = citizenid,
        ['@plate'] = plate
    })

    if wagon[1] then
        MySQL.update('DELETE FROM rex_hunting_wagons WHERE id = ?', { wagon[1].id })
        MySQL.update('DELETE FROM stashitems WHERE stash = ?', { wagon[1].plate })
        Player.Functions.AddMoney('cash', sellPrice, 'hunting-wagon-sell')
        TriggerClientEvent('ox_lib:notify', src, { title = Lang:t('server.lang_24'), description = Lang:t('server.lang_25') .. sellPrice, type = 'success', duration = 5000 })
    else
        TriggerClientEvent('ox_lib:notify', src, { title = Lang:t('server.lang_26'), description = Lang:t('server.lang_27'), type = 'error', duration = 5000 })
    end
end)

----------------------------------------------------
-- generate wagon plate
----------------------------------------------------
function GeneratePlate()
    local UniqueFound = false
    local plate = nil
    while not UniqueFound do
        plate = tostring(RSGCore.Shared.RandomStr(3) .. RSGCore.Shared.RandomInt(3)):upper()
        local result = MySQL.prepare.await("SELECT COUNT(*) as count FROM rex_hunting_wagons WHERE plate = ?", { plate })
        if result == 0 then
            UniqueFound = true
        end
    end
    return plate
end
