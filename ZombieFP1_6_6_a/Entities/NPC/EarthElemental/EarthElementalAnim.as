// Aphelion \\

#include "CreatureCommon.as";

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
	server_CreateBlob("mat_stone", -1, blob.getPosition());
}