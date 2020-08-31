local MODULE = {}

MODULE.DisplayName = "OS: Menu"
MODULE.FolderName = "os_menu"

OverdoneServers.OS_MENU = OverdoneServers.OS_MENU or {}
MODULE.PublicVar = OverdoneServers.OS_MENU
OverdoneServers.OS_MENU.Module = MODULE

MODULE.Hidden = true --If set to true, it wont show in the menu

MODULE.DataToLoad = {
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