/* RunnerStats.as
 * author: Aphelion
 */

#include "TeamColour.as";
#include "Stats.as";

#include "GameplayEvents.as";

const SColor shield_color = SColor(125, 0, 72, 255);
const SColor health_color = SColor(125, 172, 21, 18);
const SColor energy_color = SColor(125, 0, 0, 0);

Vec2f dim = Vec2f(24, 8);

void onInit( CBlob@ this )
{
	this.getCurrentScript().removeIfTag = "dead";
}

void onTick( CBlob@ this )
{
	const u32 gametime = getGameTime();

	if (getNet().isServer())
	{
		if (gametime >= this.get_u32(Stats::STAT_REGEN_TIME_PROPERTY + Stats::SHIELD))
		{
			server_RegenerateStat(this, Stats::SHIELD, 30);
		}

		if (gametime >= this.get_u32(Stats::STAT_REGEN_TIME_PROPERTY + Stats::HEALTH))
		{
			server_RegenerateStat(this, Stats::HEALTH, 30);
		}

		if (this.isBot() && gametime >= this.get_u32(Stats::STAT_REGEN_TIME_PROPERTY + Stats::ENERGY))
		{
			server_RegenerateStat(this, Stats::ENERGY, 15);
		}
	}

	if (getNet().isClient())
	{
		if (gametime >= this.get_u32(Stats::STAT_REGEN_TIME_PROPERTY + Stats::ENERGY))
		{
		    client_RegenerateStat(this, Stats::ENERGY, 15);
		}
	}
}

f32 onHit( CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 _damage, CBlob@ hitterBlob, u8 customData )
{
	if (this.hasTag("shield"))
	{
		_damage *= 0.5f;
	}

	f32 damage_dealt;
	f32 damage = Damage(this, _damage, damage_dealt);

	if (damage_dealt > 0 && hitterBlob !is null && hitterBlob !is this)
	{
		CPlayer@ damageOwner = hitterBlob.getDamageOwnerPlayer();

		if (damageOwner !is null)
		{
			if (damageOwner.getTeamNum() != this.getTeamNum())
			{
				SendGameplayEvent(createPlayerDamageEvent(damageOwner, damage_dealt));
			}
		}
	}
    return damage;
}

void onInit( CSprite@ this )
{
	this.getCurrentScript().removeIfTag = "dead";
}

void onRender( CSprite@ this )
{
	if (g_videorecording) return;

	CBlob@ localBlob = getLocalPlayerBlob();
	CBlob@ blob = this.getBlob();

	if (blob.hasTag("cloaked") && !blob.isMyPlayer() && localBlob !is null && blob.getTeamNum() != localBlob.getTeamNum())
	{
		return;
	}
	
	const f32 renderRadius = (blob.getRadius()) * 5.0f;
	const f32 y = blob.getHeight() * 0.8f;
	const bool myPlayer = blob.isMyPlayer();

	Vec2f mouseWorld = getControls().getMouseWorldPos();
	Vec2f pos2d = blob.getScreenPos() + Vec2f(0, 20);
	Vec2f center = blob.getPosition();

	bool mouseOnBlob = (mouseWorld - center).getLength() < renderRadius;
	if  (mouseOnBlob || myPlayer)
	{
		DrawStat(pos2d, y, getStat(blob, Stats::SHIELD), getBaseStat(blob, Stats::SHIELD), getStatPercentage(blob, Stats::SHIELD), shield_color);
		DrawStat(pos2d, y + 10, getStat(blob, Stats::HEALTH), getBaseStat(blob, Stats::HEALTH), getStatPercentage(blob, Stats::HEALTH), health_color);
		
		if (myPlayer)
		{
			DrawStat(pos2d, y + 20, getStat(blob, Stats::ENERGY), getBaseStat(blob, Stats::ENERGY), getStatPercentage(blob, Stats::ENERGY), energy_color);
		}
	}

	CPlayer@ player = blob.getPlayer();

	if (mouseOnBlob && player !is null)
	{
		string playerName = player.getCharacterName();

		Vec2f text_dim;
		Vec2f ul = Vec2f(pos2d.x - dim.x, pos2d.y + y - 15);
		Vec2f br = Vec2f(pos2d.x + dim.x, pos2d.y + dim.y + y - 15);

		GUI::GetTextDimensions(playerName, text_dim);
		GUI::DrawRectangle(ul + Vec2f(2, 0), br + Vec2f(0, 6), SColor(155, 0, 0, 0));
		GUI::DrawText(playerName, Vec2f(pos2d.x - text_dim.x / 2, ul.y), getTeamColor(blob.getTeamNum()));
	}
}

void DrawStat( Vec2f pos2d, const f32 y, f32 stat, f32 stat_base, f32 perc, SColor color )
{
	string text = Maths::Floor(stat) + " / " + Maths::Floor(stat_base);

	Vec2f text_dim;
	GUI::GetTextDimensions(text, text_dim);

	// thanks to Chrispin!
	GUI::DrawRectangle(Vec2f(pos2d.x - dim.x + 1, pos2d.y + y), Vec2f(pos2d.x + dim.x + 1, pos2d.y + y + dim.y + 3), SColor(75, 255, 255, 255));
	GUI::DrawRectangle(Vec2f(pos2d.x - dim.x + 2, pos2d.y + y + 1), Vec2f(pos2d.x - dim.x + perc * 2.0f * dim.x, pos2d.y + y + dim.y + 2), color);
	GUI::DrawText(text, Vec2f(pos2d.x - text_dim.x / 2, pos2d.y + y - 2), SColor(255, 255, 255, 255));
}