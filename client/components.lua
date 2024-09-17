--+--+--+--+--+--+ IDS +--+--+--+--+--+--+

local ON_CLICK_FUNCTIONS = {}
local ON_CLICK_FUNCTIONS_ID = 0

local ON_INPUT_FUNCTIONS = {}
local ON_INPUT_FUNCTIONS_ID = 0

local function getOnClickFunctionId()
    local id = ON_CLICK_FUNCTIONS_ID
    ON_CLICK_FUNCTIONS_ID = ON_CLICK_FUNCTIONS_ID + 1
    
    return tostring(id)
end

local function getOnInputFunctionId()
    local id = ON_INPUT_FUNCTIONS_ID
    ON_INPUT_FUNCTIONS_ID = ON_INPUT_FUNCTIONS_ID + 1
    
    return tostring(id)
end

--+--+--+--+--+--+ COMPONENT +--+--+--+--+--+--+

function u5_ui.addComponent(sectionId, componentType, props, style, innerHTML, onClick, onInput)
    sectionId = tostring(sectionId)
    local onClickId = nil

    if onClick then
        onClickId = getOnClickFunctionId()
        ON_CLICK_FUNCTIONS[onClickId] = onClick
    end

    local onInputId = nil

    if onInput then
        onInputId = getOnInputFunctionId()
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

    local componentId = triggerNuiCallback({
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

    local elementHTML = triggerNuiCallback({
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
    local elements = triggerNuiCallback({
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
    
    cb("ඞ")
end)

RegisterNUICallback("inputTriggered", function(data, cb)
    local onInputFunctionId = data.onInputFunctionId
    local value = data.value

    local ids = {
        sectionId = tostring(data.sectionId),
        componentId = tostring(data.componentId)
    }

    ON_INPUT_FUNCTIONS[onInputFunctionId](value, ids)
    
    cb("ඞ")
end)