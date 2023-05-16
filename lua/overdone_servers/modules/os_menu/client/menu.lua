local module = OverdoneServers.Modules.os_menu
local OSMenu = module.Data

local function CreateModuleTab(module)
    local tab = vgui.Create("DButton", modulePanel)
    tab:SetText("")

    function tab:Paint(w,h)
        draw.RoundedBox(0,0,0,w,h, Color(36,36,36,200))
        draw.SimpleText(module.DisplayName, "DermaDefault", w/2, h/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    function tab:DoClick()
        Selected = module
        print("Selected", Selected.DisplayName)
    end

    return tab
end

local function BuildMenu()
    local SizeX, SizeY = ScrW() * 0.75, ScrH() * 0.75

    local panel = vgui.Create("Panel")

    panel:MakePopup()
    panel:SetSize(SizeX, SizeY)
    panel:Center()

    function panel:Paint(w,h)
        draw.RoundedBox(ScreenScale(15),0,0,w,h, Color(30,30,30,200))
        draw.SimpleText("Overdone Servers", module:Font("MenuTitle"), 40, h * 0.05, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.RoundedBox(0,0,h * 0.096, w, h * 0.005, Color(255,255,255,200))
    end

    local closeButton = OverdoneServers.DPanels2D:CloseButton(panel)
    closeButton:SetSize(SizeY * 0.07)
    closeButton:SetScale(0.9)
    closeButton:SetPos(SizeX * 0.95 - closeButton:GetWide() * 0.5, SizeY * 0.05 - closeButton:GetTall() * 0.5)
    panel:Add(closeButton)

    local modules = {}

    for _,module in pairs(OverdoneServers.Modules) do
        if not module.Hidden then
            table.insert(modules, module)
        end
    end

    local modulePanel = vgui.Create("DScrollPanel", panel)
    modulePanel:SetSize(SizeX * 0.2, 300)
    modulePanel:SetPos(100, SizeY * 0.5) -- TODO: make this correct position

    local Selected = nil -- Format is module, or module.Settings.Category, or module.Settings.Category.SubCategory

    for i,module in ipairs(modules) do -- TODO: or any other sorted function
        local tab = CreateModuleTab(module)
        -- tab:SetSize(SizeX * 0.1, SizeY * 0.1)
        -- tab:SetPos(0, SizeY * 0.1 * (i-1))

        modulePanel:AddItem(tab)
    end
end

concommand.Add("os_menu", BuildMenu)