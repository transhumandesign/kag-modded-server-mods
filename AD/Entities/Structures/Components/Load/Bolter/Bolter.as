// Bolter.as

#include "MechanismsCommon.as";
#include "ArcherCommon.as";

class Bolter : Component
{
	u16 id;
	f32 angle;
	Vec2f offset;

	Bolter(Vec2f position, u16 _id, f32 _angle, Vec2f _offset)
	{
		x = position.x;
		y = position.y;

		id = _id;
		angle = _angle;
		offset = _offset;
	}

	void Activate(CBlob@ this)
	{
		Vec2f position = this.getPosition();

		if(getNet().isServer())
		{
			// calculate deviation
			f32 deviation = (XORRandom(100) - 50) / 20.0f;

			// calculate velocity based on deviation
			Vec2f velocity = offset;
			velocity.RotateBy(deviation);
			velocity *= 17.59f;

			// spawn projectile
			CBlob@ projectile = server_CreateBlobNoInit("arrow");

			projectile.set_u8("arrow type", 0);
			projectile.server_setTeamNum(this.getTeamNum());
            projectile.Tag("frombolter");
			projectile.Init();

            projectile.server_SetTimeToDie(1.0f);

			projectile.IgnoreCollisionWhileOverlapped(this);
			projectile.setPosition(position);
			projectile.setVelocity(velocity);

		}

		CSprite@ sprite = this.getSprite();
		if(sprite is null) return;

		sprite.PlaySound("BolterFire.ogg");

		ParticleAnimated(
		"BolterFire.png",                   // file name
		position + (offset * 8),            // position
		Vec2f_zero,                         // velocity
		angle,                              // rotation
		1.0f,                               // scale
		3,                                  // ticks per frame
		0.0f,                               // gravity
		false);                             // self lit
	}
}

void onInit(CBlob@ this)
{
	// used by BuilderHittable.as
	this.Tag("builder always hit");

	// used by KnightLogic.as
	this.Tag("blocks sword");

	// used by TileBackground.as
	this.set_TileType("background tile", CMap::tile_wood_back);
}

void onSetStatic(CBlob@ this, const bool isStatic)
{
	if(!isStatic || this.exists("component")) return;

	const Vec2f position = this.getPosition() / 8;
	const u16 angle = this.getAngleDegrees();
	const Vec2f offset = Vec2f(0, -1).RotateBy(angle);

	Bolter component(position, this.getNetworkID(), angle, offset);
	this.set("component", component);

	if(getNet().isServer())
	{
		MapPowerGrid@ grid;
		if(!getRules().get("power grid", @grid)) return;

		grid.setAll(
		component.x,                        // x
		component.y,                        // y
		TOPO_CARDINAL,                      // input topology
		TOPO_NONE,                          // output topology
		INFO_LOAD,                          // information
		0,                                  // power
		component.id);                      // id
	}

	this.getSprite().SetZ(500);
}

bool canBePickedUp(CBlob@ this, CBlob@ byBlob)
{
	return false;
}
