// Fighter logic

#include "FighterCommon.as"
#include "ThrowCommon.as"
#include "Knocked.as"
#include "Hitters.as"
#include "RunnerCommon.as"
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
	FighterInfo fighter;
	this.set("fighterInfo", @fighter);

	this.set_s8("charge_time", 0);
	this.set_u8("charge_state", FighterParams::not_aiming);
	this.set_bool("has_arrow", false);
	this.set_f32("gib health", -3.0f);
	this.Tag("player");
	this.Tag("flesh");
	this.Tag("no falldamage"); // this did nothing

	//centered on arrows
	//this.set_Vec2f("inventory offset", Vec2f(0.0f, 122.0f));
	//centered on items
	this.set_Vec2f("inventory offset", Vec2f(0.0f, 0.0f));

	//no spinning
	this.getShape().SetRotationsAllowed(false);
	this.getSprite().SetEmitSound("/RifleReload.ogg");
	this.addCommandID("shoot arrow");
	this.addCommandID("pickup arrow");
	this.getShape().getConsts().net_threshold_multiplier = 0.5f;

	this.addCommandID(grapple_sync_cmd);

	SetHelp(this, "help self hide", "fighter", "Hide    $KEY_S$", "", 1);
	SetHelp(this, "help self action2", "fighter", "$Grapple$ Grappling hook    $RMB$", "", 3);

	//add a command ID for each arrow type
	for (uint i = 0; i < arrowTypeNames.length; i++)
	{
		this.addCommandID("pick " + arrowTypeNames[i]);
	}

	this.getCurrentScript().runFlags |= Script::tick_not_attached;
	this.getCurrentScript().removeIfTag = "dead";
}

void onSetPlayer(CBlob@ this, CPlayer@ player)
{
	if (player !is null)
	{
		player.SetScoreboardVars("ScoreboardIcons.png", 2, Vec2f(16, 16));
	}
}

// Osmal - for characters not to collide with enemies - doesn't work apparently; changed RunnerCollision.as instead, 
// but we don't have stomps now
/*bool doesCollideWithBlob(CBlob@ this, CBlob@ blob)
{ 
	if (blob.hasTag("player"))
	{
	return false;
	}	
}
*/
void ManageGrapple(CBlob@ this, FighterInfo@ fighter)
{
	CSprite@ sprite = this.getSprite();
	u8 charge_state = fighter.charge_state;
	Vec2f pos = this.getPosition();

	const bool right_click = this.isKeyJustPressed(key_action2);
	if (right_click)
	{
		if (canSend(this)) // grapple
		{
			fighter.grappling = true;
			fighter.grapple_id = 0xffff;
			fighter.grapple_pos = pos;

			fighter.grapple_ratio = 1.0f; //allow fully extended

			Vec2f direction = this.getAimPos() - pos;

			//aim in direction of cursor
			f32 distance = direction.Normalize();
			if (distance > 1.0f)
			{
				fighter.grapple_vel = direction * fighter_grapple_throw_speed;
			}
			else
			{
				fighter.grapple_vel = Vec2f_zero;
			}

			SyncGrapple(this);
		}

		fighter.charge_state = charge_state;
	}

	if (fighter.grappling)
	{
		//update grapple
		//TODO move to its own script?

		if (!this.isKeyPressed(key_action2))
		{
			if (canSend(this))
			{
				fighter.grappling = false;
				SyncGrapple(this);
			}
		}
		else
		{
			const f32 fighter_grapple_range = fighter_grapple_length * fighter.grapple_ratio;
			const f32 fighter_grapple_force_limit = this.getMass() * fighter_grapple_accel_limit;

			CMap@ map = this.getMap();

			//reel in
			//TODO: sound
			if (fighter.grapple_ratio > 0.2f)
				fighter.grapple_ratio -= 1.0f / getTicksASecond();

			//get the force and offset vectors
			Vec2f force;
			Vec2f offset;
			f32 dist;
			{
				force = fighter.grapple_pos - this.getPosition();
				dist = force.Normalize();
				f32 offdist = dist - fighter_grapple_range;
				if (offdist > 0)
				{
					offset = force * Maths::Min(8.0f, offdist * fighter_grapple_stiffness);
					force *= Maths::Min(fighter_grapple_force_limit, Maths::Max(0.0f, offdist + fighter_grapple_slack) * fighter_grapple_force);
				}
				else
				{
					force.Set(0, 0);
				}
			}

			//left map? close grapple
			if (fighter.grapple_pos.x < map.tilesize || fighter.grapple_pos.x > (map.tilemapwidth - 1)*map.tilesize)
			{
				if (canSend(this))
				{
					SyncGrapple(this);
					fighter.grappling = false;
				}
			}
			else if (fighter.grapple_id == 0xffff) //not stuck
			{
				const f32 drag = map.isInWater(fighter.grapple_pos) ? 0.7f : 0.90f;
				const Vec2f gravity(0, 1);

				fighter.grapple_vel = (fighter.grapple_vel * drag) + gravity - (force * (2 / this.getMass()));

				Vec2f next = fighter.grapple_pos + fighter.grapple_vel;
				next -= offset;

				Vec2f dir = next - fighter.grapple_pos;
				f32 delta = dir.Normalize();
				bool found = false;
				const f32 step = map.tilesize * 0.5f;
				while (delta > 0 && !found) //fake raycast
				{
					if (delta > step)
					{
						fighter.grapple_pos += dir * step;
					}
					else
					{
						fighter.grapple_pos = next;
					}
					delta -= step;
					found = checkGrappleStep(this, fighter, map, dist);
				}

			}
			else //stuck -> pull towards pos
			{

				//wallrun/jump reset to make getting over things easier
				//at the top of grapple
				if (this.isOnWall()) //on wall
				{
					//close to the grapple point
					//not too far above
					//and moving downwards
					Vec2f dif = pos - fighter.grapple_pos;
					if (this.getVelocity().y > 0 &&
					        dif.y > -10.0f &&
					        dif.Length() < 24.0f)
					{
						//need move vars
						RunnerMoveVars@ moveVars;
						if (this.get("moveVars", @moveVars))
						{
							moveVars.walljumped_side = Walljump::NONE;
							moveVars.wallrun_start = pos.y;
							moveVars.wallrun_current = pos.y;
						}
					}
				}

				CBlob@ b = null;
				if (fighter.grapple_id != 0)
				{
					@b = getBlobByNetworkID(fighter.grapple_id);
					if (b is null)
					{
						fighter.grapple_id = 0;
					}
				}

				if (b !is null)
				{
					fighter.grapple_pos = b.getPosition();
					if (b.isKeyJustPressed(key_action1) ||
					        b.isKeyJustPressed(key_action2) ||
					        this.isKeyPressed(key_use))
					{
						if (canSend(this))
						{
							SyncGrapple(this);
							fighter.grappling = false;
						}
					}
				}
				else if (shouldReleaseGrapple(this, fighter, map))
				{
					if (canSend(this))
					{
						SyncGrapple(this);
						fighter.grappling = false;
					}
				}

				this.AddForce(force);
				Vec2f target = (this.getPosition() + offset);
				if (!map.rayCastSolid(this.getPosition(), target))
				{
					this.setPosition(target);
				}

				if (b !is null)
					b.AddForce(-force * (b.getMass() / this.getMass()));

			}
		}

	}
}

void ManageWeapon(CBlob@ this, FighterInfo@ fighter, RunnerMoveVars@ moveVars)
{
	CSprite@ sprite = this.getSprite();
	bool ismyplayer = this.isMyPlayer();
	bool hasarrow = fighter.has_arrow;
	s8 charge_time = fighter.charge_time;
	u8 charge_state = fighter.charge_state;
	const bool pressed_action2 = this.isKeyPressed(key_action2);
	Vec2f pos = this.getPosition();

	if (ismyplayer)
	{
		if ((getGameTime() + this.getNetworkID()) % 10 == 0)
		{
			// set back to default
			if (!hasArrows(this, fighter.arrow_type))
			{
				fighter.arrow_type = ArrowType::normal;
			}
		}

		this.set_bool("has_arrow", hasarrow);
		this.Sync("has_arrow", false);

		fighter.stab_delay = 0;
	}

	//charged - no else (we want to check the very same tick)
	if (this.isKeyPressed(key_action1) && !this.isKeyPressed(key_inventory) &&
		(charge_state > FighterParams::readying && 
		charge_time >= FighterParams::ready_time / 2 + FighterParams::shoot_period_2))
		{
			if (charge_state < FighterParams::fired)
			{
				ClientFire(this, charge_time, hasarrow, fighter.arrow_type, false);

				charge_time = FighterParams::fired_time;
				charge_state = FighterParams::fired;
			}
			else //fired..
			{
				charge_time--;

				if (charge_time <= 0)
				{
					charge_state = FighterParams::not_aiming;
					charge_time = 0;
				}
			}
			sprite.SetEmitSoundPaused(true);
		}
	else
	{
		const bool just_action1 = this.isKeyJustPressed(key_action1);

		//	printf("charge_state " + charge_state );

		if (charge_state == FighterParams::not_aiming || charge_state == FighterParams::fired)
		{
			charge_state = FighterParams::readying;
			hasarrow = hasArrows(this);

			if (!hasarrow)
			{
				fighter.arrow_type = ArrowType::normal;
				hasarrow = hasArrows(this);

			}

			if (ismyplayer)
			{
				this.set_bool("has_arrow", hasarrow);
				this.Sync("has_arrow", false);
			}

			charge_time = 0;

			if (ismyplayer)
			{
				if (just_action1)
				{
					const u8 type = fighter.arrow_type;

					if (type == ArrowType::water)
					{
						sprite.PlayRandomSound("/WaterBubble");
					}
					else if (type == ArrowType::fire)
					{
						sprite.PlaySound("SparkleShort.ogg");
					}
				}
			}

			sprite.RewindEmitSound();
			sprite.SetEmitSoundPaused(false);

			if (!ismyplayer)   // lower the volume of other players charging  - ooo good idea
			{
				sprite.SetEmitSoundVolume(0.5f);
			}
		}
		else if (charge_state == FighterParams::readying)
		{
			charge_time++;

			if (charge_time > FighterParams::ready_time)
			{
				charge_time = 1;
				charge_state = FighterParams::charging;
			}
		}
		else if (charge_state == FighterParams::charging)
		{
			if (charge_time < FighterParams::legolas_period)
				charge_time++;

			// if (charge_time >= FighterParams::legolas_period)
			// {
			// 	// Legolas state

			// 	Sound::Play("AnimeSword.ogg", pos, ismyplayer ? 1.3f : 0.7f);
			// 	Sound::Play("FastBowPull.ogg", pos);
			// 	charge_state = FighterParams::legolas_charging;
			// 	charge_time = FighterParams::shoot_period - FighterParams::legolas_charge_time;

			// 	fighter.legolas_arrows = FighterParams::legolas_arrows_count;
			// 	fighter.legolas_time = FighterParams::legolas_time;
			// }

			if (charge_time >= FighterParams::shoot_period)
				sprite.SetEmitSoundPaused(true);
		}
		else if (charge_state == FighterParams::no_arrows)
		{
			if (charge_time < FighterParams::ready_time)
			{
				charge_time++;
			}
		}
	}

	// safe disable bomb light

	if (this.wasKeyPressed(key_action1) && !this.isKeyPressed(key_action1))
	{
		const u8 type = fighter.arrow_type;
		if (type == ArrowType::bomb)
		{
			BombFuseOff(this);
		}
	}

	// my player!

	if (ismyplayer)
	{
		// set cursor

		if (!getHUD().hasButtons())
		{
			int frame = 0;
			//	print("fighter.charge_time " + fighter.charge_time + " / " + FighterParams::shoot_period );
			if (fighter.charge_state == FighterParams::readying)
			{
				frame = 1 + float(fighter.charge_time) / float(FighterParams::shoot_period + FighterParams::ready_time) * 7;
			}
			else if (fighter.charge_state == FighterParams::charging)
			{
				if (fighter.charge_time <= FighterParams::shoot_period)
				{
					frame = float(FighterParams::ready_time + fighter.charge_time) / float(FighterParams::shoot_period) * 7;
				}
				else
					frame = 9;
			}
			else if (fighter.charge_state == FighterParams::legolas_ready)
			{
				frame = 10;
			}
			else if (fighter.charge_state == FighterParams::legolas_charging)
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

		// if (fighter.fletch_cooldown > 0)
		// {
		// 	fighter.fletch_cooldown--;
		// }

		// // pickup from ground

		// if (fighter.fletch_cooldown == 0 && this.isKeyPressed(key_action2))
		// {
		// 	if (getPickupArrow(this) !is null)   // pickup arrow from ground
		// 	{
		// 		this.SendCommand(this.getCommandID("pickup arrow"));
		// 		fighter.fletch_cooldown = PICKUP_COOLDOWN;
		// 	}
		// }
	}

	fighter.charge_time = charge_time;
	fighter.charge_state = charge_state;
	fighter.has_arrow = hasarrow;

}

void onTick(CBlob@ this)
{
	FighterInfo@ fighter;
	if (!this.get("fighterInfo", @fighter))
	{
		return;
	}

	if (getKnocked(this) > 0)
	{
		fighter.grappling = false;
		fighter.charge_state = 0;
		fighter.charge_time = 0;
		return;
	}

	// ManageGrapple(this, fighter);

	// vvvvvvvvvvvvvv CLIENT-SIDE ONLY vvvvvvvvvvvvvvvvvvv

	if (!getNet().isClient()) return;

	if (this.isInInventory()) return;

	RunnerMoveVars@ moveVars;
	if (!this.get("moveVars", @moveVars))
	{
		return;
	}

	ManageWeapon(this, fighter, moveVars);
}

bool checkGrappleStep(CBlob@ this, FighterInfo@ fighter, CMap@ map, const f32 dist)
{
	if (map.getSectorAtPosition(fighter.grapple_pos, "barrier") !is null)  //red barrier
	{
		if (canSend(this))
		{
			fighter.grappling = false;
			SyncGrapple(this);
		}
	}
	else if (grappleHitMap(fighter, map, dist))
	{
		fighter.grapple_id = 0;

		fighter.grapple_ratio = Maths::Max(0.2, Maths::Min(fighter.grapple_ratio, dist / fighter_grapple_length));

		if (canSend(this)) SyncGrapple(this);

		return true;
	}
	else
	{
		CBlob@ b = map.getBlobAtPosition(fighter.grapple_pos);
		if (b !is null)
		{
			if (b is this)
			{
				//can't grapple self if not reeled in
				if (fighter.grapple_ratio > 0.5f)
					return false;

				if (canSend(this))
				{
					fighter.grappling = false;
					SyncGrapple(this);
				}

				return true;
			}
			else if (b.isCollidable() && b.getShape().isStatic())
			{
				//TODO: Maybe figure out a way to grapple moving blobs
				//		without massive desync + forces :)

				fighter.grapple_ratio = Maths::Max(0.2, Maths::Min(fighter.grapple_ratio, b.getDistanceTo(this) / fighter_grapple_length));

				fighter.grapple_id = b.getNetworkID();
				if (canSend(this))
				{
					SyncGrapple(this);
				}

				return true;
			}
		}
	}

	return false;
}

bool grappleHitMap(FighterInfo@ fighter, CMap@ map, const f32 dist = 16.0f)
{
	return  map.isTileSolid(fighter.grapple_pos + Vec2f(0, -3)) ||			//fake quad
	        map.isTileSolid(fighter.grapple_pos + Vec2f(3, 0)) ||
	        map.isTileSolid(fighter.grapple_pos + Vec2f(-3, 0)) ||
	        map.isTileSolid(fighter.grapple_pos + Vec2f(0, 3)) ||
	        (dist > 10.0f && map.getSectorAtPosition(fighter.grapple_pos, "tree") !is null);   //tree stick
}

bool shouldReleaseGrapple(CBlob@ this, FighterInfo@ fighter, CMap@ map)
{
	return !grappleHitMap(fighter, map) || this.isKeyPressed(key_use);
}

bool canSend(CBlob@ this)
{
	return (this.isMyPlayer() || this.getPlayer() is null || this.getPlayer().isBot());
}

void ClientFire(CBlob@ this, const s8 charge_time, const bool hasarrow, const u8 arrow_type, const bool legolas)
{
	//time to fire!
	if (hasarrow && canSend(this))  // client-logic
	{
		f32 arrowspeed;

		if (charge_time < FighterParams::ready_time / 2 + FighterParams::shoot_period_1)
		{
			arrowspeed = FighterParams::shoot_max_vel * (1.0f / 3.0f);
		}
		else if (charge_time < FighterParams::ready_time / 2 + FighterParams::shoot_period_2)
		{
			arrowspeed = FighterParams::shoot_max_vel * (4.0f / 5.0f);
		}
		else
		{
			arrowspeed = FighterParams::shoot_max_vel * 1.25; //Trying to get faster bulletts; multiplied by 1.25
		}

		// Vec2f(0.0f, -8.0f) works well for shooting above 2 tiles right behind cover; it wasn't that hard to fix :>
		ShootArrow(this, this.getPosition() + Vec2f(0.0f, -8.0f), this.getAimPos() + Vec2f(0.0f, -2.0f), arrowspeed, arrow_type, legolas);
	}
}

void ShootArrow(CBlob @this, Vec2f arrowPos, Vec2f aimpos, f32 arrowspeed, const u8 arrow_type, const bool legolas = true)
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

		this.SendCommand(this.getCommandID("shoot arrow"), params);
	}
}

CBlob@ getPickupArrow(CBlob@ this)
{
	CBlob@[] blobsInRadius;
	if (this.getMap().getBlobsInRadius(this.getPosition(), this.getRadius() * 1.5f, @blobsInRadius))
	{
		for (uint i = 0; i < blobsInRadius.length; i++)
		{
			CBlob @b = blobsInRadius[i];
			if (b.getName() == "arrow")
			{
				return b;
			}
		}
	}
	return null;
}

bool canPickSpriteArrow(CBlob@ this, bool takeout)
{
	CBlob@[] blobsInRadius;
	if (this.getMap().getBlobsInRadius(this.getPosition(), this.getRadius() * 1.5f, @blobsInRadius))
	{
		for (uint i = 0; i < blobsInRadius.length; i++)
		{
			CBlob @b = blobsInRadius[i];
			{
				CSprite@ sprite = b.getSprite();
				if (sprite.getSpriteLayer("arrow") !is null)
				{
					if (takeout)
						sprite.RemoveSpriteLayer("arrow");
					return true;
				}
			}
		}
	}
	return false;
}

CBlob@ CreateArrow(CBlob@ this, Vec2f arrowPos, Vec2f arrowVel, u8 arrowType)
{
	CBlob@ arrow = server_CreateBlobNoInit("arrow");
	if (arrow !is null)
	{
		// fire arrow?
		arrow.set_u8("arrow type", arrowType);
		arrow.Init();

		arrow.IgnoreCollisionWhileOverlapped(this);
		arrow.SetDamageOwnerPlayer(this.getPlayer());
		arrow.server_setTeamNum(this.getTeamNum());
		arrow.setPosition(arrowPos);
		arrow.setVelocity(arrowVel);
	}
	return arrow;
}

void onCommand(CBlob@ this, u8 cmd, CBitStream @params)
{
	if (cmd == this.getCommandID("shoot arrow"))
	{
		Vec2f arrowPos = params.read_Vec2f();
		Vec2f arrowVel = params.read_Vec2f();
		u8 arrowType = params.read_u8();
		bool legolas = params.read_bool();

		FighterInfo@ fighter;
		if (!this.get("fighterInfo", @fighter))
		{
			return;
		}

		fighter.arrow_type = arrowType;

		// return to normal arrow - server didnt have this synced
		if (!hasArrows(this, arrowType))
		{
			return;
		}

		if (legolas)
		{
			int r = 0;
			for (int i = 0; i < FighterParams::legolas_arrows_volley; i++)
			{
				if (getNet().isServer())
				{
					CBlob@ arrow = CreateArrow(this, arrowPos, arrowVel, arrowType);
					if (i > 0 && arrow !is null)
					{
						arrow.Tag("shotgunned");
					}
				}
				this.TakeBlob(arrowTypeNames[ arrowType ], 1);
				arrowType = ArrowType::normal;

				//don't keep firing if we're out of arrows
				if (!hasArrows(this, arrowType))
					break;

				r = r > 0 ? -(r + 1) : (-r) + 1;

				arrowVel = arrowVel.RotateBy(FighterParams::legolas_arrows_deviation * r, Vec2f());
				if (i == 0)
				{
					arrowVel *= 0.9f;
				}
			}
			this.getSprite().PlaySound("/RifleShot3.ogg");
		}
		else
		{
			if (getNet().isServer())
			{
				CreateArrow(this, arrowPos, arrowVel, arrowType);
			}

			this.getSprite().PlaySound("/RifleShot3.ogg");
			this.TakeBlob(arrowTypeNames[ arrowType ], 1);
		}

		fighter.fletch_cooldown = FLETCH_COOLDOWN; // just don't allow shoot + make arrow
	}
	else if (cmd == this.getCommandID("pickup arrow"))
	{
		CBlob@ arrow = getPickupArrow(this);
		bool spriteArrow = canPickSpriteArrow(this, false);
		if (arrow !is null || spriteArrow)
		{
			if (arrow !is null)
			{
				FighterInfo@ fighter;
				if (!this.get("fighterInfo", @fighter))
				{
					return;
				}
				const u8 arrowType = fighter.arrow_type;
				if (arrowType == ArrowType::bomb)
				{
					arrow.set_u16("follow", 0); //this is already synced, its in command.
					arrow.setPosition(this.getPosition());
					return;
				}
			}

			CBlob@ mat_arrows = server_CreateBlob("mat_arrows", this.getTeamNum(), this.getPosition());
			if (mat_arrows !is null)
			{
				mat_arrows.server_SetQuantity(fletch_num_arrows);
				mat_arrows.Tag("do not set materials");
				this.server_PutInInventory(mat_arrows);

				if (arrow !is null)
				{
					arrow.server_Die();
				}
				else
				{
					canPickSpriteArrow(this, true);
				}
			}
			this.getSprite().PlaySound("Entities/Items/Projectiles/Sounds/ArrowHitGround.ogg");
		}
	}
	else if (cmd == this.getCommandID(grapple_sync_cmd))
	{
		HandleGrapple(this, params, !canSend(this));
	}
	else if (cmd == this.getCommandID("cycle"))  //from standardcontrols
	{
		// cycle arrows
		FighterInfo@ fighter;
		if (!this.get("fighterInfo", @fighter))
		{
			return;
		}
		u8 type = fighter.arrow_type;

		int count = 0;
		while (count < arrowTypeNames.length)
		{
			type++;
			count++;
			if (type >= arrowTypeNames.length)
			{
				type = 0;
			}
			if (hasArrows(this, type))
			{
				fighter.arrow_type = type;
				if (this.isMyPlayer())
				{
					Sound::Play("/CycleInventory.ogg");
				}
				break;
			}
		}
	}
	else
	{
		FighterInfo@ fighter;
		if (!this.get("fighterInfo", @fighter))
		{
			return;
		}
		for (uint i = 0; i < arrowTypeNames.length; i++)
		{
			if (cmd == this.getCommandID("pick " + arrowTypeNames[i]))
			{
				fighter.arrow_type = i;
				break;
			}
		}
	}
}

// arrow pick menu
void onCreateInventoryMenu(CBlob@ this, CBlob@ forBlob, CGridMenu @gridmenu)
{
	if (arrowTypeNames.length == 0)
	{
		return;
	}

	this.ClearGridMenusExceptInventory();
	Vec2f pos(gridmenu.getUpperLeftPosition().x + 0.5f * (gridmenu.getLowerRightPosition().x - gridmenu.getUpperLeftPosition().x),
	          gridmenu.getUpperLeftPosition().y - 32 * 1 - 2 * 24);
	CGridMenu@ menu = CreateGridMenu(pos, this, Vec2f(arrowTypeNames.length, 2), "Current arrow");

	FighterInfo@ fighter;
	if (!this.get("fighterInfo", @fighter))
	{
		return;
	}
	const u8 arrowSel = fighter.arrow_type;

	if (menu !is null)
	{
		menu.deleteAfterClick = false;

		for (uint i = 0; i < arrowTypeNames.length; i++)
		{
			string matname = arrowTypeNames[i];
			CGridButton @button = menu.AddButton(arrowIcons[i], arrowNames[i], this.getCommandID("pick " + matname));

			if (button !is null)
			{
				bool enabled = hasArrows(this, i);
				button.SetEnabled(enabled);
				button.selectOneOnClick = true;

				//if (enabled && i == ArrowType::fire && !hasReqs(this, i))
				//{
				//	button.hoverText = "Requires a fire source $lantern$";
				//	//button.SetEnabled( false );
				//}

				if (arrowSel == i)
				{
					button.SetSelected(1);
				}
			}
		}
	}
}

// auto-switch to appropriate arrow when picked up
void onAddToInventory(CBlob@ this, CBlob@ blob)
{
	string itemname = blob.getName();
	if (this.isMyPlayer())
	{
		for (uint j = 0; j < arrowTypeNames.length; j++)
		{
			if (itemname == arrowTypeNames[j])
			{
				SetHelp(this, "help self action", "fighter", "$arrow$Fire arrow   $KEY_HOLD$$LMB$", "", 3);
				if (j > 0 && this.getInventory().getItemsCount() > 1)
				{
					SetHelp(this, "help inventory", "fighter", "$Help_Arrow1$$Swap$$Help_Arrow2$         $KEY_TAP$$KEY_F$", "", 2);
				}
				break;
			}
		}
	}

	CInventory@ inv = this.getInventory();
	if (inv.getItemsCount() == 0)
	{
		FighterInfo@ fighter;
		if (!this.get("fighterInfo", @fighter))
		{
			return;
		}

		for (uint i = 0; i < arrowTypeNames.length; i++)
		{
			if (itemname == arrowTypeNames[i])
			{
				fighter.arrow_type = i;
			}
		}
	}
}

void onHitBlob(CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitBlob, u8 customData)
{
	if (customData == Hitters::stab)
	{
		if (damage > 0.0f)
		{

			// fletch arrow
			if (hitBlob.hasTag("tree"))	// make arrow from tree
			{
				if (getNet().isServer())
				{
					CBlob@ mat_arrows = server_CreateBlob("mat_arrows", this.getTeamNum(), this.getPosition());
					if (mat_arrows !is null)
					{
						mat_arrows.server_SetQuantity(fletch_num_arrows);
						mat_arrows.Tag("do not set materials");
						this.server_PutInInventory(mat_arrows);
					}
				}
				this.getSprite().PlaySound("Entities/Items/Projectiles/Sounds/ArrowHitGround.ogg");
			}
			else
				this.getSprite().PlaySound("KnifeStab.ogg");
		}

		if (blockAttack(hitBlob, velocity, 0.0f))
		{
			this.getSprite().PlaySound("/Stun", 1.0f, this.getSexNum() == 0 ? 1.0f : 2.0f);
			SetKnocked(this, 30);
		}
	}
}

