--+--+--+--+--+--+ IDS +--+--+--+--+--+--+

local ON_VISIBILITY_CHANGE_FUNCTIONS = {}
local ON_VISIBILITY_CHANGE_FUNCTIONS_ID = 0


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

    local sectionId = triggerUICallback({
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

    local elementHTML = triggerUICallback({
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

function u5_ui.bindSectionToCoords(sectionId, coords, marker)
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