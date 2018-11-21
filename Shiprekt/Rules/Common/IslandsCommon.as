shared class Island
{
	u32 id;
	IslandBlock[] blocks;
	Vec2f pos, vel;
	f32 angle, angle_vel;
	Vec2f old_pos, old_vel;
	f32 old_angle;
	f32 mass;
	CBlob@ centerBlock;
	bool initialized;	
	uint soundsPlayed;

	Vec2f net_pos, net_vel;
	f32 net_angle, net_angle_vel;

	Island(){
		angle = angle_vel = old_angle = mass = 0.0f;
		initialized = false;
		@centerBlock = null;
		soundsPlayed = 0;
	}
};

shared class IslandBlock
{
	u16 blobID;
	Vec2f offset;
	f32 angle_offset;
};

Island@ getIsland( const int colorIndex )
{
	Island[]@ islands;
	if (getRules().get( "islands", @islands ))
		if (colorIndex > 0 && colorIndex <= islands.length){
			return islands[colorIndex-1];
		}
	return null;
}

Island@ getIsland( CBlob@ this )
{
	CBlob@[] blobsInRadius;	   
	CMap@ map = getMap();
	if (map.getBlobsInRadius( this.getPosition(), 0.0f, @blobsInRadius )) 
	{
		for (uint i = 0; i < blobsInRadius.length; i++)
		{
			CBlob @b = blobsInRadius[i];
            const int color = b.getShape().getVars().customData;
            if (color > 0)
            {
            	return getIsland(color);
            }			
		}
	}
    return null;
}

CBlob@ getIslandBlob( CBlob@ this )
{
	CBlob@[] blobsInRadius;	   
	CMap@ map = getMap();
	if (map.getBlobsInRadius( this.getPosition(), 0.0f, @blobsInRadius )) 
	{
		for (uint i = 0; i < blobsInRadius.length; i++)
		{
			CBlob @b = blobsInRadius[i];
            const int color = b.getShape().getVars().customData;
            if (color > 0)
            {
            	return b;
            }			
		}
	}
    return null;
}

Vec2f SnapToGrid( Vec2f pos )
{
    pos.x = Maths::Round(pos.x / 8.0f);
    pos.y = Maths::Round(pos.y / 8.0f);
    pos.x *= 8;
    pos.y *= 8;
    return pos;
}

void SetNextId( CRules@ this, Island@ island )
{
	island.id = this.get_u32("islands id")+1;
	this.set_u32("islands id", island.id);
}