local IM = InterruptManager
local IMversion = IM:GetVersion()
IM.DropDown = {}

function IM:OpenConfig()
    if (not InterruptManagerConfig) then
        IM:CreateConfig(true)
        InterruptManagerConfig:Show()
    else
        InterruptManagerConfig:Show()
    end
    
    if (IMDB.numInterrupters == 0) then
        IMDB.anchorSize.height = IMDB.statusBarSize.height * IMDB.maxInterrupters
        InterruptManagerAnchor:Show()
        InterruptManagerAnchor:SetHeight(IMDB.anchorSize.height)
        
        for i = 1,IMDB.maxInterrupters do
            --_G["InterruptManagerStatusBar" .. i]:Show()
            _G["InterruptManagerIcon" .. i]:Show()
        end
    end
    
    for i=1,IMDB.maxInterrupters do
        if (IMDB.interrupters[i].name ~= "" and IMDB.interrupters[i].active) then
            _G["InterruptManagerConfigEditbox" .. i]:SetText(IMDB.interrupters[i].name)
        end
    end
end

function IM:CreateNameEditboxes()
    for i = 1,IMDB.maxInterrupters do
        if (not _G["InterruptManagerConfigEditbox" .. i]) then
            -- Editboxes
            IM:CreateConfigEditbox("InterruptManagerConfigEditbox" .. i, "", 0, -i*30-15):SetScript("OnTabPressed", IM.NameEditboxOnTabPressed)
            -- Fill in name buttons
            IM:CreateConfigButton("InterruptManagerFillInNameButton" .. i, tostring(i), 20, -115, -i*30-20, function() IM:FillInName(i) end)
        else
            _G["InterruptManagerConfigEditbox" .. i]:Show()
            _G["InterruptManagerFillInNameButton" .. i]:Show()
        end
    end
    
    -- Hide editboxes that are > IMDB.maxInterrupters
    
    for i = 1,99 do
        if (i > IMDB.maxInterrupters and _G["InterruptManagerConfigEditbox" .. i]) then
            _G["InterruptManagerConfigEditbox" .. i]:Hide()
            _G["InterruptManagerFillInNameButton" .. i]:Hide()
        elseif (i > IMDB.maxInterrupters) then
            break
        end
    end
end

function IM:CreateConfig(dontHide)
    -- Configuration box
    PlaySound(839)
    local f = CreateFrame("Frame", "InterruptManagerConfig")
    local height = 370 + IMDB.maxInterrupters*30
    f:SetHeight(height)
    f:SetWidth(300)
    f:SetPoint("CENTER")
    f:SetParent(UIParent)
    f:SetFrameLevel(1)
    f:SetMovable(1)
    f:SetFrameStrata("HIGH")
    f:SetScript("OnMouseDown", function() InterruptManagerConfig:StartMoving() end)
    f:SetScript("OnMouseUp", function() InterruptManagerConfig:StopMovingOrSizing() end)
    f:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\AddOns\\despiTools\\Textures\\ConfigBorder",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = {left = 5, right = 5, top = 5, bottom = 5}
    })
    tinsert(UISpecialFrames, f:GetName())
    
    -- Configuration box title
    f = CreateFrame("Frame")
    f:SetHeight(30)
    f:SetWidth(200)
    f:SetPoint("CENTER", "InterruptManagerConfig", "TOP", 0, -15)
    f:SetParent(InterruptManagerConfig)
    f:SetScript("OnMouseDown", function() InterruptManagerConfig:StartMoving() end)
    f:SetScript("OnMouseUp", function() InterruptManagerConfig:StopMovingOrSizing() end)
    f:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\AddOns\\despiTools\\Textures\\ConfigBorder",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = {left = 5, right = 5, top = 5, bottom = 5}
    })
    f:SetScript("OnShow", function() PlaySound(839) end)
    f:SetScript("OnHide", function() IM:OnCloseClick() PlaySound(840) end)
    
    local t = f:CreateFontString()
    t:SetPoint("CENTER", f, "CENTER", 0, 0)
    t:SetFont("Fonts\\FRIZQT__.TTF", 12)
    t:SetText("Interrupt Manager")
    
    local moveAll = -20-IMDB.maxInterrupters*30
    -- Close button
    IM:CreateConfigButton("InterruptManagerCloseButton", "Close", 80, 60, moveAll-310, IM.OnCloseClick)
    -- Chat button
    IM:CreateConfigButton("InterruptManagerChatButton", "Chat", 80, -60, moveAll-310, IM.OnChatClick)
    -- Help Button
    IM:CreateConfigButton("InterruptManagerHelpButton", "Help", 80, 0, moveAll-280, IM.OnHelpClick)
    -- Reset button
    IM:CreateConfigButton("InterruptManagerResetButton", "Reset", 80, 0, moveAll-30, IM.Reset)
    -- Editboxes + Fill-in-name-buttons
    IM:CreateNameEditboxes()
    -- Checkboxes
    IM:CreateConfigCheckbutton("InterruptManagerLockBarsButton", "Lock bars", -80, moveAll-60, "Turn on to lock bars", not IMDB.anchorMovable, IM.OnFrameLock)
    IM:CreateConfigCheckbutton("InterruptManagerSoloModeButton", "Solo mode", -80, moveAll-90, "Turn on to be warned when your target/focus is casting, regardless of your position in the queue", IMDB.soloMode, IM.OnSoloModeToggle)
    IM:CreateConfigCheckbutton("InterruptManagerAnnounceButton", "Announce", -80, moveAll-120, "Turn on to announce your interrupts", IMDB.announce, IM.OnAnnounceToggle)
    IM:CreateConfigCheckbutton("InterruptManagerPUGModeButton", "PUG mode", -80, moveAll-150, "Turn on if someone is missing the addon", IMDB.pugMode, IM.OnPUGModeToggle)
    IM:CreateConfigCheckbutton("InterruptManagerWatchTargetButton", "Watch target", -80, moveAll-180, "Turn on to be warned when your target casts an interruptible spell", IMDB.targetWarn, IM.OnTargetWatchToggle)
    IM:CreateConfigCheckbutton("InterruptManagerWatchFocusButton", "Watch focus ", -80, moveAll-210, "Turn on to be warned when your focus casts an interruptible spell", IMDB.focusWarn, IM.OnFocusWatchToggle)
    -- DropDown menus (x, y, script, text)
    IM:CreateConfigDropDown("InterruptManagerAnnounceChannelDropDown", 80, moveAll-118, IM.AnnounceDropDown, IMDB.announceChannel)
    IM:CreateConfigDropDown("InterruptManagerPUGModeChannelDropDown", 80, moveAll-148, IM.PugModeDropDown, IMDB.pugModeChannel)
    -- Max interrupters
    IM:CreateConfigLabel("InterruptManagerMaxInterruptersLabel", -40, moveAll-240, "Max interrupters")
    f = IM:CreateConfigEditbox("InterruptManagerMaxInterruptersEditbox", tostring(IMDB.maxInterrupters), 80, moveAll-233, 50)
    f:SetMaxLetters(2)
    f:SetNumeric(true)
    f:SetScript("OnEscapePressed", function() f:ClearFocus() end)
    f:SetScript("OnEnterPressed", function() f.enterPressed = true; f:ClearFocus() end)
    f:SetScript("OnEditFocusLost", function() if (f.enterPressed) then f.enterPressed = false; IMDB.maxInterrupters = tonumber(f:GetText()); IM:UpdateMaxInterrupters() else f:SetText(tostring(IMDB.maxInterrupters)) end end)
    f:SetScript("OnShow", function() f:SetText(tostring(IMDB.maxInterrupters)) end)
    
    if (not dontHide) then
        InterruptManagerConfig:Hide()
    end
end

function IM:UpdateMaxInterrupters()
    if (InterruptManagerConfig) then
        local moveAll = -20-IMDB.maxInterrupters*30
        local height = 370 + IMDB.maxInterrupters*30
        InterruptManagerConfig:SetHeight(height)
        InterruptManagerCloseButton:SetPoint("TOP", InterruptManagerConfig, "TOP", 60, moveAll-310)
        InterruptManagerChatButton:SetPoint("TOP", InterruptManagerConfig, "TOP", -60, moveAll-310)
        InterruptManagerHelpButton:SetPoint("TOP", InterruptManagerConfig, "TOP", 0, moveAll-280)
        InterruptManagerResetButton:SetPoint("TOP", InterruptManagerConfig, "TOP", 0, moveAll-30)
        InterruptManagerLockBarsButton:SetPoint("TOP", InterruptManagerConfig, "TOP", -80, moveAll-60)
        InterruptManagerSoloModeButton:SetPoint("TOP", InterruptManagerConfig, "TOP", -80, moveAll-90)
        InterruptManagerAnnounceButton:SetPoint("TOP", InterruptManagerConfig, "TOP", -80, moveAll-120)
        InterruptManagerPUGModeButton:SetPoint("TOP", InterruptManagerConfig, "TOP", -80, moveAll-150)
        InterruptManagerWatchTargetButton:SetPoint("TOP", InterruptManagerConfig, "TOP", -80, moveAll-180)
        InterruptManagerWatchFocusButton:SetPoint("TOP", InterruptManagerConfig, "TOP", -80, moveAll-210)
        InterruptManagerAnnounceChannelDropDown:SetPoint("TOP", InterruptManagerConfig, "TOP", 80, moveAll-118)
        InterruptManagerPUGModeChannelDropDown:SetPoint("TOP", InterruptManagerConfig, "TOP", 80, moveAll-148)
        InterruptManagerMaxInterruptersEditbox:SetPoint("TOP", InterruptManagerConfig, "TOP", 80, moveAll-233)
        InterruptManagerMaxInterruptersLabel:SetPoint("TOP", InterruptManagerConfig, "TOP", -40, moveAll-240)
        IM:CreateNameEditboxes()
    end
    
    IM:UpdateInterrupterTable()
    IM:CreateStatusBars()
    
    -- Set all interrupters above the max interrupter limit to inactive
    for k,v in pairs(IMDB.interrupters) do
        if (k > IMDB.maxInterrupters) then
            v.active = false
        elseif (v.name ~= "") then
            v.active = true
        end
    end
    
    -- Num interrupters can never be more than max interrupters
    if (IMDB.numInterrupters > IMDB.maxInterrupters) then
        IMDB.numInterrupters = IMDB.maxInterrupters
    end
    
    -- Adjust the anchor and hide icons above max interrupters limit
    if (IMDB.numInterrupters == 0) then
        IMDB.anchorSize.height = IMDB.statusBarSize.height * IMDB.maxInterrupters
    else
        IMDB.anchorSize.height = IMDB.statusBarSize.height * IMDB.numInterrupters
        for i = IMDB.numInterrupters+1, IMDB.maxInterrupters do
            _G["InterruptManagerIcon" .. i]:Hide()
        end
    end
    InterruptManagerAnchor:SetSize(IMDB.anchorSize.width, IMDB.anchorSize.height)
    
    IM:SetRotation()
end

function IM:OnHelpClick()
    if (InterruptManagerNewFeatures and InterruptManagerNewFeatures:IsShown()) then
        InterruptManagerNewFeatures:Hide()
    else
        IM:InitializeNewFeatures(1)
    end
end

function IM:OnChatClick()
    if (IsShiftKeyDown()) then
        BNSendFriendInvite("Horse#2529", "Halp with addon plz!")
    else
        DEFAULT_CHAT_FRAME:AddMessage("InterruptManager: Shift-click to attempt to contact author (will send friend invitation to Horse#2529, Europe only).", 1, 0.5, 0)
    end
end

function IM:PugModeDropDown()
    local function OnClick(self, arg1)
        IMDB.pugModeChannel = arg1
        UIDropDownMenu_SetText(InterruptManagerPUGModeChannelDropDown, arg1)
    end
    
    local info = UIDropDownMenu_CreateInfo()
    local c = IMDB.pugModeChannel
    
    info.func = OnClick
    
    info.text, info.checked, info.arg1 = "SAY", c == "SAY", "SAY"
    UIDropDownMenu_AddButton(info)
    
    info.text, info.checked, info.arg1 = "YELL", c == "YELL", "YELL"
    UIDropDownMenu_AddButton(info)
    
    info.text, info.checked, info.arg1 = "PARTY", c == "PARTY", "PARTY"
    UIDropDownMenu_AddButton(info)
    
    info.text, info.checked, info.arg1 = "RAID", c == "RAID", "RAID"
    UIDropDownMenu_AddButton(info)
    
    info.text, info.checked, info.arg1 = "RAID_WARNING", c == "RAID_WARNING", "RAID_WARNING"
    UIDropDownMenu_AddButton(info)
    
    info.text, info.checked, info.arg1 = "WHISPER", c == "WHISPER", "WHISPER"
    UIDropDownMenu_AddButton(info)
    
    info.text, info.checked, info.arg1 = "INSTANCE_CHAT", c == "INSTANCE_CHAT", "INSTANCE_CHAT"
    UIDropDownMenu_AddButton(info)
end

function IM:AnnounceDropDown()
    local function OnClick(self, arg1)
        IMDB.announceChannel = arg1
        UIDropDownMenu_SetText(InterruptManagerAnnounceChannelDropDown, arg1)
    end
    
    local info = UIDropDownMenu_CreateInfo()
    local c = IMDB.announceChannel
    
    info.func = OnClick
    
    info.text, info.checked, info.arg1 = "SAY", c == "SAY", "SAY"
    UIDropDownMenu_AddButton(info)
    
    info.text, info.checked, info.arg1 = "YELL", c == "YELL", "YELL"
    UIDropDownMenu_AddButton(info)
    
    info.text, info.checked, info.arg1 = "PARTY", c == "PARTY", "PARTY"
    UIDropDownMenu_AddButton(info)
    
    info.text, info.checked, info.arg1 = "RAID", c == "RAID", "RAID"
    UIDropDownMenu_AddButton(info)
    
    info.text, info.checked, info.arg1 = "RAID_WARNING", c == "RAID_WARNING", "RAID_WARNING"
    UIDropDownMenu_AddButton(info)
    
    info.text, info.checked, info.arg1 = "INSTANCE_CHAT", c == "INSTANCE_CHAT", "INSTANCE_CHAT"
    UIDropDownMenu_AddButton(info)
end

function IM:CreateConfigDropDown(name, x, y, script, text)
    local f = CreateFrame("Frame", name, InterruptManagerConfig, "UIDropDownMenuTemplate")
    f:SetPoint("TOP", "InterruptManagerConfig", "TOP", x, y)
    UIDropDownMenu_SetWidth(f, 80)
    UIDropDownMenu_Initialize(f, script)
    UIDropDownMenu_SetText(f, text)
end

function IM:CreateConfigLabel(name, x, y, text)
    local f = CreateFrame("Frame", name, InterruptManagerConfig)
    f:SetPoint("TOP", InterruptManagerConfig, "TOP", x, y)
    local t = f:CreateFontString("$parentText")
    t:SetFont("Fonts\\FRIZQT__.TTF", 12)
    t:SetText(text)
    
    f:SetSize(t:GetStringWidth(), 12)
    t:SetAllPoints(f)
end

function IM:CreateConfigCheckbutton(name, text, x, y, tooltip, checked, script)
    f = CreateFrame("CheckButton", name, InterruptManagerConfig, "ChatConfigCheckButtonTemplate")
    f:SetSize(20, 20)
    f:SetPoint("TOP", "InterruptManagerConfig", "TOP", x, y)
    f:SetFrameLevel(2)
    f:SetScript("OnClick", function() PlaySound(80) script() end)
    f:SetChecked(checked)
    f:SetNormalTexture("Interface\\AddOns\\despiTools\\Textures\\ConfigCheckboxUp")
    f:SetPushedTexture("Interface\\AddOns\\despiTools\\Textures\\ConfigCheckboxDown")
    f:SetHighlightTexture("Interface\\AddOns\\despiTools\\Textures\\ConfigButtonHighlight",0)
    f:SetCheckedTexture("Interface\\AddOns\\despiTools\\Textures\\ConfigCheckboxChecked")
    f:SetDisabledTexture("Interface\\AddOns\\despiTools\\Textures\\ConfigButtonDisabled")
    f.tooltip = tooltip
    t = f:CreateFontString(name .. "Text")
    t:SetPoint("LEFT", _G[name], "LEFT", 25, 0)
    t:SetFont("Fonts\\FRIZQT__.TTF", 12)
    t:SetText(text)
end

function IM:CreateConfigEditbox(name, text, x, y, width, height)
    f = CreateFrame("Editbox", name)
    f:SetFontObject(GameFontNormal)
    f:SetSize((width or 200), (height or 30))
    f:SetParent(InterruptManagerConfig)
    f:SetPoint("TOP", "InterruptManagerConfig", "TOP", x, y)
    f:SetFrameLevel(2)
    f:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\AddOns\\despiTools\\Textures\\ConfigBorder",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = {left = 5,right = 5,top = 5,bottom = 5}
    })
    f:SetAutoFocus(false)
    f:ClearFocus()
    --f:SetFont("Fonts\\FRIZQT__.TTF", 12)
    f:SetTextColor(1,1,1)
    f:Insert(text)
    f:SetMaxLetters(50)
    f:SetTextInsets(9,0,0,0)
    f:SetScript("OnEscapePressed", function() _G[name]:ClearFocus() end)
    f:SetScript("OnEnterPressed", function() _G[name]:ClearFocus() end)
    f:SetScript("OnEditFocusGained", function() _G[name]:HighlightText() end)
    f:SetScript("OnEditFocusLost", function() _G[name]:HighlightText(0,0) end)
    
    return f
end

function IM:NameEditboxOnTabPressed()
    for i=1,IMDB.maxInterrupters do
        f = _G["InterruptManagerConfigEditbox" .. i]
        if (f and f:HasFocus()) then
            if (i < IMDB.maxInterrupters) then
                _G["InterruptManagerConfigEditbox" .. i+1]:SetFocus()
                break
            else
                InterruptManagerConfigEditbox1:SetFocus()
                break
            end
        end
    end
end

function IM:CreateConfigButton(name, text,width,x,y,script,tooltip)
    f = CreateFrame("Button", name)
    if (text ~= "Close") then
        f:SetScript("OnClick", function() PlaySound(80) script() end)
    else
        f:SetScript("OnClick", script) -- Let's not have the close button play a sound other than the "close" sound...
    end
    f:SetHeight(20)
    f:SetWidth(width)
    f:SetParent(InterruptManagerConfig)
    f:SetPoint("TOP", "InterruptManagerConfig", "TOP", x, y)
    f:SetFrameLevel(2)
    f:SetNormalTexture("Interface\\AddOns\\despiTools\\Textures\\ConfigButtonUp")
    f:SetPushedTexture("Interface\\AddOns\\despiTools\\Textures\\ConfigButtonDown")
    f:SetHighlightTexture("Interface\\AddOns\\despiTools\\Textures\\ConfigButtonHighlight", 0)
    f:SetDisabledTexture("Interface\\AddOns\\despiTools\\Textures\\ConfigButtonDisabled")
    f.tooltip = tooltip
    
    local font = f:CreateFontString()
    f:SetFontString(font)
    f:SetPushedTextOffset(-1, -1)
    font:SetFont("Fonts\\FRIZQT__.TTF", 12)
    font:SetText(text)
    font:SetTextColor(0, 0, 0)
end

function IM:FillInName(i)
    -- Called when clicking on a numbered button to the left of editboxes
    if (UnitExists("target")) then
        _G["InterruptManagerConfigEditbox" .. i]:SetText(IM:GetUnitName("target"))
    end
end

function IM:GetUnitName(unit)
    -- Returns "no [unit]" if unit doesn't exist
    -- Returns "Playername-Realmname" if unit is from a different realm
    -- Returns "Playername" if unit is from the same realm
    if (UnitExists(unit)) then
        local name, realm = UnitName(unit)
        
        if (realm and realm ~= "") then
            return name .. "-" .. realm
        else
            return name
        end
    else
        return "no " .. unit
    end
end

function IM:OnFrameLock()
    if (IMDB.anchorMovable) then
        IMDB.anchorMovable = not IMDB.anchorMovable
        DEFAULT_CHAT_FRAME:AddMessage("InterruptManager: Frame locked.", 1, 0.5, 0)
        InterruptManagerLockBarsButton:SetChecked(true)
        InterruptManagerAnchor:SetMovable(false)
        InterruptManagerAnchor:EnableMouse(false)
        InterruptManagerAnchor:SetScript("OnMouseDown", nil)
        InterruptManagerAnchor:SetScript("OnMouseUp", nil)
    else
        IMDB.anchorMovable = not IMDB.anchorMovable
        InterruptManagerLockBarsButton:SetChecked(false)
        DEFAULT_CHAT_FRAME:AddMessage("InterruptManager: Frame unlocked.", 1, 0.5, 0)
        InterruptManagerAnchor:SetMovable(true)
        InterruptManagerAnchor:EnableMouse(true)
        InterruptManagerAnchor:SetScript("OnMouseDown", function() InterruptManagerAnchor:StartMoving() end)
        InterruptManagerAnchor:SetScript("OnMouseUp", IM.SavePosition)
    end
end

function IM:OnSoloModeToggle()
    if (not IMDB.soloMode) then
        IMDB.soloMode = not IMDB.soloMode
        DEFAULT_CHAT_FRAME:AddMessage("InterruptManager: Solo mode enabled. You will now be warned when your target/focus starts casting a spell, regardless of your position in the queue.", 1, 0.5, 0)
    else
        IMDB.soloMode = not IMDB.soloMode
        DEFAULT_CHAT_FRAME:AddMessage("InterruptManager: Solo mode disabled.", 1, 0.5, 0)
    end
end

function IM:OnAnnounceToggle()
    if (not IMDB.announce) then
        IMDB.announce = not IMDB.announce
        DEFAULT_CHAT_FRAME:AddMessage("InterruptManager: Announce enabled.", 1, 0.5, 0)
    else
        IMDB.announce = not IMDB.announce
        DEFAULT_CHAT_FRAME:AddMessage("InterruptManager: Announce disabled.", 1, 0.5, 0)
    end
end

function IM:OnPUGModeToggle()
    if (not IMDB.pugMode) then
        IMDB.pugMode = not IMDB.pugMode
        DEFAULT_CHAT_FRAME:AddMessage("InterruptManager: PUG mode enabled. You will now announce when someone uses their interrupt ability, and whose turn it is next. This option is disabled when logging in.", 1, 0.5, 0)
        IM:SendAddonMessage("pugmode:true")
    else
        IMDB.pugMode = not IMDB.pugMode
        DEFAULT_CHAT_FRAME:AddMessage("InterruptManager: PUG mode disabled.", 1, 0.5, 0)
    end
end

function IM:OnTargetWatchToggle()
    if (not IMDB.targetWarn) then
        IMDB.targetWarn = not IMDB.targetWarn
        DEFAULT_CHAT_FRAME:AddMessage("InterruptManager: You will now be warned when your target starts casting a spell.", 1, 0.5, 0)
    else
        IMDB.targetWarn = not IMDB.targetWarn
        DEFAULT_CHAT_FRAME:AddMessage("InterruptManager: You will no longer be warned when your target starts casting a spell.", 1, 0.5, 0)
    end
end

function IM:OnFocusWatchToggle()
    if (not IMDB.focusWarn) then
        IMDB.focusWarn = not IMDB.focusWarn
        DEFAULT_CHAT_FRAME:AddMessage("InterruptManager: You will now be warned when your focus starts casting a spell.", 1, 0.5, 0)
    else
        IMDB.focusWarn = not IMDB.focusWarn
        DEFAULT_CHAT_FRAME:AddMessage("InterruptManager: You will no longer be warned when your focus starts casting a spell.", 1, 0.5, 0)
    end
end

IM.warnOnce = true
function IM:BroadcastInterrupters()
    local msg = "rotationinfo:"
    
    for i = 1,IMDB.maxInterrupters do
        local text = _G["InterruptManagerConfigEditbox" .. i]:GetText()
        local missing = true
        
        if (text ~= "" and not strfind(text, "Interrupter")) then
            msg = msg .. _G["InterruptManagerConfigEditbox" .. i]:GetText() .. ","
        end
        
        if (IsInRaid()) then
            for i = 1,40 do
                if (IM:GetUnitName("raid" .. i) == text) then
                    missing = false
                end
            end        
        elseif (IsInGroup()) then
            for i = 1,4 do
                if (IM:GetUnitName("party" .. i) == text) then
                    missing = false
                end
            end
        end
        if (text == "") then missing = false end
        if (text == "First Interrupter" or text == "Second Interrupter" or text == "Third Interrupter" or text == "Fourth Interrupter" or text == "Fifth Interrupter") then missing = false end
        if (text == UnitName("player")) then missing = false end
        
        if (missing and IM.warnOnce) then
            DEFAULT_CHAT_FRAME:AddMessage("Warning: " .. text .. " is missing from the group. InterruptManager will not work as intended unless you click close while all rotation members are in your group.", 1, 0.5, 0)
            IM.warnOnce = false
        elseif (missing) then
            DEFAULT_CHAT_FRAME:AddMessage("Warning: " .. text .. " is missing from the group.")
        end
    end
    
    IM:SendAddonMessage(msg)
    IM:SendAddonMessage("versioninfo:" .. IMversion)
end

function IM:Reset()
    for i = 1,IMDB.maxInterrupters do
        _G["InterruptManagerConfigEditbox" .. i]:SetText("")
    end
    
    local db = IMDB.interrupters
    
    for i=1,IMDB.maxInterrupters do
        _G["InterruptManagerStatusBarText" .. i]:SetText("")
        _G["InterruptManagerStatusBar" .. i]:SetValue(0)
        
        db[i] = {}
        db[i].active = false
        db[i].name = ""
        db[i].ready = false
        db[i].next = false
        db[i].cooldown = 0
        db[i].pos = -1
        db[i].readyTime = 0
        
        IM.rotation[i] = ""
    end
end

function IM:AddInterrupter(text, i)
    local db = IMDB.interrupters
    
    db[i].active = true
    db[i].name = text
    db[i].ready = true
    if (i == 1) then db[i].next = true else db[i].next = false end
    db[i].cooldown = 0
    db[i].pos = i
    db[i].readyTime = i
    db[i].overrideFunction = nil
    
    IMDB.numInterrupters = IMDB.numInterrupters + 1
end

function IM:OnLogin()
    --if (not InterruptManagerConfig) then IM:CreateConfig() end
    
    for i = 1,IMDB.numInterrupters do
        IMDB.interrupters[i].pos = i
        IMDB.interrupters[i].readyTime = i
    end
    
    IM:UpdateInterruptRotation()
    IM:SendAddonMessage("getinfo:" .. IM:GetUnitName("player"))
end

function IM:SetRotation()
    local db = IMDB.interrupters
    IMDB.numInterrupters = 0
    
    for i = 1,IMDB.maxInterrupters do
        local text = _G["InterruptManagerConfigEditbox" .. i]:GetText()
        if (text ~= "" and not strfind(text, " Interrupter")) then
            IM:AddInterrupter(text, i)
        else
            IMDB.interrupters[i].active = false
        end
        
        _G["InterruptManagerStatusBar" .. i].cooldownText:SetText("")
    end
    
    IM:UpdateAllPlayerAvailability()
    IM:UpdateInterruptRotation()
    IM:UpdateStatusBarVisibility()
end

function IM:OnCloseClick()
    InterruptManagerConfig:Hide()
    if (InterruptManagerNewFeatures) then
        InterruptManagerNewFeatures:Hide()
        InterruptManagerNewFeatures.previousItem:hideFunc()
    end
    IM:SetRotation()
    
    IMDB.leader = true
    
    
    if (IsInGroup() or IsInRaid()) then
        IM:BroadcastInterrupters()
    end
end

function IM:SendAddonMessage(msg)
    local channel
    if (IsInRaid(LE_PARTY_CATEGORY_INSTANCE) or IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) then
        channel = "INSTANCE_CHAT"
    elseif (IsInRaid()) then
        channel = "RAID"
    elseif (IsInGroup()) then
        channel = "PARTY"
    else
        local playerName = UnitName("player")
        SendAddonMessage("InterruptManager", msg, "WHISPER", playerName)
        return
    end
    
    SendAddonMessage("InterruptManager", msg, channel)
end

function IM:ReceiveRotationInfo(msg, sender)
    -- TODO: Clean this function up......
    
    -- Message example
    -- playername,[playername,][playername,][playername,][playername,]
    local db = IMDB.interrupters
    IMDB.leader = false
    local temp = strfind(sender, "-")
    local realmName = strsub(sender, temp+1)
    
    -- Don't proceed unless player's name is in the message
    if (not strfind(msg, UnitName("player"))) then return end
    
    local interrupterNames = {}
    
    -- Create config if it isn't created yet, because we will be inserting text into the config editboxes
    if (not InterruptManagerConfig) then
        IM:CreateConfig()
    end
    
    IMDB.leader = false
    
    for i = 1,99 do
        -- If message is empty, remove all text in the editbox, in case there are more players in the previous, locally stored rotation, than in the most recently broadcast one
        if (msg == "" and _G["InterruptManagerConfigEditbox" .. i]) then
            _G["InterruptManagerConfigEditbox" .. i]:SetText("")
        elseif (msg == "" and not _G["InterruptManagerConfigEditbox" .. i]) then
            break
        else
            local nameEnd = strfind(msg, ",") -- Find first ","
            local name = strsub(msg, 1, nameEnd-1) -- Use all text up until first ","
            if (strfind(name, GetRealmName())) then -- If sender is from a different realm, remove "-[yourRealm]" from the names of players from your own realm
                local t = strfind(name, "-") -- Find first "-"
                name = strsub(name, 1, t-1) -- Use all text up until first "-"
            end
            if (strfind(sender, name) and realmName ~= GetRealmName()) then -- The sender's realm will not be included in the message, which it must be. This fixes that
                name = sender
            end
            msg = strsub(msg, nameEnd+1) -- Remove the extracted name from the message for further interpreting
            
            tinsert(interrupterNames, name)
        end
    end
    
    if (IMDB.maxInterrupters < #interrupterNames) then
        IMDB.maxInterrupters = #interrupterNames
        IM:UpdateMaxInterrupters()
    end
    
    for k,v in pairs(interrupterNames) do
        _G["InterruptManagerConfigEditbox" .. k]:SetText(v)
    end
    
    IM:SendAddonMessage("versioninfo:" .. IMversion) -- Broadcasting version will produce a message if someone else has a higher version
    IM:SetRotation()
end

function IM:ReceivePugModeInfo(msg)
    -- Message examples
    -- true
    -- false
    if (msg == "true") then
        InterruptManagerConfigCheckbutton4:SetChecked(false)
        IMDB.pugMode = false
    end
end

function IM:ReceiveGetInfoRequest(msg, sender)
    -- Currently, the only use for this function is to broadcast glyph information
    -- Original intended use was to inform relogging players about the state of the rotation
    -- A method to keep a (millisecond-precision) synchronized clock would need to be implemented for such functionality
    
    -- [sender] is always in the format "Playername-Servername"
    
    -- In the combat log: 
    -- Names of players from the same realm are in the format "Playername"
    -- Names of players from different realms are in the format "Playername-Servername"
    
    -- Modify [sender] so that it doesn't contain your server name if they are from the same server
    if (strfind(sender, GetRealmName())) then
        local t = strfind(sender, "-") -- Find first "-"
        sender = strsub(sender, 1, t-1) -- Use all text up until first "-"
    end
    
    -- Don't procceed if sender isn't in your rotation
    for i = 1,IMDB.numInterrupters+1 do
        if (i > IMDB.numInterrupters) then
            return
        elseif (sender == IMDB.interrupters[i].name) then
            break
        end
    end
end

function IM:ReceiveVersionInfo(msg, sender)
    local otherVersion = tonumber(msg)
    local myVersion = tonumber(IM:GetVersion())
    
    if (otherVersion > myVersion) then
        if (not IM.newVersionNoticed) then
            DEFAULT_CHAT_FRAME:AddMessage("InterruptManager: An update is available for InterruptManager.", 1, 0.5, 0)
            IM.newVersionNoticed = true
        end
    elseif (otherVersion < 154 and not IM.newVersionNoticed) then
        DEFAULT_CHAT_FRAME:AddMessage("InterruptManager: " .. sender .. " is using a version that does not support more than 5 interrupters.", 1, 0.5, 0)
        IM.newVersionNoticed = true
    end
end

function IM:AddonMessageReceived(...)
    -- This is super ugly, but the neat way did for unknown reasons not work.
    -- All function calls were made with two arguments, msg and sender.
    -- The called functions would receive three arguments, arg1 = nil, arg2 = sender, arg3 = msg.
    -- Yes, in the reverse order compared to the function call.
    local msg, _, sender, noRealmNameSender = select(2, ...)
    
    if (strfind(sender, UnitName("player"))) then return end -- Stuff below this line will not be executed if sender is player
    
    if (strfind(msg, "rotationinfo:")) then
        msg = gsub(msg, "rotationinfo:", "")
        IM:ReceiveRotationInfo(msg, sender)
    
    elseif (strfind(msg, "versioninfo:")) then
        msg = gsub(msg, "versioninfo:", "")
        IM:ReceiveVersionInfo(msg, sender)
        
    elseif (strfind(msg, "pugmode:")) then
        msg = gsub(msg, "pugmode:", "")
        IM:ReceivePugModeInfo(msg, sender)
        
    elseif (strfind(msg, "getinfo:")) then
        msg = gsub(msg, "getinfo:", "")
        IM:ReceiveGetInfoRequest(msg, sender)
    end
end

function round(num, dec)
    local number = string.format("%." .. dec .. "f", tostring(num))
    return tonumber(number)
end

function roundString(num,dec)
    return string.format("%." .. dec .. "f", tostring(num))
end