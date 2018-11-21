// Ladder

void onInit( CBlob@ this )
{
    this.getShape().SetRotationsAllowed( false );
    this.getShape().getVars().waterDragScale = 10.0f;

    //no climbing held ladders (too many bugs)
	this.getShape().getConsts().collideWhenAttached = false;

    //this.Tag("place45"); // player holding this will place it using a special positioning script

    this.Tag("ignore blocking actors");

	CSprite @sprite = this.getSprite();
	sprite.SetZ(-50.0f);

	this.getShape().getConsts().waterPasses = true;
	this.getShape().getConsts().tileLightSource = true;

	this.getCurrentScript().runFlags |= Script::tick_not_attached;
	
	this.SetFacingLeft( (this.getNetworkID() * 31) % 2 == 1 ); //for ladders on map
}

void onTick(CBlob@ this)
{
	this.getSprite().SetZ(-50.0f);
	this.getCurrentScript().tickFrequency = 0;
}

#include "Hitters.as"
f32 onHit( CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData )
{
	if(customData == Hitters::builder)
	{
		return 0.5f;
	}
	
	return damage;
}


bool canBePickedUp( CBlob@ this, CBlob@ byBlob )
{
    return false;
}
