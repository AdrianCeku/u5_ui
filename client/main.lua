u5_ui = {}

function u5_ui.addSection(components, options)
    SendNUIMessage({
                    type = "addSection",
                    section = {
                        components = components,
                        options = options
                    }
                })
end

exports("get", function()
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

            u5_ui.addSection(components, options)
            SetNuiFocus(true, true)
            Wait(5000)
            SetNuiFocus(false, false)
        end
    end
end)