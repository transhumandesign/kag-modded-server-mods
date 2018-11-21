#include "ItemsSpawnerCommon.as";

void onRestart(CRules@ this)
{
	f32 game_time = getGameTime();

	this.set_f32("time_before_spawn", game_time + itemspawner_spawn_rate * 30.0f);
	this.set_bool("itemspawner_spawn", false);
}

void onTick( CRules@ this )
{
	f32 game_time = getGameTime();
	f32 time_before_spawn = this.get_f32("time_before_spawn");
	if (time_before_spawn <= getGameTime())
	{
		this.set_bool("itemspawner_spawn", true);
		this.set_f32("time_before_spawn", game_time + itemspawner_spawn_rate * 30.0f);
	}
	else
	{
		this.set_bool("itemspawner_spawn", false);
	}
}