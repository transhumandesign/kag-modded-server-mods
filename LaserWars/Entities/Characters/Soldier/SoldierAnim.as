// SolderAnim.as

#include "FW_Common.as";

#include "SoldierCommon.as";
#include "GunCommon.as";

#include "WorkerCommon.as";
#include "FireCommon.as";
#include "Requirements.as";
#include "RunnerCommon.as";
#include "Knocked.as";

const string shield_layer = "shield_layer";

void UpdateShield( CSprite@ this, CBlob@ blob, CSpriteLayer@ shield )
{
	shield.SetVisible(true);

	if(!blob.hasTag("dead"))
	{
		bool enabled = blob.hasTag("shield");
		if  (enabled)
		{
			shield.SetAnimation("power on");
		}
		else if (!enabled && !shield.isAnimation("default"))
		{
			shield.SetAnimation("power off");
		}
		else
		{
			shield.SetVisible(false);
		}
	}
	else
	{
		if (shield.isAnimation("default"))
		{
			shield.SetVisible(false);
		}
		else
		{
	        shield.SetAnimation("power off");
		}
	}
}

void UpdateSprite( CSprite@ this )
{
	CBlob@ blob = this.getBlob();
	if    (blob is null) return;

	string suit = getItem(blob, ItemType::EXO_SUIT);
	string texname = suit == "logistics"   ? "../Mods/" + MOD_FOLDER + "/Entities/Characters/Logistics/Worker.png" :
	                 suit == "assault"     ? "../Mods/" + MOD_FOLDER + "/Entities/Characters/Soldier/Assault.png" :
	                 suit == "infiltrator" ? "../Mods/" + MOD_FOLDER + "/Entities/Characters/Soldier/Cloaker.png" :
				     suit == "sentinel"    ? "../Mods/" + MOD_FOLDER + "/Entities/Characters/Soldier/Sentinel.png" :
	                                         "../Mods/" + MOD_FOLDER + "/Entities/Characters/Soldier/Soldier.png";

	if (this.getFilename() != texname)
	{
		this.ReloadSprite(texname);

		if (suit == "sentinel")
		{
		    this.RemoveSpriteLayer(shield_layer);
			CSpriteLayer@ shield = this.addSpriteLayer(shield_layer, texname, 32, 32, this.getBlob().getTeamNum(), this.getBlob().getSkinNum());

			if (shield !is null)
			{
				Animation@ anim = shield.addAnimation("default", 0, false);
				anim.AddFrame(11);

				Animation@ power_on = shield.addAnimation("power on", 3, false);
				power_on.AddFrame(16);
				power_on.AddFrame(13);
				power_on.AddFrame(12);
				power_on.AddFrame(11);

				Animation@ power_off = shield.addAnimation("power off", 3, false);
				power_off.AddFrame(11);
				power_off.AddFrame(12);
				power_off.AddFrame(13);
				power_off.AddFrame(16);
				
				shield.SetRelativeZ(50);
				shield.SetOffset(Vec2f(0, -4));
				shield.SetVisible(false);
			}
		}
	}
}

void onInit( CSprite@ this )
{
	this.getCurrentScript().runFlags |= Script::tick_not_infire;
}

void onTick( CSprite@ this )
{
	// store some vars for ease and speed
	CBlob@ blob = this.getBlob();

	UpdateSprite(this);
	
	CSpriteLayer@ shield = this.getSpriteLayer(shield_layer);

	if (shield !is null)
	{
		UpdateShield(this, blob, shield);
	}

	if (blob.hasTag("dead"))
	{
		this.SetAnimation("dead");
		Vec2f vel = blob.getVelocity();

		if (vel.y < -1.0f)
		{
			this.SetFrameIndex(0);
		}
		else if (vel.y > 1.0f)
		{
			this.SetFrameIndex(2);
		}
		else
		{
			this.SetFrameIndex(1);
		}
		return;
	}

	// animations
	const u8 knocked = getKnocked(blob);
	const bool action2 = blob.isKeyPressed(key_action2);
	const bool action1 = blob.isKeyPressed(key_action1);
	const bool left = blob.isKeyPressed(key_left);
	const bool right = blob.isKeyPressed(key_right);
	const bool up = blob.isKeyPressed(key_up);
	const bool down = blob.isKeyPressed(key_down);
	const bool inair = (!blob.isOnGround() && !blob.isOnLadder());
	Vec2f pos = blob.getPosition();

	RunnerMoveVars@ moveVars;
	if (!blob.get("moveVars", @moveVars))
	{
		return;
	}
	
	if (knocked > 0)
	{
		if (inair)
		{
			this.SetAnimation("knocked_air");
		}
		else
		{
			this.SetAnimation("knocked");
		}
	}
	else if (blob.hasTag("seated"))
	{
		this.SetAnimation("crouch");
	}
	else if (inair)
	{
		RunnerMoveVars@ moveVars;
		if (!blob.get("moveVars", @moveVars))
		{
			return;
		}
		Vec2f vel = blob.getVelocity();
		f32 vy = vel.y;
		if (vy < -0.0f && moveVars.walljumped)
		{
			this.SetAnimation("run");
		}
		else
		{
			this.SetAnimation("fall");
			this.animation.timer = 0;

			if (vy < -1.5)
			{
				this.animation.frame = 0;
			}
			else if (vy > 1.5)
			{
				this.animation.frame = 2;
			}
			else
			{
				this.animation.frame = 1;
			}
		}
	}
	else if ((left || right) ||
			 (blob.isOnLadder() && (up || down)))
	{
		this.SetAnimation("run");
	}
	else
	{
		if (blob.isKeyPressed(key_down))
		{
			this.SetAnimation("crouch");
		}
		else
		{
			this.SetAnimation("default");
		}
	}

	//set the attack head
	if (knocked > 0)
	{
		blob.Tag("dead head");
	}
	else if (action1)
	{
		blob.Tag("attack head");
		blob.Untag("dead head");
	}
	else
	{
		blob.Untag("attack head");
		blob.Untag("dead head");
	}
}

void onGib(CSprite@ this)
{
	if (g_kidssafe)
	{
		return;
	}

	CBlob@ blob = this.getBlob();
	Vec2f pos = blob.getPosition();
	Vec2f vel = blob.getVelocity();
	vel.y -= 3.0f;
	f32 hp = Maths::Min(Maths::Abs(blob.getHealth()), 2.0f) + 1.0;
	const u8 team = blob.getTeamNum();
	const string suit = getItem(blob, ItemType::EXO_SUIT);
	const string texname = suit == "assault"     ? "../Mods/" + MOD_FOLDER + "/Entities/Characters/Soldier/AssaultGibs.png" :
	                       suit == "infiltrator" ? "../Mods/" + MOD_FOLDER + "/Entities/Characters/Soldier/CloakerGibs.png" :
				           suit == "sentinel"    ? "../Mods/" + MOD_FOLDER + "/Entities/Characters/Soldier/SentinelGibs.png" :
	                                               "../Mods/" + MOD_FOLDER + "/Entities/Characters/Logistics/WorkerGibs.png";

	CParticle@ Body     = makeGibParticle(texname, pos, vel + getRandomVelocity(90, hp , 80), 0, 0, Vec2f(16, 16), 2.0f, 20, "/BodyGibFall", team);
	CParticle@ Arm1     = makeGibParticle(texname, pos, vel + getRandomVelocity(90, hp - 0.2 , 80), 1, 0, Vec2f(16, 16), 2.0f, 20, "/BodyGibFall", team);
	CParticle@ Arm2     = makeGibParticle(texname, pos, vel + getRandomVelocity(90, hp - 0.2 , 80), 1, 0, Vec2f(16, 16), 2.0f, 20, "/BodyGibFall", team);
	CParticle@ Gadget1  = makeGibParticle(texname, pos, vel + getRandomVelocity(90, hp , 80), 2, 0, Vec2f(16, 16), 2.0f, 0, "Sounds/material_drop.ogg", team);
	CParticle@ Gadget2  = makeGibParticle(texname, pos, vel + getRandomVelocity(90, hp + 1 , 80), 3, 0, Vec2f(16, 16), 2.0f, 0, "Sounds/material_drop.ogg", team);
}
