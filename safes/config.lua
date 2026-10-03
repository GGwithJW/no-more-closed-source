Config = {}

Config.DefaultMetadata = { -- / do not edit this if you don't know what you are doing
    Password = 0,
    StashId = "None",
}

Config.SafeTypes = {
    ["largesafe"] = {
        slotCount = 75,
        maxWeight = 200000,
    },
    ["smallsafe"] = {
        slotCount = 35,
        maxWeight = 100000,
    }
}

TMC = exports.core:getCoreObject()