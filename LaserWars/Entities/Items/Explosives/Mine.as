// Mine.as

#include "CustomHitters.as";
#include "Hitters.as";
#include "Explosion.as";

const u8 PRIMING_TIME = 45;
const string PRIMING = "mine_priming";
const string TIMER = "mine_timer";
const string STATE = "mine_state";

enum State
{
	NONE = 0,
	PRIMED
};

void onInit(CBlob@ this)
{
	this.getShape().getVars().waterDragScale = 16.0f;

	this.set_f32("explosive_radius", 48.0f);
	this.set_f32("explosive_damage", 9.5f);
	this.set_f32("map_damage_radius", 48.0f);
	this.set_f32("map_damage_ratio", 0.5f);
	this.set_bool("map_damage_raycast", true);
	this.set_string("custom_explosion_sound", "Mine.ogg");
	this.set_u8("custom_hitter", Hitters::mine);

	this.Tag("ignore fall");

	this.Tag(PRIMING);
	this.set_u8(STATE, NONE);
	this.set_u32(TIMER, getGameTime() + PRIMING_TIME);

	this.getShape().getConsts().collideWhenAttached = true;

	this.getCurrentScript().tickIfTag = PRIMING;
}

void onTick(CBlob@ this)
{
	if(getGameTime() < this.get_u32(TIMER) || !this.hasTag(PRIMING)) return;

	this.Untag(PRIMING);
	this.set_u8(STATE, PRIMED);
	this.getShape().checkCollisionsAgain = true;

	CSprite@ sprite = this.getSprite();
	if(sprite is null) return;

	sprite.SetAnimation("armed");
    sprite.PlaySound("Cloak", 1.0f, 1.2f);
    sprite.setRenderStyle(RenderStyle::light);
	//sprite.PlaySound("MineArmed.ogg");
}

void onAttach(CBlob@ this, CBlob@ attached, AttachmentPoint@ attachedPoint)
{
	this.Untag(PRIMING);
	this.set_u8(STATE, NONE);
	this.getSprite().SetAnimation("default");
    this.getSprite().setRenderStyle(RenderStyle::normal);
}

void onThisAddToInventory(CBlob@ this, CBlob@ inventoryBlob)
{
	this.Untag(PRIMING);
	this.set_u8(STATE, NONE);
	this.getSprite().SetAnimation("default");
    this.getSprite().setRenderStyle(RenderStyle::normal);
}

void onDetach(CBlob@ this, CBlob@ detached, AttachmentPoint@ attachedPoint)
{
	this.Tag(PRIMING);
	this.set_u32(TIMER, getGameTime() + PRIMING_TIME);
}

void onThisRemoveFromInventory(CBlob@ this, CBlob@ inventoryBlob)
{
	if(this.isAttached()) return;

	this.Tag(PRIMING);
	this.set_u32(TIMER, getGameTime() + PRIMING_TIME);
}

bool explodeOnCollideWithBlob(CBlob@ this, CBlob@ blob)
{
	return this.getTeamNum() != blob.getTeamNum() &&
	(blob.hasTag("flesh") || blob.hasTag("projectile") || blob.hasTag("vehicle"));
}

bool doesCollideWithBlob(CBlob@ this, CBlob@ blob)
{
	return blob.getShape().isStatic() && blob.isCollidable();
}

void onCollision(CBlob@ this, CBlob@ blob, bool solid)
{
	if(!getNet().isServer() || blob is null) return;

	if(this.get_u8(STATE) == PRIMED && explodeOnCollideWithBlob(this, blob))
	{
		Detonate(this);
	}
}

bool canBePickedUp(CBlob@ this, CBlob@ blob)
{
	return this.get_u8(STATE) != PRIMED || this.getTeamNum() == blob.getTeamNum();
}

f32 onHit(CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData)
{
	if (customData == Hitters::emp)
	{
		if (hitterBlob !is null)
		{
	        // emp + enemy mine = kills
			this.SetDamageOwnerPlayer(hitterBlob.getDamageOwnerPlayer());
			this.server_setTeamNum(hitterBlob.getTeamNum());
		}

		Detonate(this);
		return damage;
	}

	return customData == Hitters::builder ? this.getInitialHealth() / 2 : damage;
}

void Detonate(CBlob@ this)
{
	this.Tag("exploding");
	this.Sync("exploding", true);

	this.server_SetHealth(-1.0f);
	this.server_Die();
}
