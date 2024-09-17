local utils = exports["u5_utils"]

SECTIONS = {}

--+--+--+--+--+--+ CONTROLS +--+--+--+--+--+--+

RegisterCommand("focusui", function()
    SetNuiFocus(true, true)
end, false)

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