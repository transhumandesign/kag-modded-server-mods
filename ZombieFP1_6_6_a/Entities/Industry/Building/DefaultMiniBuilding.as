// A default building init script

void onInit( CBlob@ this )
{
    this.getSprite().SetZ(-50); //background
    this.getShape().getConsts().mapCollisions = false;
    this.getSprite().getConsts().accurateLighting = true;
    this.Tag("building");
	this.Tag("place norotate");
	this.Tag("auto close menu");
	
    this.SetLight(false);
    this.SetLightRadius( 30.0f );
}

void GetButtonsFor( CBlob@ this, CBlob@ caller )
{
    this.set_bool("shop available", this.isOverlapping(caller) && caller.getTeamNum() == this.getTeamNum());
}