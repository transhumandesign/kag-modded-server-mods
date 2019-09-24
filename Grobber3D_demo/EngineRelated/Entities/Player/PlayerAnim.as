void onTick(CSprite@ this)
{
	// store some vars for ease and speed
	CBlob@ blob = this.getBlob();

	if (blob.hasTag("dead"))
	{
		this.SetAnimation("dead");
		return;
	}
	// animations

	u8 delay = blob.get_u8("shoot_delay");
	const bool lmbClick	= blob.isKeyJustPressed(key_action1) && delay > 10;
	Vec2f vel = blob.getVelocity();
	f32 ln = vel.Length();
	
	if (lmbClick || (this.isAnimation("shoot") && !this.isAnimationEnded()))
	{
		this.SetAnimation("shoot");
	}
	else if (ln > 0.02f)
	{
		//if (ln > 0.06f)
		//	this.SetAnimation("frun");
		//else
			this.SetAnimation("run");
	}
	else
		this.SetAnimation("default");
	

	/*const bool left = blob.isKeyPressed(key_left);
	const bool right = blob.isKeyPressed(key_right);
	const bool up = blob.isKeyPressed(key_up);
	const bool down = blob.isKeyPressed(key_down);*/

	//Vec2f pos = blob.getPosition();

	/*if (lmbClick && !blob.get_bool("stuck"))
	{
		this.SetAnimation("shoot");
		//return;
	}

	Vec2f vel = blob.getVelocity();
	f32 ln = vel.Length();
	if (!(this.isAnimation("shoot") && !this.isAnimationEnded()))
	{
		if (ln > 0.01f)
		{
			if (ln > 0.06f)
				this.SetAnimation("frun");
			else
				this.SetAnimation("run");
		}
		else
		{
			this.SetAnimation("default");
		}
	}*/
}