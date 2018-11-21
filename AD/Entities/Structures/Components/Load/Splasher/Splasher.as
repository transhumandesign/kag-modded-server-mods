// Bolter.as

#include "MechanismsCommon.as";
#include "SplashWater.as";

class Splasher : Component
{
	u16 id;
	f32 angle;
	Vec2f offset;
    bool reset;

	Splasher(Vec2f position, u16 _id, f32 _angle, Vec2f _offset)
	{
		x = position.x;
		y = position.y;

		id = _id;
		angle = _angle;
		offset = _offset;
        reset = true;
	}

	void Activate(CBlob@ this)
	{
		Vec2f position = this.getPosition();

        if(reset)
        {
            CMap@ map = getMap();
            Vec2f pos = this.getPosition();
            pos += offset * 8;
            pos += offset * 4;
            Splash(this, pos, 2, 2, 0.0f, true, false);

            reset = false;

		    CSprite@ sprite = this.getSprite();
		    if(sprite is null) return;

		    sprite.PlaySound("BolterFire.ogg");
            sprite.SetFrameIndex(0);

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
        else
        {
            reset = true;

		    CSprite@ sprite = this.getSprite();
		    if(sprite is null) return;

		    sprite.PlaySound("LoadingTick.ogg");
            sprite.SetFrameIndex(1);

        }


	}
}

void onInit(CBlob@ this)
{
	// used by BuilderHittable.as
	this.Tag("builder always hit");

	// used by KnightLogic.as
	this.Tag("blocks sword");

	// used by TileBackground.as
	this.set_TileType("background tile", CMap::tile_castle_back);
}

void onSetStatic(CBlob@ this, const bool isStatic)
{
	if(!isStatic || this.exists("component")) return;

	const Vec2f position = this.getPosition() / 8;
	const u16 angle = this.getAngleDegrees();
	const Vec2f offset = Vec2f(0, -1).RotateBy(angle);

	Splasher component(position, this.getNetworkID(), angle, offset);
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
    this.getSprite().SetFrameIndex(1);
}

bool canBePickedUp(CBlob@ this, CBlob@ byBlob)
{
	return false;
}
