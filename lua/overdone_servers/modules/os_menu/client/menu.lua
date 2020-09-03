local public = OverdoneServers.OS_MENU
local module = public.Module

if IsValid(public.Menu) then public.Menu:Remove() end

local SizeX, SizeY = ScrW()*0.75, ScrH()*0.75

function public:BuildMenu()
    local panel = vgui.Create("Panel")
    public.Menu = panel

    panel:MakePopup()
    panel:SetSize(SizeX, SizeY)
    panel:Center()

    function panel:Paint(w,h)
        draw.RoundedBox(ScreenScale(15),0,0,w,h, Color(30,30,30,200))
        draw.SimpleText("Overdone Servers", module:Font("MenuTitle"), w/2, h*0.05, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.RoundedBox(0,0,h*0.096,w,h*0.005, Color(255,255,255,200))
        self:FormatRows(w,h)
    end

    local closeButton = OverdoneServers.DPanels2D:CloseButton(panel)
    closeButton:SetSize(SizeY*0.07)
    closeButton:SetScale(0.9)
    panel:Add(closeButton)

    local Selected = {}

    local Rows = {panel:Add(self:TiledPanels())}
    
    
    for _,module in pairs(OverdoneServers.Modules) do
        if not module.Hidden then
            table.insert(Rows[1].Columns, Rows[1]:Add(self:ModuleTile(module)))
        end
    end

    function panel:FormatRows(w,h) //Called on Paint
        for i,row in ipairs(Rows) do
            row:SetPos(0, SizeY*0.1)
            row:SetSize(SizeX, SizeY*0.12)
        end
    end
end

function public:TiledPanels()
    local panel = vgui.Create("Panel")

    panel.Columns = {}

    function panel:Paint(w,h)
        draw.RoundedBox(0,0,0,w,h, Color(36,36,36,200))
        draw.RoundedBox(0,w/2-5,0,10,h, Color(255,36,36,200))
        self:FormatColumns(w,h)
    end

    function panel:FormatColumns(w,h) //Called on Paint
        local colAmount = #panel.Columns
        for i,p in ipairs(panel.Columns) do //TODO: or any other sorted function
            --p:SetPos(SizeX*0.11*i, 0)
            
            local xpos = -0
            if (colAmount % 2 == 0) then //even
                xpos = SizeX/2 + SizeX*0.11*(colAmount - (1 + 2*(i - 1)))/2 //FIX: idk how to do this correctly :/
            else //odd
                xpos = SizeX/2 + SizeX*0.11*((colAmount + 1)/2 - i) //FIX: idk how to do this correctly :/
            end
            p:SetPos(xpos, 0)
            p:SetSize(SizeX*0.1, SizeY*0.12)
        end
    end

    return panel
end

function public:ModuleTile(module)
    local DisplayName = module.DisplayName or module.FolderName or "Invalid Module Name"

    local panel = vgui.Create("Panel")

    function panel:Paint(w,h)
        draw.RoundedBox(0,0,0,w,h, Color(100,100,100,200))
        
        draw.SimpleText(DisplayName, "DermaDefault", w/2, h/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    return panel
end

public:BuildMenu()