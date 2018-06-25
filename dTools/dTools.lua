local addonName, addon = ...

local S
local DT

addon["published"] = false
addon["leader"] = true
addon["group"] = {}
addon["rivals"] = {}

local function createMessage()
  return table.concat(S["Rotation"], ":") ..":" ..table.concat(S["Backup"], ":")
end

local function GroupMembers(reversed, forceParty)
  local unit  = (not forceParty and IsInRaid()) and 'raid' or 'party'
  local numGroupMembers = (forceParty and GetNumSubgroupMembers()  or GetNumGroupMembers()) - (unit == "party" and 1 or 0)
  local i = reversed and numGroupMembers or (unit == 'party' and 0 or 1)
  return function()
     local ret
     if i == 0 and unit == 'party' then
        ret = 'player'
     elseif i <= numGroupMembers and i > 0 then
        ret = unit .. i
     end
     i = i + (reversed and -1 or 1)
     return ret
  end
end

function addon:Open()
  if not DT then
    -- CONFIG
    local editboxSpacing = 20
    local numberRotationEntries = S["numberRotationEntries"] or 5
    local numberBackupEntries = S["numberBackupEntries"] or 3

    -- Addon Frame
    DT = CreateFrame('frame', addonName, UIParent)
    DT:SetHeight(300)
    DT:SetWidth(450)
    DT:SetPoint('CENTER')
    DT:SetFrameLevel(1)
    DT:SetFrameStrata('HIGH')
    DT:SetBackdrop({
      bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    })
    -- Child Table
    DT['children'] = {}
    local children = DT['children']
    children['MENU'] = {}

    function DT:createMenuButton(text, key, onClick, onClicked)
      local btn = CreateFrame('button', nil, self, 'UIPanelButtonTemplate')
      btn:SetSize(100, 25)
      btn:SetText(text)
      btn['key'] = key
      btn['targetKey'] = key *100
      if onClick then btn:SetScript('OnClick', onClick) end
      local clicked = CreateFrame('button', nil, self, 'UIGoldBorderButtonTemplate')
      clicked:SetWidth(100, 25)
      clicked:SetText(text)
      clicked['key'] = key *100
      clicked['targetKey'] = key
      if onClicked then clicked:SetScript('OnClick', onClicked) end
      clicked:Hide()
      clicked:Disable()
      
      return btn, clicked
    end

    function DT:createHeader(text, parent)
      local label = DT:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
      label:SetText(text)
      if parent then label:SetParent(parent) end

      return label
    end

    function DT:createEditBox(text, parent, anchor, valueID, onEscapePressed, onEnterPressed)
      local box = CreateFrame('editbox', nil, parent)
      box:SetPoint('TOPRIGHT', anchor, 'BOTTOMRIGHT', 0, -10)
      box:SetSize(120, 20)
      box:SetFontObject(GameFontHighlightSmall)
      box:SetAutoFocus(false)
      box:SetJustifyH('CENTER')
      box:SetText(text or "")
      box:SetScript('OnEscapePressed', onEscapePressed)
      box:SetScript('OnEnterPressed', onEnterPressed)
  
      box:SetBackdrop({
        bgFile = 'Interface/ChatFrame/ChatFrameBackground',
        edgeFile = 'Interface/ChatFrame/ChatFrameBackground',
        tile = true, edgeSize = 1, tileSize = 5,
      })
      box:SetBackdropColor(0, 0, 0, 0.5)
      box:SetBackdropBorderColor(0.3, 0.3, 0.3, 0.8)
      return box
    end

    function DT:createButton(text, parent, onClick)
      local btn = CreateFrame('button', nil, parent, 'UIPanelButtonTemplate')
      btn:SetSize(100, 25)
      btn:SetText(text)
      if onClick then btn:SetScript('OnClick', onClick) end

      return btn
    end

    -- Addon Header
    local header = DT:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightLarge')
    header:SetPoint('BOTTOM', DT, 'TOP', 0, 0)
    header:SetText(addonName)
    children['HEADER'] = header

    -- Menu
    for k, v in ipairs({'Interrupt', 'Settings'}) do
      local btn, clicked = DT:createMenuButton(v, k, function(self)
        self:Hide()
        for i,_ in ipairs(DT['children']['MENU']) do
          if DT['children']['MENU'][i *100]:IsShown() then
            DT['children']['MENU'][i *100]:Hide()
            DT['children']['MENU'][i]:Show()
          end
        end
        DT['children']['MENU'][self['targetKey']]:Show()
      end, function(self)
        self:Hide()
        DT['children']['MENU'][self['targetKey']]:Show()
      end)
      btn:SetPoint('TOPLEFT', DT, 'TOPLEFT', 10, -10 +(k -1) *-30)
      clicked:SetPoint('TOPLEFT', DT, 'TOPLEFT', 10, -10 +(k -1) *-30)
      children['MENU'][k] = btn
      children['MENU'][k *100] = clicked
    end
    
    DT['children']['INTERRUPT'] = {}
    local interrupt = DT['children']['INTERRUPT']
    local currentParent = children['MENU'][100]
    
    local rotationHeader = DT:createHeader('Rotation', currentParent)
    rotationHeader:SetPoint('TOPRIGHT', DT, 'TOPRIGHT', -10, -10)
    interrupt['rotationHeader'] = rotationHeader
    interrupt['rotationEditBox'] = {}
    interrupt['rotationEditBoxLabel'] = {}
    
    local anchor = rotationHeader
    for i = 1,5 do
      local editbox = DT:createEditBox(S["Rotation"][i], currentParent, anchor, i, function(self)
        self:SetText(S["Rotation"][valueID])
        self:ClearFocus()
      end, function(self)
        local text = self:GetText()
        if text == "" or UnitExists(text) then
          S["Rotation"][valueID] = text
          addon["published"] = false
          self:SetBackdropBorderColor(0.3, 0.3, 0.3, 0.8)
          self:ClearFocus()
        else
          self:SetBackdropBorderColor(1, 0, 0, 0.8)
        end
      end)
      anchor = editbox
      local editboxHeader = DT:createHeader(i, editbox)
      editboxHeader:SetPoint('LEFT', editbox, 'LEFT', -10, 0)
      interrupt['rotationEditBox'][#interrupt['rotationEditBox'] +1] = editbox
      interrupt['rotationEditBoxLabel'][#interrupt['rotationEditBoxLabel'] +1] = editboxHeader
    end

    local interruptPublish = DT:createButton('Publish', currentParent, function(self)
      addon["published"] = true
      SendAddonMessage('DTWA_ROTA', createMessage(), 'RAID')
    end)
    interruptPublish:SetPoint('BOTTOMRIGHT', DT, 'BOTTOMRIGHT', -10, 10)
    interrupt['publishButton'] = interruptPublish
    
    local backupHeader = DT:createHeader('Backup', currentParent)
    backupHeader:SetPoint('RIGHT', rotationHeader, 'LEFT', -110, 0)
    interrupt['backupHeader'] = backupHeader
    interrupt['backupEditBox'] = {}
    interrupt['backupEditBoxLabel'] = {}
    
    anchor = backupHeader
    for i = 1,3 do
      local editbox = DT:createEditBox(S["Backup"][i], currentParent, anchor, i, function(self)
        self:SetText(S["Backup"][valueID])
        self:ClearFocus()
      end, function(self)
        local text = self:GetText()
        if text == "" or UnitExists(text) then
          S["Backup"][valueID] = text
          addon["published"] = false
          self:SetBackdropBorderColor(0.3, 0.3, 0.3, 0.8)
          self:ClearFocus()
        else
          self:SetBackdropBorderColor(1, 0, 0, 0.8)
        end
      end)
      anchor = editbox
      local editboxHeader = DT:createHeader(i, editbox)
      editboxHeader:SetPoint('LEFT', editbox, 'LEFT', -10, 0)
      interrupt['backupEditBox'][#interrupt['backupEditBox'] +1] = editbox
      interrupt['backupEditBoxLabel'][#interrupt['backupEditBoxLabel'] +1] = editboxHeader
    end

    children['MENU'][1]:Click()
    DT:Show()
  else
    if DT:IsShown() then
      DT:Hide()
    else
      DT:Show()
    end
  end
end

local eventFrame = CreateFrame("frame")

function addon:Init()
  S = dToolsSaved or {}
  if IsInRaid() then
    for unit in GroupMembers() do
      addon["group"][UnitName(unit)] = true
    end
  end
  if not S["Rotation"] then
    S["Rotation"] = {"","","","",""}
  end
  if not S["Backup"] then
    S["Backup"] = {"","",""}
  end
end

local trackedPrefixes = {
  ["DTWA_REQ"] = function(msg, channel, author)
    if addon["published"] and addon["leader"] then
      SendAddonMessage("DTWA_ROTA", createMessage(), "WHISPER", author)
    end
  end,
  ["DT_HANDSHAKE"] = function(msg, channel, author)
    if channel == "RAID" or channel == "GROUP" then
      addon["rivals"][#addon["rivals"] +1] = author -- remove ppl when they leave
    end
  end,
}

local trackedEvents = {
  ["CHAT_MSG_ADDON"] = function(prefix, ...)
    if trackedPrefixes[prefix] then
      print(prefix, ...)
      trackedPrefixes[prefix](...)
    end
  end,
  ["ADDON_LOADED"] = function(name)
    if addonName == name then
      addon:Init()
      addon:Open()
      eventFrame:UnregisterEvent("ADDON_LOADED")
    end
  end,
  ["GROUP_ROSTER_UPDATE"] = function()
    if addon["published"] and addon["leader"] then
      local group = {}
      for unit in GroupMembers() do
        local n = UnitName(unit)
        group[n] = true
        if not addon["group"][n] then
          SendAddonMessage("DTWA_ROTA", createMessage(), "WHISPER", n)
        end
      end
      addon["group"] = group
    end
  end
}

local trackedSlashOptions = {
  ["sync"] = function(msg, editbox)
    print("sync requested")
    print(msg, editbox)
  end,
}

-- setup frame and eventhandler
local function eventHandler(self, event, ...)
  if trackedEvents[event] then
    trackedEvents[event](...)
  end
end
for k,_ in pairs(trackedEvents) do
  eventFrame:RegisterEvent(k)
end
eventFrame:SetScript("OnEvent", eventHandler)

-- setup prefixes
for k,_ in pairs(trackedPrefixes) do
  if not RegisterAddonMessagePrefix(k) then print("DT failed to register prefix: " ..k) end
end

-- setup slash commands
SLASH_DTOOLS1 = '/dtools'
function SlashCmdList.DTOOLS(msg, editbox)
  if msg == "" then
    return addon:Open()
  end
  msg = msg.lower()
  for k,v in pairs(trackedSlashOptions) do
    if msg:find(k) then
      v(msg, editbox)
    end
  end
end