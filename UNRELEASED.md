# Unreleased Changes

Changes listed here are intended for the next release. During release, 

## Added

- Added LiteMount compatibility so mount rarity percentages and mount display won't affecting TinyToolti-Remake while still displaying rarity percetages
- Added mount icon display
- Added the active summoned mount icon to player tooltips and the mount-option preview.
- Declared DialogueUI and LiteMount as optional dependencies so their addon files load before TinyTooltip when enabled. ( You don't need to install these two addons to use TinyTooltip-Remake)

## Fixed

- Fixed issues that causing errors for aura hover over in 12.1
- Fixed issues that aura spell ID is not showing
- Prevented DialogueUI scale detection from indexing a secret value returned by `debugstack()`. Notice: The behaviour of this change is unknow, if it doesn't work or cause some other issue, please let me know.

## Note

- All the things icon display feature will conflicts with TinyTooltip-Remake's icon display intermittently that causing some secrete value error be raised and reported caused by TinyTooltip-Remake. To avoid this, only turn on icon display in one of the addon if you're using ATT, no ATT competability work will be provided at this stage.