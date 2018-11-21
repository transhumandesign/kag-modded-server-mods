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
	u32 blade_del = this.get_u32("blade delay");
	blade_del++;
	this.set_u32("blade delay",blade_del);
    if (this.isAttached())
    {
		this.getCurrentScript().runFlags &= ~(Script::tick_not_sleeping); 					   		
		AttachmentPoint@ point = this.getAttachments().getAttachmentPointByName("PICKUP");	   		
        CBlob@ holder = point.getOccupied();												   
        if (holder is null) { return; }
		if (!point.isKeyPressed(key_action1) || blade_del<30)
		{
			return;
		}

        if (getNet().isServer())
        {
            CBlob@ arrow = server_CreateBlobNoInit( "blade" );
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
		this.getSprite().PlaySound( "SawLog.ogg" );
		this.set_u32("blade delay",0);
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
	if(!this.isOverlapping(caller) || caller.getTeamNum() != this.getTeamNum()) return;

	string desc = "Turn Saw "+(getSawOn(this) ? "Off" : "On");
	caller.CreateGenericButton( 8, Vec2f(0,0), this, this.getCommandID(toggle_id), desc );
}

void onCommand( CBlob@ this, u8 cmd, CBitStream @params )
{
	if(cmd == this.getCommandID(sawteammate_id))
	{
		CBlob@ tobeblended = getBlobByNetworkID( params.read_netid() );
		if (tobeblended !is null)
		{
			tobeblended.Tag("sawed");

			CSprite@ s = tobeblended.getSprite();
			if (s !is null) {
				s.Gib();
			}
		}

		this.getSprite().PlaySound( "SawOther.ogg" );
		cmd = this.getCommandID(toggle_id);	// proceed with toggle_id stuff
	}

	if(cmd == this.getCommandID(toggle_id))
	{
		bool set = !getSawOn(this);
		SetSawOn(this, set);

		if(getNet().isClient()) //closed/opened gfx
		{
			CSprite@ sprite = this.getSprite();

			u8 frame = set ? 0 : 1;

			sprite.animation.frame = frame;

			CSpriteLayer@ back = sprite.getSpriteLayer( "back" );
			if (back !is null)
			{
				back.animation.frame = frame;
			}

			CSpriteLayer@ chop = sprite.getSpriteLayer( "chop" );
			if (chop !is null)
			{
				chop.SetOffset(Vec2f());
			}
		}
	}
}

//function for blending things
void Blend( CBlob@ this, CBlob@ tobeblended )
{
	if (this is tobeblended || tobeblended.hasTag("sawed") ||
		tobeblended.hasTag("invincible") || !getSawOn(this)) {
			return;
	}

	//make plankfrom wooden stuff
	if ( tobeblended.getName() == "log" )
	{
		CBlob @wood = server_CreateBlob( "mat_wood", this.getTeamNum(), this.getPosition() + Vec2f(0,12) );	
		if (wood !is null)
		{
			wood.server_SetQuantity( (tobeblended.getHealth() / 0.014f) + 1 );
			wood.setVelocity( Vec2f(0, -4.0f) );
		}

		this.getSprite().PlaySound( "SawLog.ogg" );
	}
	else {
		this.getSprite().PlaySound( "SawOther.ogg" );
	}

	tobeblended.Tag("sawed");

	// on saw player - disable the saw
	if (tobeblended.getPlayer() !is null && tobeblended.getTeamNum() == this.getTeamNum())
	{
		CBitStream params;
		params.write_netid(tobeblended.getNetworkID()); 
		this.SendCommand(this.getCommandID(sawteammate_id), params);
	}


	CSprite@ s = tobeblended.getSprite();
	if (s !is null) {
		s.Gib();
	}

	//give no fucks about teamkilling
	tobeblended.server_SetHealth(-1.0f);
	tobeblended.server_Die();

}


bool canSaw(CBlob@ this, CBlob@ blob)
{
	if(blob.hasTag("saw")) return true; //destroy saws in close proximity

	if (blob.getRadius() >= this.getRadius()*0.99f || blob.getShape().isStatic() ||
		blob.hasTag("sawed") || blob.hasTag("invincible")) {
			return false;
	}

	string name = blob.getName();
	// no team sawing
	if (blob.getPlayer() !is null && blob.getTeamNum() == this.getTeamNum())
		return false;

	if (
		name == "migrant" ||
		name == "wooden_door" ||
		name == "mat_wood" ||
		name == "tree_bushy" ||
		name == "tree_pine" )
	{
		return false;
	}

	//flesh blobs have to be fed into the saw part
	if (blob.hasTag("flesh"))
	{
		Vec2f pos = this.getPosition();
		Vec2f bpos = blob.getPosition();

		Vec2f off = (bpos - pos);
		f32 len = off.Normalize();

		f32 dot = off * (Vec2f(0,-1).RotateBy(this.getAngleDegrees(), Vec2f()));	

		if(dot > 0.8f)
		{
			if(getNet().isClient() && !g_kidssafe) //add blood gfx
			{
				CSprite@ sprite = this.getSprite();
				CSpriteLayer@ chop = sprite.getSpriteLayer( "chop" );

				if (chop !is null)
				{
					chop.animation.frame = 1;
				}
			}

			return true;
		}
		else
		{
			return false;
		}
	}

	return true;
}

void onHitBlob( CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitBlob, u8 customData )
{
	if (hitBlob !is null)
	{
		Blend( this, hitBlob );
	}
}

//we have contact!
void onCollision( CBlob@ this, CBlob@ blob, bool solid )
{
	if ( blob is null || !getNet().isServer() ||
		this.isAttached() || blob.isAttached() ||
		!getSawOn(this) )
	{
		return;
	}

	if(canSaw(this,blob))
	{
		Vec2f pos = this.getPosition();
		Vec2f bpos = blob.getPosition();
		this.Tag("sawed");
		this.server_Hit( blob, bpos, bpos - pos, 0.0f, Hitters::saw );
	}
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
	this.SetZ(-10.0f);

	CSpriteLayer@ chop = this.addSpriteLayer( "chop", "/MegaSaw.png", 16, 16 );

	if (chop !is null)
	{
		Animation@ anim = chop.addAnimation( "default", 0, false );
		anim.AddFrame(3);
		anim.AddFrame(7);
		chop.SetAnimation( anim );
		chop.SetRelativeZ(-1.0f);
	}

	CSpriteLayer@ back = this.addSpriteLayer( "back", "/MegaSaw.png", 24, 16 );

	if (back !is null)
	{
		Animation@ anim = back.addAnimation( "default", 0, false );
		anim.AddFrame(1);
		anim.AddFrame(3);
		back.SetAnimation( anim );
		back.SetRelativeZ(-5.0f);
	}

	this.getBlob().getShape().SetRotationsAllowed(false);
}

void onTick( CSprite@ this )
{
	CBlob@ blob = this.getBlob();
	if(blob is null) return;

	this.SetZ(blob.isAttached()?10.0f:-10.0f);
	
	//spin saw blade
	CSpriteLayer@ chop = this.getSpriteLayer( "chop" );

	if (chop !is null && getSawOn(blob))
	{
		chop.SetFacingLeft(false);

		Vec2f around(0.5f,-0.5f);
		chop.RotateBy(30.0f,around);
	}
}

void onAttach( CBlob@ this, CBlob@ attached, AttachmentPoint @attachedPoint )
{
	this.getCurrentScript().runFlags &= ~Script::tick_not_sleeping;
	this.SetDamageOwnerPlayer( attached.getPlayer() );
}
