#include "IslandsCommon.as"

void onTick( CBlob@ this )
{	
	Island@ island = getIsland( this );
	if (island !is null)
	{
    	Vec2f pos = this.getPosition();
    	Vec2f newPos = pos;  

		newPos += island.pos - island.old_pos;
		
		Vec2f offset = pos - island.pos;
		offset.RotateBy(island.angle - island.old_angle);
		Vec2f rotPos = island.pos + offset;
		newPos += rotPos - pos;		

       	this.setPosition( newPos );
	}
}
