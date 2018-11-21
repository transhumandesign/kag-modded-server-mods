#include "IslandsCommon.as"

void onTick( CRules@ this )
{	
	Island[]@ islands;
	if (!this.get( "islands", @islands ))
		return;
		
	CMap@ map = getMap();
	const f32 mapwidth = map.tilesize*map.tilemapwidth;
	const f32 mapheight = map.tilesize*map.tilemapheight;	
	for (uint i = 0; i < islands.length; ++i)
	{
		Island @isle = islands[i];
		if (isle.vel.x > 0.0f && isle.pos.x > mapwidth){						
			isle.old_pos.x = isle.pos.x;
			isle.old_pos.x -= isle.vel.x;
			isle.pos.x -= mapwidth;			
		}
		if (isle.vel.y > 0.0f && isle.pos.y > mapheight){			
			isle.old_pos.y = isle.pos.y;
			isle.old_pos.y -= isle.vel.y;
			isle.pos.y -= mapheight;
		}		
		if (isle.vel.x < 0.0f && isle.pos.x < 0){			
			isle.old_pos.x = isle.pos.x;
			isle.old_pos.x -= isle.vel.x;
			isle.pos.x += mapwidth;			
		}	
		if (isle.vel.y < 0.0f && isle.pos.y < 0){			
			isle.old_pos.y = isle.pos.y;
			isle.old_pos.y -= isle.vel.y;
			isle.pos.y += mapheight;		
		}
	}	
}