#include "Hitters.as"
#include "FUNHitters.as"

enum facing_direction {
	none = 0,
	up,
	down,
	left,
	right
};

const string facing_prop = "facing";

enum spike_state {
	normal = 0,
	hidden,
	stabbing,
	falling
};

const string state_prop = "popup state";
const string timer_prop = "popout timer";
const u8 delay_stab = 15;
const u8 delay_retract = 35;

void onInit(CBlob@ this)
{
	this.Tag("place norotate");	  	
	
	this.getCurrentScript().runFlags |= Script::tick_not_attached;
	this.getCurrentScript().runProximityRadius = 124.0f;
	this.getCurrentScript().runFlags |= Script::tick_blob_in_proximity;	 
	
	this.getCurrentScript().tickFrequency = 5;
	
	this.getSprite().SetZ(-10.0f); //why you wont work?!	
	
	this.set_u8(facing_prop, up);
	
	this.set_u8(state_prop, normal);
	this.set_u8(timer_prop, 0);
}

void onTick(CBlob@ this)
{
    CMap@ map = getMap();
    Vec2f pos = this.getPosition();
    const f32 tilesize = map.tilesize;

	//get prop

	spike_state state = spike_state( this.get_u8(state_prop) );
	if(state == falling) //opt
		return;
	
	facing_direction facing;

	//check support/placement status 
	
	bool placedOnStone = false;
	bool placedOnWood = false;
	
    if (map.isTileSolid( map.getTile(pos + Vec2f(0.0f, tilesize)).type))
    {
		facing = up;
		this.setAngleDegrees(0.0f);
		placedOnStone = map.isTileCastle(  map.getTile(pos + Vec2f(0.0f, tilesize)).type );
		placedOnWood = map.isTileWood(  map.getTile(pos + Vec2f(0.0f, tilesize)).type );
    }
    else 
	{
        if (map.isTileSolid(map.getTile( pos + Vec2f(-tilesize, 0.0f)).type))
		{
			facing = right;
            this.setAngleDegrees(90.0f);
			placedOnStone = map.isTileCastle( map.getTile(pos + Vec2f(-tilesize, 0.0f)).type);
			placedOnWood = map.isTileWood( map.getTile(pos + Vec2f(-tilesize, 0.0f)).type);
        }
        else if (map.isTileSolid( pos + Vec2f(tilesize, 0.0f))) 
		{
			facing = left;
            this.setAngleDegrees(-90.0f);
			placedOnStone = map.isTileCastle(  map.getTile(pos + Vec2f(tilesize, 0.0f)).type);
			placedOnWood = map.isTileWood(  map.getTile(pos + Vec2f(tilesize, 0.0f)).type);
        }
        else if (map.isTileSolid( map.getTile(pos + Vec2f(0.0f, -tilesize)).type))
		{
			facing = down;
			this.setAngleDegrees(-180.0f);
			placedOnStone = map.isTileCastle(  map.getTile(pos + Vec2f(0.0f, -tilesize)).type);
			placedOnWood = map.isTileWood(  map.getTile(pos + Vec2f(0.0f, -tilesize)).type);
		}
		else
        {
			this.getCurrentScript().tickFrequency = 0;
			this.getShape().SetStatic(false);
			
			facing = down;
			state = falling;
        }
    }

	if(state == falling)
	{
		this.set_u8(state_prop, state);
		return;
	}
	
	this.set_u8(facing_prop, facing);
	
	u8 timer = this.get_u8(timer_prop);

	// set optimisation flags - not done in oninit so we actually orient to the stone first
	
	//this.getCurrentScript().runProximityTag = "player";	// no tag = take all awake blobs
	this.getCurrentScript().runProximityRadius = 64.0f;
	this.getCurrentScript().runFlags |= Script::tick_blob_in_proximity;	 

	// spike'em

	if (placedOnWood)
	{
		const u32 tickFrequency = 3;
		this.getCurrentScript().tickFrequency = tickFrequency;

		if(state == hidden)
		{
			this.getSprite().SetAnimation("hidden");
			CBlob@[] blobsInRadius;
			const int team = this.getTeamNum();
			if (map.getBlobsInRadius( pos, this.getRadius()*1.0f, @blobsInRadius ))
			{
				for (uint i = 0; i < blobsInRadius.length; i++)
				{
					CBlob @b = blobsInRadius[i];
					if (team != b.getTeamNum() && canStab(b))
					{	
						state = stabbing;
						timer = delay_stab;
						
						break;
					}
				}
			}
		}
		else if(state == stabbing)
		{
			if(timer >= tickFrequency)
			{
				timer -= tickFrequency;
			}
			else
			{
				state = normal;
				timer = delay_retract;
				
				this.getSprite().SetAnimation("default");
				this.getSprite().PlaySound( "/SpikesOut.ogg" );

				CBlob@[] blobsInRadius;
				const int team = this.getTeamNum();
				if (map.getBlobsInRadius( pos, this.getRadius()*2.0f, @blobsInRadius ))
				{
					for (uint i = 0; i < blobsInRadius.length; i++)
					{
						CBlob @b = blobsInRadius[i];
						if (canStab(b)) //even hurts team when stabbing
						{
							// hurt?
							if (this.isOverlapping(b))
							{
								this.server_Hit( b, pos, b.getVelocity()*-1, 0.5f, FUNHitters::wooden_spikes, true);
							}
						}
					}
				}
			}
		}
		else //state is normal
		{
			if(timer >= tickFrequency)
			{
				timer -= tickFrequency;
			}
			else
			{
				state = hidden;
				timer = 0;
			}
		}
		this.set_u8(state_prop, state);
		this.set_u8(timer_prop, timer);
	}
	else 
	{
		this.getCurrentScript().tickFrequency = 25;
		this.getSprite().SetAnimation("default");
		this.set_u8(timer_prop, 0);
	}

	onHealthChange( this, this.getHealth());
}

bool canStab(CBlob@ b)
{
	return !b.hasTag("dead") && b.hasTag("flesh");
}

//physics logic
void onCollision( CBlob@ this, CBlob@ blob, bool solid, Vec2f normal, Vec2f point )
{
    if (!getNet().isServer() || this.isAttached()) { // map collision? not server?
        return;
    }
    
    u8 state = this.get_u8(state_prop);
    if(state == hidden || state == stabbing)
    {
		return;
	}

    if (blob is null) // fall down and destroy on map collision
    {
		if (!this.getShape().isStatic()) {
			this.server_Hit( this, point, this.getVelocity(), 10.0f, Hitters::fall, true);		 
		}
        return;
    }

    if (!blob.hasTag("flesh")) { // only hit living things
        return;
    }	  

    f32 angle = this.getAngleDegrees();
    //printf("angle " + angle);
    Vec2f vel = blob.getVelocity();

    if (angle > -180.0f && angle < 0.0f)
    {
        f32 verDist = Maths::Abs( this.getPosition().y - blob.getPosition().y );

        if (normal.x > 0.5f && verDist < 6.1f && vel.x > 0.5f) {
            this.server_Hit( blob, point, vel*-1, 1.0f, FUNHitters::wooden_spikes, true);
        }
    }
    else if (angle > 0.0f && angle < 180.0f)
    {
        f32 verDist = Maths::Abs( this.getPosition().y - blob.getPosition().y );

        if (normal.x < 0.5f && verDist < 6.1f && vel.x < 0.5f) {
            this.server_Hit( blob, point, vel*-1, 1.0f, FUNHitters::wooden_spikes, true);
        }
    }
    else if (angle <= -180.0f)
    {
        f32 horizDist = Maths::Abs( this.getPosition().x - blob.getPosition().x );

        if (normal.y < 0.5f && horizDist < 6.1f && vel.y < 0.5f) {
            this.server_Hit( blob, point, vel*-1, 1.0f, FUNHitters::wooden_spikes, true);
        }
    }
    else
    {
        f32 horizDist = Maths::Abs( this.getPosition().x - blob.getPosition().x );

        //  printf( " n " + normal.y + " vel " + vel.y + " horizDist " + horizDist );
        if (normal.y > 0.5f && horizDist < 6.1f && vel.y > 0.5f) {
            this.server_Hit( blob, point, vel*-1, 1.0f, FUNHitters::wooden_spikes, true);
        }
        else if (this.getVelocity().y > 0.5f && horizDist < 6.1f ) { // falling down
            this.server_Hit( blob, point, vel*-1, this.getVelocity().y*2.0f, FUNHitters::wooden_spikes, true);
        }
    }
}

void onHitBlob( CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitBlob, u8 customData )
{
    if (hitBlob !is null && hitBlob !is this && damage > 0.0f)
    {
		CSprite@ sprite = this.getSprite();
        sprite.PlaySound( "/SpikesCut.ogg" );

		if (!this.hasTag("bloody"))	{			
			sprite.animation.frame += 3;
			this.Tag("bloody");
		}			
    }
}

void onHealthChange( CBlob@ this, f32 oldHealth )
{
	f32 hp = this.getHealth();
	f32 full_hp = this.getInitialHealth();
	int frame = (hp > full_hp * 0.9f) ? 0 : ( (hp > full_hp * 0.4f) ? 1 : 2);

	if (this.hasTag("bloody"))	{
		frame += 3;
	}	   
	this.getSprite().animation.frame = frame;
}

void onGib(CSprite@ this)
{
    ParticlesFromSprite( this );
}

bool canBePickedUp( CBlob@ this, CBlob@ byBlob )
{
    return false;
}


f32 onHit( CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData )
{
	f32 dmg = damage;
	switch(customData)
	{
	case Hitters::sword:
		dmg = 0.2f;
		break;

	case Hitters::bomb:
		dmg *= 0.5f;
		break;

	case Hitters::keg:
		dmg *= 2.0f;

	case Hitters::arrow:
		dmg = 0.2f;
		break;

	case Hitters::cata_stones:
		dmg *= 3.0f;
		break;
	}		
	return dmg;
}
