/* StatHUD.as
 * author: Aphelion
 */

#include "Stats.as";

const string stats_file = "GUI/StatBars.png";

void renderStatBar(CBlob@ blob, Vec2f origin, u8 stat)
{
	int segmentWidth = 4;
	int HPs = 0;

	for(f32 step = 0.0f; step < getBaseStat(blob, stat); step += 1.0f)
	{
		f32 thisHP = getStat(blob, stat) - step;

		if (thisHP > 0)
		{
			GUI::DrawIcon(stats_file, 1 + stat, Vec2f(8, 8), origin + Vec2f(segmentWidth * HPs, 0));
		}
		else
		{
			GUI::DrawIcon(stats_file, 0, Vec2f(8, 8), origin + Vec2f(segmentWidth * HPs, 0));
		}

		HPs++;
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

    //Vec2f pos = Vec2f(180.0f, getScreenHeight() - 64.0f);
    Vec2f pos = Vec2f(16.0f, getScreenHeight() - 128.0f);

	renderStatBar(blob, pos + Vec2f(0,  0), Stats::SHIELD);
	renderStatBar(blob, pos + Vec2f(0, 15), Stats::HEALTH);
	renderStatBar(blob, pos + Vec2f(0, 31), Stats::ENERGY);
}
