// RunnerKnock.as

#include "CustomHitters.as";
#include "Hitters.as";
#include "Knocked.as";

void onInit(CBlob@ this)
{
	setKnockable(this);   //already done in runnerdefault but some dont have that
	this.getCurrentScript().removeIfTag = "dead";
}

f32 onHit(CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData)
{
	if (this.hasTag("invincible")) //pass through if invince
		return damage;

	u8 time = 0;
	bool force = this.hasTag("force_knock");

	if (damage > 0.01f || force) //hasn't been cancelled somehow
	{
		if (force)
		{
			this.Untag("force_knock");
		}

		switch (customData)
		{
			case Hitters::gun:
			{
				if (damage > 1.5f)
				{
				    time = Maths::Min(Maths::Floor(damage - 1.0f) * 10, 30);
				}
				else if (damage > 1.0f)
				{
					time = 5;
				}
				break;
			}

			case Hitters::light_missile:
			    time = 30; break;

			case Hitters::swarm_missile:
			    time = 20; break;

			case Hitters::plasma:
			    time = 10; break;

			case Hitters::builder:
				time = 0; break;

			case Hitters::sword:
			{
				if (damage > 1.0f || force)
				{
					time = 20;
					if (force) //broke shield
						time = 10;
				}
				else
				{
					time = 2;
				}
				break;
			}

			case Hitters::shield:
				time = 15; break;

			case Hitters::bomb:
				time = 20; break;

			case Hitters::spikes:
				time = 10; break;

			case Hitters::arrow:
				if (damage > 1.0f)
				{
					time = 15;
				}
				break;
		}
	}

	if (damage == 0 || force)
	{
		bool undefended = (force || !this.hasTag("shielded"));

		if ((customData == Hitters::emp && undefended) ||
		     customData == Hitters::emp_force)
		{
			time = 45;
			this.Tag("dazzled");
		}
	}

	if (time > 0)
	{
		if (time >= 10)
		{
		    this.getSprite().PlaySound("/Stun", 1.0f, this.getSexNum() == 0 ? 1.0f : 2.0f);
		}

		u8 currentstun = this.get_u8("knocked");
		this.set_u8("knocked", Maths::Max(currentstun, Maths::Min(60, time)));
	}

//  print("KNOCK!" + this.get_u8("knocked") + " dmg " + damage );
	return damage; //damage not affected
}
