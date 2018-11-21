
//script for a bunny

#include "AnimalConsts.as";

const u8 DEFAULT_PERSONALITY = SCARED_BIT;

//sprite

void onInit(CSprite@ this)
{
    this.ReloadSprites(0,0);
}

void onTick(CSprite@ this)
{
	CBlob@ blob = this.getBlob();
    
    if (!blob.hasTag("dead"))
    {
		f32 x = blob.getVelocity().x;
		if (Maths::Abs(x) > 0.2f)
		{
			this.SetAnimation("walk");
		}
		else
		{
			this.SetAnimation("idle");
		}
	}
	else
	{
		this.SetAnimation("dead");
		this.getCurrentScript().runFlags |= Script::remove_after_this;
	}
}

//blob

void onInit(CBlob@ this)
{
	//brain
	this.set_u8(personality_property, DEFAULT_PERSONALITY);
	this.set_u8("random move freq",12);
	this.set_f32(target_searchrad_property, 60.0f);
	this.set_f32(terr_rad_property, 85.0f);
	this.set_u8(target_lose_random,34);
	
	this.getBrain().server_SetActive( true );
	
	//for shape
	this.getShape().SetRotationsAllowed(false);
}

bool canBePickedUp( CBlob@ this, CBlob@ byBlob )
{
    return true;
}

void onTick(CBlob@ this)
{
	f32 x = this.getVelocity().x;
	
	if (Maths::Abs(x) > 1.0f)
	{
		this.SetFacingLeft( x < 0 );
	}
	else
	{
		if (this.isKeyPressed(key_left)) {
			this.SetFacingLeft( true );
		}
		if (this.isKeyPressed(key_right)) {
			this.SetFacingLeft( false );
		}
	}
}

f32 onHit( CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData )
{
    this.Tag("dead"); 
    this.AddScript( "Eatable.as" );
    return damage;
}

bool doesCollideWithBlob( CBlob@ this, CBlob@ blob )
{
	if (blob.hasTag("dead") || blob.hasTag("player"))
		return false;
	return true;
}