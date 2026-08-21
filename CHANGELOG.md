# Changelog
All notable changes to this project will be documented in this file.

Limitations:  

Due to how TinyTooltip was disgned, gem and slot icon on item display may not be stable because of conflict with Blizzard UI rendering, there is no way to solve this problem without completely refactoring this addon which is not my top priority right now.

When anchor point selected to bottom and set to anchor to mouse, custom is not allowed as 
it will causing jittering due to anchor competition with blizzard UI system

Quick Focus is not working when clicking Unit Frame, as Unit Frame click event is protected.  

## [v1.6.6] - 2026-08-15
- Fixed Lua errors caused by mount detection attempting to access secret aura data in restricted content
- Fixed Lua errors caused by using secret class identifiers for target and Targeted By colours
- Fixed Lua errors caused by automatic status bar and target colours testing secret unit values
- Fixed Lua errors caused by spell ID display attempting to resolve secret nameplate aura instance IDs
