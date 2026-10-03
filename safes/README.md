# safes

## core_game > Interaction Types
```lua
['largesafe'] = {
    PromptName = 'Large Safe',
    PromptDescription = 'What can I store here?...',
    PromptIcon = 'fa-solid fa-vault',
    PromptComplete = function(objConf, obj)
        TaskTurnPedToFaceEntity(playerPedId, obj, 2000, 0.0, 0.0, 0.0) -- Dont set duration to infinite
        Citizen.Wait(250)
        TriggerEvent('safes:client:getSafe', source)
    end,
    Object = `m23_2_prop_m32_safe_01a`,
    UseItemMetadata = true,
    InteractDist = 1.3,
    ReturnItem = 'largesafe',
    StoreMetadataOnReturn = true,
    Offset = vector4(0.0, 0.0, -1.0, 0.0),
    LimitUse = false, -- if true then object can only be interacted by 1 player at a time
},
['smallsafe'] = {
    PromptName = 'Small Safe',
    PromptDescription = 'What can I store here?...',
    PromptIcon = 'fa-solid fa-vault',
    PromptComplete = function(objConf, obj)
        TaskTurnPedToFaceEntity(playerPedId, obj, 2000, 0.0, 0.0, 0.0) -- Dont set duration to infinite
        Citizen.Wait(250)
        TriggerEvent('safes:client:getSafe', source)
    end,
    Object = `prop_ld_int_safe_01`,
    UseItemMetadata = true,
    InteractDist = 1.3,
    ReturnItem = 'smallsafe',
    StoreMetadataOnReturn = true,
    Offset = vector4(0.0, 0.0, -1.0, 0.0),
    LimitUse = false, -- if true then object can only be interacted by 1 player at a time
},
```

## core > Shared.Items
```lua
["largesafe"] = {
        ["label"] = "Large Safe",
        ["weight"] = 30000,
        ["type"] = "item",
        ["image"] = "largesafe.webp",
        ["unique"] = true,
        ["stackable"] = true,
        ["useable"] = true,
        ["shouldClose"] = true,
        ["description"] = "What am I gonna store here..",
    },
    ["smallsafe"] = {
        ["label"] = "Small Safe",
        ["weight"] = 30000,
        ["type"] = "item",
        ["image"] = "smallsafe.webp",
        ["unique"] = true,
        ["stackable"] = true,
        ["useable"] = true,
        ["shouldClose"] = true,
        ["description"] = "What am I gonna store here..",
    },
```

## logs > Config.DiscordWebhooks
```lua
["safes"] = "WEBHOOK HERE",
```