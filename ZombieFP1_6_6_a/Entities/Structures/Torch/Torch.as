const string pickable_tag = "pickable";

void onInit( CBlob@ this )
{
	this.getSprite().SetZ(-50); //background	
	this.getShape().SetRotationsAllowed( false );
    this.SetLight( true );
    this.SetLightRadius( 64.0f );
	this.SetLightColor(SColor(255, 211, 121, 224));
    this.getShape().getConsts().mapCollisions = false;

    this.Tag("dont deactivate");
    this.Tag("fire source");
    this.Tag("place norotate");
	this.Untag(pickable_tag);
}

bool canBePickedUp(CBlob@ this, CBlob@ byBlob)
{
	return (this.getTeamNum() == byBlob.getTeamNum() && !this.getShape().isStatic() && this.hasTag(pickable_tag));
}