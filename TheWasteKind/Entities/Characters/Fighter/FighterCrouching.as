// CONFIG VARS
const Vec2f diagonal_off			= Vec2f(2.0f, 4.0f);
const Vec2f diagonal_off_crouching	= Vec2f(2.0f, 2.5f);
// ^^^^^^^^^^^^^^^ PROBABLY WHAT YOU WANT TO CHANGE ^^^^^^^^^^^^^^^

const Vec2f pos_off = Vec2f(-6, 5);
const Vec2f hitbox_ur			= Vec2f(10.0f, -14.0f) + pos_off;
const Vec2f hitbox_ur_crouching	= Vec2f(10.0f, -10.0f) + pos_off;
const Vec2f hitbox_dl			= Vec2f(2.0f, 4.0f)  + pos_off;

// END OF CONFIG VARS
// DON'T CHANGE STUFF BEYOND THIS POINT UNLESS YOU KNOW WHAT YOU'RE DOING

const Vec2f[] hitbox_default= {
	Vec2f(hitbox_ur.x, hitbox_ur.y) + Vec2f(0, diagonal_off.y),// up right
	Vec2f(hitbox_ur.x, hitbox_ur.y) - Vec2f(diagonal_off.x, 0),// up right
	Vec2f(hitbox_dl.x, hitbox_ur.y) + Vec2f(diagonal_off.x, 0),// up left
	Vec2f(hitbox_dl.x, hitbox_ur.y) + Vec2f(0, diagonal_off.y),// up left
	Vec2f(hitbox_dl.x, hitbox_dl.y) - Vec2f(0, diagonal_off.y),// down left
	Vec2f(hitbox_dl.x, hitbox_dl.y) + Vec2f(diagonal_off.x, 0),// down left
	Vec2f(hitbox_ur.x, hitbox_dl.y) - Vec2f(diagonal_off.x, 0),// down right
	Vec2f(hitbox_ur.x, hitbox_dl.y) - Vec2f(0, diagonal_off.y),// down right
	};

const Vec2f[] hitbox_crouching= {
	Vec2f(hitbox_ur_crouching.x, hitbox_ur_crouching.y) + Vec2f(0, diagonal_off_crouching.y),// up right
	Vec2f(hitbox_ur_crouching.x, hitbox_ur_crouching.y) - Vec2f(diagonal_off_crouching.x, 0),// up right
	Vec2f(hitbox_dl.x, hitbox_ur_crouching.y)			+ Vec2f(diagonal_off_crouching.x, 0),// up left
	Vec2f(hitbox_dl.x, hitbox_ur_crouching.y)			+ Vec2f(0, diagonal_off_crouching.y),// up left
	Vec2f(hitbox_dl.x, hitbox_dl.y)						- Vec2f(0, diagonal_off_crouching.y),// down left
	Vec2f(hitbox_dl.x, hitbox_dl.y)						+ Vec2f(diagonal_off_crouching.x, 0),// down left
	Vec2f(hitbox_ur_crouching.x, hitbox_dl.y)			- Vec2f(diagonal_off_crouching.x, 0),// down right
	Vec2f(hitbox_ur_crouching.x, hitbox_dl.y)			- Vec2f(0, diagonal_off_crouching.y),// down right
	};

void onTick(CBlob@ this)
{
	CShape@ shape = this.getShape();
	if (!this.exists("wasCrouching"))
	{
		shape.SetShape(hitbox_default);
		this.set_bool("wasCrouching", false);
		return;
	}

	bool wasCrouching = this.get_bool("wasCrouching");
	bool crouching = this.isKeyPressed(key_down) && !this.isKeyPressed(key_left) 
						&& !this.isKeyPressed(key_right) && !this.isKeyPressed(key_action1)
						&& this.isOnGround();

	if (crouching != wasCrouching)
	{
		shape.SetShape(crouching?hitbox_crouching:hitbox_default);
		this.set_bool("wasCrouching", crouching);
	}
}