#include "IslandsCommon.as"
#include "BlockCommon.as"

const f32 VEL_DAMPING = 0.96f;
const f32 ANGLE_VEL_DAMPING = 0.96;
const uint FORCE_UPDATE_TICKS = 21;

uint color;
bool updatedThisTick = false;

void onInit( CRules@ this )
{
	Island[] islands;
	this.set("islands", islands);
	this.addCommandID("islands sync");
	this.addCommandID("islands update");
	this.set_u32("islands id", 0);
	onRestart( this );
}

void onRestart( CRules@ this )
{
	this.clear("islands");
	this.set_bool("dirty islands", true);
}

void onTick( CRules@ this )
{
	bool full_sync = false;				
	if (getNet().isServer())
	{		
		const int time = getMap().getTimeSinceStart();
		if (time < 2) // errors are generated when done on first game tick
			return;

		const bool dirty = this.get_bool("dirty islands");
		if (dirty)
		{
			GenerateIslands( this );			
			this.set_bool("dirty islands", false);
			full_sync = true;
		}

		UpdateIslands( this );
		Synchronize( this, full_sync );
	}

	if (!updatedThisTick){
		UpdateIslands( this );
	}
}

void GenerateIslands( CRules@ this )
{	
	StoreVelocities( this );

	CBlob@[] blocks;
	this.clear("islands");
	if (getBlobsByName( "block", @blocks ))
	{
		color = 0;
		for (uint i = 0; i < blocks.length; ++i)
		{
			if (blocks[i].getShape().getVars().customData > 0)
				blocks[i].getShape().getVars().customData = 0;			
		}

		for (uint i = 0; i < blocks.length; ++i)
		{
			CBlob@ b = blocks[i];
			if (b.getShape().getVars().customData == 0)
			{
				color++;

				Island island;
				SetNextId( this, @island );
				this.push("islands", island);
				Island@ p_island;
				this.getLast( "islands", @p_island );

				ColorBlocks( b, p_island );			
			}
		}
	}

	//print("Generated " + color + " islands");
}

void ColorBlocks( CBlob@ blob, Island@ island )
{
	blob.getShape().getVars().customData = color;
	
	IslandBlock isle_block;
	isle_block.blobID = blob.getNetworkID();
	island.blocks.push_back(isle_block);

	const float rad = 8.0f; // maxium transfer radius

	CBlob@[] overlapping;
    if (blob.getOverlapping( @overlapping ))
    {
        for (uint i = 0; i < overlapping.length; i++)
        {
            CBlob@ b = overlapping[i];
            if (b.getShape().getVars().customData == 0 &&
            	b.getName() == "block" &&
            	b.getDistanceTo(blob) < rad * 1.1) // avoid "corner" overlaps
            {
            	ColorBlocks( b, island );
            }
        }
    }
}

void onRender( CRules@ this )
{
	if (g_debug == 1)
	{
		Island[]@ islands;
		if (this.get( "islands", @islands ))
			for (uint i = 0; i < islands.length; ++i)
			{
				Island @isle = islands[i];
				for (uint b_iter = 0; b_iter < isle.blocks.length; ++b_iter)
				{			
					IslandBlock@ isle_block = isle.blocks[b_iter];
					CBlob@ b = getBlobByNetworkID( isle_block.blobID );
					if (b !is null)
					{
						int c = b.getShape().getVars().customData;
						GUI::DrawRectangle( getDriver().getScreenPosFromWorldPos(b.getPosition() - Vec2f(4, 4)), getDriver().getScreenPosFromWorldPos(b.getPosition() + Vec2f(4, 4)), SColor( 100, c*50, -c*90, 93*c ) ); 	
					}
				}	
			}
	}
}

//

void UpdateIslands( CRules@ this, const bool integrate = true )
{	
	updatedThisTick = true;
	Island[]@ islands;
	this.get( "islands", @islands );	
	for (uint i = 0; i < islands.length; ++i)
	{
		Island @isle = islands[i];

		if (!isle.initialized)
		{
			InitIsland( isle );
			isle.initialized = true;
		}

		if (integrate)
		{
			isle.old_pos = isle.pos;
			isle.old_angle = isle.angle;
			isle.pos += isle.vel;		
			isle.angle += isle.angle_vel;
			isle.vel *= VEL_DAMPING;
			isle.angle_vel *= ANGLE_VEL_DAMPING;

			if (isle.vel.LengthSquared() < 0.01f)
				isle.vel *= 0.9f;
			if (Maths::Abs(isle.angle_vel) < 0.01f)
				isle.angle_vel *= 0.9f;				

			while(isle.angle < 0.0f){
				isle.angle += 360.0f;
			}
			while(isle.angle > 360.0f){
				isle.angle -= 360.0f;
			}
		}

		for (uint b_iter = 0; b_iter < isle.blocks.length; ++b_iter)
		{			
			IslandBlock@ isle_block = isle.blocks[b_iter];
			CBlob@ b = getBlobByNetworkID( isle_block.blobID );
			if (b !is null){
				UpdateIslandBlob( b, isle, isle_block );
			}
		}

		isle.soundsPlayed = 0;
	}	
}

void InitIsland( Island @isle )
{
	Vec2f center, vel;
	f32 angle_vel = 0.0f;
	for (uint b_iter = 0; b_iter < isle.blocks.length; ++b_iter)
	{			
		IslandBlock@ isle_block = isle.blocks[b_iter];
		CBlob@ b = getBlobByNetworkID( isle_block.blobID );
		if (b !is null)
		{
			center += b.getPosition();
			if (b.getVelocity().LengthSquared() > 0.0f)
			{
				vel = b.getVelocity();
				angle_vel = b.getAngularVelocity();			
			}
		}
	}
	center /= float(isle.blocks.length);

	// find center block
	f32 maxDistance = 999999.9f;
	for (uint b_iter = 0; b_iter < isle.blocks.length; ++b_iter)
	{			
		IslandBlock@ isle_block = isle.blocks[b_iter];
		CBlob@ b = getBlobByNetworkID( isle_block.blobID );
		if (b !is null)
		{
			Vec2f vec = b.getPosition() - center;
			f32 dist = vec.getLength();
			if (dist < maxDistance){
				maxDistance = dist;
				@isle.centerBlock = b;
			}
		}
	}	

	if (isle.centerBlock is null){
		warn("isle.centerBlock is null");
		return;
	}

	isle.pos = center = isle.centerBlock.getPosition();	
	isle.angle = isle.centerBlock.getAngleDegrees();
	isle.vel = vel;
	isle.angle_vel = angle_vel;
	isle.mass = Maths::Sqrt(isle.blocks.length);

	for (uint b_iter = 0; b_iter < isle.blocks.length; ++b_iter)
	{			
		IslandBlock@ isle_block = isle.blocks[b_iter];
		CBlob@ b = getBlobByNetworkID( isle_block.blobID );
		if (b !is null)
		{
			isle_block.offset = b.getPosition() - center;
			isle_block.offset.RotateBy( -isle.angle );
			isle_block.angle_offset = b.getAngleDegrees() - isle.angle;
		}
	}
}

void UpdateIslandBlob( CBlob@ blob, Island @isle, IslandBlock@ isle_block )
{
	Vec2f offset = isle_block.offset;
	offset.RotateBy( isle.angle );
 	
 	blob.setPosition( isle.pos + offset );
 	blob.setAngleDegrees( isle.angle + isle_block.angle_offset );

 	blob.setVelocity( Vec2f_zero );
 	blob.setAngularVelocity( 0.0f );
}

void StoreVelocities( CRules@ this )
{
	Island[]@ islands;
	if (this.get( "islands", @islands ))
		for (uint i = 0; i < islands.length; ++i)
		{
			Island @isle = islands[i];
			for (uint b_iter = 0; b_iter < isle.blocks.length; ++b_iter)
			{			
				IslandBlock@ isle_block = isle.blocks[b_iter];
				CBlob@ b = getBlobByNetworkID( isle_block.blobID );
				if (b !is null)
				{
					b.setVelocity( isle.vel );
					b.setAngularVelocity( isle.angle_vel );	
				}
			}
		}	
}

void onBlobDie( CRules@ this, CBlob@ blob )
{
	// this will leave holes until next full sync
	if (blob.getShape().getVars().customData > 0)
	{
		const u16 id = blob.getNetworkID();
		Island@ isle = getIsland( blob.getShape().getVars().customData );
		if (isle !is null)
		{
			for (uint b_iter = 0; b_iter < isle.blocks.length; ++b_iter)
			{			
				IslandBlock@ isle_block = isle.blocks[b_iter];
				if (isle_block.blobID == id){
					isle.blocks.erase(b_iter); 
					if (isle.centerBlock is null || isle.centerBlock.getNetworkID() == id)
					{
						@isle.centerBlock = null;
						isle.initialized = false;
					}
					b_iter = 0;

					if (blob.getSprite().getFrame() == Block::COUPLING){
						this.set_bool("dirty islands", true);		
						return;
					}
				}
			}

			if (isle.blocks.length == 0)
				this.set_bool("dirty islands", true);			
		} 
	}
}

// network

void Synchronize( CRules@ this, bool full_sync, CPlayer@ player = null )
{
	CBitStream bs;
	if (Serialize( this, bs, full_sync ))
		this.SendCommand( full_sync ? this.getCommandID("islands sync") : this.getCommandID("islands update"), bs, player );
}

bool Serialize( CRules@ this, CBitStream@ stream, const bool full_sync )
{
	Island[]@ islands;
	if (this.get( "islands", @islands ))
	{
		stream.write_u16( islands.length );
		bool atLeastOne = false;
		for (uint i = 0; i < islands.length; ++i)
		{
			Island @isle = islands[i];
			if (full_sync)
			{
				stream.write_Vec2f( isle.pos );
				stream.write_Vec2f( isle.vel );			
				stream.write_f32( isle.angle );
				stream.write_f32( isle.angle_vel );			
				stream.write_u16( isle.blocks.length );
				for (uint b_iter = 0; b_iter < isle.blocks.length; ++b_iter)
				{			
					IslandBlock@ isle_block = isle.blocks[b_iter];
					CBlob@ b = getBlobByNetworkID( isle_block.blobID );
					if (b !is null)
					{
						stream.write_netid( b.getNetworkID() );	
						stream.write_Vec2f( b.getPosition() );
						stream.write_f32( b.getAngleDegrees() );
					}
					else
					{
						stream.write_netid( 0 );	
						stream.write_Vec2f( Vec2f_zero );
						stream.write_f32( 0.0f );
					}
				}		
				isle.net_pos = isle.pos;		
				isle.net_vel = isle.vel;
				isle.net_angle = isle.angle;
				isle.net_angle_vel = isle.angle_vel;
				atLeastOne = true;
			}		
			else
			{			
				const f32 thresh = 0.005f;
				if ((getGameTime()+i) % FORCE_UPDATE_TICKS == 0 || isIslandChanged( isle ))				
				{
					stream.write_bool( true );

					if ((isle.net_pos - isle.pos).LengthSquared() > thresh){
						stream.write_bool( true );
						stream.write_Vec2f( isle.pos );
						stream.write_Vec2f( isle.old_pos );
						isle.net_pos = isle.pos;
					}
					else stream.write_bool( false );

					
					if ((isle.net_vel - isle.vel).LengthSquared() > thresh){
						stream.write_bool( true );
						stream.write_Vec2f( isle.vel );
						isle.net_vel = isle.vel;
					}
					else stream.write_bool( false );
					
					if (Maths::Abs(isle.net_angle - isle.angle) > thresh){
						stream.write_bool( true );
						stream.write_f32( isle.angle );
						stream.write_f32( isle.old_angle );
						isle.net_angle = isle.angle;
					}
					else stream.write_bool( false );

					if (Maths::Abs(isle.net_angle_vel - isle.angle_vel) > thresh){
						stream.write_bool( true );
						stream.write_f32( isle.angle_vel );
						isle.net_angle_vel = isle.angle_vel;
					}
					else stream.write_bool( false );

					atLeastOne = true;		
				}
				else
					stream.write_bool( false );
			}
		}
		return atLeastOne;
	}
	
	warn("islands not found on serialize");
	return false;
}

void onCommand( CRules@ this, u8 cmd, CBitStream @params )
{
	if (getNet().isServer())
		return;

	if (cmd == this.getCommandID("islands sync"))
	{
		Island[]@ islands;
		if (this.get( "islands", @islands ))
		{
			islands.clear();
			const u16 count = params.read_u16();
			for (uint i = 0; i < count; ++i)
			{
				Island isle;
				if (!params.saferead_Vec2f(isle.pos)){
					warn("islands sync: isle.pos not found");
					return;
				}				
				isle.old_pos = isle.pos;
				isle.vel = params.read_Vec2f();				
				isle.angle = isle.old_angle = params.read_f32();
				isle.angle_vel = params.read_f32();
				const u16 blocks_count = params.read_u16();
				for (uint b_iter = 0; b_iter < blocks_count; ++b_iter)
				{	
					u16 netid;
					if (!params.saferead_netid(netid)){
						warn("islands sync: netid not found");
						return;
					}
					CBlob@ b = getBlobByNetworkID( netid );
					Vec2f pos = params.read_Vec2f();
					f32 angle = params.read_f32();
					if (b !is null)
					{
						IslandBlock isle_block;
						isle_block.blobID = netid;
						isle.blocks.push_back(isle_block);	
						b.setPosition(pos);
						b.setAngleDegrees(angle);		
	    				b.getShape().getVars().customData = i+1; // color		
							// safety on desync
							b.SetVisible(true);
						    CSprite@ sprite = b.getSprite();
	    					sprite.asLayer().SetColor( color_white );
	    					sprite.asLayer().setRenderStyle( RenderStyle::normal );
					}
					else
						warn(" Blob not found when creating island, id = " + netid);
				}
				islands.push_back(isle);
			}	

			UpdateIslands( this, false );
		}
		else
		{
				warn("Islands not found on sync");
				return;
		}
	}
	else if (cmd == this.getCommandID("islands update"))
	{
		Island[]@ islands;
		if (this.get( "islands", @islands ))
		{
			u16 count;
			if (!params.saferead_u16(count)){
				warn("islands update: count not found");
				return;
			}
			if (count != islands.length){
				warn("Update received before island sync " + count + " != " + islands.length);
				return;
			}
			for (uint i = 0; i < count; ++i)
			{
				if (params.read_bool())
				{
					Island @isle = islands[i];

					if (params.read_bool()){
						isle.pos = params.read_Vec2f();
						isle.old_pos = params.read_Vec2f();
					}
					if (params.read_bool()){
						isle.vel = params.read_Vec2f();
					}					
					if (params.read_bool()){
						isle.angle = params.read_f32();
						isle.old_angle = params.read_f32();
					}	
					if (params.read_bool()){
						isle.angle_vel = params.read_f32();
					}										
				}
			}	

			UpdateIslands( this, false );
		}
		else
		{
				warn("Islands not found on update");
				return;
		}
	}
}

void onNewPlayerJoin( CRules@ this, CPlayer@ player )
{
	if (!player.isMyPlayer())
		Synchronize( this, true, player ); // will set old values
}

bool isIslandChanged( Island@ isle )
{
	const f32 thresh = 0.01f;
	return ((isle.pos - isle.old_pos).LengthSquared() > thresh || Maths::Abs(isle.angle - isle.old_angle) > thresh);
}