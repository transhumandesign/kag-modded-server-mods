//scale the damage:
//      knights cant damage
//      arrows cant damage

#include "CustomHitters.as";
#include "Hitters.as";

f32 onHit(CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData)
{
	f32 dmg = damage;
	switch (customData)
	{
		case Hitters::builder:
			dmg *= 1.5f; // 2.0f
			break;

		case Hitters::sword:
		case Hitters::arrow:
		case Hitters::gun:
		case Hitters::plasma:
		case Hitters::stab:
			dmg = 0.0f;
			break;

		case Hitters::bomb:
			dmg *= 2.0f; // 0.5f
			break;

		case Hitters::keg:
		case Hitters::explosion:
			dmg *= 2.5f;
			break;

		case Hitters::swarm_missile:
		    dmg *= 2.0f;
		    break;

		case Hitters::light_missile:
		    dmg *= 6.0f;
		    break;

		case Hitters::bomb_arrow:
			dmg *= 8.0f;
			break;

		case Hitters::cata_stones:
			dmg *= 5.0f;
			break;

		case Hitters::crush:
			dmg *= 4.0f;
			break;

		case Hitters::flying: // boat ram
			dmg *= 7.0f;
			break;
	}

	return dmg;
}
