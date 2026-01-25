
local LibEvent = LibStub:GetLibrary("LibEvent.7000")

local YOU = YOU
local NONE = NONE
local EMPTY = EMPTY
local TARGET = TARGET
local TOOLTIP_UPDATE_TIME = TOOLTIP_UPDATE_TIME or 0.2

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

local unpack = table.unpack or unpack

local function SafeBoolEval(fn, ...)
    return SafeBool(fn, ...)
end

local function SafeIsUnit(unit, other)
    return SafeBoolEval(UnitIsUnit, unit, other)
end

local function SafeIsPlayer(unit)
    return SafeBoolEval(UnitIsPlayer, unit)
end

local function IsTargetToken(unit)
    if (type(unit) ~= "string") then
        return false
    end
    local ok, res = pcall(function()
        return unit:match("target$")
    end)
    return ok and res ~= nil
end

local function GetTargetString(unit)
    if (IsTargetToken(unit)) then
        local okName, name = pcall(UnitName, unit)
        if (not okName or type(name) ~= "string") then return end
        local icon = addon:GetRaidIcon(unit) or ""
        local r, g, b = GameTooltip_UnitColor(unit)
        if SafeIsUnit(unit, "player") then
            return format("|cffff3333>>%s<<|r", strupper(YOU))
        end
        if SafeIsPlayer(unit) then
            local class = select(2, UnitClass(unit))
            local colorCode = select(4, GetClassColor(class))
            return format("%s|c%s%s|r", icon, colorCode or "ffffffff", name)
        end
        if (r and g and b) then
            return format("%s|cff%s[%s]|r", icon, addon:GetHexColor(r, g, b), name)
        end
        return format("%s[%s]", icon, name)
    end
    if (type(unit) ~= "string") then return end
    if (not SafeBool(UnitExists, unit)) then return end
    local name = UnitName(unit)
    local icon = addon:GetRaidIcon(unit) or ""
    if SafeIsUnit(unit, "player") then
        return format("|cffff3333>>%s<<|r", strupper(YOU))
    elseif SafeIsPlayer(unit) then
        local class = select(2, UnitClass(unit))
        local colorCode = select(4, GetClassColor(class))
        return format("%s|c%s%s|r", icon, colorCode, name)
    elseif SafeBool(UnitIsOtherPlayersPet, unit) then
        return format("%s|cff%s<%s>|r", icon, addon:GetHexColor(GameTooltip_UnitColor(unit)), name)
    else
        return format("%s|cff%s[%s]|r", icon, addon:GetHexColor(GameTooltip_UnitColor(unit)), name)
    end
end

local function UpdateTargetLine(tip, targetUnit)
    local text = GetTargetString(targetUnit)
    local line = tip.ttTargetLine
    if (not text) then
        if (line) then
            line:SetText(nil)
            tip.ttTargetLine = nil
            if (addon.AutoSetTooltipWidth) then
                addon:AutoSetTooltipWidth(tip)
            end
        end
        return
    end
    local formatted = format("%s: %s", TARGET, text)
    if (not line) then
        tip:AddLine(formatted)
        line = _G[tip:GetName() .. "TextLeft" .. tip:NumLines()]
        tip.ttTargetLine = line
    else
        line:SetText(formatted)
    end
    if (addon.AutoSetTooltipWidth) then
        addon:AutoSetTooltipWidth(tip)
    end
    tip:Show()
end

LibEvent:attachTrigger("tooltip:unit", function(self, tip, unit)
    if SafeIsUnit(unit, "player") then
        UpdateTargetLine(tip, "playertarget")
    elseif SafeIsUnit(unit, "mouseover") then
        UpdateTargetLine(tip, "mouseovertarget")
    else
        if (type(unit) ~= "string") then return end
        local okConcat, targetUnit = pcall(function() return unit .. "target" end)
        if (not okConcat or type(targetUnit) ~= "string") then return end
        if (SafeBool(UnitExists, targetUnit)) then
            UpdateTargetLine(tip, targetUnit)
        end
    end
end)

LibEvent:attachTrigger("tooltip:cleared, tooltip:hide", function(self, tip)
    if (tip) then
        tip.ttTargetLine = nil
    end
end)

GameTooltip:HookScript("OnUpdate", function(self, elapsed)
    self.updateElapsed = (self.updateElapsed or 0) + elapsed
    if (self.updateElapsed >= TOOLTIP_UPDATE_TIME) then
        self.updateElapsed = 0
        local owner = self:GetOwner()
        if (owner and (owner.unit or (owner.GetAttribute and owner:GetAttribute("unit")))) then
            return
        end
        if (not SafeBool(UnitExists, "mouseover")) then return end
        local isPlayer = SafeBool(UnitIsPlayer, "mouseover")
        if (addon.db.unit.player.showTarget and isPlayer)
            or (addon.db.unit.npc.showTarget and not isPlayer) then
            UpdateTargetLine(self, "mouseovertarget")
        end
    end
end)


-- Targeted By

local function GetTargetByString(mouseover, num, tip)
    local count, prefix = 0, IsInRaid() and "raid" or "party"
    local roleIcon, colorCode, name
    local first = true
    local isPlayer = SafeBool(UnitIsPlayer, mouseover)
    for i = 1, num do
        if SafeBool(UnitIsUnit, mouseover, prefix..i.."target") and not SafeBool(UnitIsUnit, prefix..i, "player") then
            count = count + 1
            if (isPlayer or prefix == "party") then
                if (first) then
                    tip:AddLine(format("%s:", addon.L and addon.L.TargetBy or "Targeted By"))
                    first = false
                end
                roleIcon  = addon:GetRoleIcon(prefix..i) or ""
                colorCode = select(4,GetClassColor(select(2,UnitClass(prefix..i))))
                name      = UnitName(prefix..i)
                tip:AddLine("   " .. roleIcon .. " |c" .. colorCode .. name .. "|r")
            end
        end
    end
    if (count > 0 and not isPlayer and prefix ~= "party") then
        return format("|cff33ffff%s|r", count)
    end
end

LibEvent:attachTrigger("tooltip:unit", function(self, tip, unit)
    if (not UnitExists("mouseover")) then return end
    local num = GetNumGroupMembers()
    if (num >= 1) then
        local isPlayer = SafeBool(UnitIsPlayer, "mouseover")
        if (addon.db.unit.player.showTargetBy and isPlayer)
          or (addon.db.unit.npc.showTargetBy and not isPlayer) then
            local text = GetTargetByString("mouseover", num, tip)
            if (text) then
                tip:AddLine(format("%s: %s", addon.L and addon.L.TargetBy or "Targeted By", text), nil, nil, nil, true)
            end
        end
    end
end)
