/* Hotbar.as
 * author: Aphelion
 */

#include "SoldierCommon.as";

// thanks to Chrispin!
void DrawHotbar( CBlob@ blob )
{
	u8 activeType = getActiveType(blob);

    Vec2f pos = Vec2f(16.0f, getScreenHeight() - 128.0f);

	GUI::DrawPane(pos + Vec2f(-1, 96), pos + Vec2f(128, 116), color_white);
	GUI::DrawPane(pos + Vec2f(126, 96), pos + Vec2f(160, 116), color_white);

	for (uint i = 0; i < 2; i++)
	{
		Item@ item = getItem(getItem(blob, i));
		if   (item is null) continue;

		GUI::DrawFramedPane(pos + Vec2f(0, 64) + Vec2f(80, 0) * i, pos + Vec2f(80, 96) + Vec2f(80, 0) * i);
		GUI::DrawIconByName(item.getIcon(blob.getTeamNum(), false), pos + Vec2f(8, 64) + Vec2f(80, 0) * i);
		
		if (activeType == i)
		{
		    GUI::DrawRectangle(pos + Vec2f(0, 64) + Vec2f(80, 0) * i, pos + Vec2f(80, 96) + Vec2f(80, 0) * i, SColor(100, 0, 255, 0));
	        GUI::DrawText(item.shortName, pos + Vec2f(1, 98), color_white);
	        GUI::DrawText("" + GetAmmo(blob), pos + Vec2f(128, 98), color_white);
		}
	}
}

void onInit( CSprite@ this )
{
	this.getCurrentScript().runFlags |= Script::tick_myplayer;
	this.getCurrentScript().removeIfTag = "dead";
}

void onRender( CSprite@ this )
{
	if (g_videorecording) return;
	
	CBlob@ blob = this.getBlob();

	DrawHotbar(blob);
}
