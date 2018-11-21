// Aphelion \\

void onTick(CSprite@ this)
{
	CBlob@ blob = this.getBlob();
	
	if(blob.getBrain().getTarget() !is null)
	{
		if (!this.isAnimation("attack"))
		     this.SetAnimation("attack");
	}
	else
	{
		if (!this.isAnimation("fly"))
		     this.SetAnimation("fly");
	}
}

