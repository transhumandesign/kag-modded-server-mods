// Aphelion \\

#define CLIENT_ONLY;

void onRender( CSprite@ this )
{
	if (g_debug == 0) return;

	CBlob@ blob = this.getBlob();

	// draw a green line to the aim pos
	GUI::DrawArrow2D(getDriver().getScreenPosFromWorldPos(blob.getPosition()), getDriver().getScreenPosFromWorldPos(blob.getAimPos()), SColor(155, 0, 255, 0));
}
