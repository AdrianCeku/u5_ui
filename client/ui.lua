local utils = exports["u5_utils"].getObject()

u5_ui = {}

local SECTIONS = {}

local onClickFunctions = {}
local onInputFunctions = {}


function u5_ui.addSection(options, style, innerHTML, isOpen, onOpen, onClose)
    local onOpenId = nil

    if onOpen then
        onOpenId = #onClickFunctions + 1
        onClickFunctions[onOpenId] = onOpen
    end

    local onCloseId = nil

    if onClose then
        onCloseId = #onClickFunctions + 1
        onClickFunctions[onCloseId] = onClose
    end

    local section = {
        options = options,
        style = style,
        innerHTML = innerHTML,
        onOpenId = onOpenId,
        onCloseId = onCloseId,
        isOpen = isOpen,
    }

    local sectionId = sendToUI({
        type = "addSection",
        section = section
    })

    sectionId = tostring(sectionId)
    
    SECTIONS[sectionId] = {
        options = options,
        style = style,
        innerHTML = innerHTML,
        onClose = onClose,
        isDeleted = false,
        components = {}
    }

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

    local elementHTML = sendToUI({
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
    print("Opening section", sectionId)
    print(SECTIONS[sectionId])
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
    print("Closing section", sectionId)
    print(SECTIONS[sectionId])
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
    print("Deleting section", sectionId)
    if not SECTIONS[sectionId] then
        return
    end

    SECTIONS[sectionId].isDeleted = true
    print("Sending message")
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

function u5_ui.addComponent(sectionId, componentType, props, style, innerHTML, onClick, onInput)
    sectionId = tostring(sectionId)
    local onClickId = nil

    if onClick then
        onClickId = #onClickFunctions + 1
        onClickFunctions[onClickId] = onClick
    end

    local onInputId = nil

    if onInput then
        onInputId = #onInputFunctions + 1
        onInputFunctions[onInputId] = onInput
    end

    local component = {
        componentType = componentType,
        props = props,
        onClickId = onClickId,
        onInputId = onInputId,
        innerHTML = innerHTML,
        style = style,
        isDeleted = false
    }

    local componentId = sendToUI({
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
    print(json.encode(SECTIONS))
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

    local elementHTML = sendToUI({
        type = "getComponentElement",
        sectionId = sectionId,
        componentId = componentId
    })

    return {
        component = component,
        html = elementHTML
    }
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

function u5_ui.getElementsHTML(identifier)
    local elements = sendToUI({
        type = "getElement",
        identifier = identifier
    })
    
    return elements
end

RegisterNUICallback('clickTriggered', function(data, cb)
    local obj = {
        sectionId = data.sectionId,
        componentId = data.componentId
    }

    onClickFunctions[data.id](data.passThrough, obj)
    
    cb('ok')
end)

RegisterNUICallback('changeTriggered', function(data, cb)
    local obj = {
        sectionId = data.sectionId,
        componentId = data.componentId
    }

    onInputFunctions[data.id](data.value, obj)
    
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
        if IsControlJustPressed(0, 19) then
            SetNuiFocus(true, true)
        end
    end
end)