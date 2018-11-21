// Saw logic

#include "Hitters.as"

const string toggle_id = "toggle_power";
const string sawteammate_id = "sawteammate";

void onInit( CBlob@ this )
{

    AttachmentPoint@ ap = this.getAttachments().getAttachmentPointByName("PICKUP");

    if (ap !is null)
    {
        ap.SetKeysToTake( key_action1 | key_action2 | key_action3 );
    }
	
	this.Tag("saw");

	this.addCommandID(toggle_id);
	this.addCommandID(sawteammate_id);
	//this.setTeamNum(0);
	SetSawOn(this, true);
	
    this.Tag("place45");
    this.set_s8("place45 distance", 1);
	this.Tag("place45 perp");
	
}

//toggling on/off

void onTick( CBlob@ this )
{
	u32 rpg_del = this.get_u32("rpg delay");
	rpg_del++;
	this.set_u32("rpg delay",rpg_del);
    if (this.isAttached())
    {
		this.getCurrentScript().runFlags &= ~(Script::tick_not_sleeping); 					   		
		AttachmentPoint@ point = this.getAttachments().getAttachmentPointByName("PICKUP");	   		
        CBlob@ holder = point.getOccupied();												   
        if (holder is null) { return; }
		if (!point.isKeyPressed(key_action1) || rpg_del<30)
		{
			return;
		}

        if (getNet().isServer())
        {
            CBlob@ arrow = server_CreateBlobNoInit( "rpg" );
            if (arrow !is null)
            {
				// fire arrow?
				Vec2f arrowPos = holder.getPosition() ;
				Vec2f arrowVel = holder.getAimPos() - arrowPos;
				arrowVel.Normalize();
				arrowVel*=15;
				arrow.set_u8("arrow type", 0 );
				arrow.Init();

				arrow.IgnoreCollisionWhileOverlapped( this );
                arrow.SetDamageOwnerPlayer( this.getPlayer() );
				arrow.server_setTeamNum( this.getTeamNum() );
				arrow.setPosition( arrowPos );
                arrow.setVelocity( arrowVel );
				arrow.set_Vec2f("initvel",arrowVel);
				
				
            }
        }
		this.getSprite().PlaySound( "catapult_destroy" );
		this.set_u32("rpg delay",0);
	}

}
 
void SetSawOn(CBlob@ this, const bool on)
{
	this.set_bool("saw_on", on);
}

bool getSawOn(CBlob@ this)
{
	return this.get_bool("saw_on");
}

void GetButtonsFor( CBlob@ this, CBlob@ caller )
{
}

void onCommand( CBlob@ this, u8 cmd, CBitStream @params )
{
}

//function for blending things
void Blend( CBlob@ this, CBlob@ tobeblended )
{

}


bool canSaw(CBlob@ this, CBlob@ blob)
{
	return false;
}

void onHitBlob( CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitBlob, u8 customData )
{
}

//we have contact!
void onCollision( CBlob@ this, CBlob@ blob, bool solid )
{
}

//only pickable by enemies if they are _under_ this
bool canBePickedUp( CBlob@ this, CBlob@ byBlob )
{
	return true; //(byBlob.getTeamNum() == this.getTeamNum() ||
		//byBlob.getPosition().y > this.getPosition().y + 4);
}


//sprite update
void onInit( CSprite@ this )
{
	this.getBlob().getShape().SetRotationsAllowed(false);
}

void onTick( CSprite@ this )
{
	CBlob@ blob = this.getBlob();
	if(blob is null) return;

	this.SetZ(blob.isAttached()?10.0f:-10.0f);
}

void onAttach( CBlob@ this, CBlob@ attached, AttachmentPoint @attachedPoint )
{
	this.getCurrentScript().runFlags &= ~Script::tick_not_sleeping;
	//this.SetDamageOwnerPlayer( attached.getPlayer() );
}
