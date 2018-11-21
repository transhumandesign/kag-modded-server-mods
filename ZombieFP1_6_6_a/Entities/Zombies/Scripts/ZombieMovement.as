#include "CreatureCommon.as";

void onInit(CMovement@ this)
{
	this.getCurrentScript().runFlags |= Script::tick_not_attached;
	this.getCurrentScript().removeIfTag	= "dead";   
}

void onTick(CMovement@ this)
{
    CBlob@ blob = this.getBlob();
	
	CreatureMoveVars@ moveVars;
	if (!blob.get( "moveVars", @moveVars ))
		return;
	
	CMap@ map = blob.getMap();
	CShape@ shape = blob.getShape();
	
	const bool left    = blob.isKeyPressed(key_left);
	const bool right   = blob.isKeyPressed(key_right);
	const bool up      = blob.isKeyPressed(key_up);
	const bool down    = blob.isKeyPressed(key_down);
	
	Vec2f vel = blob.getVelocity();
    Vec2f pos = blob.getPosition();
    
    const f32 vellen = shape.vellen;
	const bool onground = blob.isOnGround() || blob.isOnLadder();

	bool onladder = blob.isOnLadder();

    // check if we need to scale a wall
	if(moveVars.climbingEnabled && !blob.isOnLadder() && (up || left || right)) //key pressed
    {
		//check solid tiles
		const f32 ts = map.tilesize;
		const f32 y_ts = ts * 0.2f;
		const f32 x_ts = ts * 1.4f;
		
		bool surface_left = map.isTileSolid(pos + Vec2f(-x_ts, y_ts-map.tilesize)) || map.isTileSolid(pos + Vec2f(-x_ts, y_ts));
		//TODO: fix flags sync and hitting so we dont have to do this
		if(!surface_left)
		{
			surface_left = checkForSolidMapBlob( map, pos + Vec2f(-x_ts, y_ts-map.tilesize)) ||
						   checkForSolidMapBlob( map, pos + Vec2f(-x_ts, y_ts));
		}
		
		bool surface_right = map.isTileSolid(pos + Vec2f(x_ts, y_ts-map.tilesize)) || map.isTileSolid(pos + Vec2f(x_ts, y_ts));
		//TODO: fix flags sync and hitting so we dont have to do this
		if(!surface_right)
		{
			surface_right = checkForSolidMapBlob( map, pos + Vec2f(x_ts, y_ts-map.tilesize)) ||
							checkForSolidMapBlob( map, pos + Vec2f(x_ts, y_ts));
		}

		// set onladder to true for scaling
		if(left && surface_left)
		    onladder = true;
		else if(right && surface_right)
		    onladder = true;
    }

    // ladder and scaling walls - overrides other movement completely
	if (onladder && !blob.isAttached() && !blob.isOnGround())
    {
		shape.SetGravityScale( 0.0f );
        Vec2f ladderforce;

        if (up)
            ladderforce.y -= 1.0f;
        if (down)
            ladderforce.y += 1.2f;

        if (left)
            ladderforce.x -= 1.0f;
        if (right)
            ladderforce.x += 1.0f;

        blob.AddForce(ladderforce * 100.0f);
        //damp vel
        Vec2f vel = blob.getVelocity();
        vel *= 0.05f;
        blob.setVelocity( vel );

        moveVars.jumpCount = -1;

        CleanUp(this, blob, moveVars);
        return;
    }

	shape.SetGravityScale( 1.0f );
	shape.getVars().onladder = false;

    // jumping	
	if (moveVars.jumpFactor > 0.01f)
    {

		if (onground)
		{
			moveVars.jumpCount = 0;
		}
		else
		{
			moveVars.jumpCount++;
		}

		if (up && vel.y > -moveVars.jumpMaxVel )
		{
			moveVars.jumpStart = 0.7f;
			moveVars.jumpMid = 0.2f;
			moveVars.jumpEnd = 0.1f;

			Vec2f force = Vec2f(0,0);
			f32 side = 0.0f;

			if (blob.isFacingLeft() && left)
				side = -1.0f;
			else if (!blob.isFacingLeft() && right)
				side = 1.0f;

			// jump
			if (moveVars.jumpCount <= 0)
			{
				force.y -= 1.5f;
			}
			else if (moveVars.jumpCount < 3)
			{
				force.y -= moveVars.jumpStart;
			}
			else if (moveVars.jumpCount < 6)
			{
				force.y -= moveVars.jumpMid;
			}
			else if (moveVars.jumpCount < 8)
			{
				force.y -= moveVars.jumpEnd;
			}

			force *= moveVars.jumpFactor * 60.0f;
			
			blob.AddForce(force);
		}
	}
	
	// left and right movement
	
	bool stop = true;
	if (!onground)
    {
		if (blob.hasTag("dont stop til ground"))
			stop = false;
	}
	else
	{
		blob.Untag("dont stop til ground");
	}

	bool left_or_right = (left || right);
	{
		bool facingleft = blob.isFacingLeft();
		bool stand = blob.isOnGround() || blob.isOnLadder();
		Vec2f walkDirection;
		const f32 turnaroundspeed = 1.3f;
		const f32 normalspeed = 1.0f;
		const f32 backwardsspeed = 0.8f;

		if (right)
		{
			if (vel.x < -0.1f) {
				walkDirection.x += turnaroundspeed;
			}
			else if (facingleft) {
				walkDirection.x += backwardsspeed;
			}
			else {
				walkDirection.x += normalspeed;
			}
		}

		if (left)
		{
			if (vel.x > 0.1f) {
				walkDirection.x -= turnaroundspeed;
			}
			else if (!facingleft) {
				walkDirection.x -= backwardsspeed;
			}
			else {
				walkDirection.x -= normalspeed;
			}
		}

		f32 force = 1.0f;
		f32 lim = 0.0f;
		{
			if(left_or_right)
			{
				lim = moveVars.walkSpeed;
				lim *= moveVars.walkFactor * Maths::Abs(walkDirection.x);
			}
			
			Vec2f stop_force;
			
			bool greater = vel.x > 0;
			f32 absx = greater ? vel.x : -vel.x;
			
			bool stopped = false;
			if ( absx > lim )
			{
				if(stop) //stopping
				{
					stopped = true;
					stop_force.x -= (absx - lim) * (greater? 1 : -1);
					
					stop_force.x *= 30.0f * moveVars.stoppingFactor *
								(onground ? moveVars.stoppingForce : moveVars.stoppingForceAir);
					
					if(absx > 3.0f)
					{
						f32 extra = (absx-3.0f);
						f32 scale = (1.0f/((1+extra) * 2));
						stop_force.x *= scale;
					}
					
					blob.AddForce(stop_force);
				}
			}
			
			if( absx < lim || left && greater || right && !greater )
			{
				force *= moveVars.walkFactor * 30.0f;
				if (Maths::Abs(force) > 0.01f) {
					blob.AddForce(walkDirection*force);
				}
			}
		}
	}

	// clean up
	CleanUp(this, blob, moveVars);
}

//cleanup all vars here - reset clean slate for next frame
void CleanUp( CMovement@ this, CBlob@ blob, CreatureMoveVars@ moveVars )
{
	//reset all the vars here
	moveVars.jumpFactor = 1.0f;
	moveVars.walkFactor = 1.0f;
}

//TODO: fix flags sync and hitting so we dont need this
bool checkForSolidMapBlob( CMap@ map, Vec2f pos)
{
	CBlob@ _tempBlob; CShape@ _tempShape;
	@_tempBlob = map.getBlobAtPosition( pos );
	if(_tempBlob !is null && _tempBlob.isCollidable())
	{
		@_tempShape = _tempBlob.getShape();
		if(_tempShape.isStatic())
		{
			return true;
		}
	}
	
	return false;
}
