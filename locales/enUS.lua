
local addon = TinyTooltip or select(2, ...)

addon.L = addon.L or {}
local L = addon.L
local T = {
["general.statusbarOffsetX"] = "Statusbar Margin-X (0:Default)",
    ["general.statusbarOffsetY"] = "Statusbar Offset Y (0:Default)",
    ["general.alwaysShowIdInfo"] = "Always Show Id Info (Otherwise hold down SHIFT/ALT)",
    ["general.skinMoreFrames"]   = "Skin More Frames |cffcccc33(need to /reload)|r",
    ["dropdown.inherit"]        = "|cffffee00inherit|r",
    ["dropdown.default"]        = "|cffaaaaaadefault|r",
    ["dropdown.cursor"]         = "|cff33ccffcursor|r",
    ["dropdown.static"]         = "|cff33ccffstatic|r",
    ["dropdown.none"]           = "|cffaaaaaanone|r",
    ["dropdown.not reaction5"]      = "|cffff3333not|r reaction5",
    ["dropdown.not reaction6"]      = "|cffff3333not|r reaction6",
    ["dropdown.not inraid"]         = "|cffff3333not|r inraid",
    ["dropdown.not incombat"]       = "|cffff3333not|r incombat",
    ["dropdown.not inpvp"]          = "|cffff3333not|r inpvp",
    ["dropdown.not inarena"]        = "|cffff3333not|r inarena",
    ["dropdown.not ininstance"]     = "|cffff3333not|r ininstance",
    ["dropdown.not samerealm"]      = "|cffff3333not|r samerealm",
    ["dropdown.not samecrossrealm"]  = "|cffff3333not|r sameCrossrealm",
    ["TargetBy"]                    = "Targeted By",
    ["showTargetBy"]                = "Show Targeted By",

    ["menu.general"] = "General",
    ["menu.player"] = "Player",
    ["menu.npc"] = "NPC",
    ["menu.statusbar"] = "StatusBar",
    ["menu.spell"] = "Spell",
    ["menu.font"] = "Font",
    ["menu.variables"] = "Variables",

    ["about.desc"] = "A simple tooltip addon",
    ["about.author.label"] = "Author",
    ["about.author.name"] = "HoshinoAya - Rhonin CN",
    ["about.help.title"] = "Submit Bug / Feedback",
    ["about.help.url"] = "https://aaa.example.com/issues",
    ["about.credits.title"] = "Credits",
    ["about.credits.content"] = "Thanks to M, the original author of TinyTooltip, and all contributors\n",

}
for k, v in pairs(T) do
    L[k] = v
end
