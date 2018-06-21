local addonName, addon = ...

despiToolsSettings = despiToolsSettings or {}
local DTS = despiToolsSettings
local DT = {}

local formatMessage = function(payload)
  return table.concat(payload, ":")
end

local trackedPrefixes = {
  ["DTWA_REQ"] = function(msg, channel, author)
    SendAddonMessage("DTWA_ROTA", formatMessage(testRotation), "RAID")
  end,
  ["DTWA_JOINED"] = function(msg, channel, author)
    print(msg, channel, author)
    print(formatMessage(testRotation))
    SendAddonMessage("DTWA_ROTA", formatMessage(testRotation), "WHISPER", author)
  end,
  ["DTWA_HANDSHAKE"] = function(msg, channel, author)
  end,
}

local trackedEvents = {
  ["CHAT_MSG_ADDON"] = function(prefix, ...)
    if trackedPrefixes[prefix] then
      print(prefix, ...)
      trackedPrefixes[prefix](...)
    end
  end,
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
local eventFrame = CreateFrame("FRAME")
for k,_ in pairs(trackedEvents) do
  eventFrame:RegisterEvent(k)
end
eventFrame:SetScript("OnEvent", eventHandler)

-- setup prefixes
for k,_ in pairs(trackedPrefixes) do
  if not RegisterAddonMessagePrefix(k) then print("DT failed to register prefix: " ..k) end
end

-- setup slash commands
SLASH_DESPITOOLS1 = '/dt'
SLASH_DESPITOOLS2 = '/despitools'
function SlashCmdList.DESPITOOLS(msg, editbox)
  if msg == "" then
    return DT:Open()
  end 
  for k,v in pairs(trackedSlashOptions) do
    if msg:find(k) then
      v(msg, editbox)
    end
  end
end

function DTS:Open()
  if not DT["children"] then
    -- CONFIG
    local editboxSpacing = 20
    local numberRotationEntries = DTS["numberRotationEntries"] or 5
    local numberBackupEntries = DTS["numberBackupEntries"] or 3

    -- CREATE FRAME
    local optionsFrame = CreateFrame("Frame", "despiToolsOptions", UIParent)
    optionsFrame:SetHeight(300)
    optionsFrame:SetWidth(160)
    optionsFrame:SetPoint("CENTER")
    optionsFrame:SetFrameLevel(1)
    optionsFrame:SetFrameStrata("HIGH")
    optionsFrame:SetBackdrop({
      bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    })

    optionsFrame["children"] = {}
    local children = optionsFrame["children"]

    -- CREATE FRAME HEADER
    local optionsFrameHeader = optionsFrame:CreateFontString(nil, 'ARTWORK', "GameFontHighlightLarge")
    optionsFrameHeader:SetPoint('BOTTOM', optionsFrame, 'TOP', 0, 0)
    optionsFrameHeader:SetText('Interrupt Rotation')
    children["Header"] = optionsFrameHeader

    -- CREATE ROTATION HEADER
    local optionsFrameRotationHeader = optionsFrame:CreateFontString(nil, 'ARTWORK', "GameFontHighlight")
    optionsFrameRotationHeader:SetPoint('TOPLEFT', optionsFrame, 'TOPLEFT', 10, -10)
    optionsFrameRotationHeader:SetText('Rotation')
    children["RotationHeader"] = optionsFrameRotationHeader

    -- CREATE ROTATION ENTRY 1 HEADER
    local optionsFrameRotationEntry1 = optionsFrame:CreateFontString(nil, 'ARTWORK', "GameFontHighlight")
    optionsFrameRotationEntry1:SetPoint('LEFT', optionsFrameRotationHeader, 'BOTTOMLEFT', 0, -editboxSpacing)
    optionsFrameRotationEntry1:SetWidth(10)
    optionsFrameRotationEntry1:SetText('1')
    children["RotationLabel1"] = optionsFrameRotationEntry1
    
    -- CREATE ROTATION ENTRY 1 EDITBOX
    local rotationEditBoxRota1 = CreateFrame('editbox', nil, optionsFrame)
    rotationEditBoxRota1:SetPoint('LEFT', optionsFrameRotationEntry1, 'RIGHT', 5, 0)
    rotationEditBoxRota1:SetSize(120, 20)
    rotationEditBoxRota1:SetFontObject(GameFontHighlightSmall)
    rotationEditBoxRota1:SetAutoFocus(false)
    rotationEditBoxRota1:SetJustifyH('CENTER')
    rotationEditBoxRota1:SetScript('OnEscapePressed', function(self)
      self:ClearFocus()
    end)
    rotationEditBoxRota1:SetScript('OnEnterPressed', function(self)
      self:ClearFocus()
    end)

    rotationEditBoxRota1:SetBackdrop({
      bgFile = 'Interface/ChatFrame/ChatFrameBackground',
      edgeFile = 'Interface/ChatFrame/ChatFrameBackground',
      tile = true, edgeSize = 1, tileSize = 5,
    })
    rotationEditBoxRota1:SetBackdropColor(0, 0, 0, 0.5)
    rotationEditBoxRota1:SetBackdropBorderColor(0.3, 0.3, 0.3, 0.8)
    children["RotationEditBox1"] = rotationEditBoxRota1

    -- CREATE ROTATION ENTRY 2 HEADER
    local optionsFrameRotationEntry2 = optionsFrame:CreateFontString(nil, 'ARTWORK', "GameFontHighlight")
    optionsFrameRotationEntry2:SetPoint('LEFT', optionsFrameRotationEntry1, 'BOTTOMLEFT', 0, -editboxSpacing)
    optionsFrameRotationEntry2:SetWidth(10)
    optionsFrameRotationEntry2:SetText('2')
    children["RotationLabel2"] = optionsFrameRotationEntry2
    
    -- CREATE ROTATION ENTRY 2 EDITBOX
    local rotationEditBoxRota2 = CreateFrame('editbox', nil, optionsFrame)
    rotationEditBoxRota2:SetPoint('LEFT', optionsFrameRotationEntry2, 'RIGHT', 5, 0)
    rotationEditBoxRota2:SetSize(120, 20)
    rotationEditBoxRota2:SetFontObject(GameFontHighlightSmall)
    rotationEditBoxRota2:SetAutoFocus(false)
    rotationEditBoxRota2:SetJustifyH('CENTER')
    rotationEditBoxRota2:SetScript('OnEscapePressed', function(self)
      self:ClearFocus()
    end)
    rotationEditBoxRota1:SetScript('OnEnterPressed', function(self)
      self:ClearFocus()
    end)

    rotationEditBoxRota2:SetBackdrop({
      bgFile = 'Interface/ChatFrame/ChatFrameBackground',
      edgeFile = 'Interface/ChatFrame/ChatFrameBackground',
      tile = true, edgeSize = 1, tileSize = 5,
    })
    rotationEditBoxRota2:SetBackdropColor(0, 0, 0, 0.5)
    rotationEditBoxRota2:SetBackdropBorderColor(0.3, 0.3, 0.3, 0.8)
    children["RotationEditBox2"] = rotationEditBoxRota2

    -- CREATE ROTATION ENTRY 3 HEADER
    local optionsFrameRotationEntry3 = optionsFrame:CreateFontString(nil, 'ARTWORK', "GameFontHighlight")
    optionsFrameRotationEntry3:SetPoint('LEFT', optionsFrameRotationEntry2, 'BOTTOMLEFT', 0, -editboxSpacing)
    optionsFrameRotationEntry3:SetWidth(10)
    optionsFrameRotationEntry3:SetText('3')
    children["RotationLabel3"] = optionsFrameRotationEntry3
    
    -- CREATE ROTATION ENTRY 3 EDITBOX
    local rotationEditBoxRota3 = CreateFrame('editbox', nil, optionsFrame)
    rotationEditBoxRota3:SetPoint('LEFT', optionsFrameRotationEntry3, 'RIGHT', 5, 0)
    rotationEditBoxRota3:SetSize(120, 20)
    rotationEditBoxRota3:SetFontObject(GameFontHighlightSmall)
    rotationEditBoxRota3:SetAutoFocus(false)
    rotationEditBoxRota3:SetJustifyH('CENTER')
    rotationEditBoxRota3:SetScript('OnEscapePressed', function(self)
      self:ClearFocus()
    end)
    rotationEditBoxRota3:SetScript('OnEnterPressed', function(self)
      self:ClearFocus()
    end)

    rotationEditBoxRota3:SetBackdrop({
      bgFile = 'Interface/ChatFrame/ChatFrameBackground',
      edgeFile = 'Interface/ChatFrame/ChatFrameBackground',
      tile = true, edgeSize = 1, tileSize = 5,
    })
    rotationEditBoxRota3:SetBackdropColor(0, 0, 0, 0.5)
    rotationEditBoxRota3:SetBackdropBorderColor(0.3, 0.3, 0.3, 0.8)
    children["RotationEditBox3"] = rotationEditBoxRota3

    -- CREATE ROTATION ENTRY 4 HEADER
    local optionsFrameRotationEntry4 = optionsFrame:CreateFontString(nil, 'ARTWORK', "GameFontHighlight")
    optionsFrameRotationEntry4:SetPoint('LEFT', optionsFrameRotationEntry3, 'BOTTOMLEFT', 0, -editboxSpacing)
    optionsFrameRotationEntry4:SetWidth(10)
    optionsFrameRotationEntry4:SetText('4')
    children["RotationLabel4"] = optionsFrameRotationEntry4
    
    -- CREATE ROTATION ENTRY 4 EDITBOX
    local rotationEditBoxRota4 = CreateFrame('editbox', nil, optionsFrame)
    rotationEditBoxRota4:SetPoint('LEFT', optionsFrameRotationEntry4, 'RIGHT', 5, 0)
    rotationEditBoxRota4:SetSize(120, 20)
    rotationEditBoxRota4:SetFontObject(GameFontHighlightSmall)
    rotationEditBoxRota4:SetAutoFocus(false)
    rotationEditBoxRota4:SetJustifyH('CENTER')
    rotationEditBoxRota4:SetScript('OnEscapePressed', function(self)
      self:ClearFocus()
    end)
    rotationEditBoxRota4:SetScript('OnEnterPressed', function(self)
      self:ClearFocus()
    end)

    rotationEditBoxRota4:SetBackdrop({
      bgFile = 'Interface/ChatFrame/ChatFrameBackground',
      edgeFile = 'Interface/ChatFrame/ChatFrameBackground',
      tile = true, edgeSize = 1, tileSize = 5,
    })
    rotationEditBoxRota4:SetBackdropColor(0, 0, 0, 0.5)
    rotationEditBoxRota4:SetBackdropBorderColor(0.3, 0.3, 0.3, 0.8)
    children["RotationEditBox4"] = rotationEditBoxRota4

    -- CREATE ROTATION ENTRY 5 HEADER
    local optionsFrameRotationEntry5 = optionsFrame:CreateFontString(nil, 'ARTWORK', "GameFontHighlight")
    optionsFrameRotationEntry5:SetPoint('LEFT', optionsFrameRotationEntry4, 'BOTTOMLEFT', 0, -editboxSpacing)
    optionsFrameRotationEntry5:SetWidth(10)
    optionsFrameRotationEntry5:SetText('5')
    children["RotationLabel5"] = optionsFrameRotationEntry5
    
    -- CREATE ROTATION ENTRY 5 EDITBOX
    local rotationEditBoxRota5 = CreateFrame('editbox', nil, optionsFrame)
    rotationEditBoxRota5:SetPoint('LEFT', optionsFrameRotationEntry5, 'RIGHT', 5, 0)
    rotationEditBoxRota5:SetSize(120, 20)
    rotationEditBoxRota5:SetFontObject(GameFontHighlightSmall)
    rotationEditBoxRota5:SetAutoFocus(false)
    rotationEditBoxRota5:SetJustifyH('CENTER')
    rotationEditBoxRota5:SetScript('OnEscapePressed', function(self)
      self:ClearFocus()
    end)
    rotationEditBoxRota5:SetScript('OnEnterPressed', function(self)
      self:ClearFocus()
    end)

    rotationEditBoxRota5:SetBackdrop({
      bgFile = 'Interface/ChatFrame/ChatFrameBackground',
      edgeFile = 'Interface/ChatFrame/ChatFrameBackground',
      tile = true, edgeSize = 1, tileSize = 5,
    })
    rotationEditBoxRota5:SetBackdropColor(0, 0, 0, 0.5)
    rotationEditBoxRota5:SetBackdropBorderColor(0.3, 0.3, 0.3, 0.8)
    children["RotationEditBox5"] = rotationEditBoxRota5

    
    -- CREATE BACKUP HEADER
    local optionsFrameBackupHeader = optionsFrame:CreateFontString(nil, 'ARTWORK', "GameFontHighlight")
    optionsFrameBackupHeader:SetPoint('TOPLEFT', optionsFrameRotationEntry5, 'BOTTOMLEFT', 0, -editboxSpacing)
    optionsFrameBackupHeader:SetText('Backup')
    children["BackupHeader"] = optionsFrameBackupHeader

    -- CREATE BACKUP ENTRY 1 HEADER
    local optionsFrameBackupEntry1 = optionsFrame:CreateFontString(nil, 'ARTWORK', "GameFontHighlight")
    optionsFrameBackupEntry1:SetPoint('LEFT', optionsFrameBackupHeader, 'BOTTOMLEFT', 0, -editboxSpacing)
    optionsFrameBackupEntry1:SetWidth(10)
    optionsFrameBackupEntry1:SetText('1')
    children["BackupLabel1"] = optionsFrameBackupEntry1
    
    -- CREATE BACKUP ENTRY 1 EDITBOX
    local rotationBackupEditBox1 = CreateFrame('editbox', nil, optionsFrame)
    rotationBackupEditBox1:SetPoint('LEFT', optionsFrameBackupEntry1, 'RIGHT', 5, 0)
    rotationBackupEditBox1:SetSize(120, 20)
    rotationBackupEditBox1:SetFontObject(GameFontHighlightSmall)
    rotationBackupEditBox1:SetAutoFocus(false)
    rotationBackupEditBox1:SetJustifyH('CENTER')
    rotationBackupEditBox1:SetScript('OnEscapePressed', function(self)
      self:ClearFocus()
    end)
    rotationBackupEditBox1:SetScript('OnEnterPressed', function(self)
      self:ClearFocus()
    end)

    rotationBackupEditBox1:SetBackdrop({
      bgFile = 'Interface/ChatFrame/ChatFrameBackground',
      edgeFile = 'Interface/ChatFrame/ChatFrameBackground',
      tile = true, edgeSize = 1, tileSize = 5,
    })
    rotationBackupEditBox1:SetBackdropColor(0, 0, 0, 0.5)
    rotationBackupEditBox1:SetBackdropBorderColor(0.3, 0.3, 0.3, 0.8)
    children["BackupEditBox1"] = rotationBackupEditBox1

    -- CREATE BACKUP ENTRY 2 HEADER
    local optionsFrameBackupEntry2 = optionsFrame:CreateFontString(nil, 'ARTWORK', "GameFontHighlight")
    optionsFrameBackupEntry2:SetPoint('LEFT', optionsFrameBackupEntry1, 'BOTTOMLEFT', 0, -editboxSpacing)
    optionsFrameBackupEntry2:SetWidth(10)
    optionsFrameBackupEntry2:SetText('2')
    children["BackupLabel2"] = optionsFrameBackupEntry2
    
    -- CREATE BACKUP ENTRY 2 EDITBOX
    local rotationBackupEditBox2 = CreateFrame('editbox', nil, optionsFrame)
    rotationBackupEditBox2:SetPoint('LEFT', optionsFrameBackupEntry2, 'RIGHT', 5, 0)
    rotationBackupEditBox2:SetSize(120, 20)
    rotationBackupEditBox2:SetFontObject(GameFontHighlightSmall)
    rotationBackupEditBox2:SetAutoFocus(false)
    rotationBackupEditBox2:SetJustifyH('CENTER')
    rotationBackupEditBox2:SetScript('OnEscapePressed', function(self)
      self:ClearFocus()
    end)
    rotationBackupEditBox2:SetScript('OnEnterPressed', function(self)
      self:ClearFocus()
    end)

    rotationBackupEditBox2:SetBackdrop({
      bgFile = 'Interface/ChatFrame/ChatFrameBackground',
      edgeFile = 'Interface/ChatFrame/ChatFrameBackground',
      tile = true, edgeSize = 1, tileSize = 5,
    })
    rotationBackupEditBox2:SetBackdropColor(0, 0, 0, 0.5)
    rotationBackupEditBox2:SetBackdropBorderColor(0.3, 0.3, 0.3, 0.8)
    children["BackupEditBox2"] = rotationBackupEditBox2

    -- CREATE BACKUP ENTRY 3 HEADER
    local optionsFrameBackupEntry3 = optionsFrame:CreateFontString(nil, 'ARTWORK', "GameFontHighlight")
    optionsFrameBackupEntry3:SetPoint('LEFT', optionsFrameBackupEntry2, 'BOTTOMLEFT', 0, -editboxSpacing)
    optionsFrameBackupEntry3:SetWidth(10)
    optionsFrameBackupEntry3:SetText('3')
    children["BackupLabel3"] = optionsFrameBackupEntry3
    
    -- CREATE BACKUP ENTRY 3 EDITBOX
    local rotationBackupEditBox3 = CreateFrame('editbox', nil, optionsFrame)
    rotationBackupEditBox3:SetPoint('LEFT', optionsFrameBackupEntry3, 'RIGHT', 5, 0)
    rotationBackupEditBox3:SetSize(120, 20)
    rotationBackupEditBox3:SetFontObject(GameFontHighlightSmall)
    rotationBackupEditBox3:SetAutoFocus(false)
    rotationBackupEditBox3:SetJustifyH('CENTER')
    rotationBackupEditBox3:SetScript('OnEscapePressed', function(self)
      self:ClearFocus()
    end)
    rotationBackupEditBox3:SetScript('OnEnterPressed', function(self)
      self:ClearFocus()
    end)

    rotationBackupEditBox3:SetBackdrop({
      bgFile = 'Interface/ChatFrame/ChatFrameBackground',
      edgeFile = 'Interface/ChatFrame/ChatFrameBackground',
      tile = true, edgeSize = 1, tileSize = 5,
    })
    rotationBackupEditBox3:SetBackdropColor(0, 0, 0, 0.5)
    rotationBackupEditBox3:SetBackdropBorderColor(0.3, 0.3, 0.3, 0.8)
    children["BackupEditBox3"] = rotationBackupEditBox3


    -- CREATE SUBMIT BUTTON
    local rotationButtonSend = CreateFrame('button', nil, optionsFrame, 'UIPanelButtonTemplate')
    rotationButtonSend:SetSize(80, 20)
    rotationButtonSend:SetText("Send")
    rotationButtonSend:SetPoint('BOTTOM', optionsFrame, 'BOTTOM', 0, 5)
    rotationButtonSend:SetScript('OnClick', function(self)
      local msg = ''
      for n = 1,5 do
        msg = msg ..optionsFrame["children"]["RotationEditBox" ..n]:GetText() ..":"
      end
      for n = 1,3 do
        msg = msg ..optionsFrame["children"]["BackupEditBox" ..n]:GetText() ..(n == 3 and "" or ":")
      end

      SendAddonMessage('DTWA_ROTA', msg, 'RAID')
    end)

    optionsFrame:Show()
    DT = optionsFrame
  else
    if DT:IsShown() then
      DT:Hide()
    else
      DT:Show()
    end
  end
end

DTS:Open()