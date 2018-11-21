#include "TeamColour.as";

void onInit( CBlob@ this )
{
	this.SetLight( true );
	this.SetLightRadius( 32.0f );
	this.SetLightColor(getTeamColor(this.getTeamNum()));
	this.getSprite().PlaySound("/HealSound.ogg");
	this.getShape().SetStatic(true);
	this.server_SetTimeToDie(1.0f);
	this.getSprite().SetZ(100);

}