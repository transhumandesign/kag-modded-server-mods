// Munitions.as

#include "IconsCommon.as";

#include "Requirements.as"
#include "ShopCommon.as";
#include "Descriptions.as";
#include "WARCosts.as";
#include "CheckSpam.as";
#include "CTFShopCommon.as";

s32 cost_plasma_cells = 50;
s32 cost_swarm_missile = 200;
s32 cost_light_missile = 600;

s32 cost_grenade = 150;
s32 cost_emp_grenade = 200;
s32 cost_contact_grenade = 300;
s32 cost_mine = 500;
s32 cost_c4 = 1000;

void onInit(CBlob@ this)
{
	this.set_TileType("background tile", CMap::tile_castle_back);

	this.getSprite().SetZ(-50); //background
	this.getShape().getConsts().mapCollisions = false;

	// SHOP
	this.set_Vec2f("shop offset", Vec2f_zero);
	this.set_Vec2f("shop menu size", Vec2f(4, 2));
	this.set_string("shop description", "Buy");
	this.set_u8("shop icon", 25);

	int team = this.getTeamNum();

	{
		ShopItem@ s = addShopItem(this, "Plasma Grenade", getIcon("mat_grenades", team), "mat_grenades", "A thermal grenade designed to melt through armour", true);
		AddRequirement(s.requirements, "coin", "", "Coins", cost_grenade);
	}
	{
		ShopItem@ s = addShopItem(this, "EMP Grenade", getIcon("mat_empgrenades", team), "mat_empgrenades", "Designed to disrupt shielding and destroy deployed objects", true);
		AddRequirement(s.requirements, "coin", "", "Coins", cost_emp_grenade);
	}
	{
		ShopItem@ s = addShopItem(this, "Contact Grenade", getIcon("mat_contactgrenades", team), "mat_contactgrenades", "A highly explosive grenade designed to detonate on contact", true);
		AddRequirement(s.requirements, "coin", "", "Coins", cost_contact_grenade);
	}
	{
		ShopItem@ s = addShopItem(this, "Proximity Mine", getIcon("proximity_mine", team), "mine", "A self-cloaking mine that activates in the proximity of an enemy", false);
		AddRequirement(s.requirements, "coin", "", "Coins", cost_mine);
	}
	{
		ShopItem@ s = addShopItem(this, "Plasma Cells", getIcon("mat_cells", team), "mat_cells", getIcon("mat_cells", team) + "\n\n\nPlasma Cells\n\nUsed to power plasma-based weapons\n\nAmmunition for the Plasma Mortar and Plasma Cannon", false, false);
		AddRequirement(s.requirements, "coin", "", "Coins", cost_plasma_cells);
	}
	{
		ShopItem@ s = addShopItem(this, "Swarm Missiles", getIcon("mat_swarms", team), "mat_swarms", getIcon("mat_swarms", team) + "\n\n\nSwarm Missiles\n\nHeat-seeking missiles that hone in on hostile infantry and vehicles\n\nAmmunition for the Swarm Launcher\n\nDMG: 10/5 x 3", false, false);
		AddRequirement(s.requirements, "coin", "", "Coins", cost_swarm_missile);
	}
	{
		ShopItem@ s = addShopItem(this, "Light Missile", getIcon("mat_missiles", team), "mat_missiles", getIcon("mat_missiles", team) + "\n\n\nLight Missile\n\nA guided missile capable of obliterating vehicles and buildings\n\nAmmunition for the Missile Launcher\n\nDMG: 90/60", false, false);
		AddRequirement(s.requirements, "coin", "", "Coins", cost_light_missile);
	}
	{
		ShopItem@ s = addShopItem(this, "C4", getIcon("c4", team), "keg", "Highly explosive", false);
		AddRequirement(s.requirements, "coin", "", "Coins", cost_c4);
	}
}

void GetButtonsFor(CBlob@ this, CBlob@ caller)
{
	this.set_Vec2f("shop offset", Vec2f_zero);
	this.set_bool("shop available", this.isOverlapping(caller));
}

void onCommand(CBlob@ this, u8 cmd, CBitStream @params)
{
	if (cmd == this.getCommandID("shop made item"))
	{
		this.getSprite().PlaySound("/ChaChing.ogg");
	}
}

void onHealthChange(CBlob@ this, f32 oldHealth)
{
	CSprite@ sprite = this.getSprite();
	if (sprite !is null)
	{
		Animation@ destruction = sprite.getAnimation("destruction");
		if (destruction !is null)
		{
			f32 frame = Maths::Floor((this.getInitialHealth() - this.getHealth()) / (this.getInitialHealth() / sprite.animation.getFramesCount()));
			sprite.animation.frame = frame;
		}
	}
}
