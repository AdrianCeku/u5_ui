local UI_CALLBACKS = {}
local NEXT_CALLBACK_ID = 0

local function getCallbackId()
    local id = NEXT_CALLBACK_ID
    NEXT_CALLBACK_ID = NEXT_CALLBACK_ID + 1

    return tostring(id)
end

function sendToUI(payload)
    local promise = promise:new()
    local callbackId = getCallbackId()

    UI_CALLBACKS[callbackId] = function(response)
        promise:resolve(response)
    end

    SendNUIMessage({
        type = "uiCallback",
        payload = payload,
        callbackId = callbackId
    })

    return Citizen.Await(promise)
end

RegisterNUICallback("uiCallback", function(data, cb)
    local callbackId = data.callbackId
    local response = data.response

    if UI_CALLBACKS[callbackId] then
        UI_CALLBACKS[callbackId](response)
        UI_CALLBACKS[callbackId] = nil
    end

    cb("ok")
end)