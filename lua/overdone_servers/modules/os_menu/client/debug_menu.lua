local module = OverdoneServers:GetModule("os_menu")
local OSMenu = module.Data

local function CreateDebugEntryPanel(debugName, debugEntry, infoPaneText, width)
    local entryPanel = vgui.Create("DPanel")
    entryPanel:SetBackgroundColor(Color(0,50,0))
    local header = vgui.Create("DLabel", entryPanel)
    header:SetContentAlignment(5)
    header:Dock(FILL)
    --header:DockMargin(width / 2, 0, 0, 0)
    header:SetText(debugName)
    if isfunction(debugEntry.FuncGet) then
        if not isfunction(debugEntry.FuncDo) then
            print("Set func nil when trying to add debug entry for " .. debugName)
            return nil
        end
        local var = debugEntry.FuncGet()
        if istable(debugEntry.Options) then
            local options = debugEntry.Options
            if table.IsEmpty(options) then
                print("Empty table when trying to add debug options entry for " .. debugName)
                return nil
            elseif table.Count(options) == 1 then
                print("Only 1 option when trying to add debug options entry for " .. debugName)
                return nil
            elseif not isnumber(var) then
                print("Var selected is not a number when trying to add debug options entry for " .. debugName)
                return nil
            else
                local optionsPanel = vgui.Create("DComboBox", entryPanel)
                optionsPanel:Dock(BOTTOM)
                for i = 1, table.Count(options) do
                    optionsPanel:AddChoice(options[i])
                end
                optionsPanel:ChooseOption(options[var], var)
                function optionsPanel:OnSelect(i)
                    debugEntry.FuncDo(i)
                    infoPaneText:AppendText(
                        "Set option for " ..
                            debugName ..
                            " to " ..
                            options[i] ..
                            " = " ..
                            i .. "\n"
                    )
                end
            end
        elseif (isbool(var)) then
            local checkbox = entryPanel:Add("DCheckBox")
            checkbox:SetValue(var)
            -- checkbox:Dock(RIGHT)
            --checkbox:SetSize(20,20)
            --checkbox:SetContentAlignment(5)
            --checkbox:SetPos(3 * width )
            -- checkbox:DockMargin(width / 5, width / 3, width / 5, width / 3)
            function checkbox:OnChange(newVal)
                debugEntry.FuncDo(newVal)
                infoPaneText:AppendText(
                    "Set boolean for " ..
                        debugName ..
                        " to " ..
                        tostring(newVal) .. "\n"
                )
            end
        elseif (isstring(var) or isnumber(var)) then
            local textEntry = vgui.Create("DTextEntry", entryPanel)
            textEntry:Dock(BOTTOM)
            if (isnumber(var)) then textEntry:SetNumeric(true) end
            textEntry:SetText(var)
            function textEntry:OnEnter(newVal)
                local infoText = ""
                if isstring(var) then
                    debugEntry.FuncDo(newVal)
                    infoText = "Set string for " .. debugName .. " to " .. newVal .. "\n"
                elseif isnumber(tonumber(newVal)) then
                    debugEntry.FuncDo(tonumber(newVal))
                    infoText = "Set number for " .. debugName .. " to " .. newVal .. "\n"
                else
                    local currentVal = debugEntry.FuncGet()
                    infoText = "Invalid number \"" .. newVal .. "\" -- changing back to " .. currentVal .. "\n"
                    textEntry:SetText(currentVal)
                end
                infoPaneText:AppendText(infoText)
            end
        elseif (IsColor(var)) then
            local bottomPanel = vgui.Create("DPanel", entryPanel)
            bottomPanel:Dock(BOTTOM)
            local middlePanel = vgui.Create("DPanel", entryPanel)
            middlePanel:Dock(BOTTOM)
            local red = vgui.Create("DTextEntry", middlePanel)
            red:Dock(LEFT)
            --red:DockMargin(1,3,1,3)
            red:SetSize(width / 4, width / 3)
            red:SetTextColor(Color(255,0,0))
            red:SetText(var.r)
            red:SetNumeric(true)
            local green = vgui.Create("DTextEntry", middlePanel)
            green:SetSize(width / 4, width / 3)
            green:Dock(LEFT)
            --green:DockMargin(1,3,1,3)
            green:SetTextColor(Color(0,255,0))
            green:SetText(var.g)
            green:SetNumeric(true)
            local blue = vgui.Create("DTextEntry", middlePanel)
            blue:SetSize(width / 4, width / 3)
            blue:Dock(LEFT)
            --blue:DockMargin(1,3,1,3)
            blue:SetTextColor(Color(0,0,255))
            blue:SetText(var.b)
            blue:SetNumeric(true)
            local alpha = vgui.Create("DTextEntry", middlePanel)
            alpha:SetSize(width / 4, width / 3)
            alpha:Dock(LEFT)
            --alpha:DockMargin(1,3,1,3)
            alpha:SetTextColor(Color(100,100,100))
            alpha:SetText(var.a)
            alpha:SetNumeric(true)
            local black = vgui.Create("DPanel", bottomPanel)
            black:SetSize(width / 3)
            black:Dock(LEFT)
            black:SetBackgroundColor(Color(0,0,0))
            local gray = vgui.Create("DPanel", bottomPanel)
            gray:SetSize(width / 3)
            gray:Dock(LEFT)
            gray:SetBackgroundColor(Color(128,128,128))
            local white = vgui.Create("DPanel", bottomPanel)
            white:SetSize(width / 3)
            white:Dock(LEFT)
            white:SetBackgroundColor(Color(255,255,255))
            local currentColor = vgui.Create("DPanel", bottomPanel)
            currentColor:SetSize(width, width / 3)
            currentColor:SetBackgroundColor(var)
            local testButton = vgui.Create("DButton", entryPanel)
            testButton:Dock(RIGHT)
            testButton:SetText("Test")
            local function validateColor()
                local pass = true
                if not red:GetInt() then
                    red:SetText(debugEntry.FuncGet().r)
                    pass = false
                end
                if not green:GetInt() then
                    green:SetText(debugEntry.FuncGet().g)
                    pass = false
                end
                if not blue:GetInt() then
                    blue:SetText(debugEntry.FuncGet().b)
                    pass = false
                end
                if not alpha:GetInt() then
                    alpha:SetText(debugEntry.FuncGet().a)
                    pass = false
                end
                return pass
            end
            local function getColor()
                return Color(
                    red:GetInt(),
                    green:GetInt(),
                    blue:GetInt(),
                    alpha:GetInt()
                )
            end
            function testButton:DoClick()
                if validateColor() then
                    currentColor:SetBackgroundColor(getColor())
                else
                    infoPaneText:AppendText("Invalid color value(s)!\n")
                end
            end
            local saveButton = vgui.Create("DButton", entryPanel)
            saveButton:Dock(RIGHT)
            saveButton:SetText("Save")
            function saveButton:DoClick()
                if validateColor() then
                    local color = getColor()
                    currentColor:SetBackgroundColor(color)
                    debugEntry.FuncDo(color)
                    infoPaneText:AppendText(
                        "Set color for " ..
                            debugName ..
                            " to " ..
                            tostring(color)
                    )
                else
                    infoPaneText:AppendText("Invalid color value(s)!\n")
                end
            end
        elseif (isvector(var) or isangle(var)) then
            local bottomPanel = vgui.Create("DPanel", entryPanel)
            bottomPanel:Dock(BOTTOM)
            local selectNum1 = vgui.Create("DTextEntry", bottomPanel)
            selectNum1:SetNumeric(true)
            local selectNum2 = vgui.Create("DTextEntry", bottomPanel)
            selectNum2:SetNumeric(true)
            local selectNum3 = vgui.Create("DTextEntry", bottomPanel)
            selectNum3:SetNumeric(true)
            selectNum1:Dock(LEFT)
            selectNum2:Dock(LEFT)
            selectNum3:Dock(LEFT)
            selectNum1:SetValue(var.x)
            selectNum2:SetValue(var.y)
            selectNum3:SetValue(var.z)
            local saveButton = vgui.Create("DButton", bottomPanel)
            saveButton:Dock(LEFT)
            saveButton:SetText("Save")
            function saveButton:DoClick()
                local newVal =
                    isvector(var) and Vector(
                        selectNum1:GetFloat(),
                        selectNum2:GetFloat(),
                        selectNum3:GetFloat()
                    ) or Angle(
                        selectNum1:GetFloat(),
                        selectNum2:GetFloat(),
                        selectNum3:GetFloat()
                    )
                debugEntry.FuncDo(newVal)
                infoPaneText:AppendText(
                    "Set " ..
                        (isvector(var) and "vector " or "angle ") ..
                        "for " ..
                        debugName ..
                        " to " ..
                        tostring(newVal) .. "\n"
                )
            end
        else
            print(
                "Tried to create a debug entry panel but the given value type " ..
                    "is not set up yet! Value type is: " ..
                    type(var) ..
                    " - Debug Name: " ..
                    debugName
            ) -- TODO: pretty print
            return nil
        end
    else
        local button = vgui.Create("DColorButton", entryPanel)
        button:SetColor(Color(100,100,100))
        button:Dock(BOTTOM)
        button:SetSize(width, width / 10)
        button:DockMargin(5,5,5,5)
        button:SetText("Run Function")
        button:SetContentAlignment(5)
        function button:DoClick()
            button:SetColor(Color(0,0,100))
            local result = debugEntry.FuncDo()
            if result == nil then
                button:SetColor(Color(100,100,100))
                infoPaneText:AppendText(
                    "Finished running function for " .. debugName .. "\n"
                )
            elseif istable(result) then
                if table.Count(result) == 0 then
                    button:SetColor(Color(0,150,0))
                    infoPaneText:AppendText(debugName .. " passed all tests" .. "\n")
                else
                    button:SetColor(Color(255,0,0))
                    local failText = debugName .. " failed:"
                    for i = 1, table.Count(result) do
                        failText = failText .. "\n>>" .. result[i]
                    end
                    infoPaneText:AppendText(failText .. "\n")
                end
            end
        end
    end
    return entryPanel
end

local function OpenModuleDebugMenu(mainPanel, infoPaneText, RootModuleTable)
    for _, panel in ipairs(mainPanel:GetChildren()) do
        panel:Remove()
    end
    local column1 = vgui.Create("DScrollPanel", mainPanel)
    column1:SetSize(mainPanel:GetWide() / 3, mainPanel:GetTall())
    column1:SetPaintBackground(true)
    column1:SetBackgroundColor(Color(50, 50, 0))
    local column2 = vgui.Create("DScrollPanel", mainPanel)
    column2:SetSize(mainPanel:GetWide() / 3, mainPanel:GetTall())
    column2:SetPos(column2:GetWide(), 0)
    column2:SetPaintBackground(true)
    column2:SetBackgroundColor(Color(60, 60, 0))
    local column3 = vgui.Create("DScrollPanel", mainPanel)
    column3:SetSize(mainPanel:GetWide() / 3, mainPanel:GetTall())
    column3:SetPos(column2:GetWide() + column3:GetWide(), 0)
    column3:SetPaintBackground(true)
    column3:SetBackgroundColor(Color(70, 70, 0))
    local entryWidth = column1:GetWide()
    local counter = 0
    for name, entry in pairs(RootModuleTable.DebugEntries) do
        local entryPanel = CreateDebugEntryPanel(
            name, entry, infoPaneText, entryWidth
        )
        entryPanel:SetSize(entryWidth, 100)
        if counter % 3 == 0 then
            entryPanel:SetParent(column1)
        elseif counter % 3 == 1 then
            entryPanel:SetParent(column2)
        else
            entryPanel:SetParent(column3)
        end
        entryPanel:Dock(TOP)
        counter = counter + 1
    end
end

local function OpenDebugMenu()

    local menu = vgui.Create("DFrame")
    menu:SetSize(ScrW() / 1.5, ScrH() / 1.5)
    menu:SetTitle("Debug Menu")

    local leftPane = vgui.Create("DScrollPanel", menu)
    leftPane:SetSize(menu:GetWide() / 4, menu:GetTall())
    leftPane:SetPaintBackground(true)
    leftPane:SetBackgroundColor(Color(0, 50, 50))

    local mainPanel = vgui.Create("DPanel", menu)
    mainPanel:SetSize(menu:GetWide() - leftPane:GetWide(), menu:GetTall() - menu:GetTall() / 5)
    mainPanel:SetPos(leftPane:GetWide(), 25)
    mainPanel:SetPaintBackground(true)
    mainPanel:SetBackgroundColor(Color(50, 0, 50))

    local infoPane = vgui.Create("DScrollPanel", menu)
    infoPane:SetSize(menu:GetWide() - leftPane:GetWide(), menu:GetTall() - mainPanel:GetTall())
    infoPane:SetPos(leftPane:GetWide(), menu:GetTall() - infoPane:GetTall())
    infoPane:SetPaintBackground(true)
    infoPane:SetBackgroundColor(Color(50, 0, 0))
    local infoPaneText = vgui.Create("RichText", infoPane)
    infoPaneText:SetSize(infoPane:GetSize())
    infoPaneText:Dock(FILL)

    for _, module in pairs(OverdoneServers.Modules) do
        if not module.Hidden then
            local ModuleMenuButton = leftPane:Add("DButton")
            ModuleMenuButton:SetText(module.DisplayName)
            ModuleMenuButton:Dock(TOP)
            ModuleMenuButton:DockMargin(0, 0, 0, 5)
            function ModuleMenuButton:DoClick()
                OpenModuleDebugMenu(mainPanel, infoPaneText, module)
            end
        end
    end

    menu:MakePopup()
    menu:Center()

end

concommand.Add("os_debugmenu", function()
    OpenDebugMenu()
end)

-- PrintTable(OverdoneServers.Modules)

local testBool = true
OverdoneServers.Modules.os_texas_holdem:AddDebugEntry(
    "Bool Test",
    "Testing a bool",
    function(newVal) testBool = newVal end,
    function() return testBool end
)

local testString = "WHOA"
OverdoneServers.Modules.os_texas_holdem:AddDebugEntry(
    "String Test",
    "Testing a string",
    function(newVal) testString = newVal end,
    function() return testString end
)

local testNumber = 5.56
OverdoneServers.Modules.os_texas_holdem:AddDebugEntry(
    "Number Test",
    "Testing a number",
    function(newVal) testNumber = newVal end,
    function() return testNumber end
)

local testColor = Color(100,100,100)
OverdoneServers.Modules.os_texas_holdem:AddDebugEntry(
    "Color Test",
    "Testing a color",
    function(newVal) testColor = newVal end,
    function() return testColor end
)

local testVec = Vector(100,100,100)
OverdoneServers.Modules.os_texas_holdem:AddDebugEntry(
    "Vector Test",
    "Testing a vector",
    function(newVal) testVec = newVal end,
    function() return testVec end
)

local testAng = Angle(100,100,100)
OverdoneServers.Modules.os_texas_holdem:AddDebugEntry(
    "Angle Test",
    "Testing a angle",
    function(newVal) testAng = newVal end,
    function() return testAng end
)

local options = {
    "First",
    "Second",
    "Third"
}
local testOption = 2
OverdoneServers.Modules.os_texas_holdem:AddDebugEntry(
    "Options Test",
    "Testing options",
    function(newVal) testOption = newVal end,
    function() return testOption end,
    options
)

local funcTest = function()
    LocalPlayer():ChatPrint("hehe")
end
OverdoneServers.Modules.os_texas_holdem:AddDebugEntry(
    "Function Test",
    "Testing functions",
    funcTest
)

local regTestSuccess = function()
    LocalPlayer():ChatPrint("pass!")
    return {}
end
OverdoneServers.Modules.os_texas_holdem:AddDebugEntry(
    "Regression Test Pass",
    "Testing functions",
    regTestSuccess
)

local regTestFail = function()
    LocalPlayer():ChatPrint("fail!")
    return {
        "Part A of the test failed!",
        "Part C of the test failed!",
        "Critical error! Shutting down test!"
    }
end
OverdoneServers.Modules.os_texas_holdem:AddDebugEntry(
    "Regression Test Fail",
    "Testing functions",
    regTestFail
)

concommand.Add("os_debugmenu_tests", function()
    print("testBool: " .. tostring(testBool))
    print("testString: " .. tostring(testString))
    print("testNumber: " .. tostring(testNumber))
end)