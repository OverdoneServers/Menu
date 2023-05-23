local module = OverdoneServers:GetModule("os_menu")
local OSMenu = module.Data
local Materials = OSMenu.Materials or {}

local svgToLoad = {
    ["Chevron"] = [[
        <svg width="27" height="16" viewBox="0 0 27 16" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect x="26.1472" y="3.02209" width="18.3535" height="4.24858" rx="2.12429" transform="rotate(135 26.1472 3.02209)" fill="white"/>
            <rect x="12.9779" y="15.9821" width="18.3535" height="4.24858" rx="2.12429" transform="rotate(-135 12.9779 15.9821)" fill="white"/>
        </svg>
    ]],
}

local function CacheMats()
    for name,data in pairs(svgToLoad) do
        OverdoneServers.SVG:GetMaterial(data, function(material)
            Materials[name] = material
        end)
    end
end

if game.SinglePlayer() then
    timer.Simple(30, CacheMats)
else
    -- hook.Add("DrawOverlay", "OverdoneServers:TexasHoldem:PreCache:Materials", function()
	-- 	CacheMats()
    --     hook.Remove("DrawOverlay", "OverdoneServers:TexasHoldem:PreCache:Materials")
    -- end)


    -- module:AddHook("DrawOverlay", "PreCache:Materials", function()
    --     CacheMats()
    -- end)

end