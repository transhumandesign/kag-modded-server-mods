//Join and leave hooks for rulescore

#include "RulesCore.as"
#define SERVER_ONLY

void onNewPlayerJoin(CRules@ this, CPlayer@ player)
{
	RulesCore@ core;
	this.get("core", @core);

	if (core !is null)
	{
		/*int r = XORRandom(2); //random team on join
		if (r == 0)
		{
			player.server_setTeamNum(0);
		}
		else if (r == 1)
		{
			player.server_setTeamNum(1);
		}*/
		player.server_setTeamNum(0);
		core.AddPlayer(player);
	}
}

void onPlayerLeave(CRules@ this, CPlayer@ player)
{
	RulesCore@ core;
	this.get("core", @core);

	if (core !is null)
	{
		core.RemovePlayer(player);
	}
}
