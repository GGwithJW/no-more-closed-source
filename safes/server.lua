TMC.Functions.RegisterServerEvent("safes:server:addSafe", function(src, id, owner, type, metadata)
    TMC.Functions.ExecuteSql("SELECT id FROM safes WHERE id = @id", {
        ["@id"] = id
    }, function(res)
        if res?[1] then
            return
        end
        TMC.Functions.ExecuteSql("INSERT INTO safes (id, owner, type, metadata) VALUES (@id, @owner, @type, @metadata)",{
            ["@id"] = id,
            ["@owner"] = owner,
            ["@type"] = type,
            ["@metadata"] = metadata
        })
        local decodedMetadata = TMC.Common.Decode(metadata)
        if decodedMetadata.Password == 0 then
            TMC.Functions.SimpleNotify(src, exports.core:t('notifications.info.change_password'), "info")
        end
        TMC.Functions.TriggerEvent('tmc:log', 'safes', 'New safe added', 'green', string.format("New safe added\nID: %s\nOwner: %s\nType: %s", id, owner, type))
    end)
end)

TMC.Functions.RegisterServerCallback("safes:server:getSafe", function(src, cb, id)
    TMC.Functions.ExecuteSql("SELECT * FROM safes WHERE id = @id", {
        ["@id"] = id
    }, function(res)
        if res[1] then
            cb(res[1])
        else
            cb(nil)
        end
    end)
end)

TMC.Functions.RegisterServerEvent("safes:server:updatePassword", function(src, id, password)
    TMC.Functions.ExecuteSql("SELECT * FROM safes WHERE id = @id", {
        ["@id"] = id
    }, function(res)
        if not res?[1] then return end
        local decodedMetadata = TMC.Common.Decode(res[1].metadata)
        decodedMetadata.Password = password
        TMC.Functions.ExecuteSql("UPDATE safes SET metadata = @metadata WHERE id = @id", {
            ["@metadata"] = json.encode(decodedMetadata),
            ["@id"] = id
        })
        TMC.Functions.TriggerEvent('tmc:log', 'safes', 'Password updated', 'blue', string.format("Password updated\nID: %s\nOwner: %s\nType: %s", id, res[1].owner, res[1].type))
    end)
end)

TMC.Functions.RegisterServerEvent("safes:server:PickUpSafe", function(src, id)
    TMC.Functions.ExecuteSql("SELECT * FROM safes WHERE id = @id", {
        ["@id"] = id
    }, function(res)
        if not res?[1] then return end
        TMC.Functions.ExecuteSql("DELETE FROM safes WHERE id = @id", {
            ["@id"] = id
        })
        TriggerClientEvent("safes:client:deleteSafe", src, id)
        local player = TMC.Functions.GetPlayer(src)
        player.Functions.AddItem(res[1].type, 1)
        TMC.Functions.TriggerEvent('tmc:log', 'safes', 'Safe picked up', 'orange', string.format("Safe picked up\nID: %s\nOwner: %s\nType: %s", id, res[1].owner, res[1].type))
    end)
end)