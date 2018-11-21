/* Plasma.as
 * author: Aphelion, Chrispin
 */

#include "CustomHitters.as";

#include "MakeDustParticle.as";
#include "TeamColour.as";
#include "Explosion.as";

const int TRAIL_SEGMENTS = 15;
const f32 TICKS_PER_SEG_UPDATE = 3;

namespace Plasma
{

	const PlasmaProjectile[] profiles = 
	{
		PlasmaProjectile("plasma_l", "PlasmaExplosion.ogg", 1.0f, 32.0f, 1.5f, 1.5f, 16.0f, 0.3f),
		PlasmaProjectile("plasma_c", "PlasmaExplosion.ogg", 1.5f, 28.0f, 2.0f, 6.0f, 24.0f, 0.6f),
		PlasmaProjectile("plasma_p", "PlasmaExplosion.ogg", 0.7f, 16.0f, 1.5f, 0.3f, 0.0f, 0.0f)
	};

}

class PlasmaProjectile
{
	string name;
	string explosion_sound;

	f32 trail_width;

	f32 explosion_radius;
	f32 explosion_damage;
	f32 direct_damage;

	f32 map_radius;
	f32 map_damage_ratio;

	PlasmaProjectile( string _name, string _explosion_sound, f32 _trail_width, f32 _explosion_radius, f32 _explosion_damage, f32 _direct_damage, f32 _map_radius, f32 _map_damage_ratio )
	{
		name = _name;
		explosion_sound = _explosion_sound;

		trail_width = _trail_width;

		explosion_radius = _explosion_radius;
		explosion_damage = _explosion_damage;
		direct_damage = _direct_damage;

		map_radius = _map_radius;
		map_damage_ratio = _map_damage_ratio;
	}
}

PlasmaProjectile getProjectileData( CBlob@ this )
{
	for(uint i = 0; i < Plasma::profiles.length; i++)
	{
		PlasmaProjectile data = Plasma::profiles[i];

		if (data.name == this.getName())
		{
			return data;
		}
	}
	return Plasma::profiles[0];
}

void Setup( CBlob@ this )
{
	PlasmaProjectile data = getProjectileData(this);

	this.set_f32("trail_width", data.trail_width);
	this.set_u8("custom_hitter", Hitters::plasma);
	this.set_string("custom_explosion_sprite", "Entities/Effects/Sprites/SmallExplosion" + (XORRandom(3) + 1) + ".png");
	this.set_string("custom_explosion_sound", data.explosion_sound);
    this.set_f32("map_damage_radius", data.map_radius);
    this.set_f32("map_damage_ratio", data.map_damage_ratio);
	this.set_bool("map_damage_raycast", false);
}

void onInit( CBlob@ this )
{
	Setup(this);

	this.SetMapEdgeFlags(u8(CBlob::map_collide_none) | u8(CBlob::map_collide_nodeath));

    CShape@ shape = this.getShape();
	shape.SetRotationsAllowed(false);

	ShapeConsts@ consts = shape.getConsts();
	consts.mapCollisions = false;
	consts.bullet = true;
	consts.net_threshold_multiplier = 4.0f;

	this.Tag("projectile");
    this.getSprite().setRenderStyle(RenderStyle::light);
	this.getSprite().getConsts().accurateLighting = true;

	this.set_bool("initialized", false);
	this.set_bool("segments updating", false);
	this.set_u32("dead segment", 0);

	this.server_SetTimeToDie(10);
}

void onTick( CBlob@ this )
{
	CSprite@ thisSprite = this.getSprite();
	Vec2f thisPos = this.getPosition();
	Vec2f thisVel = this.getVelocity();
	
	bool deathTriggered = this.hasTag("death triggered");
	bool isDead = this.hasTag("dead");

	if (getNet().isClient())
	{
		f32 trail_width = this.get_f32("trail_width");
		
		if(!this.get_bool("initialized") && this.getTickSinceCreated() > 1)
		{
			this.SetLight(true);
			this.SetLightRadius(32.0f);
			this.SetLightColor(getTeamColor(this.getTeamNum()));
			thisSprite.SetZ(500.0f);
			
			array<Vec2f> trail_positions(TRAIL_SEGMENTS, this.getPosition());
			this.set("trail positions", trail_positions);
			
			array<Vec2f> trail_vectors;
			for (int i = 0; i < TRAIL_SEGMENTS-1; i++)
			{
				trail_vectors.push_back(trail_positions[i+1] - trail_positions[i]);
			}		
			this.set("trail vectors", trail_vectors);
			
			this.set_bool("initialized", true);
		}
		
		// trail effects
		if (this.getTickSinceCreated() > 1)	//delay to prevent rendering trails leading from map origin
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
						
				CSpriteLayer@ trail = thisSprite.addSpriteLayer( "trail" + (lastPosArrayElement), "PlasmaTrail.png", 16, 16 ); 
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
						trail_width*((TICKS_PER_SEG_UPDATE-ticksTillUpdate*(1.0f/TRAIL_SEGMENTS))/TICKS_PER_SEG_UPDATE)) );							
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
						
				CSpriteLayer@ trail = thisSprite.addSpriteLayer( "trail" + (lastPosArrayElement-1), "PlasmaTrail.png", 16, 16 );
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
						trail_width*((TRAIL_SEGMENTS-1.0f)/TRAIL_SEGMENTS)
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
						
				CSpriteLayer@ trail = thisSprite.addSpriteLayer( "trail"+i, "PlasmaTrail.png", 16, 16 );
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
						trail_width*((i*1.0f-(trail_positions.length-TRAIL_SEGMENTS))/TRAIL_SEGMENTS)
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

	if(!this.hasTag("collided"))
	{
		f32 angle = (this.getVelocity()).Angle();
		Pierce(this);
		thisSprite.ResetTransform();
		thisSprite.RotateBy(-angle, Vec2f(0, 0));
	}
	
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

		PlasmaProjectile data = getProjectileData(this);

		Vec2f initVelocity = this.getOldVelocity();

		this.server_Hit(blob, blob.getPosition(), initVelocity, data.direct_damage, Hitters::plasma);
		PlasmaExplode(this, data, blob.getPosition(), initVelocity);
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
		PlasmaExplode(this, getProjectileData(this), end, this.getOldVelocity());
	}
}

void PlasmaExplode( CBlob@ this, PlasmaProjectile data, Vec2f pos, Vec2f velocity )
{
	Explode(this, data.explosion_radius, data.explosion_damage);

	this.setVelocity(Vec2f(0, 0));

	this.Tag("collided");
	this.Tag("death triggered");
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
	
	this.server_SetTimeToDie(3);
	
	this.Tag("dead");
}
