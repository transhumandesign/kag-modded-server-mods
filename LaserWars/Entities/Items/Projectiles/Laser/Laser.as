/* Laser.as
 * author: Aphelion
 */

#include "GunsCommon.as";

#include "CustomHitters.as";
#include "MakeDustParticle.as";
#include "TeamColour.as";

const f32 WIDTH = 16.0f;

CSpriteLayer@ AddLayer( CSprite@ sprite )
{
	CSpriteLayer@ laser = sprite.addSpriteLayer("laser", "Laser.png", 16, 8);

    if (laser !is null)
    {
    	Animation@ anim = laser.addAnimation("default", 0, false);
    	anim.AddFrame(0);
    	
    	laser.setRenderStyle(RenderStyle::light);
    }
    return laser;
}

void onInit( CBlob@ this )
{
	GunInfo@ gunInfo = getGunInfoByIndex(this.get_u8("gun_index"));
	
	this.set_f32("damage", gunInfo.projectileInfo.damage);
	this.set_u8("range", gunInfo.projectileInfo.range);

	this.SetLight(true);
	this.SetLightRadius(48.0f);
	this.SetLightColor(getTeamColor(this.getTeamNum()));

	this.SetMapEdgeFlags(u8(CBlob::map_collide_none) | u8(CBlob::map_collide_nodeath));

    CShape@ shape = this.getShape();
	shape.SetGravityScale(0.0f);
	shape.SetRotationsAllowed(false);

	ShapeConsts@ consts = shape.getConsts();
	consts.mapCollisions = false;
	consts.bullet = true;
	consts.net_threshold_multiplier = 4.0f;
	
	this.Tag("projectile");
	this.getSprite().getConsts().accurateLighting = true;

	this.server_SetTimeToDie(10);
}

void onTick( CBlob@ this )
{
	if(!this.exists("origin pos"))
	{
	    this.set_Vec2f("origin pos", this.getPosition());
	}

    Vec2f originPos = this.get_Vec2f("origin pos");
    Vec2f pos = this.getPosition();

    f32 dist  = (pos - originPos).getLength();
	f32 angle = (this.getVelocity()).Angle();
	u8 range  = this.get_u8("range");

	if (!this.hasTag("collided") && (dist / 8) < range)
	{
		Pierce(this, this.getShape().getVars().oldpos);

	    this.setAngleDegrees(-angle);
	}
	else
	{
		this.Tag("collided");

	    this.setVelocity(Vec2f(0, 0));
	    this.server_Die();
		return;
	}

	CSprite@ sprite = this.getSprite();
	CSpriteLayer@ laser = sprite.getSpriteLayer("laser");

	if (laser !is null)
	{
		f32 segments = Maths::Max((dist / WIDTH) - 1, 0.0f);

		laser.ResetTransform();
		laser.ScaleBy(Vec2f(1.0f + segments, 1.0f));
		laser.TranslateBy(Vec2f(-WIDTH * segments / 2, 0.0f));
	}
	else if (dist > WIDTH)
	{
        AddLayer(sprite);
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

		this.server_Hit(blob, point1, normal, this.get_f32("damage"), Hitters::gun);
		Collide(this);
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

void Pierce( CBlob@ this, Vec2f fromPos )
{
	CMap@ map = this.getMap();
	Vec2f end;

	if (map.rayCastSolidNoBlobs(fromPos, this.getPosition() + this.getVelocity(), end))
	{
		MakeDustParticle(end, "/DustSmall.png");

		Collide(this);
	}
}

void Collide( CBlob@ this )
{
	this.Tag("collided");
}
