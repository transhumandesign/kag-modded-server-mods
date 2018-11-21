const int TELEPORT_FREQUENCY = 9 * 30; //9 secs
const int TELEPORT_DISTANCE = 160;//getMap().tilesize;

const int FIRE_FREQUENCY = 45;
const f32 ORB_SPEED = 5.5f;
const u8 ORB_LIMIT = 1;
const u32 ORB_BURST_COOLDOWN = 1 * 1; //10 secs
const float ORB_TIME_TO_DIE = 5.0f;


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

namespace WizardVars
{
const ::s32 resheath_time = 5;

const ::s32 orb_power = 15;
const ::s32 orb_power2 = 38;
const ::s32 slash_charge_limit = orb_power2+orb_power+10;
}

shared class WizardInfo
{
	bool has_orb;
	u8 orb_type;

	WizardInfo()
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
	WizardInfo@ wizard;
	if (!this.get( "wizardInfo", @wizard )) {
		return 0;

	}						 
	return wizard.orb_type;
}
void SetOrbType( CBlob@ this, const u8 type )
{
	WizardInfo@ wizard;
	if (!this.get( "wizardInfo", @wizard )) {
		return;

	}		  	
	wizard.orb_type = type;
}

bool hasOrbs( CBlob@ this )
{
	WizardInfo@ wizard;
	if (!this.get( "wizardInfo", @wizard )) {
		return false;

	}
	if (wizard.orb_type >= 0 && wizard.orb_type < orbTypeNames.length) {
		return this.getBlobCount( orbTypeNames[wizard.orb_type] ) > 0;
	}

	return false;
}