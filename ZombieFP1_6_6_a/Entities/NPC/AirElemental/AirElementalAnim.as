#include "CreatureCommon.as";
#include "knocked.as";

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
	CMap@ map = blob.getMap();
	Vec2f pos = blob.getPosition();
		
	CBlob@[] blobs;
	map.getBlobsInRadius(pos, 25.0f, @blobs);
		
	for(uint i = 0; i < blobs.length; i++)
	{
		CBlob@ pushed_blob = blobs[i];
		
		Vec2f vel = pushed_blob.getPosition() - pos;
		vel.Normalize();
		pushed_blob.AddForce(vel * 250.0f);
			
		SetKnocked(pushed_blob, 15);
	}	
	ParticleAnimated( "AirPush.png", pos, Vec2f(0,0), 0.0f, 1.0f, 2.5, 0.0f, false ); 				  
}