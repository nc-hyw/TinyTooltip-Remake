# Changelog
All notable changes to this project will be documented in this file.

Known Issue:  

Due to how TinyTooltip was disgned, gem and slot icon on item display may not be stable because of conflict with Blizzard UI rendering, there is no way to solve this problem without completely refactoring this addon which is not my top priority right now.

I will try to rebuilt this addon entireley if I have the time and after the game become stable.

## [v1.0.0] - 2026-01-27
New Feature: 
- Tooltip can now display M+ scores and colored using Blizzard color profile by default

Fix:  
- Fixed an issue that caused lua error when inside dungeon/raid mouseover to aura in nameplates
- Fixed an issue that dropdown menue will not correctly display after reload
- Fixed an issue that gem and slot icon will not display ...
