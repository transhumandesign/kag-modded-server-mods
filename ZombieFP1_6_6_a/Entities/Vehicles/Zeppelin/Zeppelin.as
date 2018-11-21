#include "VehicleCommon2.as"

// Zeppelin logic

void onInit(CBlob@ this )
{
	Vehicle_Setup( this,
                   75.0f, // move speed
                   0.50f,  // turn speed
                   Vec2f(0.0f, -10.0f), // jump out velocity
                   true  // inventory access
                 );
	VehicleInfo@ v;
	if (!this.get( "VehicleInfo", @v )) {
		return;
	}
	Vehicle_SetupAirship( this, v, -900.0f );
    
	Vec2f pos_off(0,0);
	this.set_f32("map dmg modifier", 35.0f);
                           
    this.getShape().SetOffset(Vec2f(-6,16));  
    this.getShape().getConsts().bullet = true;
	this.getShape().getConsts().transports = true;

	// additional shapes


	//front bits
	{
		Vec2f[] shape = { Vec2f( 69.0f,  25.0f ) -pos_off,
						  Vec2f( 93.0f,  25.0f ) -pos_off,
						  Vec2f( 79.0f,  43.0f ) -pos_off,
						  Vec2f( 69.0f,  43.0f ) -pos_off };
		this.getShape().AddShape( shape );
	}
	
	//back bit
	{
		Vec2f[] shape = { Vec2f( 8.0f,  28.5f ) -pos_off,
						  Vec2f( 18.0f, 28.5f ) -pos_off,
						  Vec2f( 18.0f, 43.0f ) -pos_off,
						  Vec2f( 11.0f, 43.0f ) -pos_off };
		this.getShape().AddShape( shape );
	}

	//back side
	{
		Vec2f[] shape = { Vec2f( 4.0f,  25.0f ) -pos_off,
						  Vec2f( 8.0f, 25.0f ) -pos_off,
						  Vec2f( 6.0f, 28.5f ) -pos_off,
						  Vec2f( 8.0f, 28.5f ) -pos_off };
		this.getShape().AddShape( shape );
	}
	
	CSprite@ sprite = this.getSprite();
	
	CSpriteLayer@ balloon = sprite.addSpriteLayer( "balloon", "Zeppelin.png", 160, 70 );
	if (balloon !is null)
	{
		balloon.addAnimation("default",0,false);
		int[] frames = { 1, 3 };
		balloon.animation.AddFrames(frames);
		balloon.SetRelativeZ(20.0f);
		balloon.SetOffset( Vec2f(14.0f, -43.0f) );
	}

	CSpriteLayer@ front = sprite.addSpriteLayer( "front layer", sprite.getConsts().filename, 96, 56 );
	if (front !is null)
	{
		front.addAnimation("default",0,false);
		int[] frames = { 0, 6, 12 };
		front.animation.AddFrames(frames);
		front.SetRelativeZ(55.0f);
	}

	//set custom minimap icon
	this.SetMinimapOutsideBehaviour(CBlob::minimap_snap);
	this.SetMinimapVars("GUI/MiniIcons.png", 19, Vec2f(16,16));
	this.SetMinimapRenderAlways(true);	
	
	if (getNet().isServer())// && hasTech( this, "mounted bow"))
	{
		CBlob@ bow = server_CreateBlob( "mounted_cannon" );	
		if (bow !is null)
		{
			bow.server_setTeamNum(this.getTeamNum());
			this.server_AttachTo( bow, "BOW" );
			this.set_u16("bowid",bow.getNetworkID());
		}
	}
	if (getNet().isServer())// && hasTech( this, "mounted bow"))
	{
		CBlob@ bow = server_CreateBlob( "mounted_crossbow" );	
		if (bow !is null)
		{
			bow.server_setTeamNum(this.getTeamNum());
			this.server_AttachTo( bow, "BOW2" );
			this.set_u16("bowid2",bow.getNetworkID());
		}
	}
	this.getShape().SetRotationsAllowed(false);
	{
	}
}

void onTick( CBlob@ this )
{
	if (this.hasAttached() || this.getTickSinceCreated() < 30) //driver, seat or gunner, or just created
	{
		VehicleInfo@ v;
		if (!this.get( "VehicleInfo", @v )) {
			return;
		}

		Vehicle_StandardControls( this, v );
	}
}

void Vehicle_onFire( CBlob@ this, VehicleInfo@ v, CBlob@ bullet, const u8 charge ) {}
bool Vehicle_canFire( CBlob@ this, VehicleInfo@ v, bool isActionPressed, bool wasActionPressed, u8 &out chargeValue ) {return false;}

bool doesCollideWithBlob( CBlob@ this, CBlob@ blob )
{
	return Vehicle_doesCollideWithBlob_boat( this, blob );
}			 

bool canBePickedUp( CBlob@ this, CBlob@ byBlob )
{
	return false;
}

// SPRITE

void onInit( CSprite@ this )
{
}

void onTick( CSprite@ this )
{
	this.SetZ(-50.0f);
	CBlob@ blob = this.getBlob();
	f32 ratio = 1.0f - (blob.getHealth()/blob.getInitialHealth());
	this.animation.setFrameFromRatio(1.0f - (blob.getHealth()/blob.getInitialHealth()));		// OPT: in warboat too

	CSpriteLayer@ balloon = this.getSpriteLayer( "balloon" );
	if (balloon !is null)
	{
		if(blob.getHealth() > 1.0f)
			balloon.animation.frame = Maths::Min((ratio)*3,1.0f);
		else
			balloon.animation.frame = 2;
	}
}

void onDie(CBlob@ this)
{
	if(this.exists("bowid"))
	{
		CBlob@ bow = getBlobByNetworkID(this.get_u16("bowid"));
		if(bow !is null)
		{
			bow.server_Die();
		}
	}
	if(this.exists("bowid2"))
	{
		CBlob@ bow = getBlobByNetworkID(this.get_u16("bowid2"));
		if(bow !is null)
		{
			bow.server_Die();
		}
	}
}