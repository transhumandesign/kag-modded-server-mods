#include "BlockCommon.as"

void onInit( CBlob@ this )
{
	this.set_string("seat label", "");
	this.set_u8("seat icon", 0);

	this.addCommandID("get in seat");
	this.Tag("seat");
}

void GetButtonsFor( CBlob@ this, CBlob@ caller )
{	
	if(this.getDistanceTo(caller) > Block::BUTTON_RADIUS_FLOOR 
		|| this.getShape().getVars().customData <= 0
		|| this.hasAttached())
		return;

	CBitStream params;
	params.write_u16( caller.getNetworkID() );
	CButton@ button = caller.CreateGenericButton( this.get_u8("seat icon"), Vec2f(0.0f, 0.0f), this, this.getCommandID("get in seat"), this.get_string("seat label"), params );
}

void onCommand( CBlob@ this, u8 cmd, CBitStream @params )
{
    if (cmd == this.getCommandID("get in seat"))
    {
		CBlob@ caller = getBlobByNetworkID( params.read_netid() );
		if (caller !is null)
		{
			this.server_AttachTo( caller, "SEAT" );
		}
    }
}

void onAttach( CBlob@ this, CBlob@ attached, AttachmentPoint @attachedPoint )
{  
	this.getSprite().PlaySound("GetInVehicle.ogg");
}

void onDetach( CBlob@ this, CBlob@ detached, AttachmentPoint @attachedPoint )
{  
	this.getSprite().PlaySound("GetInVehicle.ogg");
	this.getShape().getVars().onground = true;
}