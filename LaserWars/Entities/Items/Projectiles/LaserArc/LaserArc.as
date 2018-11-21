/* LaserArc.as
 * author: Aphelion & Chrispin
 */

#include "CustomHitters.as";

#include "MakeDustParticle.as";
#include "TeamColour.as";
#include "Explosion.as";

const int TRAIL_SEGMENTS = 10;
const f32 TICKS_PER_SEG_UPDATE = 4;
const f32 TRAIL_WIDTH = 0.8f;

void SetupTrail( CBlob@ this )
{
	Vec2f pos = this.getPosition();
	if   (pos.x == 0 || pos.y == 0) return;

	this.SetLight(true);
	this.SetLightRadius(48.0f);
	this.SetLightColor(getTeamColor(this.getTeamNum()));
	this.getSprite().SetZ(500.0f);
	
	array<Vec2f> trail_positions(TRAIL_SEGMENTS, pos);
	this.set("trail positions", trail_positions);
	
	array<Vec2f> trail_vectors;
	for (int i = 0; i < TRAIL_SEGMENTS-1; i++)
	{
		trail_vectors.push_back(trail_positions[i+1] - trail_positions[i]);
	}		
	this.set("trail vectors", trail_vectors);
	
	this.set_bool("initialized", true);
}

void onInit( CBlob@ this )
{
    CShape@ shape = this.getShape();
	//shape.SetGravityScale(1.5f);
	shape.SetRotationsAllowed(false);

	ShapeConsts@ consts = shape.getConsts();
	consts.mapCollisions = false;
	consts.bullet = false;
	consts.net_threshold_multiplier = 4.0f;

	this.Tag("projectile");
    this.getSprite().setRenderStyle(RenderStyle::light);
	this.getSprite().getConsts().accurateLighting = true;

	this.SetMapEdgeFlags(u8(CBlob::map_collide_none) | u8(CBlob::map_collide_nodeath));
	this.server_SetTimeToDie(10);
	
	this.set_bool("initialized", false);
	this.set_bool("segments updating", false);
	this.set_u32("dead segment", 0);
	
	this.set_bool("death triggered", false);
	this.set_bool("dead", false);
}

void onTick( CBlob@ this )
{
	CSprite@ thisSprite = this.getSprite();
	Vec2f thisPos = this.getPosition();
	Vec2f thisVel = this.getVelocity();
	
	bool deathTriggered = this.get_bool("death triggered");	//used to sync server and client onCollision 
	bool isDead = this.hasTag("dead");

	if (getNet().isClient())
	{
		if(!this.get_bool("initialized") && this.getTickSinceCreated() > 0)
		{
		    SetupTrail(this);
		}
		
		// trail effects
		if (this.get_bool("initialized"))
		{
			Vec2f[]@ trail_positions;
			this.get( "trail positions", @trail_positions );
			
			Vec2f[]@ trail_vectors;
			this.get( "trail vectors", @trail_vectors );
			
			if ( trail_positions is null || trail_vectors is null )
				return; 
			
			bool segmentsUpdating = this.get_bool("segments updating");
			f32 ticksTillUpdate = getGameTime() % TICKS_PER_SEG_UPDATE;
			if ( ticksTillUpdate == 0 )
			{
				this.set_bool("segments updating", true);
			}
			
			int lastPosArrayElement = trail_positions.length-1;
			int lastVecArrayElement = trail_vectors.length-1;
			
			if ( segmentsUpdating )
			{				
				trail_positions.push_back(thisPos);
				trail_vectors.push_back(thisPos - trail_positions[lastPosArrayElement]);
				this.set_bool("segments updating", false);
			}
			
			for (int i = 0; i < trail_positions.length; i++)
			{
				thisSprite.RemoveSpriteLayer("trail"+i);
			}
			
			int deadSegment = this.get_u32("dead segment");
			
			if ( !(isDead && lastPosArrayElement > deadSegment ) )
			{
				Vec2f currSegPos = trail_positions[lastPosArrayElement];
				Vec2f followVec = currSegPos - thisPos;
				Vec2f followNorm = followVec;
				followNorm.Normalize();
				
				f32 followDist = followVec.Length();
						
				CSpriteLayer@ trail = thisSprite.addSpriteLayer( "trail" + (lastPosArrayElement), "LaserArcTrail.png", 16, 16 ); 
				if (trail !is null)
				{
					Animation@ anim = trail.addAnimation( "default", 1, true );
					int[] frames = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15};
					anim.AddFrames(frames);				
					trail.SetFrameIndex(15 - (getGameTime() % 15));
					
					trail.SetVisible(true);
					
					f32 trailLength = (followDist+1.0f) / 16.0f;				
					trail.ResetTransform();						
					trail.ScaleBy( Vec2f(trailLength,
						TRAIL_WIDTH*((TICKS_PER_SEG_UPDATE-ticksTillUpdate*(1.0f/TRAIL_SEGMENTS))/TICKS_PER_SEG_UPDATE)) );							
					trail.TranslateBy( Vec2f(trailLength*8.0f, 0.0f) );							
					trail.RotateBy( -followNorm.Angle(), Vec2f());
					trail.setRenderStyle(RenderStyle::light);
					trail.SetRelativeZ(-1);
				}
			}
			
			if ( !(isDead && (lastPosArrayElement-1) > deadSegment) )
			{
				Vec2f currSegPos = trail_positions[lastPosArrayElement-1];			
				Vec2f nextSegPos = trail_positions[lastPosArrayElement];
				Vec2f followVec = currSegPos - nextSegPos;
				Vec2f followNorm = followVec;
				followNorm.Normalize();
				
				f32 followDist = followVec.Length();
				
				Vec2f netTranslation = nextSegPos - thisPos;
						
				CSpriteLayer@ trail = thisSprite.addSpriteLayer( "trail" + (lastPosArrayElement-1), "LaserArcTrail.png", 16, 16 );
				if (trail !is null)
				{
					Animation@ anim = trail.addAnimation( "default", 1, true );
					int[] frames = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15};
					anim.AddFrames(frames);				
					trail.SetFrameIndex(15 - (getGameTime() % 15)); 
					
					trail.SetVisible(true);
					
					f32 trailLength = (followDist+1.0f) / 16.0f;						
					trail.ResetTransform();							
					trail.ScaleBy( Vec2f(trailLength,
						TRAIL_WIDTH*((TRAIL_SEGMENTS-1.0f)/TRAIL_SEGMENTS)
						*((TICKS_PER_SEG_UPDATE-ticksTillUpdate*(1.0f/TRAIL_SEGMENTS))/TICKS_PER_SEG_UPDATE)) );							
					trail.TranslateBy( Vec2f(trailLength*8.0f, 0.0f) );							
					trail.RotateBy( -followNorm.Angle(), Vec2f());
					trail.TranslateBy( netTranslation );
					trail.setRenderStyle(RenderStyle::light);
					trail.SetRelativeZ(-1);
				}
			}
			
			for (int i = trail_positions.length - TRAIL_SEGMENTS; i < lastVecArrayElement; i++)
			{
				if ( isDead && i > deadSegment )
					continue;
			
				Vec2f currSegPos = trail_positions[i];				
				Vec2f prevSegPos = trail_positions[i+1];
				Vec2f followVec = currSegPos - prevSegPos;
				Vec2f followNorm = followVec;
				followNorm.Normalize();
				
				f32 followDist = followVec.Length();
				
				Vec2f netTranslation = Vec2f(0,0);
				for (int t = i+1; t < lastVecArrayElement; t++)
				{	
					netTranslation = netTranslation - trail_vectors[t]; 
				}
				
				Vec2f movementOffset = trail_positions[lastPosArrayElement-1] - thisPos;
						
				CSpriteLayer@ trail = thisSprite.addSpriteLayer( "trail"+i, "LaserArcTrail.png", 16, 16 );
				if (trail !is null)
				{
					Animation@ anim = trail.addAnimation( "default", 1, true );
					int[] frames = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15};
					anim.AddFrames(frames);				
					trail.SetFrameIndex(15 - (getGameTime() % 15));
					
					trail.SetVisible(true);
					
					f32 trailLength = (followDist+1.0f) / 16.0f;					
					trail.ResetTransform();			
					trail.ScaleBy( Vec2f(trailLength,
						TRAIL_WIDTH*((i*1.0f-(trail_positions.length-TRAIL_SEGMENTS))/TRAIL_SEGMENTS)
						*((TICKS_PER_SEG_UPDATE-ticksTillUpdate*(1.0f/TRAIL_SEGMENTS))/TICKS_PER_SEG_UPDATE)) );	
					trail.TranslateBy( Vec2f(trailLength*8.0f, 0.0f) );	
					trail.RotateBy( -followNorm.Angle(), Vec2f() );	
					trail.TranslateBy( netTranslation + movementOffset );	
					trail.setRenderStyle(RenderStyle::light);
					trail.SetRelativeZ(-1);
				}
			}
		}
    }

	f32 angle = (this.getVelocity()).Angle();
	Pierce(this);
	thisSprite.ResetTransform();
	thisSprite.RotateBy(-angle, Vec2f());
	
	if (deathTriggered && !isDead)
	{
		Die(this);
	}
}

void onCollision( CBlob@ this, CBlob@ blob, bool solid, Vec2f normal, Vec2f point1 )
{
    if (blob !is null && doesCollideWithBlob(this, blob) && !this.hasTag("collided"))
	{
		if (!solid && !blob.hasTag("flesh") && (blob.getName() != "mounted_bow" || this.getTeamNum() != blob.getTeamNum()))
		{
			return;
		}

		this.server_Hit(blob, point1, normal, 1.2f, Hitters::gun);
		LaserCollide(this, blob.getPosition(), this.getOldVelocity());
	}
}

bool doesCollideWithBlob( CBlob@ this, CBlob@ blob )
{
	if (blob.hasTag("projectile"))
	{
		return false;
	}
	
	bool check = this.getTeamNum() != blob.getTeamNum();
	if (!check)
	{
		CShape@ shape = blob.getShape();
		check = (shape.isStatic() && !shape.getConsts().platform);
	}

	if (check)
	{
		if (this.getShape().isStatic() ||
		        this.hasTag("collided") ||
		        blob.hasTag("dead"))
		{
			return false;
		}
		else
		{
			return true;
		}
	}
	return false;
}

void Pierce( CBlob@ this )
{
	CMap@ map = this.getMap();
	Vec2f end;

	if (map.rayCastSolidNoBlobs(this.getShape().getVars().oldpos, this.getPosition() + this.getVelocity(), end))
	{
		LaserCollide(this, end, this.getOldVelocity());
	}
}

void LaserCollide( CBlob@ this, Vec2f pos, Vec2f velocity )
{
	if (this.hasTag("collided")) return;

	this.setVelocity(Vec2f(0, 0));

	this.Tag("collided");
	this.set_bool("death triggered", true);
	this.Sync("death triggered", true);
}

void Die( CBlob@ this )
{
	Vec2f[]@ trail_positions;
	if (this.get("trail positions", @trail_positions))
		this.set_u32("dead segment", trail_positions.length - 1);

	this.shape.SetStatic(true);
	this.getSprite().SetVisible(false);
	this.getSprite().SetEmitSoundPaused(true);
	
	this.server_SetTimeToDie(1.5f);
	
	this.Tag("dead");
}
