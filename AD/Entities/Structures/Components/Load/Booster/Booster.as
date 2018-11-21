// Booster.as

#include "MechanismsCommon.as";
#include "Hitters.as";

class Booster : Component
{
	u16 id;
	Vec2f offset;

	Booster(Vec2f position, u16 netID, Vec2f _offset)
	{
		x = position.x;
		y = position.y;

		id = netID;
		offset = _offset;
	}

	void Activate(CBlob@ this)
	{
		Vec2f position = this.getPosition();

		CMap@ map = getMap();
		if(map.rayCastSolid(position + offset * 5, position + offset * 11))
		{
			this.getSprite().PlaySound("dry_hit.ogg");
			return;
		}

		AttachmentPoint@ mechanism = this.getAttachments().getAttachmentPointByName("MECHANISM");
		if(mechanism is null) return;

		mechanism.offset = Vec2f(0, -7);

		CBlob@ pad = mechanism.getOccupied();
		if(pad is null) return;

		pad.set_u8("state", 1);

		Vec2f force;
		const u16 angle_point = this.getAngleDegrees() / 90;

		switch(angle_point)
		{
			case 0:
			    force.y -= 500.0f;
			    break;

			case 1:
			    force.x += 500.0f;
			    break;

			case 2:
			    force.y += 500.0f;
			    break;

			case 3:
			    force.x -= 500.0f;
			    break;
		}

		// hit flesh at target position
		CBlob@[] blobs;
		map.getBlobsAtPosition(offset * 8 + position, @blobs);
		for(uint i = 0; i < blobs.length; i++)
		{
			CBlob@ blob = blobs[i];
			if(!blob.hasTag("flesh")) continue;

			blob.AddForce(force);
		}

		CSprite@ sprite = this.getSprite();
		if(sprite is null) return;

        CSpriteLayer@ layer = sprite.getSpriteLayer("background");
        layer.SetVisible(false);

		sprite.PlaySound("bounce.ogg", 2.0f);


	}

	void Deactivate(CBlob@ this)
	{
		// if ! blocked, do stuff

		AttachmentPoint@ mechanism = this.getAttachments().getAttachmentPointByName("MECHANISM");
		if(mechanism is null) return;

		mechanism.offset = Vec2f(0, 0);

		CBlob@ pad = mechanism.getOccupied();
		if(pad is null) return;

		pad.set_u8("state", 0);

		CSprite@ sprite = this.getSprite();
		if(sprite is null) return;

		sprite.PlaySound("LoadingTick.ogg");

        CSpriteLayer@ layer = sprite.getSpriteLayer("background");
        layer.SetVisible(true);


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

	Booster component(position, this.getNetworkID(), offset);
	this.set("component", component);

	this.getAttachments().getAttachmentPointByName("MECHANISM").offsetZ = -5;

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

		CBlob@ pad = server_CreateBlob("pad", this.getTeamNum(), this.getPosition());
		pad.setAngleDegrees(this.getAngleDegrees());
		pad.set_u8("state", 0);

		ShapeConsts@ consts = pad.getShape().getConsts();
		consts.mapCollisions = false;
		consts.collideWhenAttached = true;

		this.server_AttachTo(pad, "MECHANISM");
	}

	CSprite@ sprite = this.getSprite();
	if(sprite is null) return;

	sprite.SetZ(500);
	sprite.SetFrameIndex(angle / 90);
	sprite.SetFacingLeft(false);

	CSpriteLayer@ layer = sprite.addSpriteLayer("background", "Booster.png", 8, 16);
	layer.addAnimation("default", 0, false);
	layer.animation.AddFrame(4);
	layer.SetRelativeZ(-10);
	layer.SetFacingLeft(false);
}

void onDie(CBlob@ this)
{
	if(!getNet().isServer()) return;

	CBlob@ pad = this.getAttachments().getAttachmentPointByName("MECHANISM").getOccupied();
	if(pad is null) return;

	pad.server_Die();
}
