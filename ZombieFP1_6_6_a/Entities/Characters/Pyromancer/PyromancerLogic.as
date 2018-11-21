// Pyromancer logic (based on Waterman)

#include "PyromancerCommon.as";
#include "ThrowCommon.as";
#include "Knocked.as";
#include "Hitters.as";
#include "RunnerCommon.as";
#include "ShieldCommon.as";
#include "Help.as";
#include "BombCommon.as";

const int FLETCH_COOLDOWN = 45;
const int PICKUP_COOLDOWN = 15;
const int fletch_num_arrows = 1;
const int STAB_DELAY = 10;
const int STAB_TIME = 22;

void onInit(CBlob@ this)
{
	PyromancerInfo pyromancer;
	this.set("pyromancerInfo", @pyromancer);

	this.set_s8("charge_time", 0);
	this.set_bool("playedfire",false);
	this.set_u8("charge_state", PyromancerParams::not_aiming);
	this.set_bool("has_arrow", false);
	this.set_f32("gib health", -3.0f);
	this.Tag("player");
	this.Tag("flesh");

	//centered on arrows
	//this.set_Vec2f("inventory offset", Vec2f(0.0f, 122.0f));
	//centered on items
	this.set_Vec2f("inventory offset", Vec2f(0.0f, 0.0f));

	//no spinning
	this.getShape().SetRotationsAllowed(false);
	this.getSprite().SetEmitSound("../FireRoarQuiet.ogg");
	this.addCommandID("shoot firebolt");
	this.getShape().getConsts().net_threshold_multiplier = 0.5f;

	//add a command ID for each arrow type
	AddIconToken( "$Firewalk$", "pSpellIcons.png", Vec2f(16,16), 0 );
	AddIconToken( "$Firebolt$", "pSpellIcons.png", Vec2f(16,16), 1 );
	AddIconToken( "$Flaming$", "pSpellIcons.png", Vec2f(16,16), 2 );
	  
	SetHelp( this, "help self action", "pyromancer", "$Firebolt$ Shoot firebolts    $LMB$", "", 5 );
	SetHelp( this, "help self action2", "pyromancer", "$Flaming$ Flamethrower    $RMB$", "" );
	SetHelp( this, "help show", "pyromancer", "$Firewalk$ Blink using V", "" );
	
	this.getCurrentScript().runFlags |= Script::tick_not_attached;
	this.getCurrentScript().removeIfTag = "dead";
}

void onSetPlayer(CBlob@ this, CPlayer@ player)
{
	if (player !is null)
	{
		player.SetScoreboardVars("ScoreboardIcons.png", 10, Vec2f(16,16));
	}
}

void ManageBow(CBlob@ this, PyromancerInfo@ pyromancer, RunnerMoveVars@ moveVars)
{
	CSprite@ sprite = this.getSprite();
	bool ismyplayer = this.isMyPlayer();
	bool hasarrow = true;
	s8 charge_time = pyromancer.charge_time;
	u8 charge_state = pyromancer.charge_state;
	const bool pressed_action2 = this.isKeyPressed(key_action2);
	Vec2f pos = this.getPosition();

	if (charge_state == PyromancerParams::legolas_charging) // fast arrows
	{
		charge_state = PyromancerParams::legolas_ready;
	}
	//charged - no else (we want to check the very same tick)
	if (charge_state == PyromancerParams::legolas_ready) // fast arrows
	{
		moveVars.walkFactor *= 0.75f;

		pyromancer.legolas_time--;
		if (pyromancer.legolas_time == 0)
		{
			bool pressed = this.isKeyPressed(key_action1);
			charge_state = pressed ? PyromancerParams::readying : PyromancerParams::not_aiming;
			charge_time = 0;
			//didn't fire
			if (pyromancer.legolas_arrows == PyromancerParams::legolas_arrows_count)
			{
				Sound::Play("/Stun", pos, 1.0f, this.getSexNum() == 0 ? 1.0f : 2.0f);
				SetKnocked(this, 15);
			}
			else if (pressed)
			{
				sprite.RewindEmitSound();
				sprite.SetEmitSoundPaused(false);
			}
		}
		else if (this.isKeyJustPressed(key_action1) ||
		         (pyromancer.legolas_arrows == PyromancerParams::legolas_arrows_count &&
		          !this.isKeyPressed(key_action1) &&
		          this.wasKeyPressed(key_action1)))
		{
			ClientFire(this, charge_time, hasarrow, pyromancer.arrow_type, true);
			charge_state = PyromancerParams::legolas_charging;
			charge_time = PyromancerParams::shoot_period - PyromancerParams::legolas_charge_time;
			Sound::Play("FireBolt.ogg", pos);
			pyromancer.legolas_arrows--;

			if (pyromancer.legolas_arrows == 0)
			{
				charge_state = PyromancerParams::readying;
				charge_time = 5;

				sprite.RewindEmitSound();
				sprite.SetEmitSoundPaused(false);
			}
		}

	}
	else if (this.isKeyPressed(key_action1))
	{

		const bool just_action1 = this.isKeyJustPressed(key_action1);

		//	printf("charge_state " + charge_state );

		if ((just_action1 || this.wasKeyPressed(key_action2) && !pressed_action2) &&
		        (charge_state == PyromancerParams::not_aiming || charge_state == PyromancerParams::fired))
		{
			charge_state = PyromancerParams::readying;
			pyromancer.arrow_type = ArrowType::normal;

			charge_time = 0;

			sprite.PlayRandomSound("FireBolt");

			sprite.RewindEmitSound();
			sprite.SetEmitSoundPaused(false);

			if (!ismyplayer)   // lower the volume of other players charging  - ooo good idea
			{
				sprite.SetEmitSoundVolume(0.5f);
			}
		}
		else if (charge_state == PyromancerParams::readying)
		{
			charge_time++;

			if (charge_time > PyromancerParams::ready_time)
			{
				charge_time = 1;
				charge_state = PyromancerParams::charging;
			}
		}
		else if (charge_state == PyromancerParams::charging)
		{
			charge_time++;

			if (charge_time >= PyromancerParams::legolas_period)
			{
				// Legolas state
				Sound::Play("AnimeSword.ogg", pos, ismyplayer ? 1.3f : 0.7f);
				Sound::Play("FireRoar.ogg", pos);
				charge_state = PyromancerParams::legolas_charging;
				charge_time = PyromancerParams::shoot_period - PyromancerParams::legolas_charge_time;

				pyromancer.legolas_arrows = PyromancerParams::legolas_arrows_count;
				pyromancer.legolas_time = PyromancerParams::legolas_time;
			}

			if (charge_time >= PyromancerParams::shoot_period)
				sprite.SetEmitSoundPaused(true);
		}
		else if (charge_state == PyromancerParams::no_arrows)
		{
			if (charge_time < PyromancerParams::ready_time)
			{
				charge_time++;
			}
		}
	}
	else
	{
		if (charge_state > PyromancerParams::readying)
		{
			if (charge_state < PyromancerParams::fired)
			{
				if (pyromancer.charge_time >= PyromancerParams::shoot_period-10)ClientFire(this, charge_time, hasarrow, pyromancer.arrow_type, false);

				charge_time = PyromancerParams::fired_time;
				charge_state = PyromancerParams::fired;
			}
			else //fired..
			{
				charge_time--;

				if (charge_time <= 0)
				{
					charge_state = PyromancerParams::not_aiming;
					charge_time = 0;
				}
			}
		}
		else
		{
			charge_state = PyromancerParams::not_aiming;    //set to not aiming either way
			charge_time = 0;
		}

		sprite.SetEmitSoundPaused(true);
	}

	// my player!

	if (ismyplayer)
	{
		// set cursor

		if (!getHUD().hasButtons())
		{
			int frame = 0;
			//	print("pyromancer.charge_time " + pyromancer.charge_time + " / " + PyromancerParams::shoot_period );
			if (pyromancer.charge_state == PyromancerParams::readying)
			{
				frame = 1 + float(pyromancer.charge_time) / float(PyromancerParams::shoot_period + PyromancerParams::ready_time) * 7;
			}
			else if (pyromancer.charge_state == PyromancerParams::charging)
			{
				if (pyromancer.charge_time <= PyromancerParams::shoot_period)
				{
					frame = float(PyromancerParams::ready_time + pyromancer.charge_time) / float(PyromancerParams::shoot_period) * 7;
				}
				else
					frame = 9;
			}
			else if (pyromancer.charge_state == PyromancerParams::legolas_ready)
			{
				frame = 10;
			}
			else if (pyromancer.charge_state == PyromancerParams::legolas_charging)
			{
				frame = 9;
			}
			getHUD().SetCursorFrame(frame);
		}

		// activate/throw

		if (this.isKeyJustPressed(key_action3))
		{
			client_SendThrowOrActivateCommand(this);
		}

		// pick up arrow

		if (pyromancer.fletch_cooldown > 0)
		{
			pyromancer.fletch_cooldown--;
		}
	}

	pyromancer.charge_time = charge_time;
	pyromancer.charge_state = charge_state;
	pyromancer.has_arrow = hasarrow;

}

void onTick(CBlob@ this)
{
	PyromancerInfo@ pyromancer;
	if (!this.get("pyromancerInfo", @pyromancer))
	{
		return;
	}

	if (getKnocked(this) > 0)
	{
		pyromancer.grappling = false;
		pyromancer.charge_state = 0;
		pyromancer.charge_time = 0;
		return;
	}
	
	if (getKnocked(this) <= 0)
	if (this.isKeyPressed(key_action2) && !this.isKeyPressed(key_action1)){
		
		if(this.isKeyJustPressed(key_action2)){
			Sound::Play("Firewoosh.ogg", this.getPosition());
		}
		
		this.Tag("flaming");	
		
		RunnerMoveVars@ moveVars;
		if (this.get("moveVars", @moveVars))
		{
			moveVars.walkFactor *= 0.1f;
		}
	
		int neg = 1;
		if(this.isFacingLeft())neg = -1;
		
		CMap@ map = getMap();
		int range = 0;
		
		if (map != null)
		for (int doFirey = -80; doFirey <= 80; doFirey += 1 * 8) //8 - tile size in pixels
		{
			for (int doFirex = 0; doFirex <= 3 * 8; doFirex += 1 * 8) //8 - tile size in pixels
			{
				if(doFirey <= (doFirex/3) && doFirey >= -(doFirex/3))
				map.server_setFireWorldspace(Vec2f(this.getPosition().x + (doFirex+12)*neg, this.getPosition().y + doFirey - 8), true);
				if(map.isTileSolid(map.getTile(Vec2f(this.getPosition().x + (doFirex+12)*neg, this.getPosition().y + doFirey - 8)).type))break;
				this.SetLight(true);
				this.SetLightRadius(48.0f);
				this.SetLightColor(SColor(255, 255, 240, 171));	
			}
		}
	}
	else
	{
		this.Untag("flaming");
		this.SetLight(false);
	}
	
	// vvvvvvvvvvvvvv CLIENT-SIDE ONLY vvvvvvvvvvvvvvvvvvv

	if (!getNet().isClient()) return;

	if (this.isInInventory()) return;

	RunnerMoveVars@ moveVars;
	if (!this.get("moveVars", @moveVars))
	{
		return;
	}

	ManageBow(this, pyromancer, moveVars);
}

bool canSend(CBlob@ this)
{
	return (this.isMyPlayer() || this.getPlayer() is null || this.getPlayer().isBot());
}

void ClientFire(CBlob@ this, const s8 charge_time, const bool hasarrow, const u8 arrow_type, const bool legolas)
{
	//time to fire!
	if (canSend(this))  // client-logic
	{
		f32 arrowspeed;

		if (charge_time < PyromancerParams::ready_time / 2 + PyromancerParams::shoot_period_1)
		{
			arrowspeed = PyromancerParams::shoot_max_vel * (1.0f / 3.0f);
		}
		else if (charge_time < PyromancerParams::ready_time / 2 + PyromancerParams::shoot_period_2)
		{
			arrowspeed = PyromancerParams::shoot_max_vel * (4.0f / 5.0f);
		}
		else
		{
			arrowspeed = PyromancerParams::shoot_max_vel;
		}

		ShootFirebolt(this, this.getPosition() + Vec2f(0.0f, -2.0f), this.getAimPos() + Vec2f(0.0f, -2.0f), arrowspeed, arrow_type, legolas);
	}
}

void ShootFirebolt(CBlob @this, Vec2f arrowPos, Vec2f aimpos, f32 arrowspeed, const u8 arrow_type, const bool legolas = true)
{
	if (canSend(this))
	{
		// player or bot
		Vec2f arrowVel = (aimpos - arrowPos);
		arrowVel.Normalize();
		arrowVel *= arrowspeed;
		//print("arrowspeed " + arrowspeed);
		CBitStream params;
		params.write_Vec2f(arrowPos);
		params.write_Vec2f(arrowVel);
		params.write_u8(arrow_type);
		params.write_bool(legolas);

		this.SendCommand(this.getCommandID("shoot firebolt"), params);
	}
}

CBlob@ CreateFireBolt(CBlob@ this, Vec2f arrowPos, Vec2f arrowVel, u8 arrowType)
{
	
	CBlob @blob = server_CreateBlob("firebolt", this.getTeamNum(), this.getPosition());
	this.getSprite().PlaySound("FireBolt.ogg");
	if (blob !is null)
	{
		blob.setVelocity(arrowVel);
	}
	return blob;
}

CBlob@ CreateFireBall(CBlob@ this, Vec2f arrowPos, Vec2f arrowVel, u8 arrowType)
{
	
	CBlob @blob = server_CreateBlob("fireball", this.getTeamNum(), this.getPosition());
	this.getSprite().PlaySound("FireBall.ogg");
	if (blob !is null)
	{
		blob.setVelocity(arrowVel);
	}
	return blob;
}

void onCommand(CBlob@ this, u8 cmd, CBitStream @params)
{
	if (cmd == this.getCommandID("shoot firebolt"))
	{
		Vec2f arrowPos = params.read_Vec2f();
		Vec2f arrowVel = params.read_Vec2f();
		u8 arrowType = params.read_u8();
		bool legolas = params.read_bool();

		PyromancerInfo@ pyromancer;
		if (!this.get("pyromancerInfo", @pyromancer))
		{
			return;
		}

		pyromancer.arrow_type = arrowType;

		if (legolas)
		{
			if (getNet().isServer())
			{
				CBlob@ arrow = CreateFireBall(this, arrowPos, arrowVel*1.2, arrowType);
			}
			this.getSprite().PlaySound("FireBolt.ogg");
		}
		else
		{
			if (getNet().isServer())
			{
				CreateFireBolt(this, arrowPos, arrowVel, arrowType);
			}
		}
		this.getSprite().PlaySound("FireBolt.ogg");
	}
}

void onCreateInventoryMenu(CBlob@ this, CBlob@ forBlob, CGridMenu @gridmenu)
{
}

// auto-switch to appropriate arrow when picked up
void onAddToInventory(CBlob@ this, CBlob@ blob)
{
}