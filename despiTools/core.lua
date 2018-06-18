local IM = InterruptManager
IM.rotation = {}

function IM:GetVersion() return 157 end
local interruptSpells = IM.GetInterruptSpells()

function IM:SavePosition()
    InterruptManagerAnchor:StopMovingOrSizing()
    local a = IMDB.anchorPoint
    a.point, a.region, a.relativePoint, a.x, a.y = InterruptManagerAnchor:GetPoint()
end

function IM:InitializeSavedVariables()
    if (not IMDB) then
        IMDB = {}
    end
    IMDB.anchorPoint = IMDB.anchorPoint or {["point"] = "CENTER", ["region"] = nil, ["relativePoint"] = "CENTER", ["x"] = 0, ["y"] = -300}
    IMDB.anchorSize = IMDB.anchorSize or {["width"] = 200, ["height"] = 100}
    IMDB.anchorMovable = (IMDB.anchorMovable ~= false and IMDB.anchorMovable ~= true) or (IMDB.anchorMovable == true)
    IMDB.anchorAlpha = IMDB.anchorAlpha or 0.2
    
    IMDB.statusBarSize = IMDB.statusBarSize or {["width"] = 180, ["height"] = 20}
    IMDB.statusBarAlpha = IMDB.statusBarAlpha or 1
    IMDB.statusBarTextSize = IMDB.statusBarTextSize or 12
    IMDB.statusBarTextAlpha = IMDB.statusBarTextAlpha or 1
    
    IMDB.iconSize = IMDB.statusBarSize.height
    IMDB.iconAlpha = IMDB.iconAlpha or 0.4
    IMDB.iconTextSize = IMDB.iconTextSize or 12
    IMDB.iconTextAlpha = IMDB.iconTextAlpha or 1
    
    IMDB.announce = (IMDB.announce ~= false and IMDB.announce ~= true) or (IMDB.announce == true)
    IMDB.targetWarn = (IMDB.targetWarn ~= false and IMDB.targetWarn ~= true) or (IMDB.targetWarn == true)
    IMDB.announceChannel = IMDB.announceChannel or "SAY"
    IMDB.pugModeChannel = IMDB.pugModeChannel or "SAY"
    IMDB.numInterrupters = IMDB.numInterrupters or 0
    IMDB.enableOverrideMaxInterrupters = IMDB.enableOverrideMaxInterrupters or false
    
    IMDB.version = IM.GetVersion()
    
    IMDB.maxInterrupters = IMDB.maxInterrupters or 5
end

function IM:UpdateInterrupterTable()
    -- Should be called when num max interrupters changes
    for i = 1, IMDB.maxInterrupters do
        if (not IMDB.interrupters[i]) then
            IMDB.interrupters[i] = {}
            IMDB.interrupters[i].active = false
            IMDB.interrupters[i].spells = {}
            IMDB.interrupters[i].name = ""
            IMDB.interrupters[i].ready = false
            IMDB.interrupters[i].next = false
            IMDB.interrupters[i].pos = i
            IMDB.interrupters[i].readyTime = 0
            IMDB.interrupters[i].cooldown = 0
            IMDB.interrupters[i].overrideFunction = nil
            IMDB.interrupters[i].available = false
            
            IM.rotation[i] = ""
        end
    end
    
    if (#IMDB.interrupters > IMDB.maxInterrupters) then
        for i = IMDB.maxInterrupters+1, #IMDB.interrupters do
            IMDB.interrupters[i] = nil
        end
    end
end

function IM:InitializeInterrupterTable()
    IMDB.interrupters = {}
    
    for i = 1, (IMDB.maxInterrupters or 5) do
        IMDB.interrupters[i] = {}
        IMDB.interrupters[i].active = false
        IMDB.interrupters[i].spells = {}
        IMDB.interrupters[i].name = ""
        IMDB.interrupters[i].ready = false
        IMDB.interrupters[i].next = false
        IMDB.interrupters[i].pos = i
        IMDB.interrupters[i].readyTime = 0
        IMDB.interrupters[i].cooldown = 0
        IMDB.interrupters[i].overrideFunction = nil
        IMDB.interrupters[i].available = false
        
        IM.rotation[i] = ""
    end
end

function IM:CreateStatusBars()
    for i = 1,IMDB.maxInterrupters do
        if (not _G["InterruptManagerIcon" .. i]) then
            local f = CreateFrame("Frame", "InterruptManagerIcon" .. i, InterruptManagerAnchor)
            f:SetSize(IMDB.iconSize, IMDB.iconSize)
            if (i == 1) then
                f:SetPoint("TOPLEFT", InterruptManagerAnchor, "TOPLEFT", 0, -(i-1) * IMDB.iconSize)
            else
                f:SetPoint("TOP", _G["InterruptManagerIcon" .. i-1], "BOTTOM")
            end
            
            local t = f:CreateTexture()
            t:SetAllPoints(f)
            t:SetColorTexture(0, 0, 0, IMDB.iconAlpha)
            
            t = f:CreateFontString()
            t:SetPoint("CENTER", "InterruptManagerIcon" .. i, "CENTER")
            t:SetFont("Fonts\\FRIZQT__.TTF", IMDB.iconTextSize)
            t:SetText(i)
            t:SetTextColor(1, 1, 1, IMDB.iconTextAlpha)
        
            f = CreateFrame("StatusBar", "InterruptManagerStatusBar" .. i, _G["InterruptManagerIcon" .. i])
            f:SetSize(IMDB.statusBarSize.width, IMDB.statusBarSize.height)
            f:SetPoint("LEFT", "InterruptManagerIcon" .. i, "RIGHT")
            f:SetOrientation("HORIZONTAL")
            f:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
            f:SetStatusBarColor(0, 1, 0, IMDB.statusBarAlpha)
            f:SetFrameLevel(3)
            f:SetMinMaxValues(0, 1)
            f:SetValue(0)
            
            f.text = f:CreateFontString("InterruptManagerStatusBarText" .. i, nil, "GameFontNormal")
            f.text:SetPoint("LEFT", "InterruptManagerStatusBar" .. i, "LEFT", 5, 0)
            f.text:SetSize(IMDB.statusBarSize.width - 5, IMDB.statusBarSize.height)
            f.text:SetJustifyH("LEFT")
            --f.text:SetFont("Fonts\\FRIZQT__.TTF", IMDB.statusBarTextSize)
            f.text:SetTextColor(1, 1, 1, IMDB.statusBarTextAlpha)
            f.text:SetText(IMDB.interrupters[i].name)
            
            f.cooldownText = f:CreateFontString("InterruptManagerStatusBarCooldownText" .. i, nil, "GameFontNormal")
            f.cooldownText:SetSize(IMDB.statusBarTextSize*3, IMDB.statusBarTextSize)
            f.cooldownText:SetJustifyH("LEFT")
            f.cooldownText:SetPoint("RIGHT", "InterruptManagerStatusBar" .. i, "RIGHT", 3, 0)
            f.cooldownText:SetFont("Fonts\\FRIZQT__.TTF", IMDB.statusBarTextSize, "OUTLINE")
            f.cooldownText:SetTextColor(1, 1, 1, IMDB.statusBarTextAlpha)
            
            --local g = CreateFrame("StatusBar", "InterruptManagerSecondaryStatusBar"..i)
            --g:SetSize(IMDB.statusBarSize[1],IMDB.statusBarSize[2])
            --g:SetPoint("CENTER",f,"CENTER")
            --g:SetParent(f)
            --g:SetOrientation("HORIZONTAL")
            --g:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
            --g:SetStatusBarColor(1,0,0,IMDB.statusBarAlpha/2)
            --g:SetFrameLevel(2)
            --g:SetMinMaxValues(0,1)
            --g:SetValue(0)
        else
            _G["InterruptManagerIcon" .. i]:Show()
        end
    end
    
    for i = 1,99 do
        if (i > IMDB.maxInterrupters and _G["InterruptManagerIcon" .. i]) then
            _G["InterruptManagerIcon" .. i]:Hide()
        elseif (i > IMDB.maxInterrupters) then
            break
        end
    end
end

function IM:OnLoad()
    if (IMDB) then
        IM.previousVersion = IMDB.version or 0
    else
        IM.previousVersion = 0
    end
    
    if (not IMDB or not IMDB.version or IMDB.version < 154) then
        IMDB = {}
        IM:InitializeInterrupterTable()
    end
    
    if (not IMDB.interrupters) then
        IM:InitializeInterrupterTable()
    end
    
    IM:InitializeSavedVariables()
    
    -- Create the anchor
    local f = CreateFrame("Frame", "InterruptManagerAnchor", UIParent)
    f:SetSize(IMDB.anchorSize.width, IMDB.anchorSize.height)
    f:SetPoint(IMDB.anchorPoint.point, IMDB.anchorPoint.region, IMDB.anchorPoint.relativePoint, IMDB.anchorPoint.x, IMDB.anchorPoint.y)
    if (IMDB.anchorMovable) then
        f:SetMovable(true)
        f:SetScript("OnMouseDown", function() InterruptManagerAnchor:StartMoving() end)
        f:SetScript("OnMouseUp", IM.SavePosition)
    end
    
    local t = f:CreateTexture()
    t:SetColorTexture(0, 0, 0, IMDB.anchorAlpha)
    t:SetAllPoints(f)
    
    IM:CreateStatusBars()
    
    -- Create the mid-screen warning text frame
    local c = CreateFrame("MessageFrame", "InterruptManagerText")
    c:SetFontObject(BossEmoteNormalHuge)
    c:SetWidth(300)
    c:SetHeight(50)
    c:SetPoint("CENTER", UIParent, "CENTER", 0, 80)
    local fontPath = c:GetFont()
    c:SetFont(fontPath, 25, "OUTLINE")
    c:SetFadeDuration(0.4)
    --c:SetTimeVisible(1.2)
    IM:OnLogin()
    f:SetScript("OnUpdate",IM.OnUpdate)
    
    
    f = InterruptManagerFrame
    f:UnregisterEvent("ADDON_LOADED")
    f:RegisterEvent("CHAT_MSG_ADDON")
    f:RegisterEvent("CHAT_MSG_SYSTEM")
    --f:RegisterEvent("PLAYER_REGEN_DISABLED") -- not in use
    --f:RegisterEvent("PLAYER_REGEN_ENABLED") -- not in use
    f:RegisterEvent("UNIT_SPELLCAST_START")
    f:RegisterEvent("UNIT_SPELLCAST_STOP")
    f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    --f:RegisterEvent("GLYPH_ADDED")
    --f:RegisterEvent("GLYPH_REMOVED")
    --f:RegisterEvent("GLYPH_UPDATED")
    f:RegisterEvent("UNIT_FLAGS")
    f:RegisterEvent("GROUP_ROSTER_UPDATE")
    f:RegisterEvent("LOADING_SCREEN_DISABLED")
    f:RegisterEvent("PLAYER_TARGET_CHANGED")
    f:RegisterEvent("PLAYER_FOCUS_CHANGED")
    f:RegisterEvent("LOADING_SCREEN_DISABLED")
    
    RegisterAddonMessagePrefix("InterruptManager")
end

function IM:OnUpdate()
    for k,v in pairs(IMDB.interrupters) do
        if (v.active and not v.ready) then
            local bar = _G["InterruptManagerStatusBar" .. v.pos]
            
            -- Interrupt spell ready/not ready
            if (v.readyTime - GetTime() <= 0) then
                v.ready = true
                bar.cooldownText:SetText()
                return
            end
            
            -- Update StatusBar values
            bar:SetValue(v.readyTime - GetTime())
            
            -- Update text to reflect cooldown
            bar.cooldownText:SetText(roundString(v.readyTime - GetTime(),1))
        end
    end
end

function IM_OnEvent(self, event, ...)
    if (_G["IM_" .. event]) then
        _G["IM_" .. event](...)
    else
        print("Unhandled event registered by InterruptManager: " .. event)
    end
end

function IM:SetInterrupterAvailable(interrupter)
    -- This is called on three occasions
    -- 1: Event UNIT_FLAGS is fired, due to a unit dying/coming alive, or a unit disconnecting/reconnecting
    -- 2: The availability of all interrupters is updated after setting the rotation (IM:SetRotation())
    -- 3: The availability of all interrupters is updated after a GROUP_ROSTER_UPDATE
    local unit = IM:PlayerNameToUnit(interrupter.name)
    
    if (IM:IsUnitOffline(unit)) then
        interrupter.offline = true
    else
        interrupter.offline = false
    end
    
    if (IM:IsUnitDead(unit)) then
        interrupter.dead = true
    else
        interrupter.dead = false
    end
    
    if (IM:IsUnitOffline(unit) or IM:IsUnitDead(unit)) then
        interrupter.available = false
    else
        interrupter.available = true
    end
end

function IM:IsUnitOffline(unit)
    if (not UnitExists(unit) or not UnitIsConnected(unit)) then
        return true
    else
        return false
    end
end

function IM:IsUnitDead(unit)
    if (not UnitExists(unit) or (UnitIsDead(unit) and not UnitBuff(unit, "Feign Death"))) then
        return true
    else
        return false
    end
end

function IM:UpdateAllPlayerAvailability()
    for k,v in pairs(IMDB.interrupters) do
        if (v.active) then
            IM:SetInterrupterAvailable(v)
        end
    end
end

function IM:PlayerNameToUnit(playerName)
    if (UnitName("player") == playerName) then
        return "player"
    elseif (IsInRaid()) then
        for i = 1,40 do
            if (UnitExists("raid" .. i)) then
                if (IM:GetUnitName("raid" .. i) == playerName) then
                    return "raid" .. i
                end
            else
                return "unknown"
            end
        end
    elseif (IsInGroup()) then
        for i = 1,4 do
            if (UnitExists("party" .. i)) then
                if (IM:GetUnitName("party" .. i) == playerName) then
                    return "party" .. i
                end
            else
                return "unknown"
            end
        end
    end
end

function IM_LOADING_SCREEN_DISABLED()
    IM:UpdateAllPlayerAvailability()
    IM:UpdateInterruptRotation()
    
    -- Status bars aren't updated while loading screen is enabled, nor when the value they are supposed to display is <= 0
    -- which can result in them not being updated if said value reaches 0 during the loading screen
    -- This is the fix:
    for k,v in pairs(IMDB.interrupters) do
        if (v.active and not v.ready) then
            local bar = _G["InterruptManagerStatusBar" .. v.pos]
            
            -- Interrupt spell ready/not ready
            if (v.readyTime - GetTime() <= 0) then
                v.ready = true
                bar.cooldownText:SetText()
                bar:SetValue(0)
            end
        end
    end
end

function IM_GROUP_ROSTER_UPDATE()
    IM:UpdateAllPlayerAvailability()
    IM:UpdateInterruptRotation()
end

function IM_UNIT_FLAGS(...)
    local unit = ...
    local unitName = UnitName(unit)
    
    for k,v in pairs(IMDB.interrupters) do
        if (v.name == unitName) then
            IM:SetInterrupterAvailable(v)
            break
        end
    end
    
    IM:UpdateInterruptRotation()
end

function IM_UNIT_SPELLCAST_START(...)
    local unit = ...
    
    if (unit == "focus" and IMDB.numInterrupters > 0) then
        local startTime, endTime, _, _, interruptImmune = select(5, UnitCastingInfo("focus"))
        if (not interruptImmune and IMDB.focusWarn and UnitCanAttack("player", "focus")) then
            if (IMDB.soloMode or IM:PlayerAtPosition(1) == UnitName("player") .. "-" .. GetRealmName()) then
            
                local timeVisible = 10
                if (startTime and endTime and endTime/1000 - startTime/1000 < 10) then
                    timeVisible = endTime - startTime
                end
                local text = "Interrupt now! (focus)"
                
                InterruptManagerText:AddMessage(text, 1,0.5,1)
                InterruptManagerText:SetTimeVisible(timeVisible)
                InterruptManagerText.text = text
                PlaySoundFile("Interface\\AddOns\\despiTools\\Sounds\\InterruptNow.ogg")
            end
        end
    elseif (unit == "target" and IMDB.numInterrupters > 0) then
        local startTime, endTime, _, _, interruptImmune = select(5, UnitCastingInfo("target"))
        if (not interruptImmune and IMDB.targetWarn and UnitCanAttack("player", "target")) then
            if (IMDB.soloMode or IM:PlayerAtPosition(1) == UnitName("player") .. "-" .. GetRealmName()) then
                
                -- timeVisible is most likely never going to be 10 or more, this is just a precaution to prevent
                -- the message from staying on the screen for an indefinite amount of time
                local timeVisible = 10
                if (startTime and endTime and endTime/1000 - startTime/1000 < 10) then
                    timeVisible = endTime - startTime
                end
                local text = "Interrupt now! (target)"
                
                InterruptManagerText:AddMessage(text, 1,1,1)
                InterruptManagerText:SetTimeVisible(timeVisible)
                InterruptManagerText.text = text
                PlaySoundFile("Interface\\AddOns\\despiTools\\Sounds\\InterruptNow.ogg")
            end
        end
    end
end

function IM_UNIT_SPELLCAST_STOP(...)
    local unit = ...
    
    if (unit == "target" and IMDB.targetWarn and InterruptManagerText.text == "Interrupt now! (target)") then
        InterruptManagerText:SetTimeVisible(0)
    elseif (unit == "focus" and IMDB.focusWarn and InterruptManagerText.text == "Interrupt now! (focus)") then
        InterruptManagerText:SetTimeVisible(0)
    end
end

-- [Function to prevent system message spam] --
ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", function(self, event, msg)
    if(strfind(msg, "No player named ")) then
        --return true
    end
end)
local AntiSpam = {{},{}}
function IM_CHAT_MSG_SYSTEM(...)
    local text = ...
    if (strfind(text, "No player named ")) then
        if (not tContains(AntiSpam[1],text)) then
            DEFAULT_CHAT_FRAME:AddMessage(text,1,1,0)
            tinsert(AntiSpam[1],text)
            tinsert(AntiSpam[2],GetTime()+1)
        else
            for k,v in pairs(AntiSpam[1]) do
                if (v == text) then
                    if (GetTime() >= AntiSpam[2][k]) then
                        AntiSpam[2][k] = GetTime()+1
                        DEFAULT_CHAT_FRAME:AddMessage(text,1,1,0)
                    end
                end
            end
        end
    end
end

function IM_CHAT_MSG_ADDON(...)
    local prefix = ...
    if (prefix == "InterruptManager") then
        IM:AddonMessageReceived(...)
    end
end

function IM_ADDON_LOADED(...)
    local addonName = ...
    if (addonName == "despiTools") then
        IM:OnLoad()
    end
end

function IM_COMBAT_LOG_EVENT_UNFILTERED(...)
    local event = select(2, ...)
    local sourceGUID = select(4, ...)
    local sourceName = select(5, ...)
    local spellId = select(12, ...)
    local spellName = select(13, ...)
    
    if (event == "SPELL_CAST_SUCCESS") then
        if (tContains(interruptSpells.spellId, spellId)) then
            -- If an interrupt spell was cast
            IM:InterruptUsed(sourceName, spellId)
            
            -- Announce my interrupt
            if (sourceGUID == UnitGUID("player") and IMDB.announce) then
                IM:AnnounceMyInterrupt(spellName)
            end
        end
    elseif (event == "SPELL_INTERRUPT") then
        if (tContains(interruptSpells.spellId, spellId)) then
            IM:UnitInterrupted(sourceName, spellId)
        end
    end
end

function IM_PLAYER_REGEN_DISABLED()

end

function IM_PLAYER_REGEN_ENABLED()
    
end

function IM_PLAYER_TARGET_CHANGED()
    if (InterruptManagerText.text == "Interrupt now! (target)") then
        InterruptManagerText:SetTimeVisible(0)
    end
end

function IM_PLAYER_FOCUS_CHANGED()
    if (InterruptManagerText.text == "Interrupt now! (focus)") then
        InterruptManagerText:SetTimeVisible(0)
    end
end

function IM_LOADING_SCREEN_DISABLED()
    InterruptManagerText:SetTimeVisible(0)
    IM:UpdateAllPlayerAvailability()
    IM:ActivateStatusBars()
end

local f = CreateFrame("Frame", "InterruptManagerFrame")
f:SetScript("OnEvent", IM_OnEvent)
f:RegisterEvent("ADDON_LOADED")

function IM:PlayerAtPosition(position)
    -- This function returns the full name of the player at the specified position in the rotation, including server name regardless of your server
    for k,v in pairs(IMDB.interrupters) do
        if (v.pos == position) then
            local name = v.name
            
            if (not strfind(v.name, "-")) then
                name = v.name .. "-" .. GetRealmName()
            end
            
            return name
        end
    end
    error("IM:PlayerAtPosition() is supposed to always return a value.")
end

local function InterruptTableSortFunction(a,b)
    return a.readyTime < b.readyTime
end
function IM:SortTable()
    -- 1: Place the readyTimes of active interrupters into a table
    -- 2: Sort the table in ascending order
    -- 3: Use the sorted values as keys in a new table, and assign ascending values to them
    -- 4: Set position values to the interrupters with matching readyTimes.
    local sortTable = {}
    for k,v in pairs(IMDB.interrupters) do
        if (v.active and v.available) then
            tinsert(sortTable, v)
        end
    end
    
    sort(sortTable, InterruptTableSortFunction)
    
    local deadCount = 0
    for k,v in pairs(IMDB.interrupters) do
        if (v.active and not v.available) then
            v.pos = IMDB.numInterrupters - deadCount
            deadCount = deadCount + 1
        end
    end
    
    for k,v in pairs(sortTable) do
        v.pos = k
    end
end

function IM:UpdateInterruptRotation()
    local db = IMDB.interrupters
    IM:SortTable()
    
    -- Update the UI to reflect the updated rotation
    IM:UpdateStatusBarVisibility()
end

function IM:ResetInactiveStatusBars()
    -- Someone dying used to sometimes cause empty bars to show a static cooldown (in text), this should prevent that.
    for i = 1,IMDB.numInterrupters do
        local bar = _G["InterruptManagerStatusBar" .. i]
        if (bar:GetValue() == 0) then
            bar.cooldownText:SetText("")
        end
    end
    
    for i = IMDB.numInterrupters+1,IMDB.maxInterrupters do
        local bar = _G["InterruptManagerStatusBar" .. i]
        _G["InterruptManagerIcon" .. i]:Hide()
        bar.text:SetText("")
        bar.cooldownText:SetText("")
        bar:SetValue(0)
    end
end

function IM:ActivateStatusBars()
    for i = 1,IMDB.maxInterrupters do
        local a = IMDB.interrupters[i]
        if (a.active) then
            local bar = _G["InterruptManagerStatusBar" .. a.pos]
            _G["InterruptManagerIcon" .. a.pos]:Show()
            
            if (a.offline) then
                bar.text:SetText("(Offline) " .. a.name)
            elseif (a.dead) then
                bar.text:SetText("(Dead) " .. a.name)
            else
                bar.text:SetText(a.name)
            end
            bar:SetMinMaxValues(0, a.cooldown)
        end
    end
end

function IM:UpdateStatusBarVisibility()
    -- Sets the name of each interrupter to the appropriate status bar, according to their position in the rotation
    -- Sets minMax values of the StatusBars
    -- Shows or hides StatusBars depending on their activity
    -- Scales the anchor to cover no more than the active StatusBars
    if (IMDB.numInterrupters > 0) then
        InterruptManagerAnchor:Show()
        IMDB.anchorSize.height = IMDB.statusBarSize.height * IMDB.numInterrupters
        InterruptManagerAnchor:SetSize(IMDB.anchorSize.width, IMDB.anchorSize.height)
    else
        InterruptManagerAnchor:Hide()
    end
    
    IM:ActivateStatusBars()
    IM:ResetInactiveStatusBars()
end

function IM:PugModeInterruptHandler()
    local db = IMDB.interrupters
    
    if (IMDB.pugMode) then
        local c = IMDB.pugModeChannel
        
        if (c == "WHISPER") then
            SendChatMessage("InterruptManager: You are interrupting next", "WHISPER", nil, IM:PlayerAtPosition(1))
        else
        
            for i = IMDB.numInterrupters,1,-1 do
                
                local channel
                if (c == "RAID_WARNING" and IsInRaid(LE_PARTY_CATEGORY_HOME) and (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player"))) then
                    channel = "RAID_WARNING"
                elseif ((c == "RAID" or c == "RAID_WARNING") and IsInRaid(LE_PARTY_CATEGORY_HOME)) then
                    channel = "RAID"
                elseif ((c == "RAID" or c == "PARTY") and IsInGroup(LE_PARTY_CATEGORY_HOME)) then
                    channel = "PARTY"
                elseif (c == "INSTANCE_CHAT" and (IsInGroup(LE_PARTY_CATEGORY_INSTANCE) or IsInRaid(LE_PARTY_CATEGORY_INSTANCE))) then
                    channel = "INSTANCE_CHAT"
                elseif (c == "YELL") then
                    channel = "YELL"
                else
                    channel = "SAY"
                end
                
                if (i == 1) then
                    SendChatMessage("Interrupting next: " .. IM:PlayerAtPosition(i), channel)
                end
            end
            
        end
    end
end

function IM:HideOutgoingWhisper(self, event, msg)
    if (msg == "InterruptManager: You are interrupting next") then
        return true
    else
        return false
    end
end
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", IM.HideOutgoingWhisper)

function IM:UnitInterrupted(sourceName, spellId)
    -- For now, this function is only used to track rogues' interrupts for the glyph
    local db = IMDB.interrupters
        
    for i = 1,IMDB.maxInterrupters do
        if (sourceName == db[i].name) then
            if (db[i].overrideFunction) then
                db[i].overrideFunction(db[i], "SPELL_INTERRUPT")
                return
            end
        end
    end
end

function IM:InterruptUsed(sourceName, spellId)
    local db = IMDB.interrupters
        
    for i = 1,IMDB.maxInterrupters do
        if (sourceName == db[i].name) then
            if (db[i].overrideFunction) then
                db[i].overrideFunction(db[i], "SPELL_CAST_SUCCESS")
                return
            end
            for k,v in pairs(interruptSpells.spellId) do
                if (v == spellId) then
                    db[i].cooldown = interruptSpells.cooldown[k]
                    db[i].readyTime = GetTime() + interruptSpells.cooldown[k]
                    db[i].ready = false
                    IM:UpdateInterruptRotation()
                    IM:PugModeInterruptHandler()
                end
            end
        end
    end
end

-- Function for announcing my own interrupt, as well as interrupt rotation in pug-mode
function IM:AnnounceMyInterrupt(spellName)
    local c = IMDB.announceChannel
    
    if (c == "RAID_WARNING" and IsInRaid(LE_PARTY_CATEGORY_HOME) and UnitIsGroupLeader("player")) then
        SendChatMessage("Used " .. spellName, "RAID_WARNING")
    elseif (c == "RAID" and IsInRaid(LE_PARTY_CATEGORY_HOME)) then
        SendChatMessage("Used " .. spellName, "RAID")
    elseif ((c == "RAID" or c == "PARTY") and IsInGroup(LE_PARTY_CATEGORY_HOME)) then
        SendChatMessage("Used " .. spellName, "PARTY")
    elseif ((c == "INSTANCE_CHAT" or c == "RAID" or c == "PARTY") and (IsInGroup(LE_PARTY_CATEGORY_INSTANCE) or IsInRaid(LE_PARTY_CATEGORY_INSTANCE))) then
        SendChatMessage("Used " .. spellName, "INSTANCE_CHAT")
    elseif (c == "YELL") then
        SendChatMessage("Used " .. spellName, "YELL")
    else
        SendChatMessage("Used " .. spellName, "SAY")
    end
end

SLASH_DESPITOOLS1 = '/im'
SLASH_DESPITOOLS2 = '/ima'
SLASH_DESPITOOLS3 = '/interruptmanager'
function SlashCmdList.DESPITOOLS(msg, editbox)
    if (string.find(msg, "lock")) then
        IM:OnFrameLock()
    else
        IM:OpenConfig()
        IM:InitializeNewFeatures()
    end
end