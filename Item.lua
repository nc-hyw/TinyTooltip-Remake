
local LibEvent = LibStub:GetLibrary("LibEvent.7000")

local addon = TinyTooltip

local function GetItemInfoFromLink(linkOrId)
    local name, link, quality, _, _, _, _, stackCount, _, texture = GetItemInfo(linkOrId)
    if (not name) then return nil end
    return {
        itemLink = link,
        itemQuality = quality,
        itemStackCount = stackCount,
        itemTexture = texture,
    }
end

local function ColorBorder(tip, r, g, b)
    if (addon.db.item.coloredItemBorder) then
        LibEvent:trigger("tooltip.style.border.color", tip, r, g, b)
    else
        LibEvent:trigger("tooltip.style.border.color", tip, unpack(addon.db.general.borderColor))
    end
end

local function ItemIcon(tip, itemInfo)
    if (addon.db.item.showItemIcon) then
        local texture = itemInfo and itemInfo.itemTexture
        local text = addon:GetLine(tip,1):GetText()
        if (texture and not strfind(text, "^|T")) then
            addon:GetLine(tip,1):SetFormattedText("|T%s:16:16:0:0:32:32:2:30:2:30|t %s", texture, text)
        end
    end
end

local function ItemStackCount(tip, itemInfo)
    if (addon.db.item.showStackCount) then
        local stackCount = itemInfo and itemInfo.itemStackCount
        if (stackCount and stackCount > 1) then
            local text = addon:GetLine(tip,1):GetText() .. format(" |cff00eeee/%s|r", stackCount)
            addon:GetLine(tip,1):SetText(text)
        end
    end
end

LibEvent:attachTrigger("tooltip:item", function(self, tip, link)
    local itemInfo = GetItemInfoFromLink(link)
    local quality = (itemInfo and itemInfo.itemQuality) or 0
    local r, g, b = GetItemQualityColor(quality)
    ColorBorder(tip, r, g, b)
    ItemStackCount(tip, itemInfo)
    ItemIcon(tip, itemInfo)
end)
