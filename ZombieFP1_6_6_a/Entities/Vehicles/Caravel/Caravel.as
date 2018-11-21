#include "VehicleCom.as"				
#include "ClassSelectMenu.as";
#include "StandardRespawnCommand.as";
//#include "Requirements_Tech.as";

// Boat logic

const int sail_index = 0;
void onInit(CBlob@ this )
{
	Vehicle_Setup( this,
                   700.0f, // move speed
                   0.47f,  // turn speed
                   Vec2f(0.0f, -5.0f), // jump out velocity
                   true  // inventory access
                 );
	VehicleInfo@ v;
	if (!this.get( "VehicleInfo", @v )) {
		return;
	}
    Vehicle_SetupWaterSound( this, v, "BoatRowing", // movement sound
                             0.0f, // movement sound volume modifier   0.0f = no manipulation
                             0.0f // movement sound pitch modifier     0.0f = no manipulation
                           );
    
	Vec2f pos_off(0,0);
	this.set_f32("map dmg modifier", 100.0f);
	
	//block knight sword
	this.Tag("blocks sword");
                           
    this.getShape().SetOffset(Vec2f(-6,16));  
    this.getShape().getConsts().bullet = false;
	this.getShape().getConsts().transports = true;

	
    AttachmentPoint@[] aps;
    if (this.getAttachmentPoints( @aps ))
    {
        for (uint i = 0; i < aps.length; i++)
        {
            AttachmentPoint@ ap = aps[i];
            ap.offsetZ = 10.0f;
		}
	}

	this.Tag("respawn");

	InitRespawnCommand( this );
	InitClasses( this );
	this.Tag("change class store inventory");
    
	// additional shapes

	//poop deck front
	{
		Vec2f[] shape = { Vec2f( 112.0f,  22.01f ) -pos_off,
						  Vec2f( 143.0f,  22.01f ) -pos_off,
						  Vec2f( 143.0f,  22.1f ) -pos_off,
						  Vec2f( 112.0f,  22.1f ) -pos_off };
		this.getShape().AddShape( shape );
	}

	//poop deck rear
	{
		Vec2f[] shape = { Vec2f( 90.0f,  22.01f ) -pos_off,
						  Vec2f( 67.0f,  22.01f ) -pos_off,
						  Vec2f( 67.0f,  22.1f ) -pos_off,
						  Vec2f( 90.0f,  22.1f ) -pos_off };
		this.getShape().AddShape( shape );
	}
	
	//back wall
	{
		Vec2f[] shape = { Vec2f( 3.0f,  1.0f ) -pos_off,
						  Vec2f( 1.0f,  1.0f ) -pos_off,
						  Vec2f( 1.0f,  20.0f ) -pos_off,
						  Vec2f( 3.0f,  20.0f ) -pos_off };
		this.getShape().AddShape( shape );
	}
	
	//back bit
	{
		Vec2f[] shape = { Vec2f( 3.0f, 22.01f ) -pos_off,
						  Vec2f( 50.0f, 22.01f ) -pos_off,
						  Vec2f( 50.0f, 22.1f ) -pos_off,
						  Vec2f( 3.0f, 22.1f ) -pos_off };
		this.getShape().AddShape( shape );
	}
	
	//roof back bit
	{
		Vec2f[] shape = { Vec2f( 0.0f,  0.0f ) -pos_off,
						  Vec2f( 35.0f, 0.0f ) -pos_off,
						  Vec2f( 35.0f, 0.5f ) -pos_off,
						  Vec2f( 0.0f, 0.5f ) -pos_off };
		this.getShape().AddShape( shape );
	}
	
	//Back o boat
	{
		Vec2f[] shape = { Vec2f( 38.0f,  52.0f ) -pos_off,
						  Vec2f( 38.0f, 53.0f ) -pos_off,
						  Vec2f( 13.0f, 29.0f ) -pos_off,
						  Vec2f( 13.0f, 30.0f ) -pos_off };
		this.getShape().AddShape( shape );
	}
	
	//front o boat
	{
		Vec2f[] shape = { Vec2f( 140.0f,  52.0f ) -pos_off,
						  Vec2f( 170.0f, 22.1f ) -pos_off,
						  Vec2f( 140.0f, 22.1f ) -pos_off,
						  Vec2f( 139.0f, 52.0f ) -pos_off };
		this.getShape().AddShape( shape );
	}
	
	CSprite@ sprite = this.getSprite();
	CSpriteLayer@ front = sprite.addSpriteLayer( "front layer", sprite.getConsts().filename, 180 , 55 );
	if (front !is null)
	{
		front.addAnimation("default",0,false);
		int[] frames = { 0 };
		front.animation.AddFrames(frames);
		front.SetRelativeZ(55.0f);
		front.SetOffset(Vec2f(10,0));
	}
	this.set_bool("has mast", true);
	
	const Vec2f mastOffset(2,-3);
		
	CSpriteLayer@ mast = this.getSprite().addSpriteLayer( "mast", 200, 120 );	  
	if (mast !is null)
	{
		Animation@ anim = mast.addAnimation( "default", 1, false );
		int[] frames = {1};
		anim.AddFrames( frames );
		mast.SetOffset( Vec2f(1,-40) + mastOffset );
		mast.SetRelativeZ(0.0f);
	}
	
	if (this.get_bool("has mast"))		// client-side join - might be false
	{
		// add sail
								 
		CSpriteLayer@ sail = this.getSprite().addSpriteLayer( "sail "+sail_index, 200, 133 );	  
		if (sail !is null)
		{
			Animation@ anim = sail.addAnimation( "default", 3, false );
			int[] frames = {2,5,8};
			anim.AddFrames( frames );
			sail.SetOffset( Vec2f(-3,-64) + mastOffset );
			sail.SetRelativeZ(56.0f);
			
			sail.SetVisible(false);
		}
	}
	else
	{
		if (mast !is null)
		{
			mast.animation.frame = 1;
		}
	}
	
	this.set_f32("oar offset", 54.0f);

	// add pole ladder
	getMap().server_AddMovingSector( Vec2f( -100.0f, -32.0f), Vec2f(-83.0f, 20.0f), "ladder", this.getNetworkID() );
	// add back ladder
	//getMap().server_AddMovingSector( Vec2f( -50.0f, 0.0f), Vec2f(-35.0f, 20.0f), "ladder", this.getNetworkID() );
	
	//set custom minimap icon
	this.SetMinimapOutsideBehaviour(CBlob::minimap_snap);
	this.SetMinimapVars("GUI/MiniIcons.png", 18, Vec2f(16,16));
	this.SetMinimapRenderAlways(true);

	// mounted bow
	if (getNet().isServer())// && hasTech( this, "mounted bow"))
	{
		CBlob@ bow = server_CreateBlob( "mounted_cannon" );	
		if (bow !is null)
		{
			bow.server_setTeamNum(this.getTeamNum());
			this.server_AttachTo( bow, "BOWA" );
			this.set_u16("bowid",bow.getNetworkID());
		}
	}
	
	// mounted bow
	if (getNet().isServer())// && hasTech( this, "mounted bow"))
	{
		CBlob@ bow = server_CreateBlob( "mounted_cannon" );	
		if (bow !is null)
		{
			bow.server_setTeamNum(this.getTeamNum());
			this.server_AttachTo( bow, "BOWB" );
			this.set_u16("bowid",bow.getNetworkID());
		}
	}
	
	// mounted bow
	if (getNet().isServer())// && hasTech( this, "mounted bow"))
	{
		CBlob@ bow = server_CreateBlob( "mounted_crossbow" );	
		if (bow !is null)
		{
			bow.server_setTeamNum(this.getTeamNum());
			this.server_AttachTo( bow, "BOWC" );
			this.set_u16("bowid",bow.getNetworkID());
		}
	}
	
}

void onTick( CBlob@ this )
{
	const int time = this.getTickSinceCreated();
	if (this.hasAttached() || time < 30) //driver, seat or gunner, or just created
	{
		VehicleInfo@ v;
		if (!this.get( "VehicleInfo", @v )) {
			return;
		}
		Vehicle_StandardControls( this, v );		
	}

	if (time % 12 == 0) {
		Vehicle_DontRotateInWater( this );
	}
}

void Vehicle_onFire( CBlob@ this, VehicleInfo@ v, CBlob@ bullet, const u8 charge ) {}
bool Vehicle_canFire( CBlob@ this, VehicleInfo@ v, bool isActionPressed, bool wasActionPressed, u8 &out chargeValue ) {return false;}

bool doesCollideWithBlob( CBlob@ this, CBlob@ blob )
{
	if (blob.getShape().getConsts().platform)
		return false;
	return Vehicle_doesCollideWithBlob_boat( this, blob );
}			 

void onHealthChange( CBlob@ this, f32 oldHealth )
{
	const f32 tier1 = this.getInitialHealth() * 0.6f;				 
	const f32 health = this.getHealth();
	
	if (health < tier1 && oldHealth >= tier1)
	{	
		this.set_bool("has mast", false);
		this.Tag("no sail");

		CSprite@ sprite = this.getSprite();

		CSpriteLayer@ mast = sprite.getSpriteLayer("mast");
		if (mast !is null)
			mast.animation.frame = 1;

		CSpriteLayer@ sail = sprite.getSpriteLayer("sail "+sail_index);
		if (sail !is null)
			sail.SetVisible( false );
	}
}

bool canBePickedUp( CBlob@ this, CBlob@ byBlob )
{
	return false;
}

void onTick( CSprite@ this )
{
	this.SetZ(-50.0f);
	CBlob@ blob = this.getBlob();
	this.animation.setFrameFromRatio(1.0f - (blob.getHealth()/blob.getInitialHealth()));
}

void onAttach( CBlob@ this, CBlob@ attached, AttachmentPoint @attachedPoint )
{
	VehicleInfo@ v;
	if (!this.get( "VehicleInfo", @v )) {
		return;
	}
	Vehicle_onAttach( this, v, attached, attachedPoint );
}

void onDetach( CBlob@ this, CBlob@ detached, AttachmentPoint@ attachedPoint )
{
	VehicleInfo@ v;
	if (!this.get( "VehicleInfo", @v )) {
		return;
	}
	Vehicle_onDetach( this, v, detached, attachedPoint );
}


void GetButtonsFor( CBlob@ this, CBlob@ caller )
{
	if (caller.getTeamNum() == this.getTeamNum())
	{
		CBitStream params;
		params.write_u16( caller.getNetworkID() );
		CButton@ button = caller.CreateGenericButton( "$change_class$", Vec2f(26,8), this, SpawnCmd::buildMenu, "Change class", params);
	}
}

void onCommand( CBlob@ this, u8 cmd, CBitStream @params )
{
	onRespawnCommand( this, cmd, params );
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
}
