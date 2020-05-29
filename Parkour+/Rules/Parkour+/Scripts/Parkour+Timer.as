//Rules timer!

// Requires "game ticks left" set originally

void onRender(CRules@ this)
{
	if (!this.isMatchRunning()) return;

	const u32 gameTicksLeft = this.get_u32("game ticks left");

	if (gameTicksLeft > 0)
	{
		s32 timeToEnd = s32(gameTicksLeft) / 30;
		s32 secondsToEnd = timeToEnd % 60;
		s32 MinutesToEnd = timeToEnd / 60;
		drawRulesFont("Time Till Map Ends: " + ((MinutesToEnd < 10) ? "0" + MinutesToEnd : "" + MinutesToEnd) + ":" + ((secondsToEnd < 10) ? "0" + secondsToEnd : "" + secondsToEnd),
		SColor(255, 255, 255, 255), Vec2f(200, getScreenHeight() - 20), Vec2f(0, 0), true, false);
	}
}
