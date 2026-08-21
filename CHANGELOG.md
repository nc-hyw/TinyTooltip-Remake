# Changelog
All notable changes to this project will be documented in this file.

## Limitations:  
- When anchor point selected to bottom and set to anchor to mouse, custom is not allowed as 
it will causing jittering due to anchor competition with blizzard UI system

- Quick Focus is not working when clicking Unit Frame, as Unit Frame click event is protected.  

- Getting spell ID of aura will not be allowed during combat when inside intances in 12.1 due to API changes

- All the things icon display feature will conflicts with TinyTooltip-Remake's icon display intermittently that causing some secrete value error be raised and reported caused by TinyTooltip-Remake. To avoid this, only turn on icon display in one of the addon if you're using ATT, no ATT competability work will be provided at this stage.

- Patched code to prevented DialogueUI scale detection from indexing a secret value returned by `debugstack()`. Notice: The behaviour of this change is unknow as I have not encountered to this error yet but got report regarding it for a few times, if the patch doesn't work or cause some other issue(likely scalling issue), please let me know.

## Added
- Added LiteMount compatibility so mount rarity percentages and mount display won't affecting TinyToolti-Remake while still displaying rarity percetages
- Added mount icon display
- Added the active summoned mount icon to player tooltips and the mount-option preview.
- Declared DialogueUI and LiteMount as optional dependencies so their addon files load before TinyTooltip when enabled. ( You don't need to install these two addons to use TinyTooltip-Remake)

## Fixed
- Fixed issues that causing errors for aura hover over in 12.1
- Fixed issues that aura spell ID is not showing


