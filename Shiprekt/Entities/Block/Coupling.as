#include "BlockCommon.as";

void onInit( CBlob@ this )
{
    this.addCommandID("decouple");
    this.Tag("coupling");
}

void GetButtonsFor( CBlob@ this, CBlob@ caller )
{   
	int mycolour = this.getShape().getVars().customData;
	if(mycolour <= 0)
        return;

    if( this.getDistanceTo(caller) > Block::BUTTON_RADIUS_FLOOR )
    {
    	//wanted to allow decoupling when in a seat but bad luck
    	return;
    }

    CButton@ b = caller.CreateGenericButton( 1, Vec2f(0.0f, 0.0f), this, this.getCommandID("decouple"), "Decouple" );
}

void onCommand( CBlob@ this, u8 cmd, CBitStream @params )
{
    if (cmd == this.getCommandID("decouple"))
    {
        this.server_Die();
    }
}