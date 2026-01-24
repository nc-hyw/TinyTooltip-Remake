
local LibEvent = LibStub:GetLibrary("LibEvent.7000")

local YOU = YOU
local NONE = NONE
local EMPTY = EMPTY
local TARGET = TARGET
local TOOLTIP_UPDATE_TIME = TOOLTIP_UPDATE_TIME or 0.2

local addon = TinyTooltip

local function SafeBool(fn, ...)
    local ok, value = pcall(fn, ...)
    if ok and type(value) == "boolean" then
        return value
    end
    return false
end

local function GetTargetString(unit)
    if (not UnitExists(unit)) then return end
    local name = UnitName(unit)
    local icon = addon:GetRaidIcon(unit) or ""
    if SafeBool(UnitIsUnit, unit, "player") then
        return format("|cffff3333>>%s<<|r", strupper(YOU))
    elseif SafeBool(UnitIsPlayer, unit) then
        local class = select(2, UnitClass(unit))
        local colorCode = select(4, GetClassColor(class))
        return format("%s|c%s%s|r", icon, colorCode, name)
    elseif SafeBool(UnitIsOtherPlayersPet, unit) then
        return format("%s|cff%s<%s>|r", icon, addon:GetHexColor(GameTooltip_UnitColor(unit)), name)
    else
        return format("%s|cff%s[%s]|r", icon, addon:GetHexColor(GameTooltip_UnitColor(unit)), name)
    end
end

GameTooltip:HookScript("OnUpdate", function(self, elapsed)
    self.updateElapsed = (self.updateElapsed or 0) + elapsed
    if (self.updateElapsed >= TOOLTIP_UPDATE_TIME) then
        self.updateElapsed = 0
        if (not UnitExists("mouseover")) then return end
        local isPlayer = SafeBool(UnitIsPlayer, "mouseover")
        if (addon.db.unit.player.showTarget and isPlayer)
            or (addon.db.unit.npc.showTarget and not isPlayer) then
            local line = addon:FindLine(self, "^"..TARGET..":")
            local text = GetTargetString("mouseovertarget")
            local changed = false
            if (line and not text) then
                addon:HideLine(self, "^"..TARGET..":")
                changed = true
            elseif (text) then
                local formatted = format("%s: %s", TARGET, text)
                if (not line) then
                    self:AddLine(formatted)
                    changed = true
                elseif (line:GetText() ~= formatted) then
                    line:SetText(formatted)
                    changed = true
                end
            end
            if (changed) then
                self:Show()
            end
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
