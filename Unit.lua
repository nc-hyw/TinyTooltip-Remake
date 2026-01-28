
local LibEvent = LibStub:GetLibrary("LibEvent.7000")

local AFK = AFK
local DND = DND
local PVP = PVP
local LEVEL = LEVEL
local OFFLINE = FRIENDS_LIST_OFFLINE
local FACTION_HORDE = FACTION_HORDE
local FACTION_ALLIANCE = FACTION_ALLIANCE

local addon = TinyTooltip

local function SafeBool(fn, ...)
    local ok, value = pcall(fn, ...)
    if (not ok) then
        return false
    end
    local okEval, result = pcall(function()
        return value == true
    end)
    if (okEval) then
        return result
    end
    return false
end

local function strip(text)
    return (text:gsub("%s+([|%x%s]+)<trim>", "%1"))
end

local function SafeStripText(text)
    if not text then return end
    local ok, stripped = pcall(function()
        if (type(text) ~= "string") then return end
        local s = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
        s = strtrim(s or "")
        if (s == "") then return end
        return s
    end)
    if ok then
        return stripped
    end
end

local function HideOriginalSpecLine(tip, target)
    if (not target or target == "") then return end
    for i = 2, tip:NumLines() do
        local line = _G[tip:GetName() .. "TextLeft" .. i]
        local text = line and line:GetText()
        local stripped = SafeStripText(text)
        if (stripped and stripped == target) then
                line:SetText(nil)
                line:Show()
        end
    end
end

local function GetOriginalSpecLine(tip, className)
    if (not className or className == "") then return end
    local best, bestLen
    for i = 2, tip:NumLines() do
        local line = _G[tip:GetName() .. "TextLeft" .. i]
        local text = line and line:GetText()
        local stripped = SafeStripText(text)
        if (stripped) then
            local ok, match = pcall(function()
                if (stripped:find("^%d")) then return false end
                if (stripped:find("^<")) then return false end
                return stripped:find(className, 1, true) ~= nil
            end)
            if (ok and match) then
                local len = #stripped
                if (not bestLen or len < bestLen) then
                    best = stripped
                    bestLen = len
                end
            end
        end
    end
    return best
end

local function ColorBorder(tip, config, raw)
    if (config.coloredBorder and addon.colorfunc[config.coloredBorder]) then
        local r, g, b = addon.colorfunc[config.coloredBorder](raw)
        LibEvent:trigger("tooltip.style.border.color", tip, r, g, b)
    elseif (type(config.coloredBorder) == "string" and config.coloredBorder ~= "default") then
        local r, g, b = addon:GetRGBColor(config.coloredBorder)
        if (r and g and b) then
            LibEvent:trigger("tooltip.style.border.color", tip, r, g, b)
        end
    else
        LibEvent:trigger("tooltip.style.border.color", tip, unpack(addon.db.general.borderColor))
    end
end

local function ColorBackground(tip, config, raw)
    local bg = config.background
    if not bg then return end
    if (bg.colorfunc == "default" or bg.colorfunc == "" or bg.colorfunc == "inherit") then
        local r, g, b, a = unpack(addon.db.general.background)
        a = bg.alpha or a
        LibEvent:trigger("tooltip.style.background", tip, r, g, b, a)
        return
    end
    if (addon.colorfunc[bg.colorfunc]) then
        local r, g, b = addon.colorfunc[bg.colorfunc](raw)
        local a = bg.alpha or 0.8
        LibEvent:trigger("tooltip.style.background", tip, r, g, b, a)
    end
end

local function GrayForDead(tip, config, unit)
    if (config.grayForDead and SafeBool(UnitIsDeadOrGhost, unit)) then
        local line, text
        LibEvent:trigger("tooltip.style.border.color", tip, 0.6, 0.6, 0.6)
        LibEvent:trigger("tooltip.style.background", tip, 0.1, 0.1, 0.1)
        for i = 1, tip:NumLines() do
            line = _G[tip:GetName() .. "TextLeft" .. i]
            text = (line:GetText() or ""):gsub("|cff%x%x%x%x%x%x", "|cffaaaaaa")
            line:SetTextColor(0.7, 0.7, 0.7)
            line:SetText(text)
        end
    end
end

local function ShowBigFactionIcon(tip, config, raw)
    if (config.elements.factionBig and config.elements.factionBig.enable and tip.BigFactionIcon and (raw.factionGroup=="Alliance" or raw.factionGroup == "Horde")) then
        tip.BigFactionIcon:Show()
        tip.BigFactionIcon:SetTexture("Interface\\Timer\\".. raw.factionGroup .."-Logo")
        tip:Show()
        tip:SetMinimumWidth(tip:GetWidth() + 30)
    end
end

local function PlayerCharacter(tip, unit, config, raw)
    local specLine = GetOriginalSpecLine(tip, raw and raw.className)
    if (specLine) then
        raw.className = specLine
        HideOriginalSpecLine(tip, specLine)
    end
    local data = addon:GetUnitData(unit, config.elements, raw)
    addon:HideLines(tip, 2, 3)
    addon:HideLine(tip, "^"..LEVEL)
    addon:HideLine(tip, "^"..FACTION_ALLIANCE)
    addon:HideLine(tip, "^"..FACTION_HORDE)
    addon:HideLine(tip, "^"..PVP)
    for i, v in ipairs(data) do
        addon:GetLine(tip,i):SetText(strip(table.concat(v, " ")))
    end
    ColorBorder(tip, config, raw)
    ColorBackground(tip, config, raw)
    GrayForDead(tip, config, unit)
    ShowBigFactionIcon(tip, config, raw)
end

local function NonPlayerCharacter(tip, unit, config, raw)
    local levelLine = addon:FindLine(tip, "^"..LEVEL)
    if (levelLine or tip:NumLines() > 1) then
        local data = addon:GetUnitData(unit, config.elements, raw)
        local titleLine = addon:GetNpcTitle(tip)
        local increase = 0
        for i, v in ipairs(data) do
            if (i == 1) then
                addon:GetLine(tip,i):SetText(table.concat(v, " "))
            end
            if (i == 2) then
                if (config.elements.npcTitle.enable and titleLine) then
                    titleLine:SetText(addon:FormatData(titleLine:GetText(), config.elements.npcTitle, raw))
                    increase = 1
                end
                i = i + increase
                addon:GetLine(tip,i):SetText(table.concat(v, " "))
            elseif ( i > 2) then
                i = i + increase
                addon:GetLine(tip,i):SetText(table.concat(v, " "))
            end
        end
    end
    addon:HideLine(tip, "^"..LEVEL)
    addon:HideLine(tip, "^"..PVP)
    ColorBorder(tip, config, raw)
    ColorBackground(tip, config, raw)
    GrayForDead(tip, config, unit)
    ShowBigFactionIcon(tip, config, raw)
    addon:AutoSetTooltipWidth(tip)
end

LibEvent:attachTrigger("tooltip:unit", function(self, tip, unit)
    if (not unit or not SafeBool(UnitExists, unit)) then return end
    local raw = addon:GetUnitInfo(unit)
    if (SafeBool(UnitIsPlayer, unit)) then
        PlayerCharacter(tip, unit, addon.db.unit.player, raw)
    else
        NonPlayerCharacter(tip, unit, addon.db.unit.npc, raw)
    end
end)

addon.ColorUnitBorder = ColorBorder
addon.ColorUnitBackground = ColorBackground
