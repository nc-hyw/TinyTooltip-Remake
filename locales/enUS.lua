
local addon = TinyTooltip or select(2, ...)

addon.L = addon.L or {}
local L = addon.L
local T = {
    ["about.announcement.chat"] = "Blizzard has fixed the issue that caused item and spell tooltips to trigger Lua errors. A new option has also been added on the General settings page to control whether the latest announcement is shown. You can read the full details on the settings page.",
    ["about.announcement.chatKey"] = "announcement_2026_03_31_tooltip_bug",
    ["about.announcement.content"] = "Based on testing, Blizzard has fixed the issue where item and spell tooltips could become secret values, which caused many errors when 'Show Item Icon' or 'Show Spell Icon' was enabled. You can now turn these two options back on."
    .. "In addition, version 1.6.2 adds a new option on the General page to control whether announcements are shown at login.\n"
    .. "The issue currently confirmed is that, after entering combat in instances, some player tooltips may show incorrect size. This is a new issue that appeared after the season started, and the size problem only appears randomly on some players you inspect."
    .. "Because of that, I have reason to believe this is caused by Blizzard rather than by this addon. At the same time, the original TinyTooltip architecture has multiple entry points for both size calculation and content insertion, and the tooltip may be rebuilt in several different places."
    .. "That design makes tooltip size issues extremely difficult to fix, especially when it is still unclear whether the incorrect sizing is caused by the addon or by Blizzard itself."
    .. "For that reason, no update will be pushed for the sizing issue for now. I plan to fully refactor the tooltip creation flow after another 1-2 feature updates, so the whole pipeline uses a single entry point for size calculation and a single content insertion interface,"
    .. "which should completely address both the complexity of size calculation and the need to redraw tooltips multiple times during creation.\n"
    .. "\nFinally, if you encounter incorrect player tooltip sizing after combat in instances, please reload your UI to resolve it. Thank you again for your understanding and support.",
    ["about.announcement.title"] = "Announcement",
    ["about.author.label"] = "Author",
    ["about.author.name"] = "HoshinoAya - Rhonin CN",
    ["about.credits.content"] = "Thanks to M, the original author of TinyTooltip, and all contributors\n",
    ["about.credits.title"] = "Credits",
    ["about.desc"] = "A powerful tooltip addon",
    ["about.help.title"] = "Submit Bug / Feedback",
    ["about.help.url"] = "https://github.com/nc-hyw/TinyTooltip-Remake/issues",

    ["anchor.none"] = "None",
    ["anchor.offset.locked"] = "Offset is disabled when anchor point is Bottom.",

    ["button.resetAll"] = "Reset All Settings",
    ["button.resetSection"] = "Reset to Defaults",

    ["dropdown.alt"] = "Alt",
    ["dropdown.ctrl"] = "Ctrl",
    ["dropdown.cursor"] = "|cff33ccffcursor|r",
    ["dropdown.default"] = "|cffaaaaaadefault|r",
    ["dropdown.global"] = "Global Setting",
    ["dropdown.inherit"] = "|cffffee00inherit|r",
    ["dropdown.itemLevel"] = "ItemLevel (Blizzard)",
    ["dropdown.none"] = "|cffaaaaaanone|r",
    ["dropdown.not inarena"] = "|cffff3333not|r inarena",
    ["dropdown.not incombat"] = "|cffff3333not|r incombat",
    ["dropdown.not ininstance"] = "|cffff3333not|r ininstance",
    ["dropdown.not inpvp"] = "|cffff3333not|r inpvp",
    ["dropdown.not inraid"] = "|cffff3333not|r inraid",
    ["dropdown.not reaction5"] = "|cffff3333not|r reaction5",
    ["dropdown.not reaction6"] = "|cffff3333not|r reaction6",
    ["dropdown.not samecrossrealm"] = "|cffff3333not|r sameCrossrealm",
    ["dropdown.not samerealm"] = "|cffff3333not|r samerealm",
    ["dropdown.shift"] = "Shift",
    ["dropdown.static"] = "|cff33ccffstatic|r",

    ["general.alwaysShowIdInfo"] = "Always Show ID Info",
    ["general.alwaysShowIdInfo.hint"] = "If disabled, hold SHIFT/ALT to display.",
    ["general.alwaysShowIdInfo.short"] = "Always Show ID Info",
    ["general.anchor.modifierShowInCombat"] = "Hold Modifier to Show While Hidden",
    ["general.anchor.modifierShowInCombatKey"] = "Modifier Key",
    ["general.annoucements"] = "Announcements",
    ["general.annoucements.dropdown.noticeAlways"] = "Always show announcements",
    ["general.annoucements.dropdown.noticeNever"] = "Never show announcements",
    ["general.annoucements.dropdown.noticeSnooze"] = "Show once per announcement update",
    ["general.hideUnitFrameHint"] = "Hide Unit Frame Right-Click Setup Hint",
    ["general.idInfoMode.icon"] = "Show Icon ID",
    ["general.idInfoMode.spellItem"] = "Show Spell/Item ID",
    ["general.quickFocusModKey"] = "Quick Focus Mod Key",
    ["general.skinMoreFrames"] = "Skin More Frames |cffcccc33(need to /reload)|r",
    ["general.statusbarHide"] = "Hide Status Bar",
    ["general.statusbarOffsetX"] = "Statusbar Margin-X (0:Default)",
    ["general.statusbarOffsetY"] = "Statusbar Offset Y (0:Default)",
    ["general.statusbarPercent"] = "Show Health Percentage",

    ["hint.anchor.returnInCombat"] = "When mouseover in combat, the tooltip are fixed at the default position.",
    ["hint.anchor.returnOnUnitFrame"] = "Tooltips from unit frames are fixed at the default position.",

    ["id.bonus"] = "Bonus ID",
    ["id.display.both"] = "All",
    ["id.display.none"] = "None",
    ["id.enhancement"] = "Enhancement ID",
    ["id.expansion"] = "Expansion",
    ["id.gem"] = "Gem ID",
    ["id.icon"] = "Icon ID",
    ["id.item"] = "Item ID",
    ["id.maxStack"] = "Max Stack Count",
    ["id.quest"] = "Quest ID",
    ["id.spell"] = "Spell ID",

    ["item.coloredItemBorder"] = "Item Border by Quality",
    ["item.modifierShowAll"] = "Hold Modifier to Show All Info",
    ["item.showItemBonusId"] = "Show Bonus ID",
    ["item.showItemEnhancementId"] = "Show Enhancement ID",
    ["item.showItemExpansion"] = "Show Item Expansion",
    ["item.showItemGemId"] = "Show Gem ID",
    ["item.showItemIcon"] = "Show Item Icon",
    ["item.showItemIconId"] = "Show Item Icon ID",
    ["item.showItemId"] = "Show Item ID",
    ["item.showItemMaxStack"] = "Show Max Stack Count",

    ["Achievement"] = "Achievement",
    ["collected"] = "collected",
    ["ItemLevel"] = "ItemLevel",
    ["mount"] = "Mount",
    ["Mount"] = "Mount",
    ["showTargetBy"] = "Show Targeted By",
    ["TargetBy"] = "Targeted By",
    ["uncollected"] = "uncollected",

    ["menu.font"] = "Font",
    ["menu.general"] = "General",
    ["menu.item"] = "Item",
    ["menu.npc"] = "NPC",
    ["menu.player"] = "Player",
    ["menu.spell"] = "Spell",
    ["menu.statusbar"] = "StatusBar",
    ["menu.variables"] = "Variables",

    ["popup.reloadNotice.text"] = "ipsum loream",

    ["quest.showQuestId"] = "Show Quest ID",

    ["quickfocus.help"] = "Hold the modifier key and click a target to set focus. Hold the modifier key and click empty space to clear focus. (Does not work on unit frames)",

    ["spell.modifierShowAll"] = "Hold Modifier to Show All Info",
    ["spell.showIcon"] = "Show Spell Icon",
    ["spell.showSpellIconId"] = "Show Spell Icon ID",
    ["spell.showSpellId"] = "Show Spell ID",

    ["unit.player.elements.achievementPoints"] = "Achievement Points",
    ["unit.player.elements.achievementPoints.icon"] = "Use achievement icon",
    ["unit.player.elements.className.icon"] = "Use specialization icon",
    ["unit.player.elements.icon"] = "Icon",
    ["unit.player.elements.itemLevel"] = "ItemLevel",
    ["unit.player.elements.itemLevel.icon"] = "Use item level icon",
    ["unit.player.elements.mount"] = "Mount",
    ["unit.player.elements.mount.icon"] = "Use saddle icon",
    ["unit.player.elements.mplusScore.icon"] = "Use keystone icon",

    ["wildcard.help"] = "Customize Format: Hit enter to take effect.",
    ["wildcard.help.example"] = "Example: (%s) or [%s]",
    ["wildcard.help.moveSpeed"] = "Example: %d%%",
}
for k, v in pairs(T) do
    L[k] = v
end
