/* Missile.as
 * author: Aphelion
 */

#include "CustomHitters.as";
#include "Trails.as";

#include "MakeDustParticle.as";
#include "Explosion.as";

const u32 LIFETIME = 4 * 30;

namespace Missile
{
	const u32 Track_None = 0x0;
	const u32 Track_Vehicle = 0x1;
	const u32 Track_Player = 0x2;
	const u32 Track_Cursor = 0x4;

	const MissileData[] profiles = 
	{
		// swarm missile
		MissileData("missile_s", "ExplosionPlasma.ogg", Hitters::swarm_missile, 5, 200.0f, 160.0f, 9.0f, 0.75f, 48.0f, 0.5f, 0.25f, 12.0f, 0.4f, Track_Vehicle | Track_Player | Track_Cursor),

		// light missile
		MissileData("missile_l", "ExplosionMissile.ogg", Hitters::light_missile, 3, 200.0f, 48.0f, 12.0f, 1.0f, 64.0f, 6.0f, 3.0f, 48.0f, 0.5f, Track_Vehicle | Track_Cursor),

		// heavy missile
		MissileData("missile_h", "ExplosionMissile.ogg", Hitters::heavy_missile, 0, 0.0f, 0.0f, 14.0f, 0.75f, 64.0f, 4.5f, 13.5f, 64.0f, 0.6f, Track_None),
	};
}

class MissileData
{
	string name;
	string explosion_sound;
	u8 hitter;

	int tracking_delay;
	f32 control_distance;
	f32 search_radius;
	f32 max_velocity;
	f32 trail_width;

	f32 explosion_radius;
	f32 explosion_damage;
	f32 direct_damage;

	f32 map_radius;
	f32 map_damage_ratio;

	u32 tracking_flags;

	MissileData( string _name, string _explosion_sound, u8 _hitter, int _tracking_delay, f32 _control_distance, f32 _search_radius, f32 _max_velocity, f32 _trail_width, f32 _explosion_radius, f32 _explosion_damage, f32 _direct_damage, f32 _map_radius, f32 _map_damage_ratio, u32 _tracking_flags )
	{
		name = _name;
		explosion_sound = _explosion_sound;
		hitter = _hitter;

		tracking_delay = _tracking_delay;
		control_distance = _control_distance;
		search_radius = _search_radius;
		max_velocity = _max_velocity;
		trail_width = _trail_width;

		explosion_radius = _explosion_radius;
		explosion_damage = _explosion_damage;
		direct_damage = _direct_damage;

		map_radius = _map_radius;
		map_damage_ratio = _map_damage_ratio;

		tracking_flags = _tracking_flags;
	}
}

MissileData getProjectileData( CBlob@ this )
{
	for(uint i = 0; i < Missile::profiles.length; i++)
	{
		MissileData data = Missile::profiles[i];

		if (data.name == this.getName())
		{
			return data;
		}
	}
	return Missile::profiles[0];
}

void Setup( CBlob@ this )
{
	MissileData data = getProjectileData(this);

	this.set_f32("trail_width", data.trail_width);
	this.set_u8("custom_hitter", data.hitter);
	this.set_string("custom_explosion_sprite", "Entities/Effects/Sprites/SmallExplosion" + (XORRandom(3) + 1) + ".png");
	this.set_string("custom_explosion_sound", data.explosion_sound);
    this.set_f32("map_damage_radius", data.map_radius);
    this.set_f32("map_damage_ratio", data.map_damage_ratio);
	this.set_bool("map_damage_raycast", false);

	SetupTrails(this, "PlasmaTrail.png", 10, 2, data.trail_width, 32.0f, getTeamColor(this.getTeamNum()));
}

void onInit( CBlob@ this )
{
	this.getShape().SetGravityScale(0.5f);
	this.getShape().SetRotationsAllowed(false);

	ShapeConsts@ consts = this.getShape().getConsts();
	consts.mapCollisions = false;
	consts.bullet = true;
	consts.net_threshold_multiplier = 4.0f;

	Setup(this);

	this.Tag("projectile");
	this.SetMapEdgeFlags(u8(CBlob::map_collide_none) | u8(CBlob::map_collide_nodeath));

	CSprite@ sprite = this.getSprite();
	sprite.getConsts().accurateLighting = true;
	//sprite.SetEmitSound("/Seeker.ogg");
	//sprite.SetEmitSoundPaused(false);

	this.server_SetTimeToDie(15);
}

void onTick( CBlob@ this )
{
	MissileData data = getProjectileData(this);

	Vec2f pos = this.getPosition();
	Vec2f vel = this.getVelocity();

	CBlob@ target = getBlobByNetworkID(this.get_netid("target"));

	bool deathTriggered = this.hasTag("death triggered");
	bool isDead = this.hasTag("dead");

	UpdateTrails(this);

	bool track_vehicles = (data.tracking_flags & Missile::Track_Vehicle) != 0;
	bool track_players = (data.tracking_flags & Missile::Track_Player) != 0;
	bool track_cursor = (data.tracking_flags & Missile::Track_Cursor) != 0;

	if ((track_vehicles || track_players) && this.getTickSinceCreated() > data.tracking_delay)
	{
		if (target is null)
		{
			CBlob@[] blobs;
			this.getMap().getBlobsInRadius(pos, data.search_radius, @blobs);

			f32 best_dist = 99999.9f;
			for(uint step = 0; step < blobs.length; ++step)
			{
				CBlob@ candidate = blobs[step];
				if    (candidate is this) continue;

				bool vehicle = track_vehicles && candidate.hasTag("vehicle");
				bool player  = track_players && candidate.hasTag("player") && !candidate.hasTag("cloaked") && !candidate.hasTag("dead");

				if (candidate.getTeamNum() != this.getTeamNum() && (vehicle || player))
				{
					Vec2f tpos = candidate.getPosition();

					f32 dist = (tpos - pos).getLength();

					if (vehicle)
					{
						dist /= 2;
					}

					if (dist < best_dist && !getMap().rayCastSolid(pos, tpos))
					{
						this.set_netid("target", candidate.getNetworkID());
						this.Sync("target", true);

						@target = candidate;
						best_dist = dist;
					}
				}
			}
		}
		else
		{
			Vec2f tpos = target.getPosition();
			Vec2f targetNorm = tpos - pos;
			targetNorm.Normalize();
			
			this.AddForce(targetNorm * 3.0f);
			this.getShape().setDrag(0.2f);
		}
	}

	if (track_cursor)
	{
		if (target is null)
		{
			CBlob@ ownerBlob;

			CPlayer@ damagePlayer = this.getDamageOwnerPlayer();
			if (damagePlayer !is null)
			{
				@ownerBlob = damagePlayer.getBlob();
			}

			if (ownerBlob !is null)
			{
				f32 distance_to_missile =   (pos - ownerBlob.getPosition()).getLength();
				if (distance_to_missile < data.control_distance)
				{
					Vec2f targetNorm = ownerBlob.getAimPos() - pos;
					targetNorm.Normalize();
					
					this.AddForce(targetNorm * 1.0f);
					this.getShape().setDrag(0.6f);
				}
				else
				{
					this.getShape().setDrag(0.2f);
				}
			}
		}
    }
		
	f32 len = vel.Normalize();

	if (len > data.max_velocity)
	{
		len = data.max_velocity;
	}
	
	vel *= len;
	this.setVelocity(vel);

	if(!this.hasTag("collided"))
	{
		if (this.getTickSinceCreated() < LIFETIME)
		{
			f32 angle = (this.getVelocity()).Angle();
			Pierce(this);

		    CSprite@ sprite = this.getSprite();
			sprite.ResetTransform();
			sprite.RotateBy(-angle, Vec2f(0, 0));
		}
		else
		{
			MissileExplode(this, data, this.getPosition(), this.getVelocity());
		}
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

		MissileData data = getProjectileData(this);

		Vec2f initVelocity = this.getOldVelocity();

		this.server_Hit(blob, blob.getPosition(), initVelocity, data.direct_damage, data.hitter);
		MissileExplode(this, data, blob.getPosition(), initVelocity);
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
		MissileExplode(this, getProjectileData(this), end, this.getOldVelocity());
	}
}

void MissileExplode( CBlob@ this, MissileData data, Vec2f pos, Vec2f velocity )
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
	
	this.server_SetTimeToDie(1.5f);
	
	this.Tag("dead");
}
