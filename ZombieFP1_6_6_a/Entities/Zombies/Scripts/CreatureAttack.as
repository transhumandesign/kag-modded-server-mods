// Aphelion \\

#include "Hitters.as";

void onInit(CBlob@ this)
{
	if (!this.exists("attack frequency"))
		 this.set_u8("attack frequency", 30);
	
	if (!this.exists("attack distance"))
	     this.set_f32("attack distance", 0.5f);
	     
	if (!this.exists("attack damage"))
		 this.set_f32("attack damage", 1.0f);
		
	if (!this.exists("attack hitter"))
		 this.set_u8("attack hitter", Hitters::bite);
	
	if (!this.exists("attack sound"))
		 this.set_string("attack sound", "ZombieBite");
	
	this.getCurrentScript().removeIfTag	= "dead";
}

void onTick( CBlob@ this )
{
	CBlob@ target = this.getBrain().getTarget();
	if    (target !is null)
	{
		if (getGameTime() >= this.get_u32("next_attack"))
		{
			CMap@ map = this.getMap();
            Vec2f pos = this.getPosition();

            const f32 radius = this.getRadius();
            const f32 attack_distance = radius + this.get_f32("attack distance");

			Vec2f vec = this.getAimPos() - pos;
			f32 angle = vec.Angle();
            
		    HitInfo@[] hitInfos;

		    if (map.getHitInfosFromArc(this.getPosition(), -angle, 90.0f, radius + attack_distance, this, @hitInfos))
		    {
			    for(uint i = 0; i < hitInfos.length; i++)
			    {
				    HitInfo@ hi = hitInfos[i];
				    
				    CBlob@ b = hi.blob;

				    if (b !is null && b is target)
				    {
					    HitTarget(this, b);
					    break;
				    }
			    }
		    }
		}
	}
}

void HitTarget( CBlob@ this, CBlob@ target )
{
	Vec2f hitvel = Vec2f( this.isFacingLeft() ? -1.0 : 1.0, 0.0f );
	
	this.server_Hit( target, target.getPosition(), hitvel, this.get_f32("attack damage"), this.get_u8("attack hitter"), true);
	this.set_u32("next_attack", getGameTime() + this.get_u8("attack frequency"));
}

void onHitBlob( CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitBlob, u8 customData )
{		 
	if (damage > 0.0f)
	{
		this.getSprite().PlayRandomSound(this.get_string("attack sound"));
	}
}