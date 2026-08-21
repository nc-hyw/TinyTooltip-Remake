
local LibEvent = LibStub:GetLibrary("LibEvent.7000")
local LibSchedule = LibStub:GetLibrary("LibSchedule.7000")

local addon = TinyTooltip
local L = addon.L or {}
local mounts = {}

if (not C_MountJournal) then return end

local function GetAllMountSource()
    local mountIDs = C_MountJournal.GetMountIDs()
    local name, spellID, isCollected, source
    for i, mountID in ipairs(mountIDs) do
        name, spellID, _, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetMountInfoByID(mountID)
        if (spellID) then
            _, _, source = C_MountJournal.GetMountInfoExtraByID(mountID)
            if (type(source) == "string") then
                source = strtrim(source)
                while (source:sub(-2) == "|n") do
                    source = strtrim(source:sub(1, -3))
                end
            end
            mounts[spellID] = {
                source = source,
                isCollected = isCollected,
                mountID = mountID,
                name = name,
            }
        end
    end
    if (#mounts > 0) then return true end
end

LibEvent:attachEvent("VARIABLES_LOADED", function()
    LibSchedule:AddTask({
        identity = "GetAllMountSource",
        elasped  = 10,
        begined  = GetTime() + 2,
        expired  = GetTime() + 100,
        override = true,
        onExecute = GetAllMountSource,
    })
end)

LibEvent:attachTrigger("tooltip:aura", function(self, tip, spellID)
    if (spellID and mounts[spellID]) then
        tip:AddLine(" ")
        if (mounts[spellID].isCollected) then
            tip:AddDoubleLine(mounts[spellID].source, L["collected"], 1, 1, 1, 0.1, 1, 0.1)
        else
            tip:AddLine(mounts[spellID].source, 1, 1, 1)
        end
        tip:Show()
    end
end)
