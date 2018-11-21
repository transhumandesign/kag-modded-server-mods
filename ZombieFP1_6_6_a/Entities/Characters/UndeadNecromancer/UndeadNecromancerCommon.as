const int TELEPORT_FREQUENCY = 12 * 30; //12 secs
const int TELEPORT_DISTANCE = 140;//getMap().tilesize;

const int FIRE_FREQUENCY = 45;
const f32 ORB_SPEED = 4.5f;
const u8 ORB_LIMIT = 1;
const u32 ORB_BURST_COOLDOWN = 1 * 1; //10 secs
const float ORB_TIME_TO_DIE = 4.0f;


namespace OrbType
{
enum type
{
    normal = 0,
    fire,
	bomb,
	water,
	count
};
}

namespace NecromancerVars
{
const ::s32 resheath_time = 5;

const ::s32 orb_power = 15;
const ::s32 orb_power2 = 38;
const ::s32 slash_charge_limit = orb_power2+orb_power+10;
}

shared class NecromancerInfo
{
	bool has_orb;
	u8 orb_type;

	NecromancerInfo()
	{
		has_orb = false;
		orb_type = OrbType::normal;
	}
};

const string[] orbTypeNames = { "mat_orbs",
                                  "mat_fireorbs",
								  "mat_bomborbs",
								  "mat_waterorbs"
                                };
const string[] orbNames = { "Regular Orb",
                              "Fire Orb",
							  "Bomb Orb",
							  "Water Orb"
                            };

const string[] orbIcons = { "$Orb$",
							  "$FireOrb$",
							  "$BombOrb$",
							  "$WaterOrb$"
};

u8 getOrbType( CBlob@ this )
{
	NecromancerInfo@ necromancer;
	if (!this.get( "necromancerInfo", @necromancer )) {
		return 0;

	}						 
	return necromancer.orb_type;
}
void SetOrbType( CBlob@ this, const u8 type )
{
	NecromancerInfo@ necromancer;
	if (!this.get( "necromancerInfo", @necromancer )) {
		return;

	}		  	
	necromancer.orb_type = type;
}

bool hasOrbs( CBlob@ this )
{
	NecromancerInfo@ necromancer;
	if (!this.get( "necromancerInfo", @necromancer )) {
		return false;

	}
	if (necromancer.orb_type >= 0 && necromancer.orb_type < orbTypeNames.length) {
		return this.getBlobCount( orbTypeNames[necromancer.orb_type] ) > 0;
	}

	return false;
}