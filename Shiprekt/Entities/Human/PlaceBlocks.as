#include "IslandsCommon.as"

const f32 rotate_speed = 30.0f;
const f32 max_build_distance = 32.0f;

void onInit( CBlob@ this )
{
    CBlob@[] blocks;
    this.set("blocks", blocks);
    this.set_f32("blocks_angle", 0.0f);
    this.set_f32("target_angle", 0.0f);

    this.addCommandID("place");
}

void onTick( CBlob@ this )
{	
    CBlob@[]@ blocks;
    if (this.get( "blocks", @blocks ) && blocks.size() > 0)        
    {
        Island@ island = getIsland( this );
        if (island !is null)
        {            
            f32 blocks_angle = this.get_f32("blocks_angle");   
            f32 target_angle = this.get_f32("target_angle"); 
            Vec2f pos = this.getPosition();
            Vec2f aimPos = this.getAimPos();

            PositionBlocks( island, @blocks, pos, aimPos, blocks_angle );    

            if (island.centerBlock is null){
                warn("PlaceBlocks: centerblock not found");
                return;
            }

            if (this.isMyPlayer()) 
            {
                const bool overlappingIsland = blocksOverlappingIsland( @blocks );

                // place

                if (this.isKeyJustPressed( key_action1 ))
                {
                    if (target_angle == blocks_angle && !overlappingIsland)
                    {
                        CBitStream params;
                        params.write_netid( island.centerBlock.getNetworkID() );
                        params.write_Vec2f( pos - island.pos );
                        params.write_Vec2f( aimPos - island.pos );
                        params.write_f32( target_angle );
                        this.SendCommand( this.getCommandID("place"), params );
                    }
                    else
                    {
                        this.getSprite().PlaySound("NoAmmo.ogg");
                    }
                }

                // rotate

                if (this.isKeyJustPressed( key_action3 ))
                {
                    target_angle += 90.0f;
                    if (target_angle > 360.0f) {
                        target_angle -= 360.0f;
                        blocks_angle -= 360.0f;
                    }
                    this.set_f32("target_angle", target_angle);
                    this.Sync("target_angle", false);
                }
            }

            blocks_angle += rotate_speed;
            if (blocks_angle > target_angle)
                blocks_angle = target_angle;        
            this.set_f32("blocks_angle", blocks_angle);   
        }   
        else
        {
            // cant place in water
            for (uint i = 0; i < blocks.length; ++i)
            {
                CBlob @block = blocks[i];
                SetDisplay( block, SColor(255, 255, 0, 0), RenderStyle::light, -10.0f);
            }
        }      
    }
}

void PositionBlocks( Island@ island, CBlob@[]@ blocks, Vec2f pos, Vec2f aimPos, const f32 blocks_angle )
{
    if (island is null || island.centerBlock is null){
        warn("PositionBlocks: centerblock not found");
        return;
    }
    const f32 angle = island.angle;
    Vec2f mouseAim = aimPos - pos;
    f32 mouseDist = Maths::Min( mouseAim.Normalize(), max_build_distance );
    aimPos = pos + mouseAim * mouseDist;

    Vec2f island_pos = island.centerBlock.getPosition();
    Vec2f islandAim = aimPos - island.pos;
    islandAim.RotateBy( -angle );
    islandAim = SnapToGrid( islandAim );
    islandAim.RotateBy( angle );
    Vec2f cursor_pos = island_pos + islandAim;

    // rotate blocks

    Vec2f snap;
    for (uint i = 0; i < blocks.length; ++i)
    {
        CBlob @block = blocks[i];
        Vec2f offset = block.get_Vec2f("offset");
        offset.RotateBy(blocks_angle);                        
        if (i == 0)
            snap = (cursor_pos + offset) - SnapToGrid( cursor_pos + offset );
        offset.RotateBy(angle);                
  
        block.setPosition( cursor_pos + offset ); // align
        block.setAngleDegrees(angle + blocks_angle);

        SetDisplay( block, color_white, RenderStyle::light, 10.0f);
    }    
}

void onCommand( CBlob@ this, u8 cmd, CBitStream @params )
{
    if (cmd == this.getCommandID("place"))
    {
        CBlob@ centerblock = getBlobByNetworkID( params.read_netid() );
        if (centerblock is null)
        {
            warn("place cmd: centerblock not found");
            return;
        }

        Vec2f pos_offset = params.read_Vec2f();
        Vec2f aimPos_offset = params.read_Vec2f();
        const f32 target_angle = params.read_f32();

        Island@ island = getIsland( centerblock.getShape().getVars().customData );
        if (island is null)
        {
            warn("place cmd: island not found");
            return;
        }

        CBlob@[]@ blocks;
        if (this.get( "blocks", @blocks ) && blocks.size() > 0)                 
        {
            PositionBlocks( island, @blocks, island.pos + pos_offset, island.pos + aimPos_offset, target_angle );  

            for (uint i = 0; i < blocks.length; ++i)
            {
                CBlob@ b = blocks[i];
                if (b !is null)
                {
                    b.getShape().getVars().customData = 0; // push on island     
                    b.set_u16("ownerID", 0); // so it wont add to owner blocks
                    SetDisplay( b, color_white, RenderStyle::normal, 0.0f );
                }
                else{
                    warn("place cmd: blob not found");
                }
            }
        }
        else
        {
            warn("place cmd: no blocks");
            return;
        }
        blocks.clear();            
        getRules().set_bool("dirty islands", true);
        this.getSprite().PlaySound("build_ladder.ogg");
    }
}

bool blocksOverlappingIsland( CBlob@[]@ blocks )
{
    bool result = false;
    for (uint i = 0; i < blocks.length; ++i)
    {
        CBlob @block = blocks[i];
        if (blockOverlappingIsland( block ))
            result = true;
    }
    return result; 
}

bool blockOverlappingIsland( CBlob@ blob )
{
    CBlob@[] overlapping;
    if (blob.getOverlapping( @overlapping ))
    {    
        for (uint i = 0; i < overlapping.length; i++)
        {
            CBlob@ b = overlapping[i];
            int color = b.getShape().getVars().customData;
            if (color > 0)
            {
                if ((b.getPosition() - blob.getPosition()).getLength() < blob.getRadius()/2){
                    SetDisplay( blob, SColor(255, 255, 0, 0), RenderStyle::additive );
                    return true;
                }
            }
        }
    }
    return false;
}

void SetDisplay( CBlob@ blob, SColor color, RenderStyle::Style style, f32 Z=-10000)
{
    CSprite@ sprite = blob.getSprite();
    sprite.asLayer().SetColor( color );
    sprite.asLayer().setRenderStyle( style );
    if (Z>-10000){
        sprite.SetZ(Z);
    }
}

void onDie( CBlob@ this )
{
    // remove held blocks on death

    CBlob@[]@ blocks;
    if (this.get( "blocks", @blocks ))        
    {
        for (uint i = 0; i < blocks.length; ++i)
        {
            CBlob @block = blocks[i];
            block.server_Die();
        }        
    }    
}