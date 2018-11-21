#include "CreatureCommon.as";
#include "Hitters.as";

const f32 DAMAGE = 1.0f;
const f32 AOE = 10.0f;//radius

void onTick(CSprite@ this)
{
	CBlob@ blob = this.getBlob();
	
	if (blob.hasTag("dead"))
	{
		this.getCurrentScript().runFlags |= Script::remove_after_this;
		return;
	}

	const bool left = blob.isKeyPressed(key_left);
	const bool right = blob.isKeyPressed(key_right);
	const bool up = blob.isKeyPressed(key_up);
	const bool down = blob.isKeyPressed(key_down);
	const bool inair = (!blob.isOnGround() && !blob.isOnLadder());
	
	if(inair) 
	{
		if (!this.isAnimation("jump"))
			 this.SetAnimation("jump");
	}
	else if(blob.hasTag(chomp_tag))
	{
		if (!this.isAnimation("attack"))
			 this.SetAnimation("attack");
	}
	else if ((left || right) ||
             (blob.isOnLadder() && (up || down)))
	{
		if (!this.isAnimation("walk"))
			 this.SetAnimation("walk");
	}
	else
	{
		if (!this.isAnimation("default"))
			 this.SetAnimation("default");
	}
}

void onGib(CSprite@ this)
{
    CBlob@ blob = this.getBlob();
	Vec2f pos = blob.getPosition();
	CBlob@[] aoeBlobs;
	CMap@ map = getMap();
	
	if ( getNet().isServer() )
	{
		map.getBlobsInRadius( pos, AOE, @aoeBlobs );
		for ( u8 i = 0; i < aoeBlobs.length(); i++ )
		{
			CBlob@ blob = aoeBlobs[i];
			if ( !getMap().rayCastSolidNoBlobs( pos, blob.getPosition() ) )
				blob.server_Hit( blob, pos, Vec2f_zero, DAMAGE, Hitters::fire);
		}
	}	
	ParticleAnimated( "/LargeSmoke.png",
				  blob.getPosition(), Vec2f(0,0), 0.0f, 1.0f,
				  3,
				  -0.1f, false );
	ParticleAnimated( "/FireFlash.png",
				  blob.getPosition(), Vec2f(0,0), 0.0f, 1.0f,
				  3,
				  -0.1f, false );
}