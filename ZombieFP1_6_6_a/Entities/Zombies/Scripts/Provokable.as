// Aphelion \\

#include "CreatureCommon.as";

f32 onHit( CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData )
{
	if(getNet().isServer())
	{
		if (damage > 0.0f && hitterBlob !is null && this.getBrain().getTarget() !is hitterBlob)
		{
		    if (isTarget(this, hitterBlob))
			{
				f32 distance;

				if (isTargetVisible(this, hitterBlob, distance) && distance < this.get_f32(target_searchrad_property))
            	{
					this.getBrain().SetTarget(hitterBlob);
		    	}
			}
		}
	}
	return damage;
}