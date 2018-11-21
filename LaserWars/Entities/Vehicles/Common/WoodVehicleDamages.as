#include "CustomHitters.as";
#include "Hitters.as";
#include "GameplayEvents.as";

f32 onHit(CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData)
{
	f32 dmg = damage;

	switch (customData)
	{
		case Hitters::gun:
		case Hitters::plasma:
			dmg *= 0.25f;
			break;

		case Hitters::builder:
			dmg *= 1.5f; // 2.0f
			break;

		case Hitters::sword:
			if (dmg <= 1.0f)
			{
				dmg = 0.25f;
			}
			else
			{
				dmg = 0.5f;
			}
			break;

		case Hitters::bomb:
			dmg *= 1.0f; // 1.40f
			break;

		case Hitters::explosion:
			dmg *= 4.5f;
			break;

		case Hitters::swarm_missile:
		    dmg *= 0.75f;
		    break;

		case Hitters::light_missile:
		    dmg *= 2.5f;
		    break;

		case Hitters::bomb_arrow:
			dmg *= 12.0f;
			break;

		case Hitters::arrow:
			dmg = this.getMass() > 1000.0f ? 1.0f : 0.5f;
			break;

		case Hitters::ballista:
			dmg *= 2.0f;
			break;
	}

	if (dmg > 0.0f && hitterBlob !is null && hitterBlob !is this)
	{
		CPlayer@ damageOwner = hitterBlob.getDamageOwnerPlayer();

		if (damageOwner !is null)
		{
			if (damageOwner.getTeamNum() != this.getTeamNum())
			{
				SendGameplayEvent(createVehicleDamageEvent(damageOwner, dmg * 10.0f));
			}
		}
	}
	return dmg;
}

void onDie(CBlob@ this)
{
	CPlayer@ p = this.getPlayerOfRecentDamage();

	if (p !is null)
	{
		CBlob@ b = p.getBlob();

		if (b !is null && b.getTeamNum() != this.getTeamNum())
		{
			SendGameplayEvent(createVehicleDestroyEvent(p));
		}
	}
}