despiTools = {}
local DT = despiTools
DT.spells = {
    [132409] = {
        ["name"] = "Spell Lock",
        ["cd"] = 24,
    },
    [119911] = {
        ["name"] = "Optical Blast",
        ["cd"] = 24,
    },
    [116705] = {
        ["name"] = "Spear Hand Strike",
        ["cd"] = 15,
    },
    [147362] = {
        ["name"] = "Counter Shot",
        ["cd"] = 24,
    },
    [96231] = {
        ["name"] = "Rebuke",
        ["cd"] = 15,
    },
    [106839] = {
        ["name"] = "Skull Bash",
        ["cd"] = 15,
    },
    [78675] = {
        ["name"] = "Solar Beam",
        ["cd"] = 60,
    },
    [47528] = {
        ["name"] = "Mind Freeze",
        ["cd"] = 15,
    }
}

InterruptManager = {}
local IM = InterruptManager
local interruptSpells

function IM.GetInterruptSpells()
    interruptSpells =
{
            -- spellNames (The first Spell Lock ID 132409, is the spell gained from Grimoire of Sacrifice)
    ["spellName"] = {"Spell Lock", "Optical Blast", "Spear Hand Strike", "Counter Shot", "Rebuke", "Skull Bash", "Solar Beam", "Mind Freeze", "Counterspell", "Kick", "Wind Shear", "Spell Lock", "Pummel", "Silence", "Consume Magic", "Call Felhunter", "Muzzle"},
            -- spellIds
    ["spellId"]  =  {132409,       119911,          116705,              147362,         96231,    106839,       78675,        47528,         2139,           1766,   57994,        119910,       6552,     15487,     183752,          212619,           187707},
            -- spellCooldowns
    ["cooldown"]  = {24,           24,              15,                  24,             15,       15,           60,           15,            24,             15,     12,           24,           15,       45,        15,              24,               15},
}
    
    return interruptSpells
end



interruptSpells = IM.GetInterruptSpells()

--[[local function AddSpellModifier(ID, func)
    if (not IM.spellModifierFunctions) then
        IM.spellModifierFunctions = {}
        IM.spellModifiers = {}
    end
    
    tinsert(IM.spellModifiers, ID)
    IM.spellModifierFunctions[ID] = func
end

-- All modifiers need to be listed below here! Otherwise, they will not be added to the tables

-- Usage: AddSpellModifier(ID, overrideFunction)
-- Where ID is a unique value to identify each modifying trigger, and overrideFunction is
-- the function to be called when the player with the modification uses their interrupt.
-- Only one override is currently supported, and only upon interrupt spell cast success.

-- For glyphs that modify spell behavior, pass the spellID of the glyph as the first argument. No further
-- editing is required for them to take effect.

-- For any other effects, pass any unique ID as the first argument. Strings are accepted.
-- There is no automation in broadcasting non-glyph spell modifiers. These must be coded
-- individually.
local function GlyphOfSilence(...)
    local a = ...
    a.cooldown = 20
    a.readyTime = GetTime() + 20
    a.ready = false
    IM:UpdateInterruptRotation()
    IM:PugModeInterruptHandler()
end
AddSpellModifier(159626, GlyphOfSilence)

local function GlyphOfRebuke(...)
    local a = ...
    a.cooldown = 20
    a.readyTime = GetTime() + 20
    a.ready = false
    IM:UpdateInterruptRotation()
    IM:PugModeInterruptHandler()
end
AddSpellModifier(54925, GlyphOfRebuke)

local function GlyphOfSkullBash(...)
    local a = ...
    a.cooldown = 20
    a.readyTime = GetTime() + 20
    a.ready = false
    IM:UpdateInterruptRotation()
    IM:PugModeInterruptHandler()
end
AddSpellModifier(116216, GlyphOfSkullBash)

local function GlyphOfMindFreeze(...)
    local a = ...
    a.cooldown = 20
    a.readyTime = GetTime() + 20
    a.ready = false
    IM:UpdateInterruptRotation()
    IM:PugModeInterruptHandler()
end
AddSpellModifier(58686, GlyphOfMindFreeze)

local function GlyphOfCounterspell(...)
    local a = ...
    a.cooldown = 20
    a.readyTime = GetTime() + 20
    a.ready = false
    IM:UpdateInterruptRotation()
    IM:PugModeInterruptHandler()
end
AddSpellModifier(115703, GlyphOfCounterspell)

local function GlyphOfWindShear(...)
    local a = ...
    a.cooldown = 20
    a.readyTime = GetTime() + 20
    a.ready = false
    IM:UpdateInterruptRotation()
    IM:PugModeInterruptHandler()
end
AddSpellModifier(55451, GlyphOfWindShear)

local function GlyphOfKick(...)
    local a, event = ...
    
    if (event == "SPELL_CAST_SUCCESS") then
        a.cooldown = 19
        a.readyTime = GetTime() + 19
        a.ready = false
        IM:UpdateInterruptRotation()
        IM:PugModeInterruptHandler()
    elseif (event == "SPELL_INTERRUPT") then
        a.cooldown = 13
        a.readyTime = GetTime() + 13
        a.ready = false
        IM:UpdateInterruptRotation()
        IM:PugModeInterruptHandler()
    end
end
AddSpellModifier(56805, GlyphOfKick)

]]





