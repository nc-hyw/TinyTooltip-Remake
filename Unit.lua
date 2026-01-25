
local LibEvent = LibStub:GetLibrary("LibEvent.7000")

local AFK = AFK
local DND = DND
local PVP = PVP
local LEVEL = LEVEL
local OFFLINE = FRIENDS_LIST_OFFLINE
local FACTION_HORDE = FACTION_HORDE
local FACTION_ALLIANCE = FACTION_ALLIANCE

local addon = TinyTooltip

-- 默认匹配模式（如果本地化文件没有定义，使用这些）
local defaultHintPatterns = {
    "右键",              -- 中文：右键
    "Right.*[Cc]lick",  -- 英文：Right-click
    "设置框体",          -- 中文：设置框体
    "设置",              -- 中文：设置
    "[Ss]etup",         -- 英文：Setup
    "[Ff]ocus",         -- 英文：Focus
    "焦点",              -- 中文：焦点
    "框体",              -- 中文：框体
}

-- 缓存匹配模式列表（避免每次调用都检查本地化文件）
local cachedHintPatterns = nil
local function GetHintPatterns()
    if (cachedHintPatterns) then
        return cachedHintPatterns
    end
    local patterns = addon.L["general.hideUnitFrameHint.patterns"]
    if (type(patterns) == "table" and #patterns > 0) then
        cachedHintPatterns = patterns
    else
        cachedHintPatterns = defaultHintPatterns
    end
    return cachedHintPatterns
end

-- 检查文本是否匹配提示模式（优化：提前返回）
local function IsHintText(plainText)
    if (not plainText or plainText == "") then return false end
    
    local patterns = GetHintPatterns()
    for _, pattern in ipairs(patterns) do
        if (strfind(plainText, pattern)) then
            return true
        end
    end
    
    return false
end

-- 清理文本中的颜色代码和空白（缓存函数，避免重复创建）
local function StripTooltipText(text)
    if (not text) then return "" end
    return text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("|T[^|]+|t", ""):gsub("^%s+", ""):gsub("%s+$", "")
end

-- 检查文本是否为空（优化版本）
local function IsEmptyText(text)
    if (not text) then return true end
    local stripped = text:gsub("^%s+", ""):gsub("%s+$", "")
    return stripped == ""
end

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

local function HideRightClickSetupText(tip)
    if (not addon.db.general.hideUnitFrameHint) then return false end
    
    local numLines = tip:NumLines()
    if (numLines < 2) then return false end
    
    -- 缓存 tip 名称，避免重复调用 GetName()
    local tipName = tip:GetName()
    local removed = false
    
    -- 首先移除所有包含右键设置提示的行及其上方的空行
    for i = numLines, 2, -1 do
        local line = _G[tipName .. "TextLeft" .. i]
        if (line) then
            local ok, text = pcall(function() return line:GetText() end)
            if (ok and text) then
                -- 使用优化的文本清理函数
                local plainText = StripTooltipText(text)
                -- 匹配右键设置相关的提示文本（从本地化文件读取模式）
                if (IsHintText(plainText)) then
                    line:SetText(nil)
                    removed = true
                    -- 向上查找并移除所有连续的空行
                    for j = i - 1, 2, -1 do
                        local prevLine = _G[tipName .. "TextLeft" .. j]
                        if (prevLine) then
                            local okPrev, prevText = pcall(function() return prevLine:GetText() end)
                            if (okPrev and IsEmptyText(prevText)) then
                                prevLine:SetText(nil)
                                removed = true
                            else
                                -- 遇到非空行，停止
                                break
                            end
                        else
                            break
                        end
                    end
                end
            end
        end
    end
    
    -- 然后移除tooltip末尾的所有空行（可能是为提示预留的）
    local trailingEmptyCount = 0
    for i = numLines, 2, -1 do
        local line = _G[tipName .. "TextLeft" .. i]
        if (line) then
            local ok, text = pcall(function() return line:GetText() end)
            if (ok and IsEmptyText(text)) then
                trailingEmptyCount = trailingEmptyCount + 1
            else
                -- 遇到非空行，停止
                break
            end
        else
            break
        end
    end
    
    -- 如果末尾有1行或更多空行，移除它们（通常提示前会有1-2行空行）
    if (trailingEmptyCount >= 1) then
        for i = numLines, max(2, numLines - trailingEmptyCount + 1), -1 do
            local line = _G[tipName .. "TextLeft" .. i]
            if (line) then
                local ok, text = pcall(function() return line:GetText() end)
                if (ok and IsEmptyText(text)) then
                    line:SetText(nil)
                    removed = true
                end
            end
        end
    end
    
    -- 检查最后几行中是否有其他空行（可能是为提示预留的）
    -- 检查最后5行，移除其中的空行
    local checkRange = min(5, numLines - 1)
    if (checkRange >= 1) then
        for i = numLines, max(2, numLines - checkRange), -1 do
            local line = _G[tipName .. "TextLeft" .. i]
            if (line) then
                local ok, text = pcall(function() return line:GetText() end)
                if (ok and IsEmptyText(text)) then
                    -- 检查前后行，如果前后都有内容，这个空行可能是为提示预留的
                    local prevLine = (i > 2) and _G[tipName .. "TextLeft" .. (i - 1)] or nil
                    local nextLine = (i < numLines) and _G[tipName .. "TextLeft" .. (i + 1)] or nil
                    local prevHasContent = false
                    local nextHasContent = false
                    
                    if (prevLine) then
                        local okPrev, prevText = pcall(function() return prevLine:GetText() end)
                        prevHasContent = okPrev and prevText and not IsEmptyText(prevText)
                    end
                    
                    if (nextLine) then
                        local okNext, nextText = pcall(function() return nextLine:GetText() end)
                        nextHasContent = okNext and nextText and not IsEmptyText(nextText)
                    end
                    
                    -- 如果前后都有内容，这个空行可能是为提示预留的，移除它
                    if (prevHasContent and nextHasContent) then
                        line:SetText(nil)
                        removed = true
                    end
                end
            end
        end
    end
    
    return removed
end

-- Hook AddLine方法来阻止添加右键设置提示及其前面的空行
local function HookTooltipAddLine(tip)
    if (tip._addLineHooked) then return end
    tip._addLineHooked = true
    
    local originalAddLine = tip.AddLine
    local emptyLineCount = 0  -- 记录连续的空行数量
    local tipName = tip:GetName()  -- 缓存 tip 名称
    
    tip.AddLine = function(self, text, r, g, b, wrap)
        -- 如果功能未启用，直接调用原始方法（提前返回，避免不必要的检查）
        if (not addon.db.general.hideUnitFrameHint) then
            return originalAddLine(self, text, r, g, b, wrap)
        end
        
        -- 检查是否是空行（使用优化的函数）
        local isEmpty = IsEmptyText(text)
        if (isEmpty) then
            emptyLineCount = emptyLineCount + 1
            
            -- 如果tooltip末尾已经有空行，且正在添加新的空行，可能是为提示预留的，阻止添加
            if (self:IsShown() and emptyLineCount >= 1) then
                local numLines = self:NumLines()
                if (numLines >= 2) then
                    -- 检查最后一行是否已经是空行
                    local lastLine = _G[tipName .. "TextLeft" .. numLines]
                    if (lastLine) then
                        local ok, lastText = pcall(function() return lastLine:GetText() end)
                        if (ok and IsEmptyText(lastText)) then
                            return
                        end
                    end
                end
            end
        else
            -- 使用优化的文本清理函数
            local plainText = StripTooltipText(text)
            -- 如果是右键设置提示，直接阻止添加（从本地化文件读取模式）
            if (IsHintText(plainText)) then
                -- 阻止添加提示行，同时移除之前添加的空行
                emptyLineCount = 0
                -- 立即移除末尾的空行（不延迟，确保同步）
                local numLines = self:NumLines()
                -- 移除末尾的空行（最多移除3行，确保移除所有可能的空行）
                local removedCount = 0
                for i = numLines, max(2, numLines - 3), -1 do
                    local line = _G[tipName .. "TextLeft" .. i]
                    if (line) then
                        local ok, lineText = pcall(function() return line:GetText() end)
                        if (ok and IsEmptyText(lineText)) then
                            line:SetText(nil)
                            removedCount = removedCount + 1
                        else
                            break
                        end
                    end
                end
                -- 如果还有空行残留，延迟再检查一次
                if (removedCount > 0) then
                    C_Timer.After(0.05, function()
                        if (self:IsShown()) then
                            HideRightClickSetupText(self)
                        end
                    end)
                end
                return
            end
            -- 如果遇到非空非提示的行，重置空行计数
            emptyLineCount = 0
        end
        
        -- 如果累积了2个或更多空行，且tooltip正在显示，可能是为提示预留的空行
        -- 阻止添加这些空行
        if (isEmpty and emptyLineCount >= 2 and self:IsShown()) then
            -- 检查tooltip的最后几行是否都是空行
            local numLines = self:NumLines()
            if (numLines >= 2) then
                local allEmpty = true
                for i = max(2, numLines - emptyLineCount + 1), numLines do
                    local line = _G[tipName .. "TextLeft" .. i]
                    if (line) then
                        local ok, lineText = pcall(function() return line:GetText() end)
                        if (ok and lineText and not IsEmptyText(lineText)) then
                            allEmpty = false
                            break
                        end
                    end
                end
                -- 如果末尾都是空行，阻止添加新的空行
                if (allEmpty) then
                    return
                end
            end
        end
        
        -- 调用原始方法
        return originalAddLine(self, text, r, g, b, wrap)
    end
end

-- 持续检查并移除空行和提示（用于头像框等可能延迟添加的情况）
local function SetupContinuousCleanup(tip)
    if (tip._cleanupHooked) then return end
    tip._cleanupHooked = true
    
    -- 在OnUpdate中检查（但不要太频繁）
    local lastCheck = 0
    local lastLineCount = 0  -- 缓存行数，如果行数没变化就不需要检查
    tip:HookScript("OnUpdate", function(self, elapsed)
        if (not addon.db.general.hideUnitFrameHint) then return end
        
        -- 如果tooltip未显示，跳过检查
        if (not self:IsShown()) then
            lastCheck = 0
            lastLineCount = 0
            return
        end
        
        lastCheck = lastCheck + elapsed
        -- 每0.2秒检查一次（优化：只在行数变化时检查）
        if (lastCheck >= 0.2) then
            local currentLineCount = self:NumLines()
            -- 如果行数发生变化，才执行清理
            if (currentLineCount ~= lastLineCount) then
                lastLineCount = currentLineCount
                HideRightClickSetupText(self)
            end
            lastCheck = 0
        end
    end)
end

local function PlayerCharacter(tip, unit, config, raw)
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
    
    -- 隐藏右键设置提示
    if (addon.db.general.hideUnitFrameHint) then
        HookTooltipAddLine(tip)
        -- 延迟检查一次，清除可能已经存在的提示
        if (not tip._hideCheckScheduled) then
            tip._hideCheckScheduled = true
            C_Timer.After(0.1, function()
                tip._hideCheckScheduled = nil
                if (tip:IsShown()) then
                    HideRightClickSetupText(tip)
                end
            end)
        end
    end
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
    
    -- 隐藏右键设置提示
    if (addon.db.general.hideUnitFrameHint) then
        HookTooltipAddLine(tip)
        -- 延迟检查一次，清除可能已经存在的提示
        if (not tip._hideCheckScheduled) then
            tip._hideCheckScheduled = true
            C_Timer.After(0.1, function()
                tip._hideCheckScheduled = nil
                if (tip:IsShown()) then
                    HideRightClickSetupText(tip)
                end
            end)
        end
    end
    
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
    -- 设置持续清理，确保头像框等场景也能正确移除
    if (addon.db.general.hideUnitFrameHint) then
        SetupContinuousCleanup(tip)
    end
end)

addon.ColorUnitBorder = ColorBorder
addon.ColorUnitBackground = ColorBackground
