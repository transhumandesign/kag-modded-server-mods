#include "TradingCommon.as"
#include "Descriptions.as"
#include "GameplayEvents.as"

#define SERVER_ONLY

const int coinsOnDamageAdd = 2;
const int coinsOnKillAdd = 10;

const int coinsOnDeathLosePercent = 20;
const int coinsOnTKLose = 50;

const int coinsOnRestartAdd = 0;
const bool keepCoinsOnRestart = false;

const int coinsOnHitSiege = 2;
const int coinsOnKillSiege = 0;

const int coinsOnCapFlag = 100;

const int coinsOnBuild = 1;
const int coinsOnBuildWood = 1;
const int coinsOnBuildWorkshop = 2;

int min_coins = 15;

//
string cost_config_file = "ad_vars.cfg";
bool kill_traders_and_shops = false;

//something with traders
void Reset(CRules@ this)
{
	cost_config_file = "ad_vars.cfg";

	ConfigFile cfg = ConfigFile();
	cfg.loadFile(cost_config_file);

	kill_traders_and_shops = !(cfg.read_bool("spawn_traders_ever", true));

	if (kill_traders_and_shops)
	{
		KillTradingPosts();
	}

}


//////COINS YOU GET WHEN THE MAP RESTARTS OR FIRST JOIN//////////
void onInit(CRules@ this)
{
    onRestart(this);

}

void onRestart(CRules@ this)
{
    Reset(this);

    int players = getPlayersCount();
    for(int i = 0; i < players; i++)
    {
        CPlayer@ player = getPlayer(i);
        player.server_setCoins(coinsOnRestartAdd);

    }

}

void onNewPlayerJoin( CRules@ this, CPlayer@ player)
{
    player.server_setCoins(coinsOnRestartAdd);

}

void onSetPlayer(CRules@ this, CBlob@ blob, CPlayer@ player)
{
    if(player is null)
        return;

    int team = player.getTeamNum();
    if(player.getCoins() < min_coins)
        player.server_setCoins(min_coins);

}

//handles rogue traders!!
void onBlobCreated(CRules@ this, CBlob@ blob)
{
	if (blob.getName() == "tradingpost")
	{
		if (kill_traders_and_shops)
		{
			blob.server_Die();
			KillTradingPosts();
		}
		else
		{
			MakeTradeMenu(blob);
		}
	}
}

TradeItem@ addItemForCoin(CBlob@ this, const string &in name, int cost, const bool instantShipping, const string &in iconName, const string &in configFilename, const string &in description)
{
	TradeItem@ item = addTradeItem(this, name, 0, instantShipping, iconName, configFilename, description);
	if (item !is null && cost > 0)
	{
		AddRequirement(item.reqs, "coin", "", "Coins", cost);
		item.buyIntoInventory = true;
	}
	return item;
}

void MakeTradeMenu(CBlob@ trader)
{
	//load config


	cost_config_file = "ad_vars.cfg";

	ConfigFile cfg = ConfigFile();
	cfg.loadFile(cost_config_file);

	s32 cost_bombs = cfg.read_s32("cost_bombs", 20);
	s32 cost_waterbombs = cfg.read_s32("cost_waterbombs", 40);
	s32 cost_keg = cfg.read_s32("cost_keg", 80);
	s32 cost_mine = cfg.read_s32("cost_mine", 50);

	s32 cost_arrows = cfg.read_s32("cost_arrows", 10);
	s32 cost_waterarrows = cfg.read_s32("cost_waterarrows", 40);
	s32 cost_firearrows = cfg.read_s32("cost_firearrows", 30);
	s32 cost_bombarrows = cfg.read_s32("cost_bombarrows", 50);

	s32 cost_mountedbow = cfg.read_s32("cost_mountedbow", 100);
	s32 cost_drill = cfg.read_s32("cost_drill", 0);
	s32 cost_boulder = cfg.read_s32("cost_boulder", 50);
	s32 cost_burger = cfg.read_s32("cost_burger", 40);

	s32 cost_catapult = cfg.read_s32("cost_catapult", 100);
	s32 cost_ballista = cfg.read_s32("cost_ballista", 150);

	s32 menu_width = cfg.read_s32("trade_menu_width", 3);
	s32 menu_height = cfg.read_s32("trade_menu_height", 5);

	// build menu
	CreateTradeMenu(trader, Vec2f(menu_width, menu_height), "Buy weapons");

	//
	addTradeSeparatorItem(trader, "$MENU_GENERIC$", Vec2f(3, 1));

	if (cost_bombs > 0)
		addItemForCoin(trader, "Bomb", cost_bombs, true, "$mat_bombs$", "mat_bombs", Descriptions::bomb);

	if (cost_waterbombs > 0)
		addItemForCoin(trader, "Water Bomb", cost_waterbombs, true, "$mat_waterbombs$", "mat_waterbombs", Descriptions::waterbomb);

	if (cost_keg > 0)
		addItemForCoin(trader, "Keg", cost_keg, true, "$keg$", "keg", Descriptions::keg);

	if (cost_mine > 0)
		addItemForCoin(trader, "Mine", cost_mine, true, "$mine$", "mine", Descriptions::mine);


	if (cost_arrows > 0)
		addItemForCoin(trader, "Arrows", cost_arrows, true, "$mat_arrows$", "mat_arrows", Descriptions::arrows);

	if (cost_waterarrows > 0)
		addItemForCoin(trader, "Water Arrows", cost_waterarrows, true, "$mat_waterarrows$", "mat_waterarrows", Descriptions::waterarrows);

	if (cost_firearrows > 0)
		addItemForCoin(trader, "Fire Arrows", cost_firearrows, true, "$mat_firearrows$", "mat_firearrows", Descriptions::firearrows);

	if (cost_bombarrows > 0)
		addItemForCoin(trader, "Bomb Arrow", cost_bombarrows, true, "$mat_bombarrows$", "mat_bombarrows", Descriptions::bombarrows);

	if (cost_boulder > 0)
		addItemForCoin(trader, "Boulder", cost_boulder, true, "$boulder$", "boulder", Descriptions::boulder);

	if (cost_burger > 0)
		addItemForCoin(trader, "Burger", cost_burger, true, "$food$", "food", "Food for healing. Don't think about this too much.");


	if (cost_catapult > 0)
		addItemForCoin(trader, "Catapult", cost_catapult, true, "$catapult$", "catapult", Descriptions::catapult);

	if (cost_ballista > 0)
		addItemForCoin(trader, "Ballista", cost_ballista, true, "$ballista$", "ballista", Descriptions::ballista);

}

void KillTradingPosts()
{
	CBlob@[] tradingposts;
	bool found = false;
	if (getBlobsByName("tradingpost", @tradingposts))
	{
		for (uint i = 0; i < tradingposts.length; i++)
		{
			CBlob @b = tradingposts[i];
			b.server_Die();
		}
	}
}

// give coins for killing

void onPlayerDie(CRules@ this, CPlayer@ victim, CPlayer@ killer, u8 customData)
{
	if (victim !is null)
	{
		if (killer !is null)
		{
			if (killer !is victim && killer.getTeamNum() != victim.getTeamNum())
			{
				killer.server_setCoins(killer.getCoins() + coinsOnKillAdd);
			}
			else if (killer.getTeamNum() == victim.getTeamNum())
			{
				killer.server_setCoins(killer.getCoins() - coinsOnTKLose);
			}
		}

		s32 lost = victim.getCoins() * (coinsOnDeathLosePercent * 0.01f);

		victim.server_setCoins(victim.getCoins() - lost);

		//drop coins
		CBlob@ blob = victim.getBlob();
		if (blob !is null)
			server_DropCoins(blob.getPosition(), XORRandom(lost));
	}
}

// give coins for damage
f32 onPlayerTakeDamage(CRules@ this, CPlayer@ victim, CPlayer@ attacker, f32 DamageScale)
{
	if (attacker !is null && attacker !is victim && attacker.getTeamNum() != victim.getTeamNum())
	{
		attacker.server_setCoins(attacker.getCoins() + DamageScale * coinsOnDamageAdd / this.attackdamage_modifier);
	}

	return DamageScale;
}

// coins for various game events
void onCommand(CRules@ this, u8 cmd, CBitStream @params)
{
	//only important on server
	if (!getNet().isServer())
		return;

	if (cmd == getGameplayEventID(this))
	{
		GameplayEvent g(params);

		CPlayer@ p = g.getPlayer();
		if (p !is null)
		{
			u32 coins = 0;

			switch (g.getType())
			{
				case GE_built_block:

				{
					g.params.ResetBitIndex();
					u16 tile = g.params.read_u16();
					if (tile == CMap::tile_castle)
					{
						coins = coinsOnBuild;
					}
					else if (tile == CMap::tile_wood)
					{
						coins = coinsOnBuildWood;
					}
				}

				break;

				case GE_built_blob:

				{
					g.params.ResetBitIndex();
					string name = g.params.read_string();

					if (name.findFirst("door") != -1 ||
					        name == "wooden_platform" ||
					        name == "trap_block" ||
					        name == "spikes")
					{
						coins = coinsOnBuild;
					}
					else if (name == "building")
					{
						coins = coinsOnBuildWorkshop;
					}
				}

				break;

				case GE_hit_vehicle:
					coins = coinsOnHitSiege;
					break;

				case GE_kill_vehicle:
					coins = coinsOnKillSiege;
					break;

				case GE_captured_flag:
					coins = coinsOnCapFlag;
					break;
			}

			if (coins > 0)
			{
				p.server_setCoins(p.getCoins() + coins);
			}
		}
	}
}
