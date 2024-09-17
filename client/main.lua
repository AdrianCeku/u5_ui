local utils = exports["u5_utils"]

SECTIONS = {}

--+--+--+--+--+--+ CONTROLS +--+--+--+--+--+--+

local disableControl = {
    -- Look controls
    1,
    2, 
    3,
    4,
    5,
    6,
    -- Sprint
    21,
    -- Attack / Aim
    24,
    25,
    68,
    69,
    70,
    91,
    92,
    114,
    121,
    140,
    141,
    142,
    257,
    263,
    264,
    331,

}

local isUiOpen = false

RegisterNuiCallback("focusInput", function(data, cb)
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(false)

    cb("ඞ")
end)

RegisterNuiCallback("focusOutInput", function(data, cb)
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(true)

    cb("ඞ")
end)

RegisterCommand("focusui", function()
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(true)
    isUiOpen = true

    Citizen.CreateThread(function()
        while isUiOpen do 
            Citizen.Wait(0)
            for i=1, #disableControl do
                DisableControlAction(0, disableControl[i], true)
            end
        end
    end)
end, false)

RegisterNUICallback("exit", function(data, cb)
    SetNuiFocus(false, false)
    isUiOpen = false

    cb("ඞ")
end)

RegisterKeyMapping("focusui", config.keybindMessage, "keyboard", config.toggleKey)

--+--+--+--+--+--+ CONFIG +--+--+--+--+--+--+

AddEventHandler("onResourceStart", function(resourceName)
    local waitTime = 5000 -- The NUI takes some time to load, so we need to wait a bit before sending the config or it wont register. Please DM me or submit a PR if you know a better way to do this

    Citizen.CreateThread(function()
        if (GetCurrentResourceName() ~= resourceName) then
            return
        end
    
        Citizen.Wait(waitTime)
    
        config.toggleKeyJS = getJSKey(config.inputMapper, config.toggleKey)
    
        SendNUIMessage({
            type = "config",
            config = config
        })
    end)
end)