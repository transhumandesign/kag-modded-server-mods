
void onInit(CMovement@ this)
{
	this.getCurrentScript().removeIfTag = "dead";
	this.getCurrentScript().runFlags |= Script::tick_not_attached;
	CBlob@ blob = this.getBlob();
	CShape@ shape = blob.getShape();
	shape.SetGravityScale(0.0f);
}

void onTick(CMovement@ this)
{
	CBlob@ blob = this.getBlob();
	//if(!blob.isMyPlayer()) return;
	//CControls@ c = getControls();

	const bool left		= blob.isKeyPressed(key_left);
	const bool right	= blob.isKeyPressed(key_right);
	const bool up		= blob.isKeyPressed(key_up);
	const bool down		= blob.isKeyPressed(key_down);
	const bool shift	= getControls().isKeyPressed(KEY_LSHIFT);

	Vec2f force;
	
	// movement
	if (up)
	{
		force.x += 1;
	}

	if (down)
	{
		force.x -= 1;
	}

	if (left)
	{
		force.y -= 1;
	}

	if (right)
	{
		force.y += 1;
	}
	//force.Normalize();
	f32 dirX = blob.get_f32("dir_x");
	force.RotateBy(dirX);

	blob.AddForce(force * 7.0f * (shift ? 0.5f : 1));
	//damp vel
	Vec2f vel = blob.getVelocity();
	vel *= 0.7f;
	blob.setVelocity(vel);
}