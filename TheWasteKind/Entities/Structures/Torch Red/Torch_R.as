// 255, 152, 16, 56 for dark red
#include "Hitters.as"

void onInit( CBlob@ this )
{
	this.getShape().SetRotationsAllowed( false );
    this.SetLight( true );
    this.SetLightRadius( 64.0f );
    this.SetLightColor( SColor(255, 200, 0, 50 ) );
    this.getShape().getConsts().mapCollisions = false;
	this.getShape().SetStatic( true );
    CMap@ map = getMap();
    Vec2f pos = this.getPosition();
    const f32 tilesize = map.tilesize;


}

bool canBePickedUp( CBlob@ this, CBlob@ byBlob )
{
    return false;
}
