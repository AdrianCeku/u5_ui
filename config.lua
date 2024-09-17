config = {}

config.inputMapper = "MOUSE_BUTTON" -- can be KEYBOARD or MOUSE_BUTTON. If you want to use another mapper, you have to edit client/functions.lua/getJSKey()
                                    --https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/mouse_button/

config.toggleKey = "MOUSE_MIDDLE"   -- https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/mouse_button/
                                    -- https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/
                                    -- May not work with all keys. You can have a look at client/functions.lua/getJSKey() for the lookup table and add your own if needed
                                    -- Depending on what you change, you also have to edit ui/src/App.vue/addExitListener() and rebuild using "npm run build" in the root of the ui folder (you need to have node and npm installed)

config.keybindMessage = "UI: Toggle Focus"   -- This is the message that will be displayed in the control settings