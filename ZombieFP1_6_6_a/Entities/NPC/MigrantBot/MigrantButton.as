#include "MigrantCommon"


void onInit( CBlob@ this )
{			 
    this.addCommandID("migrant_stop");
	this.addCommandID("migrant_start");
	//this.addCommandID("stock");
    AddIconToken( "$migrant_standground$", "Orders.png", Vec2f(32,32), 2 );
	AddIconToken( "$migrant_continue$", "Orders.png", Vec2f(32,32), 4 );
	
	this.getCurrentScript().tickFrequency = 31;
	
}

void onTick( CBlob@ this )
{

}

void GetButtonsFor( CBlob@ this, CBlob@ caller )
{
	/*
	if (!this.hasTag("dead"))
	{
		CBitStream params;
		params.write_u16(caller.getNetworkID());
		caller.CreateGenericButton( "$command_migrant$", Vec2f(0,-8), this, this.getCommandID("stock"), "Shop", params );
	}
	*/
	if (this.hasTag("dead"))
		return;
	u8 strategy = this.get_u8("strategy");
	printf("strategy = "+strategy);
	CBitStream params;
	const string name = this.getName();
	if (strategy != Strategy::idle && strategy != Strategy::runaway)
	{
		strategy = Strategy::idle;
		printf("strategy idle = "+strategy);
		//params.write_u16( this.getNetworkID() );
		params.write_u8( strategy );
		caller.CreateGenericButton( "$migrant_standground$", Vec2f(0,-16), this,  this.getCommandID("migrant_stop"), "Tell migrant to stop", params );
	}
	else
	{
		strategy = Strategy::find_teammate;
		printf("strategy Teammate = "+strategy);
		//params.write_u16( this.getNetworkID() );
		params.write_u8( strategy );
		caller.CreateGenericButton( "$migrant_continue$", Vec2f(0,-16), this,  this.getCommandID("migrant_start"), "Tell migrant to follow and or go to Dorm", params );
	}
	
}


void onCommand( CBlob@ this, u8 cmd, CBitStream @params )
{		
	u8 strategy = 0;
	//printf("Command started!");
    if (cmd == this.getCommandID("migrant_stop"))
    {	
    	strategy = params.read_u8();
    	this.set_u8("strategy", strategy);
    	//printf("strategy stop_migrant = "+strategy);	
    }
    else if (cmd == this.getCommandID("migrant_start"))
    {
    	strategy = params.read_u8();
    	this.set_u8("strategy", strategy);	
    	//printf("strategy start_migrant = "+strategy);	
    }
}
