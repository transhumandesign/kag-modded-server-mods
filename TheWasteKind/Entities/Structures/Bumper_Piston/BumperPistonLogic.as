//BumperPiston

namespace BumperPiston
{
	enum State
	{
		idle = 0,
		bounce
	}
}
const f32 BumperPiston_speed = 9.0f;

void onInit( CBlob@ this )
{
    this.set_u8("BumperPistonState", BumperPiston::idle);
    this.set_u32("BumperPistonBounceTime", 0);
    this.Tag("no falldamage");
	this.Tag("blocks sword");
	this.Tag("blocks water");

	this.getCurrentScript().tickFrequency = 2;
}

void onTick( CBlob@ this )
{
    if (this.get_u8("BumperPistonState") == BumperPiston::bounce)
    {
        u32 bouncetime = getGameTime() - this.get_u32("BumperPistonBounceTime");

        if (bouncetime > 3) //10 ticks after bouncing
        {
            this.set_u8("BumperPistonState", BumperPiston::idle);
        }
    }
}

void onSetStatic(CBlob@ this, const bool isStatic)
{
   f32 angle = this.getAngleDegrees();
   
   Vec2f force = Vec2f(0, -1);
   force.RotateBy(angle);
   
   this.set_Vec2f("force", force);
}

void onCollision( CBlob@ this, CBlob@ blob, bool solid, Vec2f normal, Vec2f point1 )
{
    // map collision?
    if (blob is null || (!isTouchingPlate(this, blob))) return;
      
	u8 state = this.get_u8("BumperPistonState");
	this.set_u8("BumperPistonState", BumperPiston::bounce);
	this.set_u32("BumperPistonBounceTime", getGameTime() );
		
	//different force if buttons pressed
	f32 bounceForce = blob.isKeyPressed( key_jump ) ? 1.4f : blob.isKeyPressed( key_down ) ? 0.7f : 1.0f;
	bounceForce *= BumperPiston_speed;
		
	u32 bounced = blob.get_u32("bounced");
	u32 time = getGameTime();
	
	if (bounced == time)	return;
	
	blob.set_u32("bounced", time);
		
	f32 scalar = blob.getMass() * bounceForce; //some value
	
	Vec2f force = this.get_Vec2f("force");
	force *= scalar;
	
	blob.AddForce(force);
	this.getSprite().PlaySound( "/BumperPistonJump.ogg" );
}

bool isTouchingPlate(CBlob@ this, CBlob@ blob)
{
    Vec2f touch = this.getTouchingOffsetByBlob(blob);
    f32 angle = touch.Angle();
  
    u16 facing = this.getAngleDegrees();
			
	switch (facing)
    {
		
        case 0: if (angle <= 135 && angle >= 45) return true;
			break;
        case 90: if (angle <= 45 || angle >= 315) return true;
			break;
        case 180: if (angle <= 315 && angle >= 225) return true;
			break;
        case 270: if (angle <= 225 && angle >= 135) return true;
			break;

    }
	return false;
}

bool canBePickedUp( CBlob@ this, CBlob@ byBlob )
{
    return false;
}