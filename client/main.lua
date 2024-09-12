u5_ui = {}

local WAITING_FOR_SECTION_ID = false
local SECTION_ID = nil

local WAITING_FOR_COMPONENT_ID = false
local COMPONENT_ID = nil

local onClickFunctions = {}

function u5_ui.addSection(options, onClose)
    local onCloseId = nil

    if onClose then
        onCloseId = #onClickFunctions + 1
        onClickFunctions[onCloseId] = onClose
    end
    
    WAITING_FOR_SECTION_ID = true

    SendNUIMessage({
        type = "addSection",
        options = options,
        onCloseId = onCloseId
    })
                
    while WAITING_FOR_SECTION_ID do
        Citizen.Wait(10)
    end

    local retVal = SECTION_ID
    SECTION_ID = nil
    
    return retVal
end

function u5_ui.addComponent(sectionId, componentType, props, onClick)
    local onClickId = nil

    if onClick then
        onClickId = #onClickFunctions + 1
        onClickFunctions[onClickId] = onClick
    end

    local component = {
        componentType = componentType,
        props = props,
        onClickId = onClickId
    }

    WAITING_FOR_COMPONENT_ID = true
    SendNuiMessage(json.encode({
        type = "addComponent",
        sectionId = sectionId,
        component = component
    }))

    while WAITING_FOR_COMPONENT_ID do
        Citizen.Wait(10)
    end

    local retVal = COMPONENT_ID
    COMPONENT_ID = nil

    return retVal
end

RegisterNUICallback('sendSectionId', function(data, cb)
    SECTION_ID = data.id
    WAITING_FOR_SECTION_ID = false

    cb('ok')
end)

RegisterNUICallback('sendComponentId', function(data, cb)
    COMPONENT_ID = data.id
    WAITING_FOR_COMPONENT_ID = false

    cb('ok')
end)

RegisterNUICallback('clickTriggered', function(data, cb)
    onClickFunctions[data.id]()
    
    cb('ok')
end)

RegisterNUICallback('exit', function(data, cb)
    SetNuiFocus(false, false)
    
    cb('ok')
end)

exports("getObject", function()
    return u5_ui
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(0, 38) then
            SetNuiFocus(true, true)
        end
    end
end)