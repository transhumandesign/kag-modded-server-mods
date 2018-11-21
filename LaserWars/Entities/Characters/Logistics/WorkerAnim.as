// WorkerAnim.as

#include "SoldierCommon.as";
#include "GunCommon.as";

#include "WorkerCommon.as";
#include "FireCommon.as";
#include "Requirements.as";
#include "RunnerCommon.as";
#include "Knocked.as";

const string blade_layer = "blade_layer";
const Vec2f  blade_offset = Vec2f(4.0f, 2.0f);

const string tool_layer = "tool_layer";
const Vec2f  tool_offset = Vec2f(-2.0f, 7.0f);
const Vec2f  tool_rotation_offset = Vec2f(-6.0f, -2.0f);

void UpdateBlade( CSprite@ this, CBlob@ blob, CSpriteLayer@ blade, bool visible )
{
	blade.SetVisible(visible);

	if (visible)
	{
		Vec2f origin = getGunOrigin(this);
		Vec2f offset = origin + blade_offset;

		blade.ResetTransform();
		blade.SetOffset(offset);
	}
}

void UpdateTool( CSprite@ this, CBlob@ blob, CSpriteLayer@ layer, bool visible )
{
	layer.SetVisible(visible);

	if (visible)
	{
		f32 direction = (blob.isFacingLeft() ? 1.0f : -1.0f);
		Vec2f rotationOffset = Vec2f(tool_rotation_offset.x * direction, tool_rotation_offset.y);
		Vec2f origin = getGunOrigin(this);

		CSpriteLayer@ muzzle = this.getSpriteLayer("muzzle");
		{
			f32 armangle = getArmAngle(this, blob);
			Vec2f offset = origin + tool_offset + Vec2f(0, -3.0f);

			muzzle.ResetTransform();
			muzzle.RotateBy(armangle, rotationOffset);
			muzzle.SetOffset(blob.isFacingLeft() ? Vec2f(-offset.x, offset.y) : offset);
		}
		{
			f32 armangle = getArmAngle(this, blob, blob.getPosition() + muzzle.getOffset());
			Vec2f offset = origin + tool_offset;

			layer.ResetTransform();
			layer.RotateBy(armangle, rotationOffset);
			layer.SetOffset(offset);
		}
	}
}

void onInit( CSprite@ this )
{
	this.RemoveSpriteLayer(blade_layer);
	CSpriteLayer@ blade = this.addSpriteLayer(blade_layer, "Worker.png", 32, 32, this.getBlob().getTeamNum(), this.getBlob().getSkinNum());

	if (blade !is null)
	{
		Animation@ anim = blade.addAnimation("default", 0, false);
		anim.AddFrame(11);
		
		blade.SetRelativeZ(-1);
		blade.SetVisible(false);
	}

	this.RemoveSpriteLayer("muzzle");
	CSpriteLayer@ muzzle = this.addSpriteLayer("muzzle", "Weapons_Muzzle.png", 32, 16, this.getBlob().getTeamNum(), this.getBlob().getSkinNum());

	if (muzzle !is null)
	{
		Animation@ anim = muzzle.addAnimation("default", 0, false);
		anim.AddFrame(0);
		
		muzzle.SetRelativeZ(500);
		muzzle.SetVisible(false);
	}

    this.RemoveSpriteLayer(tool_layer);

	CSpriteLayer@ tool = this.addSpriteLayer(tool_layer, "OmniTool.png", 32, 16, this.getBlob().getTeamNum(), this.getBlob().getSkinNum());
	
	if (tool !is null)
	{
		Animation@ anim = tool.addAnimation("default", 0, false);
		anim.AddFrame(0);

		Animation@ idle = tool.addAnimation("idle", 4, false);
		idle.AddFrame(1);
		idle.AddFrame(0);

		Animation@ spinning = tool.addAnimation("spinning", 2, true);
		spinning.AddFrame(2);
		spinning.AddFrame(3);
		spinning.AddFrame(4);
		spinning.AddFrame(5);
		
		tool.SetRelativeZ(1);
		tool.SetVisible(false);
	}

	this.getCurrentScript().runFlags |= Script::tick_not_infire;
}

void onTick( CSprite@ this )
{
	// store some vars for ease and speed
	CBlob@ blob = this.getBlob();
	
	CSpriteLayer@ blade = this.getSpriteLayer(blade_layer);
	CSpriteLayer@ tool = this.getSpriteLayer(tool_layer);

	if (blob.hasTag("dead"))
	{
		UpdateBlade(this, blob, blade, false);
	    UpdateTool(this, blob, tool, false);

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

	if (getActiveItem(blob) == "omni_tool")
	{
		if((action2 || (tool.isAnimation("spinning") && !tool.isAnimationEnded())) && knocked == 0)
		{
			tool.SetAnimation("spinning");
		}
		else if(!action2 && (tool.isAnimation("idle") || (tool.isAnimation("spinning") && tool.isAnimationEnded())))
		{
			tool.SetAnimation("idle");
		}
		else
		{
			tool.SetAnimation("default");
		}
		
		UpdateBlade(this, blob, blade, false);
		UpdateTool(this, blob, tool, true);
	}
	else
	{
		UpdateBlade(this, blob, blade, true);
	    UpdateTool(this, blob, tool, false);
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
	else if (action2)
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

void DrawCursorAt(Vec2f position, string& in filename)
{
	position = getMap().getAlignedWorldPos(position);
	if (position == Vec2f_zero) return;
	position = getDriver().getScreenPosFromWorldPos(position - Vec2f(1, 1));
	GUI::DrawIcon(filename, position, getCamera().targetDistance * getDriver().getResolutionScaleFactor());
}

// render cursors

const string cursorTexture = "Entities/Characters/Sprites/TileCursor.png";

void onRender( CSprite@ this )
{
	CBlob@ blob = this.getBlob();
	if (!blob.isMyPlayer())
	{
		return;
	}
	if (getHUD().hasButtons())
	{
		return;
	}
	
	CSpriteLayer@ tool = this.getSpriteLayer(tool_layer);
	
	// draw tile cursor
	if (blob.isKeyPressed(key_action1) || tool.isAnimation("spinning"))
	{

		HitData@ hitdata;
		blob.get("hitdata", @hitdata);
		CBlob@ hitBlob = hitdata.blobID > 0 ? getBlobByNetworkID(hitdata.blobID) : null;

		if (hitBlob !is null) // blob hit
		{
			if (!hitBlob.hasTag("flesh"))
			{
				hitBlob.RenderForHUD(RenderStyle::outline);
			}
		}
		else// map hit
		{
			DrawCursorAt(hitdata.tilepos, cursorTexture);
		}
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

	CParticle@ Body     = makeGibParticle("Entities/Characters/Worker/WorkerGibs.png", pos, vel + getRandomVelocity(90, hp , 80), 0, 0, Vec2f(16, 16), 2.0f, 20, "/BodyGibFall", team);
	CParticle@ Arm1     = makeGibParticle("Entities/Characters/Worker/WorkerGibs.png", pos, vel + getRandomVelocity(90, hp - 0.2 , 80), 1, 0, Vec2f(16, 16), 2.0f, 20, "/BodyGibFall", team);
	CParticle@ Arm2     = makeGibParticle("Entities/Characters/Worker/WorkerGibs.png", pos, vel + getRandomVelocity(90, hp - 0.2 , 80), 1, 0, Vec2f(16, 16), 2.0f, 20, "/BodyGibFall", team);
	CParticle@ Gadget1  = makeGibParticle("Entities/Characters/Worker/WorkerGibs.png", pos, vel + getRandomVelocity(90, hp , 80), 2, 0, Vec2f(16, 16), 2.0f, 0, "Sounds/material_drop.ogg", team);
	CParticle@ Gadget2  = makeGibParticle("Entities/Characters/Worker/WorkerGibs.png", pos, vel + getRandomVelocity(90, hp + 1 , 80), 3, 0, Vec2f(16, 16), 2.0f, 0, "Sounds/material_drop.ogg", team);
}
