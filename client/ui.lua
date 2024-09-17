local utils = exports["u5_utils"].getObject()

u5_ui = {}

local SECTIONS = {}

--+--+--+--+--+--+ IDS +--+--+--+--+--+--+

local ON_CLICK_FUNCTIONS = {}
local ON_CLICK_FUNCTIONS_ID = 0

local ON_INPUT_FUNCTIONS = {}
local ON_INPUT_FUNCTIONS_ID = 0

local ON_VISIBILITY_CHANGE_FUNCTIONS = {}
local ON_VISIBILITY_CHANGE_FUNCTIONS_ID = 0


local function getOnClickFunctionsId()
    local id = ON_CLICK_FUNCTIONS_ID
    ON_CLICK_FUNCTIONS_ID = ON_CLICK_FUNCTIONS_ID + 1
    
    return tostring(id)
end

local function getOnInputFunctionsId()
    local id = ON_INPUT_FUNCTIONS_ID
    ON_INPUT_FUNCTIONS_ID = ON_INPUT_FUNCTIONS_ID + 1
    
    return tostring(id)
end

local function getOnVisibilityChangeFunctionsId()
    local id = ON_VISIBILITY_CHANGE_FUNCTIONS_ID
    ON_VISIBILITY_CHANGE_FUNCTIONS_ID = ON_VISIBILITY_CHANGE_FUNCTIONS_ID + 1
    
    return tostring(id)
end

--+--+--+--+--+--+ SECTION +--+--+--+--+--+--+

function u5_ui.addSection(options, style, wrapperStyle, innerHTML, isOpen, onVisibilityChange)
    local onVisibilityChangeId = nil

    if onVisibilityChange then
        onVisibilityChangeId = getOnVisibilityChangeFunctionsId()
        ON_VISIBILITY_CHANGE_FUNCTIONS[onVisibilityChangeId] = onVisibilityChange
    end

    local section = {
        options = options,
        style = style,
        wrapperStyle = wrapperStyle,
        innerHTML = innerHTML,
        isOpen = isOpen,
        onVisibilityChangeFunctionId = onVisibilityChangeId,
        isDeleted = false,
        components = {}
    }

    local sectionId = sendToUIandGetReturnValue({
        type = "addSection",
        section = section
    })

    sectionId = tostring(sectionId)
    
    SECTIONS[sectionId] = section

    return sectionId
end

function u5_ui.getSection(sectionId, includeHTML)
    sectionId = tostring(sectionId)

    if not SECTIONS[sectionId] then
        return nil
    end

    local section = SECTIONS[sectionId]

    if not includeHTML then
        return section
    end

    local elementHTML = sendToUIandGetReturnValue({
        type = "getSectionElement",
        sectionId = sectionId
    })

    return {
        section = section,
        html = elementHTML
    }
end


function u5_ui.updateSection(sectionId, section)
    sectionId = tostring(sectionId)

    if not SECTIONS[sectionId] then
        return
    end

    SECTIONS[sectionId] = section

    SendNUIMessage({
        type = "updateSection",
        sectionId = sectionId,
        section = section
    })
end

function u5_ui.openSection(sectionId)
    sectionId = tostring(sectionId)

    if not SECTIONS[sectionId] then
        return
    end

    SendNUIMessage({
        type = "openSection",
        sectionId = sectionId
    })
end

function u5_ui.closeSection(sectionId)
    sectionId = tostring(sectionId)

    if not SECTIONS[sectionId] then
        return
    end

    SendNUIMessage({
        type = "closeSection",
        sectionId = sectionId
    })
end

function u5_ui.bindSectionToCoords(sectionId, coords)
    sectionId = tostring(sectionId)

    local range = 2
    local marker = {
        range = 20,
    }

    local onEnter = function()
        u5_ui.openSection(sectionId)
    end

    local onExit = function()
        u5_ui.closeSection(sectionId)
    end

    utils.addInteractPoint(
        coords,
        range,
        marker,
        onEnter,
        onExit
    ) 
end

function u5_ui.deleteSection(sectionId)
    sectionId = tostring(sectionId)
    if not SECTIONS[sectionId] then
        return
    end

    SECTIONS[sectionId].isDeleted = true

    SendNUIMessage({
        type = "deleteSection",
        sectionId = sectionId
    })
end

function u5_ui.restoreSection(sectionId)
    sectionId = tostring(sectionId)

    if not SECTIONS[sectionId] then
        return
    end

    SECTIONS[sectionId].isDeleted = false

    SendNUIMessage({
        type = "restoreSection",
        sectionId = sectionId
    })
end

--+--+--+--+--+--+ COMPONENT +--+--+--+--+--+--+

function u5_ui.addComponent(sectionId, componentType, props, style, innerHTML, onClick, onInput)
    sectionId = tostring(sectionId)
    local onClickId = nil

    if onClick then
        onClickId = #ON_CLICK_FUNCTIONS + 1
        ON_CLICK_FUNCTIONS[onClickId] = onClick
    end

    local onInputId = nil

    if onInput then
        onInputId = #ON_INPUT_FUNCTIONS + 1
        ON_INPUT_FUNCTIONS[onInputId] = onInput
    end

    local component = {
        componentType = componentType,
        props = props,
        style = style,
        innerHTML = innerHTML,
        onClickId = onClickId,
        onInputId = onInputId,
        isDeleted = false
    }

    local componentId = sendToUIandGetReturnValue({
        type = "addComponent",
        sectionId = sectionId,
        component = component,
    })

    componentId = tostring(componentId)

    local componentsTable = SECTIONS[sectionId].components
    componentsTable[componentId] = component

    return componentId
end

function u5_ui.getComponent(sectionId, componentId, includeHTML)
    sectionId = tostring(sectionId)
    componentId = tostring(componentId)

    if not SECTIONS[sectionId] then
        return nil
    end

    if not SECTIONS[sectionId].components[componentId] then
        return nil
    end

    local component = SECTIONS[sectionId].components[componentId]

    if not includeHTML then
        return component
    end

    local elementHTML = sendToUIandGetReturnValue({
        type = "getComponentElementHTML",
        sectionId = sectionId,
        componentId = componentId
    })

    return {
        component = component,
        html = elementHTML
    }
end

function u5_ui.updateComponent(sectionId, componentId, component)
    sectionId = tostring(sectionId)
    componentId = tostring(componentId)

    if not SECTIONS[sectionId] then
        return
    end

    if not SECTIONS[sectionId].components[componentId] then
        return
    end

    SECTIONS[sectionId].components[componentId].props = newProps

    SendNUIMessage({
        type = "updateComponent",
        sectionId = sectionId,
        componentId = componentId,
        component = component
    })
end


function u5_ui.deleteComponent(sectionId, componentId)
    sectionId = tostring(sectionId)
    componentId = tostring(componentId)

    if not SECTIONS[sectionId] then
        return
    end

    if not SECTIONS[sectionId].components[componentId] then
        return
    end

    SECTIONS[sectionId].components[componentId].isDeleted = true

    SendNUIMessage({
        type = "deleteComponent",
        sectionId = sectionId,
        componentId = componentId
    })
end

function u5_ui.restoreComponent(sectionId, componentId)
    sectionId = tostring(sectionId)
    componentId = tostring(componentId)

    if not SECTIONS[sectionId] then
        return
    end

    if not SECTIONS[sectionId].components[componentId] then
        return
    end

    SECTIONS[sectionId].components[componentId].isDeleted = false

    SendNUIMessage({
        type = "restoreComponent",
        sectionId = sectionId,
        componentId = componentId
    })
end

function u5_ui.getElementsHTML(identifier)
    local elements = sendToUIandGetReturnValue({
        type = "getElementsHTML",
        identifier = identifier
    })
    
    return elements
end

--+--+--+--+--+--+ CALLBACKS +--+--+--+--+--+--+

RegisterNUICallback("clickTriggered", function(data, cb)
    local onClickFunctionId = data.onClickFunctionId

    local ids = {
        sectionId = tostring(data.sectionId),
        componentId = tostring(data.componentId)
    }

    ON_CLICK_FUNCTIONS[onClickFunctionId](data, ids)
    
    cb("ok")
end)

RegisterNUICallback("inputTriggered", function(data, cb)
    local onInputFunctionId = data.onInputFunctionId
    local value = data.value

    local ids = {
        sectionId = tostring(data.sectionId),
        componentId = tostring(data.componentId)
    }

    ON_INPUT_FUNCTIONS[onInputFunctionId](value, ids)
    
    cb("ok")
end)

RegisterNUICallback("visibilityChanged", function(data, cb)
    local onVisibilityChangeFunctionId = data.onVisibilityChangeFunctionId
    local isVisible = data.isVisible
    local sectionId = tostring(data.sectionId)

    ON_VISIBILITY_CHANGE_FUNCTIONS[onVisibilityChangeFunctionId](isVisible, sectionId)
    
    cb("ok")
end)

RegisterNUICallback("exit", function(data, cb)
    SetNuiFocus(false, false)
    
    cb("ok")
end)

--+--+--+--+--+--+ EXPORTS +--+--+--+--+--+--+

exports("getObject", function()
    return u5_ui
end)

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
  


--+--+--+--+--+--+ CONTROLS +--+--+--+--+--+--+

RegisterCommand("showui", function()
    SetNuiFocus(true, true)
end, false)

RegisterKeyMapping("showui", config.keybindMessage, "keyboard", config.toggleKey)


-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(0)
--         if IsControlJustPressed(0, config.openKey) then
--             SetNuiFocus(true, true)
--         end
--     end
-- end)