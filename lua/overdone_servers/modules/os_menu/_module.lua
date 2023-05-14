local MODULE = {}

MODULE.DisplayName = "OS: Menu"
MODULE.FolderName = "os_menu"

MODULE.LoadLast = true

OverdoneServers.Menu = OverdoneServers.Menu or {}
MODULE.PublicVar = OverdoneServers.Menu
OverdoneServers.Menu.Module = MODULE

MODULE.Hidden = true --If set to true, it wont show in the menu

MODULE.DataToLoad = {
    Server = {

    },
    Shared = {},
    Client = {
        "menu.lua",
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
    print("Sup")
end

OverdoneServers:AddModule(MODULE)