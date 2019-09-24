
#include "TreeDeeSound.as"

f32 onHit( CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData )
{
	if (isClient())
	{
		if(this.isMyPlayer())
		{
			SetScreenFlash( 0, 255, 255, 255 );
			this.set_u8("alpha", 160);
		}
		PlayTreeDeeSound("GrobberHit.ogg", this.getPosition(), 100.0, 1.0);
	}
	return damage;
}