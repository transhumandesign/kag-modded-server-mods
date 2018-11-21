// ShieldHit.as

#include "CustomParticles.as";
#include "CustomHitters.as";
#include "Hitters.as";

#include "ShieldCommon.as";

bool canBlockThisType(u8 type) // this function needs to use a tag on the hitterBlob, like ("bypass shield")
{
	return type == Hitters::stomp ||
	       type == Hitters::builder ||
	       type == Hitters::sword ||
	       type == Hitters::shield ||
	       type == Hitters::arrow ||
	       type == Hitters::gun ||
	       type == Hitters::plasma ||
	       type == Hitters::bite ||
	       type == Hitters::stab ||
	       isExplosionHitter(type) ||
	       isCustomExplosionHitter(type);
}

f32 onHit(CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData)
{
	if (this.hasTag("dead") ||
	        !this.hasTag("shielded") ||
	        !canBlockThisType(customData) ||
	        this is hitterBlob)
	{
		//print("dead " + this.hasTag("dead") + "shielded " + this.hasTag("shielded") + "cant " + canBlockThisType(customData));
		return damage;
	}

	//no shield when stunned
	if (this.get_u8("knocked") > 0)
	{
		return damage;
	}

	if (blockAttack(this, velocity, 0.0f))
	{
		if (isExplosionHitter(customData) || isCustomExplosionHitter(customData)) //bomb jump
		{
			Vec2f vel = this.getVelocity();
			this.setVelocity(Vec2f(0.0f, Maths::Min(0.0f, vel.y)));

			Vec2f bombforce = Vec2f(0.0f, ((velocity.y > 0) ? 0.7f : -1.3f));

			bombforce.Normalize();
			bombforce *= 2.0f * Maths::Sqrt(damage) * this.getMass();
			bombforce.y -= 2;

			if (!this.isOnGround() && !this.isOnLadder())
			{
				if (this.isFacingLeft() && vel.x > 0)
				{
					bombforce.x += 50;
					bombforce.y -= 80;
				}
				else if (!this.isFacingLeft() && vel.x < 0)
				{
					bombforce.x -= 50;
					bombforce.y -= 80;
				}
			}
			else if (this.isFacingLeft() && vel.x > 0)
			{
				bombforce.x += 5;
			}
			else if (!this.isFacingLeft() && vel.x < 0)
			{
				bombforce.x -= 5;
			}

			this.AddForce(bombforce);
			this.Tag("dont stop til ground");

		}
		else if (exceedsShieldBreakForce(this, damage))
		{
			this.Tag("force_knock");
			return damage;
		}

		//Sound::Play("Entities/Characters/Knight/ShieldHit.ogg", worldPoint);
		const f32 vellen = velocity.Length();
		team_sparks(this.getTeamNum(), worldPoint, -velocity.Angle(), Maths::Max(vellen * 0.05f, damage));
		return 0.0f;
	}

	return damage; //no block, damage goes through
}
