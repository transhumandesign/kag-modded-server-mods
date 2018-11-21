// GenericBoost.as

#include "Hitters.as";

namespace Boost
{
	enum pointing
	{
		pointing_up = 0,
		pointing_right,
		pointing_down,
		pointing_left
	};

	enum state
	{
		hidden = 0,
		stabbing,
		falling
	};
}


// Todo: collision normal
void onCollision(CBlob@ this, CBlob@ blob, bool solid)
{
	/*if(!getNet().isServer() || this.get_u8("state") == Boost::hidden || blob is null || !blob.hasTag("flesh") || blob.hasTag("invincible")) return;

	Vec2f velocity = blob.getOldVelocity();
	velocity.Normalize();

	const u16 angle_point = this.getAngleDegrees() / 90;
	const u16 angle_collision = velocity.Angle();

	bool pierced = false;

    Vec2f force;

	switch(angle_point)
	{
		case Boost::pointing_up:
			pierced = angle_collision <= 315 && angle_collision >= 225;
            force.y -= 600.0f;
			break;

		case Boost::pointing_right:
			pierced = angle_collision <= 225 && angle_collision >= 135;
            force.x += 2000.0f;
			break;

		case Boost::pointing_down:
			pierced = angle_collision <= 135 && angle_collision >= 45;
            force.y -= 2000.0f;
			break;

		case Boost::pointing_left:
			pierced = angle_collision <= 45 || angle_collision >= 315;
            force.x -= 2000.0f;
			break;
	}

	if(!pierced) return;
    blob.AddForce(force);

	//this.server_Hit(blob, blob.getPosition(), blob.getVelocity() * -1, 1, Hitters::spikes, true);*/
}

bool canBePickedUp( CBlob@ this, CBlob@ byBlob )
{
	return false;
}
