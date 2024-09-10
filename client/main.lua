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
            u5_ui.addSection(
            {
                {
                    type = "Button",
                    props = {
                        text = "Shad",
                    }
                },
                {
                    type = "TestButton",
                    props = {
                        text = "Test",
                    },
                }
            }, 
            {
                title = "Hello World",
                description = "This is a test"
            })
            SetNuiFocus(true, true)
            Wait(5000)
            SetNuiFocus(false, false)
        end
    end
end)