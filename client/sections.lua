local utils = exports["u5_utils"]
--+--+--+--+--+--+ IDS +--+--+--+--+--+--+

local ON_VISIBILITY_CHANGE_FUNCTIONS = {}
local ON_VISIBILITY_CHANGE_FUNCTIONS_ID = 0

function getOnVisibilityChangeFunctionId()
    local id = ON_VISIBILITY_CHANGE_FUNCTIONS_ID
    ON_VISIBILITY_CHANGE_FUNCTIONS_ID = ON_VISIBILITY_CHANGE_FUNCTIONS_ID + 1
    
    return tostring(id)
end

--+--+--+--+--+--+ SECTION +--+--+--+--+--+--+

function addSection(options, style, wrapperStyle, innerHTML, isOpen, onVisibilityChange)
    local onVisibilityChangeId = nil

    if onVisibilityChange then
        onVisibilityChangeId = getOnVisibilityChangeFunctionId()
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

    local sectionId = triggerNuiCallback({
        type = "addSection",
        section = section
    })

    sectionId = tostring(sectionId)
    
    SECTIONS[sectionId] = section

    return sectionId
end

function getSection(sectionId, includeHTML)
    sectionId = tostring(sectionId)

    if not SECTIONS[sectionId] then
        return nil
    end

    local section = SECTIONS[sectionId]

    if not includeHTML then
        return section
    end

    local elementHTML = triggerNuiCallback({
        type = "getSectionElement",
        sectionId = sectionId
    })

    return {
        section = section,
        html = elementHTML
    }
end

function updateSection(sectionId, section)
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

function openSection(sectionId)
    sectionId = tostring(sectionId)

    if not SECTIONS[sectionId] then
        return
    end

    SendNUIMessage({
        type = "openSection",
        sectionId = sectionId
    })
end

function closeSection(sectionId)
    sectionId = tostring(sectionId)

    if not SECTIONS[sectionId] then
        return
    end

    SendNUIMessage({
        type = "closeSection",
        sectionId = sectionId
    })
end

function deleteSection(sectionId)
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

function restoreSection(sectionId)
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

function bindSectionToCoords(sectionId, coords, marker)
    sectionId = tostring(sectionId)

    local range = 2
    local marker = {
        range = 20,
    }

    local onEnter = function()
        openSection(sectionId)
    end

    local onExit = function()
        closeSection(sectionId)
    end

    utils:addInteractPoint(
        coords,
        range,
        marker,
        onEnter,
        onExit
    ) 
end

--+--+--+--+--+--+ CALLBACKS +--+--+--+--+--+--+

RegisterNUICallback("visibilityChanged", function(data, cb)
    local onVisibilityChangeFunctionId = data.onVisibilityChangeFunctionId
    local isVisible = data.isVisible
    local sectionId = tostring(data.sectionId)

    ON_VISIBILITY_CHANGE_FUNCTIONS[onVisibilityChangeFunctionId](isVisible, sectionId)
    
    cb("ඞ")
end)

RegisterNUICallback("exit", function(data, cb)
    SetNuiFocus(false, false)
    
    cb("ඞ")
end)

--+--+--+--+--+--+ EVENTS +--+--+--+--+--+--+

RegisterNetEvent("u5_ui:client:addSection", addSection)
RegisterNetEvent("u5_ui:client:getSection", getSection)
RegisterNetEvent("u5_ui:client:updateSection", updateSection)
RegisterNetEvent("u5_ui:client:openSection", openSection)
RegisterNetEvent("u5_ui:client:closeSection", closeSection)
RegisterNetEvent("u5_ui:client:deleteSection", deleteSection)
RegisterNetEvent("u5_ui:client:restoreSection", restoreSection)
RegisterNetEvent("u5_ui:client:bindSectionToCoords", bindSectionToCoords)

--+--+--+--+--+--+ EXPORTS +--+--+--+--+--+--+

exports("addSection", addSection)
exports("getSection", getSection)
exports("updateSection", updateSection)
exports("openSection", openSection)
exports("closeSection", closeSection)
exports("deleteSection", deleteSection)
exports("restoreSection", restoreSection)
exports("bindSectionToCoords", bindSectionToCoords)