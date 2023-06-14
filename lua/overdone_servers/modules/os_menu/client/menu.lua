local module = OverdoneServers:GetModule("os_menu")
local OSMenu = module.Data

local DPanels2D = OverdoneServers:GetLibrary("2dvgui_extended")

local transparent = 200 -- 0-255

if (OSMenu.Menu) then
    OSMenu.Menu:Remove()
end

local function CreateCategoryTab(parent, module, category)
    local tab = vgui.Create("DButton", parent)
    tab:SetText("")
    tab.showCategories = false

    function tab:Paint(w,h)
        draw.RoundedBox(0,0,0,w,h, Color(36,36,36,transparent))
        draw.SimpleText(module.DisplayName, "DermaDefault", w/2, h/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        if (self:IsHovered()) then
            draw.RoundedBox(0,0,0,w,h, Color(66,165,174,15))
        end

        if (not self.showCategories) then
            -- draw an arrow to the right side of the tab
            local arrowSize = h * 0.5
            local arrowX = w - arrowSize * 1.5
            local arrowY = h/2 - arrowSize/2
            local arrowColor = Color(255,255,255,255)
            draw.RoundedBox(0,arrowX,arrowY,arrowSize,arrowSize, arrowColor)
            draw.RoundedBox(0,arrowX + arrowSize/2 - 1,arrowY + arrowSize/4,2,arrowSize/2, arrowColor)
            draw.RoundedBox(0,arrowX + arrowSize/4,arrowY + arrowSize/2 - 1,arrowSize/2,2, arrowColor)

        end
    end

    function tab:DoClick()
        Selected = module
        print("Selected", Selected.DisplayName)
    end

    return tab
end

local function CreateSeparator(parent)
    local sep = vgui.Create("DPanel", parent)
    sep:SetSize(parent:GetWide(), 1)

    function sep:Paint(w,h)
        draw.RoundedBox(0,0,0,w,h, Color(255,255,255,transparent))
    end

    return sep
end

local function BuildMenu()
    local SizeX, SizeY = ScrW() * 0.75, ScrH() * 0.75
    local headerSize = SizeY * 0.1
    local headerSeparatorSize = 3
    local leftPanelSize = SizeX * 0.2

    local panel = vgui.Create("Panel")

    OSMenu.Menu = panel

    panel:SetSize(SizeX, SizeY)
    panel:Center()
    panel:MakePopup()

    function panel:Paint(w,h)
        draw.RoundedBox(ScreenScale(15),0,0,w,h, Color(30,30,30,transparent))
        draw.SimpleText("Overdone Servers", module:Font("MenuTitle"), 40, headerSize/2, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.RoundedBox(0,0,headerSize,w,headerSeparatorSize,Color(255,255,255,transparent))
    end

    local closeButton = DPanels2D:CloseButton(panel) -- TODO: Make visible. Possibly a library bug?
    closeButton:SetSize(SizeY * 0.07)
    closeButton:SetScale(0.9)
    closeButton:SetPos(SizeX * 0.95 - closeButton:GetWide() * 0.5, SizeY * 0.05 - closeButton:GetTall() * 0.5)
    panel:Add(closeButton)

    local modules = {}

    for _, module in pairs(OverdoneServers.Modules) do
        if not module.Hidden then
            table.insert(modules, module)
        end
    end

    local moduleScrollPanel = vgui.Create("DScrollPanel", panel)
    moduleScrollPanel:Dock(LEFT)
    moduleScrollPanel:SetWide(leftPanelSize)
    moduleScrollPanel:DockMargin(0,headerSize + headerSeparatorSize,0,0)

    local moduleLayoutPanel = vgui.Create("DListLayout", moduleScrollPanel)

    local Selected = nil -- Format is module, or module.Settings.Category, or module.Settings.Category.SubCategory

    for i = 1, 8 do -- TODO: REMOVE THIS
        for _, module in ipairs(modules) do
            local tab = CreateCategoryTab(moduleLayoutPanel, module)
            tab:SetSize(moduleScrollPanel:GetWide(), SizeY * 0.06)
            moduleScrollPanel:AddItem(tab)
            moduleScrollPanel:AddItem(CreateSeparator(moduleLayoutPanel))
        end
    end
end

concommand.Add("os_menu", BuildMenu)
concommand.Add("os_closemenu", function()
    if (OSMenu.Menu) then
        OSMenu.Menu:Remove()
    end
end)


-- print("Loading menu at " .. CurTime())
-- BuildMenu()