#include "Hitters.as";
#include "BlockCommon.as";
#include "ExplosionEffects.as";
#include "IslandsCommon.as";

const f32 BOMB_RADIUS = 16.0f;

void Explode ( CBlob@ this, f32 radius )
{
    Vec2f pos = this.getPosition();
    CMap@ map = this.getMap();

    Sound::Play( "Bomb.ogg", pos );
    makeLargeExplosionParticle(pos);
    ShakeScreen( 4*radius, 45, pos );

    if (getNet().isServer())
    {     
        //hit blobs
        CBlob@[] blobs;
        map.getBlobsInRadius( pos, radius, @blobs );

        for (uint i = 0; i < blobs.length; i++)
        {
            CBlob@ hit_blob = blobs[i];
			if (hit_blob is this)
				continue;

            Vec2f hit_blob_pos = hit_blob.getPosition();  

            if (hit_blob.getName() == "block")
            {
                if (hit_blob.getShape().getVars().customData <= 0)
                    continue;

                // move the island

                Island@ isle = getIsland(hit_blob);
                if (isle !is null && isle.mass > 0.0f)
                {
                    Vec2f impact = (hit_blob_pos - pos) * 0.15f / isle.mass;
                    isle.vel += impact;
                }

                // detonate bomb
                    
                if( Block::isType( hit_blob, Block::BOMB))
                {
                    if(!hit_blob.hasTag("timer"))
                    {
                        hit_blob.SendCommand( hit_blob.getCommandID("detonate") );
                    }
                    continue;
                }
            }            
        
            //hit the object
            this.server_Hit(    hit_blob, hit_blob_pos,
                                Vec2f_zero, 5.0f,
                                Hitters::bomb, true);
        }
    }
	    
}

void StartDetonation(CBlob@ this)
{
    this.server_SetTimeToDie(2);
    this.Tag("timer");
    CSprite@ sprite = this.getSprite();
    sprite.SetAnimation("exploding");
    sprite.SetEmitSound( "/bomb_timer.ogg" );
    sprite.SetEmitSoundPaused( false );
    sprite.RewindEmitSound();
}

void onHitBlob( CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitBlob, u8 customData )
{            
    if (customData == Hitters::bomb)
    {
        //explosion particle
        makeSmallExplosionParticle(worldPoint);
    }
}

void onDie( CBlob@ this )
{
    if (this.getShape().getVars().customData > 0)
    {
        this.getSprite().Gib();
        Explode( this, BOMB_RADIUS );
    }
}

void onInit( CBlob@ this )
{
    this.addCommandID("detonate");

    CSprite@ sprite = this.getSprite();
    if(sprite !is null)
    {
        //default animation
        {
            Animation@ anim = sprite.addAnimation("default", 0, false);
            anim.AddFrame(Block::BOMB);
        }
        //exploding "warmup" animation
        {
            Animation@ anim = sprite.addAnimation("exploding", 2, true);

            int[] frames = {
                Block::BOMB_A1, Block::BOMB_A1,
                Block::BOMB_A2, Block::BOMB_A2,
                Block::BOMB, Block::BOMB,
                Block::BOMB, Block::BOMB,

                Block::BOMB_A1, Block::BOMB_A1,
                Block::BOMB_A2, Block::BOMB_A2,
                Block::BOMB, Block::BOMB,
                Block::BOMB,

                Block::BOMB_A1,
                Block::BOMB_A2,
                Block::BOMB, Block::BOMB,

                Block::BOMB_A1,
                Block::BOMB_A2,
                Block::BOMB, Block::BOMB,

                Block::BOMB_A1,
                Block::BOMB_A2,
                Block::BOMB, Block::BOMB,

                Block::BOMB_A1,
                Block::BOMB_A2,
                Block::BOMB, Block::BOMB,

                Block::BOMB_A1,
                Block::BOMB_A2,
                Block::BOMB, Block::BOMB,
            };

            anim.AddFrames(frames);
        }
    }
}

void GetButtonsFor( CBlob@ this, CBlob@ caller )
{   
    if(this.getDistanceTo(caller) > Block::BUTTON_RADIUS_FLOOR || this.getShape().getVars().customData <= 0)
        return;

    if(this.hasTag("timer"))
        caller.CreateGenericButton( 2, Vec2f(0.0f, 0.0f), this, this.getCommandID("detonate"), "Cancel" );
    else
        caller.CreateGenericButton( 1, Vec2f(0.0f, 0.0f), this, this.getCommandID("detonate"), "Detonate" );
}

void onCommand( CBlob@ this, u8 cmd, CBitStream @params )
{
    if (cmd == this.getCommandID("detonate"))
    {
        if(!this.hasTag("timer"))
        {
            StartDetonation(this);
        }
        else
        {
            this.server_SetTimeToDie(-1);
            this.Untag("timer");
            this.getSprite().SetAnimation("default");            
            this.getSprite().SetEmitSoundPaused( true );  
        }
    }
}