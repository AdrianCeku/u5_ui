RegisterNetEvent("u5_ui:client:addSection")
AddEventHandler("u5_ui:client:addSection", function(options, style, wrapperStyle, innerHTML, isOpen, onVisibilityChange)
    local sectionId = u5_ui.addSection(options, style, wrapperStyle, innerHTML, isOpen, onVisibilityChange)
end)


RegisterNetEvent("u5_ui:client:updateSection")
AddEventHandler("u5_ui:client:updateSection", function(sectionId, options, style, wrapperStyle, innerHTML, isOpen, onVisibilityChange)
    u5_ui.updateSection(sectionId, options, style, wrapperStyle, innerHTML, isOpen, onVisibilityChange)
end)

RegisterNetEvent("u5_ui:client:openSection")
AddEventHandler("u5_ui:client:openSection", function(sectionId)
    u5_ui.openSection(sectionId)
end)

RegisterNetEvent("u5_ui:client:closeSection")
AddEventHandler("u5_ui:client:closeSection", function(sectionId)
    u5_ui.closeSection(sectionId)
end)

RegisterNetEvent("u5_ui:client:bindSectionToCoords")
AddEventHandler("u5_ui:client:bindSectionToCoords", function(sectionId, coords)
    u5_ui.bindSectionToCoords(sectionId, coords)
end)

RegisterNetEvent("u5_ui:client:deleteSection")	
AddEventHandler("u5_ui:client:deleteSection", function(sectionId)
    u5_ui.deleteSection(sectionId)
end)

RegisterNetEvent("u5_ui:client:restoreSection")
AddEventHandler("u5_ui:client:restoreSection", function(sectionId)
    u5_ui.restoreSection(sectionId)
end)

RegisterNetEvent("u5_ui:client:addComponent")
AddEventHandler("u5_ui:client:addComponent", function(sectionId, componentType, props, style, innerHTML, onClick, onInput)
    u5_ui.addComponent(sectionId, componentType, props, style, innerHTML, onClick, onInput)
end)

RegisterNetEvent("u5_ui:client:updateComponent")
AddEventHandler("u5_ui:client:updateComponent", function(sectionId, componentId, component)
    u5_ui.updateComponent(sectionId, componentId, component)
end)

RegisterNetEvent("u5_ui:client:deleteComponent")
AddEventHandler("u5_ui:client:deleteComponent", function(sectionId, componentId)
    u5_ui.deleteComponent(sectionId, componentId)
end)

RegisterNetEvent("u5_ui:client:restoreComponent")
AddEventHandler("u5_ui:client:restoreComponent", function(sectionId, componentId)
    u5_ui.restoreComponent(sectionId, componentId)
end)