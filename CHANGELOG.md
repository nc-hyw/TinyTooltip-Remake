# Changelog
All notable changes to this project will be documented in this file.

Limitations:  

Due to how TinyTooltip was disgned, gem and slot icon on item display may not be stable because of conflict with Blizzard UI rendering, there is no way to solve this problem without completely refactoring this addon which is not my top priority right now.

When anchor point selected to bottom and set to anchor to mouse, custom is not allowed as 
it will causing jittering due to anchor competition with blizzard UI system

## [v1.3.0] - 2026-03-01
New Feature:
- Now you can get achivement points in tooltip
- Now you can get equipped item level in tooltip

Fix:
- Refactored how tooltip style is applied to solve numerous error
- Added compatability support for DialogueUI
- Fxied an issue where macro does not display icon, spell id and icon id
- Fixed an issue where if Blizzard is reporting incorrect item quality the border quality will be coloured incorrect too.

## [v1.2.0] - 2026-02-06
New Feature:
- Now id info also shows iconID and spellID, itemID has been localized in simplified Chinese
- Buff now also shows spellID

Fix: 
- Fixed an issue where target line will be displayed on item/spell tooltip when overlay
- Fixed an issue where text is not aligned in frame while descrption text and id was turned off but icon is turned on


## [v1.1.3] - 2026-02-01
Fix:
- Fix an issue where displayed line over 4 rows will cause misallginment

## [v1.1.2] - 2026-02-01
New Feature:
- Now you can select hide "Right click to confgure the frame" in General setting page
- Added Text lable in offset setup for better experence

Fix:
- Redesigned layout regarding anchor setting to solve overlapping issue of Anchor button
- Fixed an error when try to open Anchor box without close existing Anchor box
- Fixed static anchor will not working properly with scale setting
- Fixed an issue where customized anchor will not working properly
- Fixed an issue where selecting custom anchor position will cause error
- Fixed an issue where tooltip will not move with cursor when "anchor to cursor" was selected
- Fixed an issue where faction will repeately display when targeting an enemy NPC

## [v1.1.0] - 2026-01-29  
New Feature:
- Player now have the option to display Mount information and if it was collected in tooltip  

Fix:
- Fix an issue when anchor point set to mouse ( not right of mouse ) the tooltip will stuttering
- Fix an issue target is always showing even when 'show target' is unckced

Other Improvements:
- Added hint to string format display
- Health percentage is now back

## [v1.0.1] - 2026-01-28  
Fixed an issue where spec will not be displayed correctly for guildless player
Fixed an issue where M+ score will not be displayed correctly for player who do not have M+ runs
Fixed an issue where change font could cause error and setting page disappear

Changed default layout for better M+ score display

## [v1.0.0] - 2026-01-27  
New Feature: 
- Tooltip can now display M+ scores and colored using Blizzard color profile by default

Fix:  
- Fixed an issue that caused lua error when inside dungeon/raid mouseover to aura in nameplates
- Fixed an issue that dropdown menue will not correctly display after reload
- Fixed an issue that gem and slot icon will not display ...
