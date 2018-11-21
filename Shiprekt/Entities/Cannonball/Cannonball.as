#include "WaterEffects.as"
#include "BlockCommon.as"

void onInit( CBlob@ this )
{
	this.Tag("projectile");

	ShapeConsts@ consts = this.getShape().getConsts();
    consts.mapCollisions = false;	 // weh ave our own map collision
	consts.bullet = true;	

	this.getSprite().SetZ(150.0f);	
}

void onTick( CBlob@ this )
{
	bool killed = false;

	Vec2f pos = this.getPosition();
	Vec2f vel = this.getVelocity();

	// this gathers HitInfo objects which contain blob or tile hit information
	HitInfo@[] hitInfos;
	if (getMap().getHitInfosFromRay( pos, -vel.Angle(), vel.Length(), this, @hitInfos ))
	{
		//HitInfo objects are sorted, first come closest hits
		for (uint i = 0; i < hitInfos.length; i++)
		{
			HitInfo@ hi = hitInfos[i];
			CBlob@ b = hi.blob;	  
			if(b is null || b is this) continue;

			const int color = b.getShape().getVars().customData;
			const int blockType = b.getSprite().getFrame();
			const bool isBlock = b.getName() == "block";

			if (color > 0 || !isBlock)
			{
				if (isBlock)
				{
					if ((Block::isCore(blockType) || Block::isSolid(blockType))) {//don't hit
						killed = true;
					}
					else continue;
				}
				else
				{
					if (b.getTeamNum() == this.getTeamNum())
						continue;
				}

				if(getNet().isServer() && blockType == Block::PROPELLER) //shoot prop = change on/off
				{
					b.SendCommand(b.getCommandID("on/off"));
				}

				this.server_Hit( b, pos,
                                 Vec2f_zero, 1.0f,
                                 0, true);					
			}
		}
	}

	if (killed)
	{
		this.server_Die();
	}
}

void onDie( CBlob@ this )
{
	MakeWaterParticle( this.getPosition(), Vec2f_zero);
	this.getSprite().PlaySound("WaterSplashBall.ogg");

	Vec2f pos = this.getPosition();
	CBlob@[] blobsInRadius;
	if (this.getMap().getBlobsInRadius( pos, 0.0f, @blobsInRadius ))
	{
		for (uint i = 0; i < blobsInRadius.length; i++)
		{
			CBlob @b = blobsInRadius[i];
			if (b.getName() == "block" && b.getShape().getVars().customData > 0 && b.getDistanceTo(this) < 5.0f)
			{
				b.server_Die();
			}
		}
	}
}

Random _sprk_r;
void sparks(Vec2f pos, int amount)
{
	for (int i = 0; i < amount; i++)
    {
        Vec2f vel(_sprk_r.NextFloat() * 7.0f, 0);
        vel.RotateBy(_sprk_r.NextFloat() * 360.0f);

        CParticle@ p = ParticlePixel( pos, vel, SColor( 255, 255, 128+_sprk_r.NextRanged(128), _sprk_r.NextRanged(128)), true );
        if(p is null) return; //bail if we stop getting particles

        p.timeout = 20 + _sprk_r.NextRanged(20);
        p.scale = 1.0f + _sprk_r.NextFloat();
        p.damping = 0.85f;
    }
}


void onHitBlob( CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitBlob, u8 customData )
{            
	CSprite@ sprite = hitBlob.getSprite();
	const int blockType = sprite.getFrame();

	if (hitBlob.getName() == "shark"){
		ParticleBloodSplat( worldPoint, true );
		sprite.PlaySound("BodyGibFall");		
	}
	else
	if (hitBlob.hasTag("player"))
	{
		hitBlob.server_Die();
	}
	else
	if (Block::isSolid(blockType) || Block::isCore(blockType)){
		sparks(worldPoint, 32);
		if(Block::isCore(blockType)){
			Sound::Play( "Entities/Characters/Knight/ShieldHit.ogg", worldPoint );
		}
		else 
		{
			Sound::Play( "Entities/Items/Explosives/Bomb.ogg", worldPoint );
			hitBlob.Damage( damage, null );
		}
	}
	else
		hitBlob.server_Die();

}