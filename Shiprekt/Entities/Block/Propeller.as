#include "IslandsCommon.as"
#include "BlockCommon.as"
#include "WaterEffects.as"
#include "PropellerForceCommon.as"

Random _r(133701); //global clientside random object

void onInit( CBlob@ this )
{
	this.addCommandID("on/off");
	this.set_f32("power", 0.0f);
	this.Tag("propeller");

	CSprite@ sprite = this.getSprite();
    CSpriteLayer@ propeller = sprite.addSpriteLayer( "propeller" );
    if (propeller !is null)
    {
    	propeller.SetOffset(Vec2f(0,8));
    	propeller.SetRelativeZ(2);
    	propeller.SetLighting( false );
        Animation@ animcharge = propeller.addAnimation( "go", 1, true );
        animcharge.AddFrame(Block::PROPELLER_A1);
        animcharge.AddFrame(Block::PROPELLER_A2);
        propeller.SetAnimation("go");
    }

    sprite.SetEmitSound("PropellerMotor");
    sprite.SetEmitSoundPaused(true);
}

void GetButtonsFor( CBlob@ this, CBlob@ caller )
{	
	if(this.getDistanceTo(caller) > Block::BUTTON_RADIUS_SOLID || this.getShape().getVars().customData <= 0)
		return;

	const bool on = isOn(this);
	CBitStream params;
	CButton@ button = caller.CreateGenericButton( on ? 1 : 3, Vec2f(0.0f, 0.0f), this, this.getCommandID("on/off"), on ? "Off" : "On", params );
}

void onCommand( CBlob@ this, u8 cmd, CBitStream @params )
{
    if (cmd == this.getCommandID("on/off") && getNet().isServer())
    {
		this.set_f32("power", isOn(this) ? 0.0f : -1.0f);
    }
}

bool isOn(CBlob@ this)
{
	return this.get_f32("power") != 0;
}

void onTick( CBlob@ this )
{	
	if (this.getShape().getVars().customData <= 0)
		return;
	
	CSprite@ sprite = this.getSprite();
	const f32 power = this.get_f32("power");
	const bool on = power != 0;

	sprite.getSpriteLayer("propeller").animation.time = on ? 1 : 0;
	this.Sync("power", true);

	if (on)
	{
		Island@ island = getIsland(this.getShape().getVars().customData);
		if (island !is null)
		{
			Vec2f pos = this.getPosition();

			// move
			Vec2f moveVel;
			Vec2f moveNorm;
			float angleVel;

			PropellerForces(this, island, power, moveVel, moveNorm, angleVel);

			const f32 mass = island.mass;
			moveVel /= mass;
			angleVel /= mass;

			island.vel += moveVel;
			island.angle_vel += angleVel;

			// eat stuff

			if (getNet().isServer())
			{
				Vec2f faceNorm(0,-1);
				faceNorm.RotateBy(this.getAngleDegrees());
				CBlob@ victim = getMap().getBlobAtPosition( pos - faceNorm * Block::size );
				if (victim !is null && !victim.isAttached() 
					 && ((victim.getShape().getVars().customData > 0
					       && victim.getSprite().getFrame() != Block::SOLID
					       && victim.getSprite().getFrame() != Block::PROPELLER) 
					       || victim.getName() != "block"))	
				{
					victim.server_Die();
				}
			}

			// effects

			Vec2f rpos = Vec2f(_r.NextFloat() * -4 + 4, _r.NextFloat() * -4 + 4);
			MakeWaterParticle(pos + moveNorm * -6 + rpos, moveNorm * (-0.8f + _r.NextFloat() * -0.3f));

			// limit sounds		

			if (island.soundsPlayed == 0){
				sprite.SetEmitSoundPaused(false);								
			}
			island.soundsPlayed++;
			const f32 vol = Maths::Min(0.5f + float(island.soundsPlayed)/2.0f, 3.0f);
			sprite.SetEmitSoundVolume( vol );
		}
	}
	else
	{
		sprite.SetEmitSoundPaused(true);
	}
}