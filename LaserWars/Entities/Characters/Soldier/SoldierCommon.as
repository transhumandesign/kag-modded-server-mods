/* SoldierCommon.as
 * author: Aphelion
 */

#include "PlayerProfilesCommon.as";
#include "ItemsCommon.as";
#include "GunsCommon.as";

#include "Stats.as";

const string type_active_property = "item type active";
const string type_property = "item type ";

namespace GrenadeType
{
	enum type
	{
		grenade = 0,
		emp_grenade,
		contact_grenade,
		count,
	};
}

const string[] grenadeNames =
{
	"Grenade",
    "EMP Grenade",
    "Contact Grenade"
};

const string[] grenadeTypeNames =
{
	"mat_grenades",
    "mat_empgrenades",
    "mat_contactgrenades"
};

const string[] suits =
{
	"assault",
	"logistics",
	"sentinel",
	"infiltrator"
};

void server_Setup( CBlob@ this, CPlayer@ player )
{
	if (!getNet().isServer()) return;

	PlayerProfile@ profile = server_GetOrCreateProfile(player);
	ExoSuit@ suit;

	if (player.isBot())
	{
		@suit = getSuit(suits[XORRandom(suits.length)]);

		Item@ weapon = getItem(suit.default_primary);

		Item[][]@ items = getItems();
		for(uint i = 0; i < 10; i++)
		{
			Item@ item = items[1][XORRandom(items[1].length)];
			if   (item.availableTo(suit.flag) && (item.isFree() || player.getCoins() >= item.price))
			{
				@weapon = item;
				break;
			}
		}

		//@weapon = getItem("sniper_rifle");

		setItem(this, ItemType::EXO_SUIT, suit.name);
		setItem(this, ItemType::WEAPON_PRIMARY, weapon.blob == "pulse_rifle"   ? "combat_rifle" :
			                                    weapon.blob == "gatling_laser" ? "lmg" : 
			                                    weapon.blob);
		setItem(this, ItemType::WEAPON_SIDEARM, "ion_pistol");
	}
	else
	{
	    @suit = getSuit(profile.loadout_exosuit);

		setItem(this, ItemType::EXO_SUIT, profile.loadout_exosuit);
		setItem(this, ItemType::WEAPON_PRIMARY, profile.loadout_primary);
		setItem(this, ItemType::WEAPON_SIDEARM, profile.loadout_sidearm);
	}
	
	if (suit !is null)
	{
		server_CreateStat(this, Stats::SHIELD, suit.shield, suit.shield_regen);
		server_CreateStat(this, Stats::HEALTH, suit.armour, suit.armour_regen);
		server_CreateStat(this, Stats::ENERGY, suit.energy, suit.energy_regen);

		GunInfo@ primary = getGunInfoByName(getItem(this, ItemType::WEAPON_PRIMARY));
		GunInfo@ sidearm = getGunInfoByName(getItem(this, ItemType::WEAPON_SIDEARM));

		if (primary !is null)
		{
			server_CreateStat(this, Stats::AMMO_1, primary.fireInfo.magazine, 0);
		}

		if (sidearm !is null)
		{
			server_CreateStat(this, Stats::AMMO_2, sidearm.fireInfo.magazine, 0);
		}

		this.set_f32("movement_factor", suit.movement_factor);
		this.Sync("movement_factor", true);
	}
}

u8 GetAmmo( CBlob@ this )
{
	GunInfo@ gunInfo = getGunInfoByName(getActiveItem(this));

	if (gunInfo !is null)
	{
		return GetAmmo(this, gunInfo.fireInfo);
	}
	return 0;
}

u8 GetAmmo( CBlob@ this, FireInfo info )
{
	u8 ammoType = info.ammoType;

	switch(ammoType)
	{
		case AmmoType::PRIMARY:
		{
			return Maths::Floor(getStat(this, Stats::AMMO_1));
		}

		case AmmoType::SIDEARM:
		{
			return Maths::Floor(getStat(this, Stats::AMMO_2));
		}

		case AmmoType::ITEM:
		{
			return Maths::Floor(this.getBlobCount(info.ammoBlob) / info.ammoRequired);
		}
	}
	return 0;
}

bool HasAmmo( CBlob@ this )
{
	GunInfo@ gunInfo = getGunInfoByName(getActiveItem(this));

	if (gunInfo !is null)
	{
		return HasAmmo(this, gunInfo.fireInfo);
	}
	return false;
}

bool HasAmmo( CBlob@ this, FireInfo info )
{
	u8 ammoType = info.ammoType;

	switch(ammoType)
	{
		case AmmoType::PRIMARY:
		{
			return HasStat(this, Stats::AMMO_1, 1);
		}

		case AmmoType::SIDEARM:
		{
			return HasStat(this, Stats::AMMO_2, 1);
		}

		case AmmoType::ITEM:
		{
			return this.getBlobCount(info.ammoBlob) >= info.ammoRequired;
		}
	}
	return false;
}

bool TakeAmmo( CBlob@ this, FireInfo info )
{
	u8 ammoType = info.ammoType;

	switch(ammoType)
	{
		case AmmoType::PRIMARY:
		{
			return client_TakeStat(this, Stats::AMMO_1, 1, 30);
		}

		case AmmoType::SIDEARM:
		{
			return client_TakeStat(this, Stats::AMMO_2, 1, 30);
		}

		case AmmoType::ITEM:
		{
			return getNet().isServer() ? this.TakeBlob(info.ammoBlob, info.ammoRequired) >= info.ammoRequired :
			                             HasAmmo(this, info); // just check to see if we have it, cant take the blob clientside
		}
	}
	return false;
}

void RegenerateAmmo( CBlob@ this, GunInfo@ info )
{
	FireInfo@ fireInfo = info.fireInfo;

	u8 ammoType = fireInfo.ammoType;
	if(ammoType == AmmoType::ITEM) return;

	u8 stat = ammoType == AmmoType::PRIMARY ? Stats::AMMO_1 :
	                                          Stats::AMMO_2;

	const u32 gametime = getGameTime();

	if (getNet().isServer() && this.isBot())
	{
		if (gametime >= this.get_u32(Stats::STAT_REGEN_TIME_PROPERTY + stat))
		{
			server_SetStat(this, stat, getStat(this, stat) + fireInfo.ammoRegen, 15);
		}
	}

	if (getNet().isClient())
	{
		if (gametime >= this.get_u32(Stats::STAT_REGEN_TIME_PROPERTY + stat))
		{
			client_SetStat(this, stat, getStat(this, stat) + fireInfo.ammoRegen, 15);
		}
	}
}

ExoSuit@ getSuit( string name )
{
	for(uint i = 0; i < ExoSuits::suits.length; i++)
	{
		ExoSuit@ suit = ExoSuits::suits[i];
		
		if (suit.name == name)
		{
			return suit;
		}
	}
	return null;
}

u8 getActiveType( CBlob@ this )
{
	return this.get_u8(type_active_property);
}

string getActiveItem( CBlob@ this )
{
    return getItem(this, getActiveType(this));
}

string getItem( CBlob@ this, u8 type )
{
    return this.get_string(type_property + type);
}

void setActive( CBlob@ this, u8 type )
{
    this.set_u8(type_active_property, type);
	this.Sync(type_active_property, true);
}

void setItem( CBlob@ this, u8 type, string item )
{
    this.set_string(type_property + type, item);
	this.Sync(type_property + type, true);
}
