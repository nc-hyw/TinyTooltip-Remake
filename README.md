## English

As TinyTooltip haven't been updated more than a year and not supporting version 12.0  
This remake version which based on original TinyTooltip will be carry on for other players who needs it.

The original TinyTooltip didn't support equipped item level display, so this version doesn't include it either. Since Blizzard's current API for retrieving equipped item level is bugged and returns incorrect data, adding this feature right now would be meaningless. I will consider implementing it once Blizzard fixes the API. For now, if you want to see equipped item level on tooltips, please use other addons that don't rely on Blizzard's API, such as TinyInspect-Remake or ItemInfoOverlay.

**Limitations:**  
Due to API restrictions (or maybe my poor technic):

1.  When inside dungeon/raid, tooltip generated from enemy unit frame is not possible to display target, but tooltip generated from model and name plates are not affected.
2.  When inside dungeon/raid, tooltip generated from enemy model/nameplates will not be able to comparing target ID which means it is not possible to display ">> You <<" colored in red with tooltip when enemy targeting you. Player tooltip and not inside dungeon/raid is not affected.
3.  HP queried from tooltip is not be able to perform comparison, Blizzard used a mechanism called secrete value to protected the data, and ANY operation on them is forbidden and will triggering lua error, therefore the tool will only be able to display current and max health and can not show health remaining percentage.

All other functions should be working properly including customize your tooltip. But if you ever encounter any problem please submit your feedback in Curseforge or Github including how to reproduce it, what's your intention and what actually happened.

As I am interested in maintaining this project from now on and adding more features into it, any suggestion is welcome.

## 简体中文

由于 TinyTooltip 已超过一年未更新且不支持 12.0，本重制版本基于原版 TinyTooltip，继续为有需求的玩家提供支持。

**已知问题：**  
由于 API 限制（也可能是我的技术有限）：

1.  在副本/团队副本中，由敌对单位框体生成的提示无法显示目标；由模型和姓名板生成的提示不受影响。
2.  在副本/团队副本中，由敌方模型/姓名板生成的提示无法比较目标 ID，因此当敌方目标是你时无法显示红色的 “>> 你 <<”。玩家提示以及非副本/团队环境不受影响。
3.  从 tooltip 获取的 HP 无法进行比较。暴雪使用了名为 “secret value” 的机制来保护数据，对其进行任何运算都会触发 Lua 错误，因此本插件只能显示当前和最大生命值，无法显示剩余生命百分比。

除此之外的功能应当都能正常使用，包括自定义你的 tooltip。如果你遇到任何问题，请在 Curseforge 或 GitHub 提交反馈，并说明复现步骤、你的预期，以及实际发生的情况。

我计划从现在开始维护这个项目并添加更多功能，欢迎任何建议。
