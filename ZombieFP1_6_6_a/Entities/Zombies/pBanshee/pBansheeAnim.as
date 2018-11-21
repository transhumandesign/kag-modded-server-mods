// Aphelion \\

void onTick(CSprite@ this)
{
	CBlob@ blob = this.getBlob();
	if    (blob.getBrain().getTarget() !is null || blob.hasTag("enraged"))
	{
		if (!this.isAnimation("attack"))
			this.SetAnimation("attack");
	}
	else if(!blob.isOnGround() && !blob.isOnLadder()) 
	{
		if (!this.isAnimation("fly"))
			this.SetAnimation("fly");
	}
	else if (!this.isAnimation("walk"))
			 this.SetAnimation("walk");
}