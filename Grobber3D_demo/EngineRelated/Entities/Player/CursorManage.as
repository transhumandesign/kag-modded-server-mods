#define CLIENT_ONLY

void onInit(CSprite@ this)
{
	this.getCurrentScript().runFlags |= Script::tick_myplayer;
	this.getCurrentScript().removeIfTag = "dead";
}

void ManageCursors(CBlob@ this)
{
	if (getHUD().hasButtons() || getRules().get_bool("stuck"))
	{
		getHUD().SetDefaultCursor();
	}
	else
	{
		getHUD().SetCursorImage("HideCursor.png");
	}
}

void onRender(CSprite@ this)
{
	if (g_videorecording)
		return;

	CBlob@ blob = this.getBlob();

	ManageCursors(blob);
}
