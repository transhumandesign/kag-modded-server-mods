#include "RunnerAnimCommon.as";
#include "RunnerCommon.as";


void onInit( CSprite@ this )
{
	this.getCurrentScript().runFlags |= Script::tick_not_infire;
}

void onTick( CSprite@ this )
{
	CBlob@ blob = this.getBlob();
	u8 gooTimer = blob.get_u8( "goo timer" );

	if (blob.hasTag("dead"))
    {
        this.SetAnimation("dead");
		Vec2f vel = blob.getVelocity();

        if (vel.y < -1.0f) {
            this.SetFrameIndex( 0 );
        }
        else {
            this.SetFrameIndex( 1 );
        }		 
        return;
    }
	
	const u8 knocked = blob.get_u8("knocked");
	const bool action2 = blob.isKeyPressed(key_action2);
	const bool action1 = blob.isKeyPressed(key_action1);

	
	const bool left = blob.isKeyPressed( key_left );
	const bool right = blob.isKeyPressed( key_right );
	const bool up = blob.isKeyPressed( key_up );
	const bool down = blob.isKeyPressed( key_down );
	const bool inair = ( !blob.isOnGround() && !blob.isOnLadder() );
	Vec2f pos = blob.getPosition();
	Vec2f vec;
	const int direction = blob.getAimDirection( vec );


	RunnerMoveVars@ moveVars;
	if (!blob.get( "moveVars", @moveVars )) {
		return;	
	}

	if (knocked > 0)
	{
		if (inair) {
			this.SetAnimation("knocked_air");
		}
		else {
			this.SetAnimation("knocked");
		}
	}
	else if ((this.isAnimation("spit") && !this.isAnimationEnded()))
	{
		return;
	}
	else if ( gooTimer > 64 && action2  || (this.isAnimation("retch") && !this.isAnimationEnded()))
	{
		this.SetAnimation("retch");
	}
	else if ( action1 || ( this.isAnimation( "strike" ) || this.isAnimation( "strike_mid_up" ) || this.isAnimation( "strike_mid_down" ) ) && !this.isAnimationEnded() )
	{
		if ( direction == -1 )
			this.SetAnimation("strike_mid_up");
		else if ( direction == 1 )
			this.SetAnimation("strike_mid_down");	
		else
				this.SetAnimation("strike");			
	}
	else if (inair)
	{
		RunnerMoveVars@ moveVars;
		if (!blob.get( "moveVars", @moveVars )) {
			return;
		}
		Vec2f vel = blob.getVelocity();
		f32 vy = vel.y;
		if (vy < -0.0f && moveVars.walljumped)
		{
			this.SetAnimation("run");
		}
		else
		{
			this.SetAnimation("fall");
			this.animation.timer = 0;

			if (vy < -1.5 ) {
				this.animation.frame = 0;
			}
			else if (vy > 1.5 ) {
				this.animation.frame = 2;
			}
			else {
				this.animation.frame = 1;
			}
		}
	}
	else if ( blob.hasTag( "crawling" ) )
	{
		if ( (left || right) )
			this.SetAnimation( "crawl" );
		else
			this.SetAnimation( "crouch" );
	}
	else if ((left || right) ||
			 (blob.isOnLadder() && (up || down) ) )
	{
		this.SetAnimation("run");
	}
	else if ( down )
	{
		this.SetAnimation("crouch");
	}
	else
	{
		this.SetAnimation("default");
		/*
		// get the angle of aiming with mouse
		Vec2f aimpos = blob.getAimPos();
		Vec2f vec = aimpos - pos;
		f32 angle = vec.Angle();
		int direction;

		if ((angle > 330 && angle < 361) || (angle > -1 && angle < 30) ||
			(angle > 150 && angle < 210)) {
				direction = 0;
		}
		else if (aimpos.y < pos.y) {
			direction = -1;
		}
		else {
			direction = 1;			
		}
		
		defaultIdleAnim(this, blob, direction);*/
	}
}


void onGib(CSprite@ this)
{
    if (g_kidssafe) {
        return;
    }

    CBlob@ blob = this.getBlob();
    Vec2f pos = blob.getPosition();
    Vec2f vel = blob.getVelocity();
	vel.y -= 3.0f;
    f32 hp = Maths::Min(Maths::Abs(blob.getHealth()), 2.0f) + 1.0;
	const u8 team = blob.getTeamNum();
    CParticle@ Arm1     = makeGibParticle( "/UndeadBunnyGibs.png", pos, vel + getRandomVelocity( 90, hp - 0.2 , 80 ), 0, 0, Vec2f (16,16), 2.0f, 20, "/BodyGibFall", team );
    CParticle@ Body     = makeGibParticle( "/UndeadBunnyGibs.png", pos, vel + getRandomVelocity( 90, hp , 80 ), 1, 0, Vec2f (16,16), 2.0f, 20, "/BodyGibFall", team );
    CParticle@ Arm2     = makeGibParticle( "/UndeadBunnyGibs.png", pos, vel + getRandomVelocity( 90, hp - 0.2 , 80 ), 2, 0, Vec2f (16,16), 2.0f, 20, "/BodyGibFall", team );
    CParticle@ Shield   = makeGibParticle( "/UndeadBunnyGibs.png", pos, vel + getRandomVelocity( 90, hp - 0.2 , 80 ), 3, 0, Vec2f (16,16), 2.0f, 20, "/BodyGibFall", team );
    CParticle@ Sword    = makeGibParticle( "/UndeadBunnyGibs.png", pos, vel + getRandomVelocity( 90, hp - 0.2 , 80 ), 4, 0, Vec2f (16,16), 2.0f, 20, "/BodyGibFall", team );
}