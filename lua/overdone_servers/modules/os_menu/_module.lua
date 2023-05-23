local MODULE = {}

MODULE.DisplayName = "OS: Menu"

MODULE.Hidden = true --If set to true, it wont show in the menu

MODULE.DataToLoad = {
    Server = {},
    Shared = {},
    Client = {
        "materials.lua",
        "menu.lua",
        "debug_menu.lua"
    },
    Fonts = {
        {"MenuTitle", "sansation-light.ttf",
            {
                font = "Sansation Light",
                size = 15,
                weight = 1
            }
        }
    }
}

function MODULE:Start()
    print("OS Menu Module Started. Hello there!")
end

return MODULE