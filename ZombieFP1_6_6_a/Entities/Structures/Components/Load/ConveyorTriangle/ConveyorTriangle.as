// Dispenser.as

#include "MechanismsCommon.as";
class Conveyor : Component
{
		u16 id;
	f32 angle;
	Vec2f offset;

	Conveyor(Vec2f position, u16 _id, f32 _angle, Vec2f _offset)
	{
		x = position.x;
		y = position.y;

		id = _id;
		angle = _angle;
		offset = _offset;
	}
	void Activate(CBlob@ this)
	{

		this.set_bool("is active", true);
		this.getSprite().SetAnimation("roll");
		//print("active");
	}

	void Deactivate(CBlob@ this)
	{
		this.set_bool("is active", false);
		this.getSprite().SetAnimation("default");
		//print("deactive");

	}
}
/*
class Dispenser : Component
{
	u16 id;
	f32 angle;
	Vec2f offset;

	Dispenser(Vec2f position, u16 _id, f32 _angle, Vec2f _offset)
	{
		x = position.x;
		y = position.y;

		id = _id;
		angle = _angle;
		offset = _offset;
	}

	CBlob@ blob = this.getBlob();

	void Deactivate(CBlob@ this)
	{
		CBlob@ sprite = this.getSprite();

		this.SetAnimation("default");
		
	}

	void Activate(CBlob@ this)
	{
		CBlob@ sprite = this.getSprite();

		this.SetAnimation("roll");


		
	}


		ParticleAnimated(
		"DispenserFire.png",                // file name
		position + (offset * 8),            // position
		Vec2f_zero,                         // velocity
		angle,                              // rotation
		1.0f,                               // scale
		3,                                  // ticks per frame
		0.0f,                               // gravity
		false);                             // self lit
	
	}
}
*/
void onInit(CBlob@ this)
{	    
	this.getShape().SetOffset(Vec2f(0.0, 2.0));

	//this.Tag("place norotate");

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

	Conveyor component(position, this.getNetworkID(), angle, offset);
	this.set("component", component);

	if(getNet().isServer())
	{
		MapPowerGrid@ grid;
		if(!getRules().get("power grid", @grid)) return;

		grid.setAll(
		component.x,                        // x
		component.y,                        // y
		TOPO_CARDINAL,                      // input topology
		TOPO_CARDINAL,                          // output topology
		INFO_LOAD,                          // information
		0,                                  // power
		component.id);                      // id
	}

	CSprite@ sprite = this.getSprite();
	if(sprite is null) return;

	//sprite.SetFacingLeft(false);
	sprite.SetZ(-500);
}

bool canBePickedUp(CBlob@ this, CBlob@ byBlob)
{
	return false;
}

/*void onCollision(CBlob@ this, CBlob@ blob, bool solid)
{
	if(blob !is null)
	{
		blob.AddForce(Vec2f((this.getMass()/20), 0.0f));
	}
}
//bool isColliding*/
void onCollision(CBlob@ this, CBlob@ blob, bool solid)
{
	if(blob !is null)
	{
		if (this.get_bool("is active")) 
		{
			this.set_bool("is colliding", true);
			blob.setVelocity(Vec2f((this.isFacingLeft() ?  -4.0f : 4.0f), -3.0f));
			if (this.getTeamNum()==99)
			{
			blob.setVelocity(Vec2f((this.isFacingLeft() ?  -12.0f : 12.0f), -10.0f));

			}

		}
	}
}
void onEndCollision(CBlob@ this, CBlob@ blob, bool solid)
{
	if(blob !is null)
	{
		if (this.get_bool("is active")) 		
		{
			this.set_bool("is colliding", false);
				blob.setVelocity(Vec2f((this.isFacingLeft() ?  -4.0f : 4.0f), -3.0f));
		}
	}
}

/*void onTick(CBlob@ this)
{
	if (this.get_bool("is colliding")) 
	{ 
		print("it's colliding");
	}
}*/
//onCollision(...) { blob.set_bool("is colliding", true); } onEndCollision(...) { blob.set_bool("is colliding", false); }