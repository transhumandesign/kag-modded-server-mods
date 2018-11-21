//not server only so the client also gets the game event setup stuff

#include "Stats.as";

#include "GameplayEvents.as";

const int coinsOnDamageAdd = 10;
const int coinsOnKillAdd = 200;

const int coinsOnDeathLosePercent = 5;
const int coinsOnTKLose = 500;

const int coinsOnRestartAdd = 0;
const f32 coinsKeptScale = 0.2f;

const int coinsOnHitSiege = 0;
const int coinsOnKillSiege = 600;

const int coinsOnCapFlag = 1000;

const int coinsOnBuild = 20;
const int coinsOnBuildWood = 10;
const int coinsOnBuildWorkshop = 100;

const int warmupFactor = 2;

string[] names;

void GiveRestartCoins(CPlayer@ p)
{
	p.server_setCoins(Maths::Floor(p.getCoins() * coinsKeptScale));
}

void GiveRestartCoinsIfNeeded(CPlayer@ player)
{
	const string s = player.getUsername();
	for (uint i = 0; i < names.length; ++i)
	{
		if (names[i] == s)
		{
			return;
		}
	}

	names.push_back(s);
	GiveRestartCoins(player);
}

//extra coins on start to prevent stagnant round start
void Reset(CRules@ this)
{
	if (!getNet().isServer())
		return;

	names.clear();

	uint count = getPlayerCount();
	for (uint p_step = 0; p_step < count; ++p_step)
	{
		CPlayer@ p = getPlayer(p_step);
		GiveRestartCoins(p);
		names.push_back(p.getUsername());
	}
}

void onRestart(CRules@ this)
{
	Reset(this);
}

void onInit(CRules@ this)
{
	Reset(this);
}

//also given when plugging player -> on first spawn
void onSetPlayer(CRules@ this, CBlob@ blob, CPlayer@ player)
{
	if (!getNet().isServer())
		return;

	if (player !is null)
	{
		GiveRestartCoinsIfNeeded(player);
	}
}

//
// give coins for killing

void onPlayerDie(CRules@ this, CPlayer@ victim, CPlayer@ killer, u8 customData)
{
	if (!getNet().isServer())
		return;

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

				case GE_hit_player:

				{
					g.params.ResetBitIndex();
					f32 damage = g.params.read_f32();

					coins = Maths::Floor(damage);
				}

				break;

				case GE_hit_vehicle:

				{
					g.params.ResetBitIndex();
					f32 damage = g.params.read_f32();

					coins = Maths::Floor(damage);
				}

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
				if (this.isWarmup())
					coins /= warmupFactor;

				p.server_setCoins(p.getCoins() + coins);
			}
		}
	}
}