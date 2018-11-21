//Crossbow Include

namespace CrossbowParams
{
	enum Aim
	{
		not_aiming = 0,
		readying,
		charging,
		fired,
		no_arrows,
		stabbing,
		legolas_ready,
		legolas_charging
	}

	const ::s32 ready_time = 11;

	const ::s32 shoot_period = 30;
	const ::s32 shoot_period_1 = CrossbowParams::shoot_period / 3;
	const ::s32 shoot_period_2 = 2 * CrossbowParams::shoot_period / 3;
	const ::s32 legolas_period = CrossbowParams::shoot_period * 3;

	const ::s32 fired_time = 7;
	const ::f32 shoot_max_vel = 17.59f;

	const ::s32 legolas_charge_time = 5;
	const ::s32 legolas_arrows_count = 1;
	const ::s32 legolas_arrows_volley = 3;
	const ::s32 legolas_arrows_deviation = 5;
	const ::s32 legolas_time = 60;
}

namespace ArrowType
{
	enum type
	{
		normal = 0,
		count
	};
}

shared class CrossbowInfo
{
	s8 charge_time;
	u8 charge_state;
	bool has_arrow;
	u8 stab_delay;
	u8 fletch_cooldown;
	u8 arrow_type;

	u8 legolas_arrows;
	u8 legolas_time;

	f32 cache_angle;

	CrossbowInfo()
	{
		charge_time = 0;
		charge_state = 0;
		has_arrow = false;
		stab_delay = 0;
		fletch_cooldown = 0;
		arrow_type = ArrowType::normal;
	}
};

const string[] arrowTypeNames = { "mat_arrows"

                                };

const string[] arrowNames = { "Regular arrows"

                            };

const string[] arrowIcons = { "$Arrow$"

                            };


bool hasArrows(CBlob@ this)
{
	CrossbowInfo@ crossbow;
	if (!this.get("crossbowInfo", @crossbow))
	{
		return false;
	}
	if (crossbow.arrow_type >= 0 && crossbow.arrow_type < arrowTypeNames.length)
	{
		return this.getBlobCount(arrowTypeNames[crossbow.arrow_type]) > 0;
	}
	return false;
}

bool hasArrows(CBlob@ this, u8 arrowType)
{
	return this.getBlobCount(arrowTypeNames[arrowType]) > 0;
}

void SetArrowType(CBlob@ this, const u8 type)
{
	CrossbowInfo@ crossbow;
	if (!this.get("crossbowInfo", @crossbow))
	{
		return;
	}
	crossbow.arrow_type = type;
}

u8 getArrowType(CBlob@ this)
{
	CrossbowInfo@ crossbow;
	if (!this.get("crossbowInfo", @crossbow))
	{
		return 0;
	}
	return crossbow.arrow_type;
}
