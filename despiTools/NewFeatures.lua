local IM = InterruptManager
local old, new

function IM:NewFeature_148HowToUse()
    IM:CreateNewFeaturesItem()
    
    local show = function()
        local f = IM:OpenFeatureDescriptionWindow()
        f:SetHeight(228)
        f:SetWidth(300)
        f:SetPoint("RIGHT", InterruptManagerConfig, "LEFT", 0, 120)
        
        local line1 = "Enter the name of each player you want in the rotation."
        local line2 = "Players who are not on your realm must have their realm name included in this format: 'Playername-Servername'."
        local line3 = "The AddOn can optionally announce information about the rotation to a chat channel, but this is by default disabled."
        local line4 = "For the sake of clarity, it is strongly recommended that all players install the AddOn."
        local line5 = "You can have several rotations within a raid that do not interfere with eachother."
        
        f.text:SetText(line1 .. "\n\n" .. line2 .. "\n\n" .. line3 .. "\n\n" .. line4 .. "\n\n" .. line5)
    end
    
    local hide = function()
        InterruptManagerNewFeaturesDescriptionWindow:Hide()
    end
    
    local desc = "How to use"
    local order = 1
    
    tinsert(IM.newFeaturesFunctions, {["desc"] = desc, ["show"] = show, ["hide"] = hide, ["order"] = order})
end

function IM:NewFeature_148AutoFillNames()
    IM:CreateNewFeaturesItem()
    
    local show = function()
        local f = IM:OpenFeatureDescriptionWindow()
        f:SetHeight(56)
        f:SetWidth(300)
        f:SetPoint("RIGHT", InterruptManagerConfig, "LEFT", 0, 120)
        
        f.text:SetText("Click one of the numbered buttons while targeting a player to enter their name into the corresponding editbox.")
        
        for i = 1,IMDB.maxInterrupters do
            ActionButton_ShowOverlayGlow(_G["InterruptManagerFillInNameButton" .. i])
        end
    end
    
    local hide = function()
        InterruptManagerNewFeaturesDescriptionWindow:Hide()
        
        for i = 1,IMDB.maxInterrupters do
            ActionButton_HideOverlayGlow(_G["InterruptManagerFillInNameButton" .. i])
        end
    end
    
    local desc = "Click to fill in names"
    local order = 2
    
    tinsert(IM.newFeaturesFunctions, {["desc"] = desc, ["show"] = show, ["hide"] = hide, ["order"] = order})
end

function IM:NewFeature_148LockBarsButton()
    IM:CreateNewFeaturesItem()
    
    local show = function()
        local f = IM:OpenFeatureDescriptionWindow()
        f:SetHeight(50)
        f:SetWidth(300)
        f:SetPoint("RIGHT", InterruptManagerConfig, "LEFT", 0, 0)
        
        local line1 = "Check to lock the bars. You can also type"
        local line2 = "/im lock"
        
        f.text:SetText(line1 .. "\n" .. line2)
        
        ActionButton_ShowOverlayGlow(InterruptManagerLockBarsButton)
    end
    
    local hide = function()
        InterruptManagerNewFeaturesDescriptionWindow:Hide()
        
        ActionButton_HideOverlayGlow(InterruptManagerLockBarsButton)
    end
    
    local desc = "Lock bars button"
    local order = 3
    
    tinsert(IM.newFeaturesFunctions, {["desc"] = desc, ["show"] = show, ["hide"] = hide, ["order"] = order})
end

function IM:NewFeature_148SoloModeButton()
    IM:CreateNewFeaturesItem()
    
    local show = function()
        local f = IM:OpenFeatureDescriptionWindow()
        f:SetHeight(94)
        f:SetWidth(300)
        f:SetPoint("RIGHT", InterruptManagerConfig, "LEFT", 0, -30)
        
        local line1 = "By default, you will only receive a warning when your target starts casting if it is your turn to interrupt."
        local line2 = "Enable Solo mode to receive a warning regardless of whose turn it is to interrupt."
        
        f.text:SetText(line1 .. "\n\n" .. line2)
        
        ActionButton_ShowOverlayGlow(InterruptManagerSoloModeButton)
    end
    
    local hide = function()
        InterruptManagerNewFeaturesDescriptionWindow:Hide()
        
        ActionButton_HideOverlayGlow(InterruptManagerSoloModeButton)
    end
    
    local desc = "Solo mode button"
    local order = 4
    
    tinsert(IM.newFeaturesFunctions, {["desc"] = desc, ["show"] = show, ["hide"] = hide, ["order"] = order})
end

function IM:NewFeature_148AnnounceButton()
    IM:CreateNewFeaturesItem()
    
    local show = function()
        local f = IM:OpenFeatureDescriptionWindow()
        f:SetHeight(80)
        f:SetWidth(300)
        f:SetPoint("RIGHT", InterruptManagerConfig, "LEFT", 0, -60)
        
        local line1 = "Enable Announce to send a chat message when you use your interrupt spell."
        local line2 = "The drop-down menu lets you choose output channel."
        
        f.text:SetText(line1 .. "\n\n" .. line2)
        
        ActionButton_ShowOverlayGlow(InterruptManagerAnnounceButton)
        ActionButton_ShowOverlayGlow(InterruptManagerAnnounceChannelDropDownButton)
    end
    
    local hide = function()
        InterruptManagerNewFeaturesDescriptionWindow:Hide()
        
        ActionButton_HideOverlayGlow(InterruptManagerAnnounceButton)
        ActionButton_HideOverlayGlow(InterruptManagerAnnounceChannelDropDownButton)
    end
    
    local desc = "Announce button"
    local order = 5
    
    tinsert(IM.newFeaturesFunctions, {["desc"] = desc, ["show"] = show, ["hide"] = hide, ["order"] = order})
end

function IM:NewFeature_148PUGModeButton()
    IM:CreateNewFeaturesItem()
    
    local show = function()
        local f = IM:OpenFeatureDescriptionWindow()
        f:SetHeight(104)
        f:SetWidth(300)
        f:SetPoint("RIGHT", InterruptManagerConfig, "LEFT", 0, -90)
        
        local line1 = "When enabled, you announce via chat which player should be interrupting next."
        local line2 = "The drop-down menu lets you choose output channel."
        local line3 = "Disabled by default."
        
        f.text:SetText(line1 .. "\n\n" .. line2 .. "\n\n" .. line3)
        
        ActionButton_ShowOverlayGlow(InterruptManagerPUGModeButton)
        ActionButton_ShowOverlayGlow(InterruptManagerPUGModeChannelDropDownButton)
    end
    
    local hide = function()
        InterruptManagerNewFeaturesDescriptionWindow:Hide()
        
        ActionButton_HideOverlayGlow(InterruptManagerPUGModeButton)
        ActionButton_HideOverlayGlow(InterruptManagerPUGModeChannelDropDownButton)
    end
    
    local desc = "PUG mode button"
    local order = 6
    
    tinsert(IM.newFeaturesFunctions, {["desc"] = desc, ["show"] = show, ["hide"] = hide, ["order"] = order})
end

function IM:NewFeature_148WatchTargetFocusButtons()
    IM:CreateNewFeaturesItem()
    
    local show = function()
        local f = IM:OpenFeatureDescriptionWindow()
        f:SetHeight(94)
        f:SetWidth(300)
        f:SetPoint("RIGHT", InterruptManagerConfig, "LEFT", 0, -135)
        
        local line1 = "Enable to receive a warning when your target/focus starts casting an interruptible spell." 
        local line2 = "This is the warning that is mentioned in the Solo mode explanation."
        
        f.text:SetText(line1 .. "\n\n" .. line2)
        
        ActionButton_ShowOverlayGlow(InterruptManagerWatchTargetButton)
        ActionButton_ShowOverlayGlow(InterruptManagerWatchFocusButton)
    end
    
    local hide = function()
        InterruptManagerNewFeaturesDescriptionWindow:Hide()
        
        ActionButton_HideOverlayGlow(InterruptManagerWatchTargetButton)
        ActionButton_HideOverlayGlow(InterruptManagerWatchFocusButton)
    end
    
    local desc = "Watch target/focus buttons"
    local order = 7
    
    tinsert(IM.newFeaturesFunctions, {["desc"] = desc, ["show"] = show, ["hide"] = hide, ["order"] = order})
end

function IM:NewFeature_148Technicalities()
    IM:CreateNewFeaturesItem()
    
    local show = function()
        local f = IM:OpenFeatureDescriptionWindow()
        f:SetHeight(320)
        f:SetWidth(300)
        f:SetPoint("RIGHT", InterruptManagerConfig, "LEFT", 0, 0)
        
        local line1 = "The AddOn parses the combat log, in which the names of players from other realms are in the format 'Playername-Servername'."
        local line2 = "The rotation is actually not a rotation, but a priority list sorted by whose interrupt ability will be ready first."
        local line3 = "Interrupt abilities used by players who are not in the rotation will have no effect whatsoever."
        local line4 = "The addon warns of interruptible spellcasts, but there are currently no other filters."
        local line5 = "If utilizing the PUG mode functionality, you can not set up more than one rotation, due to the fact that when you set up the second group, you will lose all information about the first group, which you need to track their interrupt abilities."
        local line6 = "If not utilizing the PUG mode functionality, you can set up as many unique rotations as you like."
        
        f.text:SetText(line1 .. "\n\n" .. line2 .. "\n\n" .. line3 .. "\n\n" .. line4 .. "\n\n" .. line5 .. "\n\n" .. line6)
    end
    
    local hide = function()
        InterruptManagerNewFeaturesDescriptionWindow:Hide()
    end
    
    local desc = "Technicalities..."
    local order = 8
    
    tinsert(IM.newFeaturesFunctions, {["desc"] = desc, ["show"] = show, ["hide"] = hide, ["order"] = order})
end

function IM:NewFeature_148Panic()
    IM:CreateNewFeaturesItem()
    
    local show = function()
        local f = IM:OpenFeatureDescriptionWindow()
        f:SetHeight(70)
        f:SetWidth(300)
        f:SetPoint("RIGHT", InterruptManagerConfig, "LEFT", 0, 120)
        
        local line1 = "Your bars are lost, you're getting errors, whatever it is, try typing this:"
        local line2 = "/run IMDB=nil ReloadUI()"
        
        f.text:SetText(line1 .. "\n\n" .. line2)
    end
    
    local hide = function()
        InterruptManagerNewFeaturesDescriptionWindow:Hide()
    end
    
    local desc = "Something isn't working!"
    local order = 9
    
    tinsert(IM.newFeaturesFunctions, {["desc"] = desc, ["show"] = show, ["hide"] = hide, ["order"] = order})
end

function IM:NewFeature_150Glyphs()
    IM:CreateNewFeaturesItem()
    
    local show = function()
        local f = IM:OpenFeatureDescriptionWindow()
        f:SetHeight(236)
        f:SetWidth(300)
        f:SetPoint("RIGHT", InterruptManagerConfig, "LEFT", 0, 120)
        
        local line1 = "Version 1.50:"
        local line2 = "Players who are offline or dead are now displayed as such, and will be placed at the bottom of the priority list until they reconnect or are resurrected."
        local line3 = "The following glyphs now correctly alter the functionality of the AddOn to reflect their in-game effects:"
        local line4 = "Glyph of Silence\nGlyph of Rebuke\nGlyph of Skull Bash\nGlyph of Mind Freeze\nGlyph of Counterspell\nGlyph of Wind Shear\nGlyph of Kick"
        
        f.text:SetText(line1 .. "\n\n" .. line2 .. "\n\n" .. line3 .. "\n\n" .. line4)
    end
    
    local hide = function()
        InterruptManagerNewFeaturesDescriptionWindow:Hide()
    end
    
    local desc = "1.50: Glyphs and player availability"
    local order = 10
    
    tinsert(IM.newFeaturesFunctions, {["desc"] = desc, ["show"] = show, ["hide"] = hide, ["order"] = order})
end

function IM:NewFeature_154MoreInterrupters()
    IM:CreateNewFeaturesItem()
    
    local show = function()
        local f = IM:OpenFeatureDescriptionWindow()
        f:SetHeight(156)
        f:SetWidth(300)
        f:SetPoint("RIGHT", InterruptManagerConfig, "LEFT", 0, 120)
        
        local line1 = "Version 1.54:"
        local line2 = "Maximum number of interrupters can now be changed up to 99. You can still leave editboxes empty if you need less interrupters than the maximum number."
        local line3 = "Note that communication with a lower version AddOn when number of interrupters is greater than 5 is undefined, and will result in unexpected behavior."
        
        f.text:SetText(line1 .. "\n\n" .. line2 .. "\n\n" .. line3)
        
        ActionButton_ShowOverlayGlow(InterruptManagerMaxInterruptersEditbox)
    end
    
    local hide = function()
        InterruptManagerNewFeaturesDescriptionWindow:Hide()
        ActionButton_HideOverlayGlow(InterruptManagerMaxInterruptersEditbox)
    end
    
    local desc = "1.54: New interrupter limit"
    local order = 11
    
    tinsert(IM.newFeaturesFunctions, {["desc"] = desc, ["show"] = show, ["hide"] = hide, ["order"] = order})
end

function IM:NewFeature_157LegionUpdate()
    IM:CreateNewFeaturesItem()
    
    local show = function()
        local f = IM:OpenFeatureDescriptionWindow()
        f:SetHeight(214)
        f:SetWidth(300)
        f:SetPoint("RIGHT", InterruptManagerConfig, "LEFT", 0, 120)
        
        local line1 = "Version 1.57:"
        local line2 = "Updated the AddOn for 7.2.5!"
        local line3 = "Added Call Felhunter, Muzzle and Consume Magic. Hopefully, I didn't miss any other new spells."
        local line4 = "Fixed a bug that produced error messages in the chat log."
        local line5 = "Fixed a bug that prevented textures from being drawn."
        local line6 = "Interrupt warnings are no longer produced when a non-attackable target starts casting."
        
        f.text:SetText(line1 .. "\n\n" .. line2 .. "\n\n" .. line3 .. "\n\n" .. line4 .. "\n\n" .. line5 .. "\n\n" .. line6)
    end
    
    local hide = function()
        InterruptManagerNewFeaturesDescriptionWindow:Hide()
    end
    
    local desc = "1.57: Legion (7.2.5) update"
    local order = 12
    
    tinsert(IM.newFeaturesFunctions, {["desc"] = desc, ["show"] = show, ["hide"] = hide, ["order"] = order})
end

local function SortFunctionsByOrder(a, b)
    return a.order < b.order
end

local showFunc, hideFunc
function IM:HighlightNewFeatureItem(frame)
    local n = InterruptManagerNewFeatures
    
    if (n.previousItem) then
        n.previousItem.hideFunc()
    end
    
    frame:showFunc()
    frame:Highlight()
    
    n.previousItem = frame
end

local MAX_NEW_FEATURE_ITEMS = 15
function IM:ScrollNewFeaturesItems(delta)
    local scrollLevel = InterruptManagerNewFeatures.scrollLevel
    
    if (scrollLevel + delta < 0 or IM.numNewFeatures <= MAX_NEW_FEATURE_ITEMS) then
        InterruptManagerNewFeatures.scrollLevel = 0
    elseif (scrollLevel + delta + MAX_NEW_FEATURE_ITEMS > IM.numNewFeatures) then
        InterruptManagerNewFeatures.scrollLevel = IM.numNewFeatures - MAX_NEW_FEATURE_ITEMS
    else
        InterruptManagerNewFeatures.scrollLevel = scrollLevel + delta
    end
    
    IM:UpdateNewFeaturesWindow()
end

function IM:UpdateNewFeaturesWindow()
    for i = 1, MAX_NEW_FEATURE_ITEMS do
        local feature = IM.newFeaturesFunctions[i + InterruptManagerNewFeatures.scrollLevel]
        if (not feature) then return end
        
        _G["IMNewFeatureItem" .. i].text:SetText(feature.desc)
        _G["IMNewFeatureItem" .. i].showFunc = feature.show
        _G["IMNewFeatureItem" .. i].hideFunc = feature.hide
    end
end

function IM:CreateNewFeaturesItem()
    if (not InterruptManagerNewFeatures or not InterruptManagerNewFeatures:IsShown()) then
        IM:OpenNewFeaturesWindow()
    end
    
    IM.numNewFeatures = IM.numNewFeatures + 1
    local i = IM.numNewFeatures
    
    if (IM.numNewFeatures < MAX_NEW_FEATURE_ITEMS) then
        local f = CreateFrame("Button", "IMNewFeatureItem" .. i, InterruptManagerNewFeatures)
        f:SetHeight(20)
        f:SetWidth(250)
        f:SetPoint("TOP", InterruptManagerNewFeatures, "TOP", 0, -i*20-30)
        f:SetFrameLevel(3)
        f:SetID(IM.numNewFeatures)
        --f:SetHighlightTexture("Interface\\AddOns\\despiTools\\Textures\\ConfigItemButtonHighlight")
        --f:SetPushedTexture("Interface\\AddOns\\despiTools\\Textures\\ConfigItemButtonPushed")
        f:SetScript("OnMouseWheel", function(self, delta) IM:ScrollNewFeaturesItems(delta) end)
        f:SetScript("OnEnter", function() IM:HighlightNewFeatureItem(f) end)
        f.Highlight = function() InterruptManagerNewFeatures.highlightFrame:SetPoint("CENTER", f, "CENTER") end
        
        local t = f:CreateFontString("$parentText")
        f.text = t
        t:SetFont("Fonts\\FRIZQT__.TTF",12)
        t:SetTextColor(1,1,1)
        t:SetJustifyH("LEFT")
        t:SetHeight(f:GetHeight())
        t:SetWidth(f:GetWidth())
        t:SetPoint("LEFT", f, "LEFT", 5, 0)
        
        t = f:CreateTexture("$parentTexture")
        f.texture = t
        t:SetAllPoints(f)
        t:SetAlpha(0.4)
    end
end

function IM:OpenFeatureDescriptionWindow()
    if (not InterruptManagerNewFeaturesDescriptionWindow) then
        local f = CreateFrame("Frame", "InterruptManagerNewFeaturesDescriptionWindow", InterruptManagerNewFeatures)
        f:SetFrameLevel(3)
        f:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\AddOns\\despiTools\\Textures\\ConfigBorder",
            tile = true,
            tileSize = 16,
            edgeSize = 16,
            insets = {left = 5, right = 5, top = 5, bottom = 5}
        })
        
        local t = f:CreateFontString("$parentText")
        f.text = t
        t:SetFont("Fonts\\FRIZQT__.TTF",12)
        t:SetTextColor(1,1,1)
        t:SetJustifyH("LEFT")
        t:SetJustifyV("TOP")
        t:SetPoint("CENTER", f, "CENTER")
        
        f.oldSetWidth = f.SetWidth
        f.oldSetHeight = f.SetHeight
        
        function f:SetWidth(value)
            f:oldSetWidth(value)
            t:SetWidth(value-20)
        end
        
        function f:SetHeight(value)
            f:oldSetHeight(value)
            t:SetHeight(value-20)
        end
        
        return InterruptManagerNewFeaturesDescriptionWindow
    else
        InterruptManagerNewFeaturesDescriptionWindow:Show()
        return InterruptManagerNewFeaturesDescriptionWindow
    end
end

function IM:OpenNewFeaturesWindow()
    -- Configuration box
    if (not InterruptManagerNewFeatures) then
        local f = CreateFrame("Frame", "InterruptManagerNewFeatures", InterruptManagerConfig)
        f:SetHeight(490)
        f:SetWidth(300)
        f:SetPoint("CENTER", InterruptManagerConfig, "CENTER", 300, 0)
        f:SetFrameLevel(1)
        f:SetMovable(1)
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
        f.scrollLevel = 0
        
        -- Configuration box title
        f = CreateFrame("Frame")
        f:SetHeight(30)
        f:SetWidth(200)
        f:SetPoint("CENTER", InterruptManagerNewFeatures, "TOP", 0, -15)
        f:SetParent(InterruptManagerNewFeatures)
        f:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\AddOns\\despiTools\\Textures\\ConfigBorder",
            tile = true,
            tileSize = 16,
            edgeSize = 16,
            insets = {left = 5, right = 5, top = 5, bottom = 5}
        })
        local t = f:CreateFontString()
        t:SetPoint("CENTER", f, "CENTER", 0, 0)
        t:SetFont("Fonts\\FRIZQT__.TTF", 12)
        t:SetText("Features")
        
        -- Button highlight border
        f = CreateFrame("Frame", nil, InterruptManagerNewFeatures)
        f:SetFrameLevel(2)
        f:SetSize(250,20)
        f:SetPoint("CENTER", UIParent, "CENTER")
        
        InterruptManagerNewFeatures.highlightFrame = f
        
        t = f:CreateTexture()
        t:SetPoint("CENTER", f, "CENTER")
        t:SetSize(250,20)
        t:SetColorTexture(0.7,0.7,0.7)
        t:SetDrawLayer("ARTWORK", 1)
        
        t = f:CreateTexture()
        t:SetPoint("CENTER", f, "CENTER")
        t:SetSize(248,18)
        t:SetColorTexture(0,0,0)
        t:SetDrawLayer("ARTWORK", 2)
        
        -- Close Button
        f = CreateFrame("Button", nil, InterruptManagerNewFeatures)
        f:SetScript("OnClick",function() InterruptManagerNewFeatures.previousItem:hideFunc() PlaySound("GAMEABILITYBUTTONMOUSEDOWN") InterruptManagerNewFeatures:Hide() end)
        f:SetHeight(20)
        f:SetWidth(80)
        f:SetPoint("BOTTOM", "InterruptManagerNewFeatures", "BOTTOM", 0, 20)
        f:SetFrameLevel(2)
        f:SetNormalTexture("Interface\\AddOns\\despiTools\\Textures\\ConfigButtonUp")
        f:SetPushedTexture("Interface\\AddOns\\despiTools\\Textures\\ConfigButtonDown")
        f:SetHighlightTexture("Interface\\AddOns\\despiTools\\Textures\\ConfigButtonHighlight", 0)
        f:SetDisabledTexture("Interface\\AddOns\\despiTools\\Textures\\ConfigButtonDisabled")
        
        local font = f:CreateFontString()
        f:SetFontString(font)
        f:SetPushedTextOffset(-1, -1)
        font:SetFont("Fonts\\FRIZQT__.TTF", 12)
        font:SetText("Close")
        font:SetTextColor(0,0,0)
    else
        InterruptManagerNewFeatures:Show()
    end
end

function IM:InitializeNewFeatures(overrideOldVersion)
    old = (overrideOldVersion or IM.previousVersion)
    new = IM:GetVersion()
    if (old == new) then return end
    
    IM.previousVersion = new
    
    if (not IM.addedNewFeatureItems) then
        IM.numNewFeatures = 0
        IM.newFeaturesFunctions = {}
        IM.addedNewFeatureItems = {}
    end
    
    for k,v in pairs(IM) do
        if (type(v) == "function" and strfind(k, "NewFeature_") and not tContains(IM.addedNewFeatureItems, k)) then
            local start = tonumber(strfind(k, "_"))
            local End = start+2
            local functionVersion = tonumber(strsub(k, start, End))
            if (functionVersion > old) then
                v()
                tinsert(IM.addedNewFeatureItems, k)
                sort(IM.newFeaturesFunctions, SortFunctionsByOrder)
            end
        end
    end
    
    if (InterruptManagerNewFeatures) then
        IM:UpdateNewFeaturesWindow()
        IM:HighlightNewFeatureItem(IMNewFeatureItem1)
        
        if (not InterruptManagerNewFeatures:IsShown()) then
            InterruptManagerNewFeatures:Show()
        end
    end
end