local public = OverdoneServers.OS_MENU
local module = public.Module

if IsValid(public.Menu) then public.Menu:Remove() end

local panel = vgui.Create("Panel")
public.Menu = panel
panel.SizeX, panel.SizeY = ScrW()*0.75, ScrH()*0.75

panel:SetSize(panel.SizeX, panel.SizeY)
panel:Center()
panel:MakePopup()
function panel:Paint(w,h)
    draw.RoundedBox(ScreenScale(15),0,0,w,h, Color(30,30,30,200))
end
local closeButton = OverdoneServers.DPanels2D:CloseButton(panel)
closeButton:SetSize(panel.SizeY*0.07, panel.SizeY*0.07)
closeButton:SetPos(panel.SizeY*0.9, panel.SizeY*0.9)
panel:Add(closeButton)