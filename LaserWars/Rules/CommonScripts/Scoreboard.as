/* Scoreboard.as
 * author: Aphelion
 */

#include "PlayerProfilesCommon.as";

// set kills and deaths
void onBlobDie( CRules@ this, CBlob@ blob )
{
	if (blob !is null)
	{
		CPlayer@ killer = blob.getPlayerOfRecentDamage();
		CPlayer@ victim = blob.getPlayer();

		if (victim !is null)
		{
			IncrementDeaths(victim);
			UpdateScore(victim);

			if (killer !is null)
			{
				if (killer.getTeamNum() != blob.getTeamNum())
				{
					IncrementKills(killer);
					UpdateScore(killer);
				}
			}
		}
	}
}

void UpdateScore( CPlayer@ player )
{
	f32 score_positive = 50 * player.getKills();
	f32 score_negative = 25 * player.getDeaths();

	player.setScore(Maths::Max(0, score_positive - score_negative));
}

void IncrementKills( CPlayer@ player )
{
	player.setKills(player.getKills() + 1);

	if (getLocalPlayer() is player || getNet().isServer())
	{
		PlayerProfile@ profile = getProfile(player);

		if (profile !is null)
		{
			profile.kills++;
		}
	}
}

void IncrementDeaths( CPlayer@ player )
{
	player.setDeaths(player.getDeaths() + 1);

	if (getLocalPlayer() is player || getNet().isServer())
	{
		PlayerProfile@ profile = getProfile(player);

		if (profile !is null)
		{
			profile.deaths++;
		}
    }
}
