// ArcherShop.as

#include "Requirements.as";
#include "ShopCommon.as";
#include "Descriptions.as";
#include "CheckSpam.as";
#include "CTFShopCommon.as";

s32 cost_arrows = 15;
s32 cost_waterarrows = 20;
s32 cost_firearrows = 30;
s32 cost_bombarrows = 50;

void onInit(CBlob@ this)
{
	this.set_TileType("background tile", CMap::tile_wood_back);

	this.getSprite().SetZ(-50); //background
	this.getShape().getConsts().mapCollisions = false;

	//load config
	if (getRules().exists("ctf_costs_config"))
	{
		cost_config_file = getRules().get_string("ctf_costs_config");
	}

	ConfigFile cfg = ConfigFile();
	cfg.loadFile(cost_config_file);

	cost_arrows = cfg.read_s32("cost_arrows", cost_arrows);
	cost_waterarrows = cfg.read_s32("cost_waterarrows", cost_waterarrows);
	cost_firearrows = cfg.read_s32("cost_firearrows", cost_firearrows);
	cost_bombarrows = cfg.read_s32("cost_bombarrows", cost_bombarrows);

	// Icons
	AddIconToken("$stickynade$", "StickyNade.png", Vec2f(16, 16), 7);

	// SHOP
	this.set_Vec2f("shop offset", Vec2f_zero);
	this.set_Vec2f("shop menu size", Vec2f(5, 1));
	this.set_string("shop description", "Buy");
	this.set_u8("shop icon", 25);

	// CLASS
	this.set_Vec2f("class offset", Vec2f(-12, 0));

	{
		ShopItem@ s = addShopItem(this, "Arrows", "$mat_arrows$", "mat_arrows", descriptions[2], true);
		AddRequirement(s.requirements, "coin", "", "Coins", cost_arrows);
	}
	{
		ShopItem@ s = addShopItem(this, "Water Arrows", "$mat_waterarrows$", "mat_waterarrows", descriptions[50], true);
		AddRequirement(s.requirements, "coin", "", "Coins", cost_waterarrows);
	}
	{
		ShopItem@ s = addShopItem(this, "Fire Arrows", "$mat_firearrows$", "mat_firearrows", descriptions[32], true);
		AddRequirement(s.requirements, "coin", "", "Coins", cost_firearrows);
	}
	{
		ShopItem@ s = addShopItem(this, "Bomb Arrows", "$mat_bombarrows$", "mat_bombarrows", descriptions[51], true);
		AddRequirement(s.requirements, "coin", "", "Coins", cost_bombarrows);
	}
	{
		ShopItem@ s = addShopItem(this, "Sticky Nade", "$stickynade$", "stickynade", "Higly explosive, sticks to walls!", true);
		AddRequirement(s.requirements, "coin", "", "Coins", 60);
	}
	this.set_string("required class", "archer");
}

void GetButtonsFor(CBlob@ this, CBlob@ caller)
{
	if(caller.getConfig() == this.get_string("required class"))
	{
		this.set_Vec2f("shop offset", Vec2f_zero);
	}
	else
	{
		this.set_Vec2f("shop offset", Vec2f(12, 0));
	}
	this.set_bool("shop available", this.isOverlapping(caller));
}

void onCommand(CBlob@ this, u8 cmd, CBitStream @params)
{
	if(cmd == this.getCommandID("shop made item"))
	{
		this.getSprite().PlaySound("/ChaChing.ogg");
	}
}

void onHealthChange(CBlob@ this, f32 oldHealth)
{
	CSprite@ sprite = this.getSprite();
	if(sprite !is null)
	{
		Animation@ destruction = sprite.getAnimation("destruction");
		if (destruction !is null)
		{
			f32 frame = Maths::Floor((this.getInitialHealth() - this.getHealth()) / (this.getInitialHealth() / sprite.animation.getFramesCount()));
			sprite.animation.frame = frame;
		}
	}
}