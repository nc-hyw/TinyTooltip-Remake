local NUM_CHAT_WINDOWS = NUM_CHAT_WINDOWS
    or (Constants and Constants.ChatFrameConstants and Constants.ChatFrameConstants.MaxChatWindows)
    or 10

local supportedHyperlinkTypes = {
    achievement = true,
    battlepet = true,
    currency = true,
    enchant = true,
    item = true,
    quest = true,
    spell = true,
}

local hookedFrames = {}
local showingTooltip

local function GetLinkType(link)
    if (type(link) ~= "string") then return end
    return link:match("^([^:]+):")
end

local function OnHyperlinkEnter(frame, link, text)
    local linkType = GetLinkType(link)
    if (linkType) then
        linkType = string.lower(linkType)
    end
    if (not linkType or not supportedHyperlinkTypes[linkType]) then return end

    -- Clear any previous tooltip state before showing chat-link tooltips.
    GameTooltip:Hide()

    if (GameTooltip_SetDefaultAnchor) then
        GameTooltip_SetDefaultAnchor(GameTooltip, frame)
    else
        GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
    end

    if (linkType == "battlepet" and BattlePetToolTip_ShowLink and BattlePetTooltip) then
        showingTooltip = BattlePetTooltip
        BattlePetToolTip_ShowLink(text)
        return
    end

    showingTooltip = GameTooltip
    local ok = pcall(GameTooltip.SetHyperlink, GameTooltip, link)
    if (ok) then
        GameTooltip:Show()
    else
        showingTooltip = nil
    end
end

local function OnHyperlinkLeave()
    if (showingTooltip and showingTooltip.Hide) then
        showingTooltip:Hide()
    end
    showingTooltip = nil
end

local function HookChatFrame(frame)
    if (not frame or hookedFrames[frame]) then return end
    frame:HookScript("OnHyperlinkEnter", OnHyperlinkEnter)
    frame:HookScript("OnHyperlinkLeave", OnHyperlinkLeave)
    hookedFrames[frame] = true
end

local function HookDefaultChatFrames()
    for i = 1, NUM_CHAT_WINDOWS do
        HookChatFrame(_G["ChatFrame" .. i])
    end
end

local function HookCommunitiesChatFrame()
    local frame = CommunitiesFrame and CommunitiesFrame.Chat and CommunitiesFrame.Chat.MessageFrame
    HookChatFrame(frame)
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("UPDATE_CHAT_WINDOWS")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(_, event, addonName)
    if (event == "ADDON_LOADED") then
        if (addonName == "Blizzard_Communities") then
            HookCommunitiesChatFrame()
        end
        return
    end
    HookDefaultChatFrames()
    HookCommunitiesChatFrame()
end)
