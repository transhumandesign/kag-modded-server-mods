//common knight header
const int TELEPORT_FREQUENCY = 15 * 30; //15 secs
const int TELEPORT_DISTANCE = 90;//getMap().tilesize;

namespace KnightStates
{
	enum States
	{
		normal = 0,
		shielding,
		shielddropping,
		shieldgliding,
		sword_drawn,
		sword_cut_mid,
		sword_cut_mid_down,
		sword_cut_up,
		sword_cut_down,
		sword_power,
		sword_power_super
	}
}

namespace KnightVars
{
	const ::s32 resheath_time = 2;

	const ::s32 slash_charge = 15;
	const ::s32 slash_charge_level2 = 38;
	const ::s32 slash_charge_limit = slash_charge_level2 + slash_charge + 10;
	const ::s32 slash_move_time = 4;
	const ::s32 slash_time = 13;
	const ::s32 double_slash_time = 8;

	const ::f32 slash_move_max_speed = 3.5f;

	const u32 glide_down_time = 50;
}

shared class AssassinInfo
{
	u8 swordTimer;
	u8 shieldTimer;
	bool doubleslash;
	u8 tileDestructionLimiter;
	u32 slideTime;

	u8 state;
	Vec2f slash_direction;
	s32 shield_down;
	
	bool grappling;
	u16 grapple_id;
	f32 grapple_ratio;
	f32 cache_angle;
	Vec2f grapple_pos;
	Vec2f grapple_vel;

	AssassinInfo()
	{
		grappling = false;
	}
};

const f32 knight_grapple_length = 72.0f;
const f32 knight_grapple_slack = 16.0f;
const f32 knight_grapple_throw_speed = 20.0f;

const f32 knight_grapple_force = 2.0f;
const f32 knight_grapple_accel_limit = 1.5f;
const f32 knight_grapple_stiffness = 0.1f;

namespace BombType
{
	enum type
	{
		bomb = 0,
		water,
		count
	};
}

const string[] bombNames = { "Bomb",
                             "Water Bomb"
                           };

const string[] bombIcons = { "$Bomb$",
                             "$WaterBomb$"
                           };

const string[] bombTypeNames = { "mat_bombs",
                                 "mat_waterbombs"
                               };


//checking state stuff

bool isShieldState(u8 state)
{
	return (state >= KnightStates::shielding && state <= KnightStates::shieldgliding);
}

bool isSpecialShieldState(u8 state)
{
	return (state > KnightStates::shielding && state <= KnightStates::shieldgliding);
}

bool isSwordState(u8 state)
{
	return (state >= KnightStates::sword_drawn && state <= KnightStates::sword_power_super);
}

bool inMiddleOfAttack(u8 state)
{
	return ((state > KnightStates::sword_drawn && state <= KnightStates::sword_power_super));
}

//checking angle stuff

f32 getCutAngle(CBlob@ this, u8 state)
{
	f32 attackAngle = (this.isFacingLeft() ? 180.0f : 0.0f);

	if (state == KnightStates::sword_cut_mid)
	{
		attackAngle += (this.isFacingLeft() ? 30.0f : -30.0f);
	}
	else if (state == KnightStates::sword_cut_mid_down)
	{
		attackAngle -= (this.isFacingLeft() ? 30.0f : -30.0f);
	}
	else if (state == KnightStates::sword_cut_up)
	{
		attackAngle += (this.isFacingLeft() ? 80.0f : -80.0f);
	}
	else if (state == KnightStates::sword_cut_down)
	{
		attackAngle -= (this.isFacingLeft() ? 80.0f : -80.0f);
	}

	return attackAngle;
}

f32 getCutAngle(CBlob@ this)
{
	Vec2f aimpos = this.getMovement().getVars().aimpos;
	int tempState;
	Vec2f vec;
	int direction = this.getAimDirection(vec);

	if (direction == -1)
	{
		tempState = KnightStates::sword_cut_up;
	}
	else if (direction == 0)
	{
		if (aimpos.y < this.getPosition().y)
		{
			tempState = KnightStates::sword_cut_mid;
		}
		else
		{
			tempState = KnightStates::sword_cut_mid_down;
		}
	}
	else
	{
		tempState = KnightStates::sword_cut_down;
	}

	return getCutAngle(this, tempState);
}

//shared attacking/bashing constants (should be in KnightVars but used all over)

const int DELTA_BEGIN_ATTACK = 2;
const int DELTA_END_ATTACK = 5;
const f32 DEFAULT_ATTACK_DISTANCE = 16.0f;
const f32 MAX_ATTACK_DISTANCE = 18.0f;
const f32 SHIELD_KNOCK_VELOCITY = 3.0f;

const f32 SHIELD_BLOCK_ANGLE = 175.0f;
const f32 SHIELD_BLOCK_ANGLE_GLIDING = 140.0f;
const f32 SHIELD_BLOCK_ANGLE_SLIDING = 160.0f;

const string grapple_sync_cmd = "grapple sync";

void SyncGrapple(CBlob@ this)
{
	AssassinInfo@ knight;
	if (!this.get("knightInfo", @knight)) { return; }

	CBitStream bt;
	bt.write_bool(knight.grappling);

	if (knight.grappling)
	{
		bt.write_u16(knight.grapple_id);
		bt.write_u8(u8(knight.grapple_ratio * 250));
		bt.write_Vec2f(knight.grapple_pos);
		bt.write_Vec2f(knight.grapple_vel);
	}

	this.SendCommand(this.getCommandID(grapple_sync_cmd), bt);
}

//TODO: saferead
void HandleGrapple(CBlob@ this, CBitStream@ bt, bool apply)
{
	AssassinInfo@ knight;
	if (!this.get("knightInfo", @knight)) { return; }

	bool grappling;
	u16 grapple_id;
	f32 grapple_ratio;
	Vec2f grapple_pos;
	Vec2f grapple_vel;

	grappling = bt.read_bool();

	if (grappling)
	{
		grapple_id = bt.read_u16();
		u8 temp = bt.read_u8();
		grapple_ratio = temp / 250.0f;
		grapple_pos = bt.read_Vec2f();
		grapple_vel = bt.read_Vec2f();
	}

	if (apply)
	{
		knight.grappling = grappling;
		if (knight.grappling)
		{
			knight.grapple_id = grapple_id;
			knight.grapple_ratio = grapple_ratio;
			knight.grapple_pos = grapple_pos;
			knight.grapple_vel = grapple_vel;
		}
	}
}