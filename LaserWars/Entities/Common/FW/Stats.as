/* Stats.as
 * author: Aphelion
 */

#include "Utils.as";

namespace Stats
{
	const string BASE_STAT_PROPERTY = "base stat ";
	const string STAT_PROPERTY = "stat ";

	const string STAT_REGEN_TIME_PROPERTY = "stat regen time ";
	const string STAT_REGEN_PROPERTY = "stat regen ";

	enum Types
	{
		SHIELD,
		HEALTH,
		ENERGY,
		AMMO_1,
		AMMO_2
	}
}

f32 Damage( CBlob@ this, f32 _amount, f32 &out damage_dealt )
{
    f32 amount = _amount * 10; // 1 normal dmg = 10 dmg here
	if (amount > 0)
	{
	    f32 shield = getStat(this, Stats::SHIELD);
		if (shield > 0)
		{
			f32 shield_efficiency = 1.0f;
			f32 effective_damage = amount * shield_efficiency;
			amount -= shield;

			f32 damage = Maths::Min(effective_damage, shield);
			damage_dealt += damage;

			server_SetStat(this, Stats::SHIELD, shield - damage, 90);
		}
		
		if (amount > 0)
		{
		    f32 health = getStat(this, Stats::HEALTH);
		    if (health > 0)
			{
				f32 armour_efficiency = 1.0f;
				f32 effective_damage = amount * armour_efficiency;
				amount -= health;
				
				f32 damage = Maths::Min(effective_damage, health);
				damage_dealt += damage;

				server_SetStat(this, Stats::HEALTH, health - damage, 90);
			}
		}
	}
	return amount > 0 ? amount / 10 : 0.0f;
}

void server_CreateStat( CBlob@ this, u8 stat, f32 value, f32 regen )
{
	if(!getNet().isServer()) return;

	this.set_f32(Stats::BASE_STAT_PROPERTY + stat, value);
	this.Sync(Stats::BASE_STAT_PROPERTY + stat, true);

	this.set_f32(Stats::STAT_REGEN_PROPERTY + stat, regen);
	this.Sync(Stats::STAT_REGEN_PROPERTY + stat, true);

	server_SetStat(this, stat, value, 0, false);
}

bool HasStat( CBlob@ this, u8 stat, f32 value )
{
	return getStat(this, stat) >= value;
}

bool server_TakeStat( CBlob@ this, u8 stat, f32 value, u8 delay = 30 )
{
	f32 stat_value = getStat(this, stat);
	if (stat_value >= value)
	{
		server_SetStat(this, stat, stat_value - value, delay);
		return true;
	}
	return false;
}

bool client_TakeStat( CBlob@ this, u8 stat, f32 value, u8 delay = 30 )
{
	f32 stat_value = getStat(this, stat);
	if (stat_value >= value)
	{
		client_SetStat(this, stat, stat_value - value, delay);
		return true;
	}
	return false;
}

void server_RegenerateStat( CBlob@ this, u8 stat, u8 delay = 30 )
{
	server_SetStat(this, stat, getStat(this, stat) + getStatRegen(this, stat), delay);
}

void client_RegenerateStat( CBlob@ this, u8 stat, u8 delay = 30 )
{
	client_SetStat(this, stat, getStat(this, stat) + getStatRegen(this, stat), delay);
}

void server_SetStat( CBlob@ this, u8 stat, f32 value, u8 delay = 30, bool triggerDelay = true )
{
	if (getNet().isServer())
	{
		this.set_f32(Stats::STAT_PROPERTY + stat, Maths::Max(0, Maths::Min(getBaseStat(this, stat), value)));
	    this.Sync(Stats::STAT_PROPERTY + stat, true);

	    if (triggerDelay)
	    {
	        this.set_u32(Stats::STAT_REGEN_TIME_PROPERTY + stat, getGameTime() + delay);
	    }
	}
}

void client_SetStat( CBlob@ this, u8 stat, f32 value, u8 delay = 30, bool triggerDelay = true )
{
	this.set_f32(Stats::STAT_PROPERTY + stat, Maths::Max(0, Maths::Min(getBaseStat(this, stat), value)));

    if (triggerDelay)
    {
        this.set_u32(Stats::STAT_REGEN_TIME_PROPERTY + stat, getGameTime() + delay);
    }
}

f32 getStat( CBlob@ this, u8 stat )
{
	return this.get_f32(Stats::STAT_PROPERTY + stat);
}

f32 getBaseStat( CBlob@ this, u8 stat )
{
	return this.get_f32(Stats::BASE_STAT_PROPERTY + stat);
}

f32 getStatRegen( CBlob@ this, u8 stat )
{
	return this.get_f32(Stats::STAT_REGEN_PROPERTY + stat);
}

f32 getStatPercentage( CBlob@ this, u8 stat )
{
	return getPercentage(getStat(this, stat), getBaseStat(this, stat));
}
