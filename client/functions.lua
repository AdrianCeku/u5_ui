local UI_CALLBACKS = {}
local NEXT_CALLBACK_ID = 0

local function getCallbackId()
    local id = NEXT_CALLBACK_ID
    NEXT_CALLBACK_ID = NEXT_CALLBACK_ID + 1

    return tostring(id)
end

function triggerNuiCallback(payload)
    local promise = promise:new()
    local callbackId = getCallbackId()

    UI_CALLBACKS[callbackId] = function(response)
        promise:resolve(response)
    end

    SendNUIMessage(
        {
            type = "uiCallback",
            payload = payload,
            callbackId = callbackId
        }
    )

    return Citizen.Await(promise)
end

RegisterNUICallback("uiCallback",function(data, cb)
    local callbackId = data.callbackId
    local response = data.response

    if UI_CALLBACKS[callbackId] then
        UI_CALLBACKS[callbackId](response)
        UI_CALLBACKS[callbackId] = nil
    end

    cb("ඞ")
end)

function getJSKey(gtaKeyId)
    local key = string.upper(tostring(gtaKeyId))

    local keys = {
        ["BACK"] = "Backspace",
        ["TAB"] = "Tab",
        ["RETURN"] = "Enter",
        ["PAUSE"] = "Pause",
        ["CAPITAL"] = "CapsLock",
        ["ESCAPE"] = "Escape",
        ["SPACE"] = "Space",
        ["PAGEUP"] = "PageUp",
        ["PRIOR"] = "PageUp",
        ["PAGEDOWN"] = "PageDown",
        ["NEXT"] = "PageDown",
        ["END"] = "End",
        ["HOME"] = "Home",
        ["LEFT"] = "ArrowLeft",
        ["UP"] = "ArrowUp",
        ["RIGHT"] = "ArrowRight",
        ["DOWN"] = "ArrowDown",
        ["SYSRQ"] = "F13",
        ["SNAPSHOT"] = "F13",
        ["INSERT"] = "Insert",
        ["DELETE"] = "Delete",
        ["0"] = "Digit0",
        ["1"] = "Digit1",
        ["2"] = "Digit2",
        ["3"] = "Digit3",
        ["4"] = "Digit4",
        ["5"] = "Digit5",
        ["6"] = "Digit6",
        ["7"] = "Digit7",
        ["8"] = "Digit8",
        ["9"] = "Digit9",
        ["A"] = "KeyA",
        ["B"] = "KeyB",
        ["C"] = "KeyC",
        ["D"] = "KeyD",
        ["E"] = "KeyE",
        ["F"] = "KeyF",
        ["G"] = "KeyG",
        ["H"] = "KeyH",
        ["I"] = "KeyI",
        ["J"] = "KeyJ",
        ["K"] = "KeyK",
        ["L"] = "KeyL",
        ["M"] = "KeyM",
        ["N"] = "KeyN",
        ["O"] = "KeyO",
        ["P"] = "KeyP",
        ["Q"] = "KeyQ",
        ["R"] = "KeyR",
        ["S"] = "KeyS",
        ["T"] = "KeyT",
        ["U"] = "KeyU",
        ["V"] = "KeyV",
        ["W"] = "KeyW",
        ["X"] = "KeyX",
        ["Y"] = "KeyY",
        ["Z"] = "KeyZ",
        ["LWIN"] = "MetaLeft",
        ["RWIN"] = "MetaRight",
        ["APPS"] = "ContextMenu",
        ["NUMPAD0"] = "Numpad0",
        ["NUMPAD1"] = "Numpad1",
        ["NUMPAD2"] = "Numpad2",
        ["NUMPAD3"] = "Numpad3",
        ["NUMPAD4"] = "Numpad4",
        ["NUMPAD5"] = "Numpad5",
        ["NUMPAD6"] = "Numpad6",
        ["NUMPAD7"] = "Numpad7",
        ["NUMPAD8"] = "Numpad8",
        ["NUMPAD9"] = "Numpad9",
        ["MULTIPLY"] = "NumpadMultiply",
        ["ADD"] = "NumpadAdd",
        ["SUBTRACT"] = "NumpadSubtract",
        ["DECIMAL"] = "NumpadDecimal",
        ["DIVIDE"] = "NumpadDivide",
        ["NUMPADEQUALS"] = "Numpad Equals",
        ["NUMPADENTER"] = "NumpadEnter",
        ["F1"] = "F1",
        ["F2"] = "F2",
        ["F3"] = "F3",
        ["F4"] = "F4",
        ["F5"] = "F5",
        ["F6"] = "F6",
        ["F7"] = "F7",
        ["F8"] = "F8",
        ["F9"] = "F9",
        ["F10"] = "F10",
        ["F11"] = "F11",
        ["F12"] = "F12",
        ["F13"] = "F13",
        ["F14"] = "F14",
        ["F15"] = "F15",
        ["F16"] = "F16",
        ["F17"] = "F17",
        ["F18"] = "F18",
        ["F19"] = "F19",
        ["F20"] = "F20",
        ["F21"] = "F21",
        ["F22"] = "F22",
        ["F23"] = "F23",
        ["F24"] = "F24",
        ["NUMLOCK"] = "NumLock",
        ["SCROLL"] = "ScrollLock",
        ["LSHIFT"] = "ShiftLeft",
        ["RSHIFT"] = "ShiftRight",
        ["LCONTROL"] = "ControlLeft",
        ["RCONTROL"] = "ControlRight",
        ["LMENU"] = "AltLeft",
        ["RMENU"] = "AltRight",
        ["SEMICOLON"] = "Semicolon",
        ["EQUALS"] = "Equal",
        ["PLUS"] = "Add",
        ["COMMA"] = "Comma",
        ["MINUS"] = "Minus",
        ["PERIOD"] = "Period",
        ["SLASH"] = "Period",
        ["GRAVE"] = "Backquote",
        ["LBRACKET"] = "BracketLeft",
        ["BACKSLASH"] = "Backslash",
        ["RBRACKET"] = "BracketRight",
        ["APOSTROPHE"] = "Digit0"
    }

    return keys[key]
end
