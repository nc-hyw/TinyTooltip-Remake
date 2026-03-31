# Changelog
All notable changes to this project will be documented in this file.

Limitations:  

Due to how TinyTooltip was disgned, gem and slot icon on item display may not be stable because of conflict with Blizzard UI rendering, there is no way to solve this problem without completely refactoring this addon which is not my top priority right now.

When anchor point selected to bottom and set to anchor to mouse, custom is not allowed as 
it will causing jittering due to anchor competition with blizzard UI system

Quick Focus is not working when clicking Unit Frame, as Unit Frame click event is protected.  

## [v1.6.2] - 2026-03-31
- Added an option to toggle announcement display
- Update announcement content

## [v1.6.1] - 2026-03-26
- Fix an issue where target will appear outside of tooltip bound
- Fix an issue quality border colour will rasie lua error due to blizzard rencent introduced bugs
- Added a notification


## [v1.6.0] - 2026-03-20
New Feature:
  - Added option for display Quest ID display in general
  - Added option to using mod key to show player/npc tooltip during combat when 'hide' in combat was set  
      This option can be set globally and in player/npc setting for different tooltip and can use different mod key just in case that  suits your need
  - Added option to show BonusID, EnhancementId and GemID    
      **Note**: This intend to be experimental feature for purpose of data mining, even though the data is striped from Blizzard Item link but I do noticed that for some non-equippable item the link comes back with a bonus ID, therefore, turn this own and trust the data at your own risk and turn it off if you encounter into problems.

Fix:
  - Included missing icon directory into released zip file so that icon can be displayed correctly


## [v1.5.0] - 2026-03-15
- Now you have the option to show Specialization, Mount, M+ Score, Achivements, Item Level with icon instead of just txt
  To use your dessired icon for Item Level, M+ Score and Mount, copy and paste your customized icon into icon directory in this addon and rename it accordingly. 
  Specialization and Achivements are using in-game resources therefore can not be customized.

## [v1.4.3] - 2026-03-14
- Fixed lua errors when item link is nil
- Fixed 'bad self' error in dungeon Murder Row

## [v1.4.2] - 2026-03-12
- Fixed an issue that status bar sometimes will showing on item/spell tooltip
- Fixed an issue that lua error  will occure when hove over to KeystoneLoot addon item

## [v1.4.1] - 2026-03-06
- Fixed: Disabled aggresive setting clean function to solve some setting will be reset after reload

## [v1.4.0] - 2026-03-06
New Feature: 
 - Added Expansion information in item tooltip
 - Added Quick Focus feature, this feature is defaulted to be off

Other Improvements: 
 - Changed how chat frame tooltip was anchored
        Now it will always anchored to mourse cursor as it is more reasonable
- Refactored Item and Spell setting page so that you have more freedom to decided what should be turned on and what should be turned off

- Improved how setting profile was merged when new features was introduced

## [v1.3.3] - 2026-03-04
- Added new setting menue for spell/item/icon id display
- Added feature to direct generate toollink from chat frame
- Fixed some tooltip width inconsistency issue when Faction was displayed


## [v1.3.2] - 2026-03-03
- Fixed issue that incorrectly colouring LibOtip pure black background tooltip to grey

## [v1.3.1] - 2026-03-02
- Fixed issues that mouseover to native random mount macro will crash the game
- Fixed issues that system  border will always be displayed 


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
