despiToolsSettings = despiToolsSettings or {}
local DTS = despiToolsSettings
local DT = {
  ["SPELLS"] = {
    [47528] = {
      ["name"] = "Mind Freeze",
      ["cd"] = 15,
    },
  },
}

local cleu = {
  ["SPELL_CAST_SUCCESS"] = function(...)
    local _,_,name,_,_,_,_,_,_,spellID,spellName = ...
    if UnitInRaid(name) or UnitName("player") == name then
      if DT["SPELLS"][spellID] then
        print(name .." used " ..spellName)
      end
    end
  end,
}

local chatMsgRaid = function(msg, author)
  -- needed?
end

local trackedEvents = {
  ["COMBAT_LOG_EVENT_UNFILTERED"] = function(ts, subevent, ...)
    if cleu[subevent] then
      cleu[subevent](...)
    end
  end,
  ["CHAT_MSG_RAID"] = chatMsgRaid,
  ["CHAT_MSG_RAID_LEADER"] = chatMsgRaid,
  ["CHAT_MSG_ADDON"] = function(prefix, msg, channel, author)
    if not channel == "GUILD" then print(prefix, msg, channel, author) end
    if prefix == "DTWA_REQ" then
      SendAddonMessage("DTWA_ROTA", "testmsg", "RAID")
    end
  end,
}

local function eventHandler(self, event, ...)
  if trackedEvents[event] then
    trackedEvents[event](...)
  end
end

RegisterAddonMessagePrefix("DTWA_REQ")

local eventFrame = CreateFrame("FRAME", "despiToolsEventFrame")
for k,_ in pairs(trackedEvents) do
  eventFrame:RegisterEvent(k)
end
eventFrame:SetScript("OnEvent", eventHandler)

SLASH_DESPITOOLS1 = '/dt'
SLASH_DESPITOOLS3 = '/despitools'
function SlashCmdList.DESPITOOLS(msg, editbox)
    if (string.find(msg, "sync")) then
        print("sync called")
    end
end