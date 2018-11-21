// Vehicle Workshop

#include "Requirements.as";
#include "Requirements_Tech.as";
#include "ShopCommon.as";
#include "Descriptions.as";
#include "WARCosts.as";
#include "CheckSpam.as";

const s32 cost_catapult = 80;
const s32 cost_ballista = 200;
const s32 cost_dinghy = 25;
const s32 cost_longboat = 50;
const s32 cost_warboat = 250;
const s32 cost_glider = 500;
const s32 cost_zeppelin = 1000;
const s32 cost_ballista_ammo = 100;
const s32 cost_ballista_ammo_upgrade_gold = 100;

void onInit(CBlob@ this)
{
	this.set_TileType("background tile", CMap::tile_castle_back);

	this.getSprite().SetZ(-50); //background
	this.getShape().getConsts().mapCollisions = false;

	AddIconToken("$vehicleshop_upgradebolts$", "BallistaBolt.png", Vec2f(32, 8), 1);

	// SHOP
	this.set_Vec2f("shop offset", Vec2f(0, 0));
	this.set_Vec2f("shop menu size", Vec2f(3, 5));
	this.set_string("shop description", "Buy Vehicles");
	this.set_u8("shop icon", 25);

	{
		ShopItem@ s = addShopItem(this, "Catapult", "$catapult$", "catapult", "$catapult$\n\n\n" + descriptions[5], false, true);
		s.crate_icon = 4;
		AddRequirement(s.requirements, "coin", "", "Coins", 100);
	}
	{
		ShopItem@ s = addShopItem(this, "Ballista", "$ballista$", "ballista", "$ballista$\n\n\n" + descriptions[6], false, true);
		s.crate_icon = 5;
		AddRequirement(s.requirements, "coin", "", "Coins", 200);
	}
	{
		ShopItem@ s = addShopItem(this, "Tank", "$tank$", "tank", "$tank$\n\n\n" + "Packs quite a punch.", false, true);
		s.crate_icon = 11;
		AddRequirement(s.requirements, "coin", "", "Coins", 300);
	}
	{
		ShopItem@ s = addShopItem(this, "Zeppelin", "$zeppelin$", "zeppelin", "Flying warship.", false, true);
		AddRequirement(s.requirements, "coin", "", "Coins", 600);
		s.crate_icon = 19;
	}
	{
		ShopItem@ s = addShopItem(this, "Ballon", "$balloon$", "balloon", "A small ballon, fitting for 2 people.", false, true);
		AddRequirement(s.requirements, "coin", "", "Coins", 400);
		s.crate_icon = 7;
	}	
	{
		ShopItem@ s = addShopItem(this, "Glider", "$glider$", "glider", "A small and fast airship.", false, true);
		AddRequirement(s.requirements, "coin", "", "Coins", 200);
		s.crate_icon = 3;
	}
	{
		ShopItem@ s = addShopItem(this, "Raft", "$raft$", "raft", "$raft$\n\n\n" + "You're a big boat.", false, true);
		AddRequirement(s.requirements, "coin", "", "Coins", 25);
		s.crate_icon = 0;
	}	
	{
		ShopItem@ s = addShopItem(this, "Dinghy", "$dinghy$", "dinghy", "$dinghy$\n\n\n" + descriptions[10], false, true);
		AddRequirement(s.requirements, "coin", "", "Coins", 50);
		s.crate_icon = 10;
	}
	{
		ShopItem@ s = addShopItem(this, "Longboat", "$longboat$", "longboat", "$longboat$\n\n\n" + descriptions[33], false, true);
		AddRequirement(s.requirements, "coin", "", "Coins", 100);
		s.crate_icon = 1;
	}
	{
		ShopItem@ s = addShopItem(this, "War Boat", "$warboat$", "warboat", "$warboat$\n\n\n" + descriptions[37], false, true);
		AddRequirement(s.requirements, "coin", "", "Coins", 200);
		s.crate_icon = 2;
	}
	{
		ShopItem@ s = addShopItem(this, "Cannon Balls", "$mat_cannonballs$", "mat_cannonballs", "Ammo for your cannons.", true);
		AddRequirement(s.requirements, "coin", "", "Coins", 100 );
	}	
	{
		ShopItem@ s = addShopItem(this, "CrossBolts", "$mat_crossbolts$", "mat_crossbolts", "Bolts for your crossbows.", true);
		AddRequirement(s.requirements, "coin", "", "Coins", 50 );
	}		
	{
		ShopItem@ s = addShopItem(this, "Ballista Ammo", "$mat_bolts$", "mat_bolts", "$mat_bolts$\n\n\n" + descriptions[15], false, false);
		s.crate_icon = 5;
		AddRequirement(s.requirements, "coin", "", "Coins", cost_ballista_ammo);
	}
	{
		ShopItem@ s = addShopItem(this, "Bomb Bolt Upgrade", "$vehicleshop_upgradebolts$", "upgradebolts", "For Ballista\nTurns its piercing bolts into a shaped explosive charge.", false);
		s.spawnNothing = true;
		AddRequirement(s.requirements, "blob", "mat_gold", "Gold", cost_ballista_ammo_upgrade_gold);
		AddRequirement(s.requirements, "not tech", "bomb ammo", "Bomb Bolt", 1);
	}
}

void GetButtonsFor(CBlob@ this, CBlob@ caller)
{
	u8 kek = caller.getTeamNum();	
	if (kek == 0)
	{
		this.set_bool("shop available", this.isOverlapping(caller));
	}
}

void onCommand(CBlob@ this, u8 cmd, CBitStream @params)
{
	if (cmd == this.getCommandID("shop made item"))
	{
		this.getSprite().PlaySound("/ChaChing.ogg");
		bool isServer = (getNet().isServer());
		u16 caller, item;
		if (!params.saferead_netid(caller) || !params.saferead_netid(item))
		{
			return;
		}
		string name = params.read_string();
		{
			if (name == "upgradebolts")
			{
				GiveFakeTech(getRules(), "bomb ammo", this.getTeamNum());
			}
		}
	}
}
