local MODULE = {}

MODULE.DisplayName = "OS: Menu"
MODULE.FolderName = "os_menu"

OverdoneServers.OS_MENU = {}

MODULE.PublicVar = OverdoneServers.OS_MENU
MODULE.Hidden = true --If set to true, it wont show in the menu

MODULE.FilesToLoad = {
    Server = {
        
    },
    Shared = {},
    Client = {
        "menu.lua",
    },
    SendToClient = {},
    MaterialDir = {},
}

function MODULE:Start()
    print("Sup")
end

OverdoneServers:AddModule(MODULE)