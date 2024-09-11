u5_ui = {}

local WAITING_FOR_SECTION_ID = false
local SECTION_ID = nil

local WAITING_FOR_COMPONENT_ID = false
local COMPONENT_ID = nil

local onClickFunctions = {}

function u5_ui.addSection(components, options)
    WAITING_FOR_SECTION_ID = true
    SendNUIMessage({
                    type = "addSection",
                    section = {
                        components = components,
                        options = options
                    }
                })
                
    while WAITING_FOR_SECTION_ID do
        Citizen.Wait(10)
    end

    local retVal = SECTION_ID
    SECTION_ID = nil
    
    return retVal
end

function u5_ui.addComponentToSection(sectionId, componentType, props, onClick)
    local onClickId = #onClickFunctions + 1
    onClickFunctions[onClickId] = onClick

    local component = {
        type = componentType,
        props = props,
        onClickId = onClickId
    }

    WAITING_FOR_COMPONENT_ID = true
    SendNuiMessage({
        type = "addComponentToSection",
        sectionId = sectionId,
        component = component
    })

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

exports("getObject", function()
    return u5_ui
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(0, 38) then
            local components = {
                {
                    type = "Button",
                    props = {
                        text = "Shad",
                    }
                },
                {
                    type = "Accordion",
                    props = {
                        headline = "Accordion",
                        content = "This is an accordion"
                    }
                },
            }

            local options = {
                title = "Hello World",
                description = "This is a test"
            }

            local section = u5_ui.addSection(components, options)
            SetNuiFocus(true, true)
            Wait(5000)
            SetNuiFocus(false, false)
        end
    end
end)