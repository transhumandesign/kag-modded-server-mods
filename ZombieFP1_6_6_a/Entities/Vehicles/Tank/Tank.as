#include "VehicleCommon.as"

// Tank logic 

void onInit( CBlob@ this )
{		
	Vehicle_Setup( this,
				   30.0f, // move speed
				   0.31f,  // turn speed
				   Vec2f(0.0f, 0.0f), // jump out velocity
				   false  // inventory access
				 );
	VehicleInfo@ v;
	if (!this.get( "VehicleInfo", @v )) {
		return;
	}

	Vehicle_SetupGroundSound( this, v, "WoodenWheelsRolling", // movement sound
							  1.0f, // movement sound volume modifier   0.0f = no manipulation
							  1.0f // movement sound pitch modifier     0.0f = no manipulation
							);
	Vehicle_addWheel( this, v, "WoodenWheels.png", 16, 16, 1, Vec2f(-22.0f,4.0f) );
	Vehicle_addWheel( this, v, "WoodenWheels.png", 16, 16, 0, Vec2f(-15.0f,10.0f) );
	Vehicle_addWheel( this, v, "WoodenWheels.png", 16, 16, 0, Vec2f(-5.0f,10.0f) );
	Vehicle_addWheel( this, v, "WoodenWheels.png", 16, 16, 0, Vec2f(5.0f,10.0f) );
	Vehicle_addWheel( this, v, "WoodenWheels.png", 16, 16, 0, Vec2f(15.0f,10.0f) );
	Vehicle_addWheel( this, v, "WoodenWheels.png", 16, 16, 1, Vec2f(22.0f,4.0f) );
	
	this.getSprite().SetZ(-50.0f);
	this.getShape().SetOffset(Vec2f(0,6));

	Vec2f massCenter(0, 8);
	this.getShape().SetCenterOfMassOffset(massCenter);
	this.set_Vec2f("mass center", massCenter);
	
	// converting
	this.Tag("convert on sit");

	this.set_f32("map dmg modifier", 0.0f);

	{
		Vec2f[] shape = { Vec2f(  2,  8 ),
						  Vec2f(  4, -6 ),
						  Vec2f( 22, -6 ),
						  Vec2f( 26,  8 ) };
		this.getShape().AddShape( shape );
	}

	//set custom minimap icon
	this.SetMinimapOutsideBehaviour(CBlob::minimap_snap);
	this.SetMinimapVars("GUI/MiniIcons.png", 11, Vec2f(16, 16));
	this.SetMinimapRenderAlways(true);	
	
	this.addCommandID("attach vehicle");
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

		// load new item if present in inventory
		Vehicle_StandardControls( this, v );
	}
	else if(time % 30 == 0)
	{
		VehicleInfo@ v;
		if (!this.get( "VehicleInfo", @v )) {
			return;
		}
		Vehicle_StandardControls( this, v ); //just make sure it's updated
	}
}

bool Vehicle_canFire( CBlob@ this, VehicleInfo@ v, bool isActionPressed, bool wasActionPressed, u8 &out chargeValue )
{
	return false;
}

void Vehicle_onFire( CBlob@ this, VehicleInfo@ v, CBlob@ bullet, const u8 _charge ) {}

void onCommand( CBlob@ this, u8 cmd, CBitStream @params )
{
	if (cmd == this.getCommandID("attach vehicle"))
	{
		CBlob@ vehicle = getBlobByNetworkID( params.read_netid() );
		if (vehicle !is null)
		{
			vehicle.server_AttachTo( this, "VEHICLE" );
		}
	}
}

bool doesCollideWithBlob( CBlob@ this, CBlob@ blob )
{
	return Vehicle_doesCollideWithBlob_boat( this, blob );
}

void onHealthChange( CBlob@ this, f32 oldHealth )
{
	const f32 threshold = this.getInitialHealth() * 0.25f;	
	
	if (this.getHealth() < threshold && oldHealth >= threshold)
	{	
		CSpriteLayer@ wheel = this.getSprite().getSpriteLayer("!w 2");
		if (wheel !is null)
			wheel.SetVisible( false );

		makeGibParticle( "Entities/Vehicles/Common/WoodenWheels.png", 
			this.getPosition()+wheel.getOffset(), this.getVelocity() + getRandomVelocity( 90, 5, 80 ), 
			0, 0, Vec2f (16,16), 2.0f, 20, "/material_drop", 0 );

	}
}

void onCollision( CBlob@ this, CBlob@ blob, bool solid )
{
	if (blob !is null) {
		TryToAttachVehicle( this, blob );
	}
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

void onDie(CBlob@ this)
{
	if (this.exists("bowid"))
	{
		CBlob@ bow = getBlobByNetworkID(this.get_u16("bowid"));
		if (bow !is null)
		{
			bow.server_Die();
		}
	}
}
