#include "BlockCommon.as"
#include "HumanCommon.as"
#include "ExplosionEffects.as";

void onInit( CBlob@ this )
{
	this.Tag("mothership");
	this.addCommandID("click take");
}

void GetButtonsFor( CBlob@ this, CBlob@ caller )
{	
	if(this.getDistanceTo(caller) > Block::BUTTON_RADIUS_SOLID
	  || Human::isHoldingBlocks(caller)
	  || this.getShape().getVars().customData <= 0
	  || caller.getTeamNum() != this.getTeamNum())
		return;

	CBitStream params;
	params.write_u16( caller.getNetworkID() );
	CButton@ button = caller.CreateGenericButton( 8, Vec2f(0.0f, 0.0f), this, this.getCommandID("click take"), "Take block", params );
}

void onCommand( CBlob@ this, u8 cmd, CBitStream @params )
{
    if (cmd == this.getCommandID("click take") && getNet().isServer()) // only server so client doesnt send so its twice
    {		
		CRules@ rules = getRules();
		CBitStream send_params;
		send_params.write_netid( params.read_netid() );
		rules.SendCommand( rules.getCommandID("take blocks"), send_params );
    }
}

void onDie( CBlob@ this )
{
	Vec2f pos = this.getPosition();
	Sound::Play( "ShipExplosion", pos );
    makeLargeExplosionParticle(pos);
    ShakeScreen( 190, 180, pos );
    client_AddToChat( "Team " + this.getTeamNum() + " ship destroyed." );
}