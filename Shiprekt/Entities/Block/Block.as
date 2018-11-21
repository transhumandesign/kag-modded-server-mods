#include "IslandsCommon.as"
#include "BlockCommon.as"
#include "MakeDustParticle.as"

// onInit: called from engine after blob is created with server_CreateBlob()

void onInit( CBlob@ this )
{
	CSprite @sprite = this.getSprite();
	CShape @shape = this.getShape();
	sprite.asLayer().SetLighting( false );
	shape.getConsts().net_threshold_multiplier = -1.0f;
	this.SetMapEdgeFlags( u8(CBlob::map_collide_none) | u8(CBlob::map_collide_nodeath) );
}

// onCollision: called once from the engine when a collision happens; 
// blob is null when it is a tilemap collision

void onCollision( CBlob@ this, CBlob@ blob, bool solid, Vec2f normal, Vec2f point1 )
{
	if (blob is null) { // exit if this is a tilemap collision
		return;
	}

	// get this blobs and the other blobs island color stored in a temporary engine variable
	const int color = this.getShape().getVars().customData;
	const int other_color = blob.getShape().getVars().customData;
	if (color > 0 && other_color > 0 && color != other_color) // block vs block
	{
		if (getNet().isServer())
		{
			// solid blocks are stronger than others
			const int blockType = this.getSprite().getFrame();
			const bool solid = Block::isSolid(blockType) || blockType == Block::BOMB;
			const int other_blockType = blob.getSprite().getFrame();
			const bool other_solid = Block::isSolid(other_blockType) || blockType == Block::BOMB;
			if (other_solid || !solid){
				DieOrBomb( this );
			}
			if (solid || !other_solid){
				DieOrBomb( blob );
			}			
		}

		Island@ island = getIsland(color);
		Island@ other_island = getIsland(other_color);
		CollisionResponse( island, other_island, point1 );
	}
	else if (other_color == 0 && color > 0)
	{
		int blockType = this.getSprite().getFrame();
		// solid block vs player
		if (Block::isSolid(blockType))
		{
			if (!blob.isAttached() && blob.getName() == "human")
			{
				Vec2f pos = blob.getPosition();
				
				blob.setPosition( pos + normal * -(blob.getRadius() * 0.4f) );

				// kill by impact
				Island@ island = getIsland(color);
				if (!blob.isOnGround() && blob.get_s8( "stay count" ) <= 0 && (island.vel.getLength() > 1.0f || Maths::Abs(island.angle_vel) > 1.0f)){
					blob.server_Die();
				}
			}

			if (blob.hasTag("projectile"))
			{
				blob.server_Die();
			}			
		}
	}
}

void onGib(CSprite@ this)
{
	MakeDustParticle( this.getBlob().getPosition(), "/DustSmall.png");
	this.PlaySound("destroy_wood.ogg");
}

void onDie(CBlob@ this)
{
	// kill humans standing on top

	if (this.getSprite().getFrame() != Block::COUPLING)
	{
		CBlob@[] overlapping;
	    if (this.getOverlapping( @overlapping ))
	    {
	        for (uint i = 0; i < overlapping.length; i++)
	        {
	            CBlob@ b = overlapping[i];
	            if (b.getName() == "human" &&
	            	b.getDistanceTo(this) < 6.0f)
	            {
	            	b.server_Die();
	            }
	        }
	    }	
	}

    // check if this was held by somebody - then destroy all other held

	CBlob@ owner = getBlobByNetworkID( this.get_u16( "ownerID" ) );    
	if (owner !is null)
	{
	    CBlob@[]@ blocks;
	    if (this.get( "blocks", @blocks ))                 
	    {
	        for (uint i = 0; i < blocks.length; ++i)
	        {
	            CBlob@ b = blocks[i];
	            b.server_Die();
	        }
	        blocks.clear();
	    }        
	}

	//gib the sprite

    if (this.getShape().getVars().customData > 0)
    {
		this.getSprite().Gib();
	}
}

void DieOrBomb( CBlob@ this )
{
	if(!getNet().isServer()) return;

	if (this.getSprite().getFrame() == Block::BOMB)
	{
		if(!this.hasTag("timer"))
		{
			this.SendCommand( this.getCommandID("detonate") );
		}
	}
	else
	{
		this.server_Die();
	}
}

void CollisionResponse( Island@ island, Island@ other_island, Vec2f point1 )
{
	if (island !is null && other_island !is null)
	{			
		Vec2f velnorm = island.vel; 
		const f32 vellen = velnorm.Normalize();
		Vec2f other_velnorm = other_island.vel; 
		const f32 other_vellen = other_velnorm.Normalize();

		Vec2f colvec = point1 - other_island.pos;
		Vec2f colvec2 = point1 - island.pos;
		colvec.Normalize();
		colvec2.Normalize();

		const f32 veltransfer = 0.35f;
		const f32 veldamp = 0.66f;
		const f32 dirscale = Maths::Min((velnorm*other_velnorm + 1.0f), 1.0f);
		const f32 massratio = (island.mass > other_island.mass) ? other_island.mass / island.mass : island.mass / other_island.mass;
		island.vel *= veldamp;
		other_island.vel *= veldamp;
		island.vel += other_island.vel * dirscale * (1.0f - massratio) * veltransfer;
		other_island.vel += island.vel * dirscale * massratio * veltransfer;

		// effects

		int shake = (vellen * island.mass + other_vellen * other_island.mass)*2;
		ShakeScreen( shake, 12, point1 );
		Sound::Play( shake > 25 ? "WoodHeavyBump" : "WoodLightBump", point1);
	} 	
}

void onHealthChange( CBlob@ this, f32 oldHealth )
{
	const f32 hp = this.getHealth();
	if (hp < 0.0f)
	{
		this.server_Die();
	}
	else
	{		
		// we'll destroy frame used as block type so we add a layer simply
		if (hp < oldHealth-0.5f && Block::isSolid(this.getSprite().getFrame()))
		{
			f32 full_hp = this.getInitialHealth();
			const int frame = (oldHealth > full_hp * 0.5f) ? 5 : 6;	
			CSprite@ sprite = this.getSprite();
		    CSpriteLayer@ layer = sprite.addSpriteLayer( "dmg"+frame );
		    if (layer !is null)
		    {
		    	layer.SetRelativeZ(1+frame);
		    	layer.SetLighting( false );
		    	layer.SetFrame(frame);
		    }	

		    MakeDustParticle( this.getPosition(), "/dust2.png");
	    }	
	}	
}

// network

void onSendCreateData( CBlob@ this, CBitStream@ stream )
{	 
	stream.write_u8( Block::getType(this) );
	stream.write_netid( this.get_u16("ownerID") );
}

bool onReceiveCreateData( CBlob@ this, CBitStream@ stream )
{
	u8 type = 0;
	u16 ownerID = 0;

	if (!stream.saferead_u8(type)){
		warn("Block::onReceiveCreateData - missing type");
		return false;	
	}
	if (!stream.saferead_u16(ownerID)){
		warn("Block::onReceiveCreateData - missing ownerID");
		return false;	
	}

	this.getSprite().SetFrame( type );
	this.SetMinimapVars("GUI/block_minimap.png", Block::minimapframe(Block::Type(type)), Vec2f(3,3));
	
	CBlob@ owner = getBlobByNetworkID(ownerID);
	if (owner !is null)
	{
	    owner.push( "blocks", @this );
		this.getShape().getVars().customData = -1; // don't push on island
	}

	return true;
}
