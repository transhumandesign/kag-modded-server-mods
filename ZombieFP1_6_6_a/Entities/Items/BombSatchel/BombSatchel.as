// BombSatchel.as

#include "Hitters.as";
#include "BombCommon.as";
#include "Explosion.as";

void onInit(CSprite@ this)
{
	this.SetEmitSound("Sparkle.ogg");
	this.SetEmitSoundPaused(true);
}

void onTick(CSprite@ this)
{
	CBlob@ blob = this.getBlob();
	if(blob.isOnGround() || blob.getShape().isStatic() || blob.isAttached()) return;

	Vec2f velocity = blob.getVelocity();
	velocity.Normalize();

	f32 angle = velocity.Angle();

	this.ResetTransform();
	this.RotateBy(-angle - 90, Vec2f_zero);
}

const u16 fuse = 150;


// todo: standardize spark colors and light color on lit fuse
const SColor[] colors = {
SColor(0xFFF3AC5C),         // ARGB(255, 243, 172,  92);
SColor(0xFFF3AC5C),         // weighted
SColor(0xFFDB5743),         // ARGB(255, 219,  87,  67);
SColor(0xFFDB5743),         // weighted
SColor(0xFF7E3041)};        // ARGB(255, 126,  48,  65);

void onInit(CBlob@ this)
{
	// Activatable.as adds the following
	// this.Tag("activatable");
	// this.addCommandID("activate");

	// used by Fabric scripts, Wooden.as, Stone.as
	this.Tag("ignore fall");

	// used by RunnerMovement.as & ActivateHeldObject.as
	this.Tag("medium weight");

	// used by Explosion.as
	this.set_f32("explosive_radius", 32.0f);
	this.set_f32("explosive_damage", 4.0f);
	this.set_bool("explosive_teamkill", true);

	this.set_f32("map_damage_radius", 40.0f);
	this.set_f32("map_damage_ratio", 0.5f);
	this.set_bool("map_damage_raycast", true);

	this.set_u8("custom_hitter", Hitters::bomb_arrow);
	this.set_string("custom_explosion_sound", "KegExplosion.ogg");

	// used by this script
	this.SetLightRadius(32.0f);
	this.SetLightColor(SColor(0xFFFFF0AB));
	this.SetLight(false);

	CShape@ shape = this.getShape();
	shape.getVars().waterDragScale = 12.0f;
	shape.getConsts().collideWhenAttached = false;

	this.getCurrentScript().tickIfTag = "exploding";
}

void onTick(CBlob@ this)
{
	const u32 timer = this.get_u32("timer");
	const u32 time = getGameTime();
	const s16 remaining = timer - time;

	if(XORRandom(2) == 0)
	{
		sparks(this.getPosition(), this.getAngleDegrees(), 3.5f + (XORRandom(10) / 5.0f), colors[XORRandom(colors.length)]);
	}

	if(remaining > 0) return;

	Explode(this, this.get_f32("explosive_radius"), this.get_f32("explosive_damage"));

	if(getNet().isServer())
	{
		this.server_Die();
	}
}

// todo: collide and stick to dynamic bodies?
void onCollision(CBlob@ this, CBlob@ blob, bool solid, Vec2f normal, Vec2f point1)
{
	if(!solid || this.isAttached()) return;

	CShape@ shape = this.getShape();
	if(this.hasTag("spiky") && !shape.isStatic())
	{
		this.setPosition(normal * this.getRadius() + point1);
		shape.SetStatic(true);
	}

	CSprite@ sprite = this.getSprite();
	if(sprite is null) return;

	const f32 angle = normal.Angle();
	// const f32 volume = shape.vellen / 4;

	sprite.ResetTransform();
	sprite.RotateBy(-angle + 90, Vec2f_zero);

	// collision sound managed by fabric script, Wooden.as
	// sprite.PlaySound("WoodHit.ogg", Maths::Min(volume, 1.0f));
}

void onAttach(CBlob@ this, CBlob@ attached, AttachmentPoint @attachedPoint)
{
	// if shape is static, set to false
	CShape@ shape = this.getShape();
	if(shape.isStatic())
	{
		// if this is stuck in a wall and burning, roast their grubby hands ლ(ಠ益ಠლ)
		if(getNet().isServer() && this.hasTag("exploding"))
		{
			this.server_Hit(attached, attached.getPosition(), Vec2f_zero, 0.5f, Hitters::fire, true);
		}

		shape.SetStatic(false);
	}

	// reset any rotations
	this.getSprite().ResetTransform();
}

void onDetach(CBlob@ this, CBlob@ detached, AttachmentPoint@ attachedPoint)
{
	// double check static, if static set to false
	CShape@ shape = this.getShape();
	if(!shape.isStatic()) return;

	shape.SetStatic(false);
}

void onThisAddToInventory( CBlob@ this, CBlob@ inventoryBlob )
{
	this.doTickScripts = true;
}

void onCommand(CBlob@ this, u8 cmd, CBitStream @params)
{
	if(cmd != this.getCommandID("activate")) return;

	// set countdown timer
	this.set_u32("timer", getGameTime() + fuse);

	// set tag to start ticking
	this.Tag("exploding");

	// set tag to allow sticking to terrain
	this.Tag("spiky");

	// turn light on
	this.SetLight(true);

	CSprite@ sprite = this.getSprite();
	if(sprite is null) return;

	// set animation and un-pause emit sound, play spikes out
	sprite.SetAnimation("lit");
	sprite.SetEmitSoundPaused(false);
	sprite.PlaySound("SpikesOut.ogg");
}

void onDie(CBlob@ this)
{
	this.getSprite().Gib();
}

bool doesCollideWithBlob(CBlob@ this, CBlob@ blob)
{
	return blob.getShape().isStatic() && blob.isCollidable();
}