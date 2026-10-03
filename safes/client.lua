if TMC.Common.IsDepRunning('radialmenu') then
    exports.radialmenu:registerSubMenu('safes:pickUpSafe', {
        title = 'Pickup Safe',
        icon = 'vault',
        iconCategory = 'duotone',
        functionName = 'safes:client:PickUpSafe',
        enableMenu = function()
            return not isDead and (exports['core_game']:CanPickupInteractionObject('largesafe') or exports['core_game']:CanPickupInteractionObject('smallsafe'))
        end,
    })
    exports.radialmenu:addSubMenuToRoot('general', 'safes:pickUpSafe')
end

AddEventHandler('core_game:client:interactionObjectSpawned', function(obj, entity)
    if obj.type == 'largesafe' then
        local defaultMetadata = Config.DefaultMetadata
        defaultMetadata.StashId = string.format("%s_%s_%s", string.lower(obj.owner), obj.type, obj.id)
        TMC.Functions.TriggerServerEvent('safes:server:addSafe', obj.id, obj.owner, obj.type, json.encode(defaultMetadata))
    elseif obj.type == 'smallsafe' then
        local defaultMetadata = Config.DefaultMetadata
        defaultMetadata.StashId = string.format("%s_%s_%s", string.lower(obj.owner), obj.type, obj.id)
        TMC.Functions.TriggerServerEvent('safes:server:addSafe', obj.id, obj.owner, obj.type, json.encode(defaultMetadata))
    end
end)

RegisterNetEvent("safes:client:PickUpSafe", function()
    local closestSafe = exports['core_game']:GetClosestInteractionObject()
    if closestSafe then
        TMC.Functions.OpenMenu({
            namespace = "safes_pickup",
            title = "Pickup Safe",
            subtitle = "Are you sure you want to pick up this safe?",
            searchable = false,
            form = true,
        },{
            {
                type = "button",
                name = "info",
                label = "Information",
                description = "This will remove the safe and add it to your inventory.",
                icon = "fas fa-box-open",
                disabled = true,
            }
        }, function(close, confirmed)
            if confirmed then
                TMC.Functions.TriggerServerEvent('safes:server:PickUpSafe', closestSafe)
            end
        end, function(select)
        end, function(change)
        end)
    end
end)

RegisterNetEvent('safes:client:deleteSafe', function(id)
    if id then
        TMC.Functions.TriggerServerEvent('core_game:server:pickupInteractionObject', id, true)
    end
end)

RegisterNetEvent("safes:client:getSafe", function()
    local safe = exports['core_game']:GetClosestInteractionObject()
    TMC.Functions.TriggerServerCallback("safes:server:getSafe", function(data)
        if data then
            local decodedMetadata = TMC.Common.Decode(data.metadata)
            local safeData = {
                id = data.id,
                owner = data.owner,
                type = data.type,
                metadata = decodedMetadata
            }
            UseSafe(safeData)
        else
            TMC.Functions.SimpleNotify("No safe data found for this object.", "error")
        end
    end, safe)
end)

UseSafe = function(data)
    if not data then
        return
    end
    local owner = LocalPlayer.state.citizenid == data.owner
    local elements = {
        {
            type = "button",
            name = "open_safe",
            label = "Open Safe",
            description = "Enter the password and access the safe's contents.",
            icon = "fas fa-lock",
            disabled = false,
        }
    }
    if owner then
        table.insert(elements, {
            type = "button",
            name = "set_password",
            label = "Set Password",
            description = "Set or change the password for this safe.",
            icon = "fas fa-key",
            disabled = false,
        })
    end
    TMC.Functions.OpenMenu({
        namespace = data.metadata.StashId,
        title = TMC.Shared.Items[data.type].label,
        subtitle = 'Manage this safe',
        searchable = false,
        form = true
    },elements, function(close, confirmed)
    end, function(select)
    end, function(change)
        if change.elementChanged == "open_safe" then
            TMC.Functions.CloseMenu()
            EnterPassword(data)
        elseif change.elementChanged == "set_password" then
            TMC.Functions.CloseMenu()
            ChangePassword(data)
        end
    end)
end

EnterPassword = function(data)
    if not data then
        return
    end
    local password = data.metadata.Password
    TMC.Functions.OpenMenu({
        namespace = string.format("%s_password", data.metadata.StashId),
        title = TMC.Shared.Items[data.type].label,
        subtitle = 'Enter the password',
        searchable = false,
        form = true
    },{
        {
            type = "text",
            name = "password",
            label = "Password",
            required = true,
        }
    }, function(close, confirmed)
        if confirmed then
            local input = tonumber(close.password) -- because its a string by default, we convert to number :D
            if input == password then
                OpenSafeStash(data)
            else
                TMC.Functions.SimpleNotify(exports.core:t('notifications.error.wrong_password'), "error")
            end
        end
    end, function(select)
    end, function(change)
    end)
end

ChangePassword = function(data)
    if not data then
        return
    end
    local owner = LocalPlayer.state.citizenid == data.owner
    if not owner then
        return
    end
    TMC.Functions.OpenMenu({
        namespace = string.format("%s_change_password", data.metadata.StashId),
        title = TMC.Shared.Items[data.type].label,
        subtitle = 'Enter the new password',
        searchable = false,
        form = true
    },{
        {
            type = "text",
            name = "password",
            label = "New Password",
            required = true,
        }
    }, function(close, confirmed)
        if confirmed then
            local input = tonumber(close.password) -- because its a string by default, we convert to number :D
            TMC.Functions.TriggerServerEvent("safes:server:updatePassword", data.id, input)
        end
    end, function(select)
    end, function(change)
    end)
end

OpenSafeStash = function(data)
    if not data then
        return
    end
    TMC.Functions.TriggerServerEvent('inventory:server:openInventory', 'stash', data.metadata.StashId, {
        title = string.format("%s - %s", TMC.Shared.Items[data.type].label, data.owner),
        slotCount = Config.SafeTypes[data.type].slotCount,
        maxWeight = Config.SafeTypes[data.type].maxWeight,
        temp = false
    })
end