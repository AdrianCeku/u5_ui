local utils = exports["u5_utils"]

SECTIONS = {}

--+--+--+--+--+--+ CONTROLS +--+--+--+--+--+--+

RegisterCommand("showui", function()
    SetNuiFocus(true, true)
end, false)

RegisterKeyMapping("showui", config.keybindMessage, "keyboard", config.toggleKey)

--+--+--+--+--+--+ CONFIG +--+--+--+--+--+--+

AddEventHandler("onResourceStart", function(resourceName)
    local waitTime = 2000 -- The NUI takes some time to load, so we need to wait a bit before sending the config or it wont register. Please DM me or submit a PR if you know a better way to do this

    Citizen.CreateThread(function()
        if (GetCurrentResourceName() ~= resourceName) then
          return
        end
    
        Citizen.Wait(waitTime)
    
        config.toggleKeyJS = getJSKey(config.toggleKey)
    
        SendNUIMessage({
            type = "config",
            config = config
        })
    end)
  end)

--+--+--+--+--+--+ EXPORTS +--+--+--+--+--+--+