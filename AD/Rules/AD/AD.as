#include "ADCommon.as"
#include "MakeCrate.as"
#include "Requirements_Tech.as";
//Attack & Deffend game logic

/*TODO:
scoreboard
helptext
princess killable by arrows
*/

Random rand(Time());
bool instant;

#define SERVER_ONLY

void onInit(CRules@ this)
{
    onRestart(this);

}

void onRestart(CRules@ this)
{
    instant = true;
    this.set_s32("build time", 150*30); //30 seconds 150
    s32 time = 150*30 + 60*10*30;
    this.set_s32("game duration", time); //ticks =  6 minutes 480
    this.set_s32("defender spawn", 8*30); //ticks
    this.set_s32("attacker spawn", 8*30); //ticks  

    this.set_s32("resupply time", getGameTime() + 45*30);
    this.Sync("resupply time", true);

    this.SetCurrentState(0); //intermission
    CMap@ map = getMap();
    Vec2f t = getPrincessSpawn();
    t.x -= 8;
    t.y -= 16;
    Vec2f t2 = t;
    t2.x += 8*3;
    t2.y += 8*4;
    map.server_AddSector(t, t2, "no build");
    server_CreateBlob("princess", 0, getPrincessSpawn());
    server_CreateBlob("tdm_spawn", 0, getSpawnLocation(0));

    this.set_s32("power crate time", getGameTime() + 50*30);
    this.set_s32("extra crate time", 0); //10

    RespawnList respawns;
    this.set("respawns", respawns);

    killPlayers(this);

}

void killPlayers(CRules@ this)
{
    RespawnList@ respawns;
    this.get("respawns", @respawns);
    if(respawns is null) return;

    int players = getPlayersCount();
    for(int i = 0; i < players; i++)
    {
        CPlayer@ player = getPlayer(i);
        if(player !is null)
        {
            player.server_setTeamNum(0);
            if(player.getBlob() !is null)
            {
                player.getBlob().server_Die();

            }

            respawns.defenders.push_back(RespawnPlayer(player.getUsername(), getGameTime() + 1));
    
        }

    }

}

Vec2f getPrincessSpawn()
{
    Vec2f[] spawns;
    if(getMap().getMarkers("gray spawn", spawns))
    {
        return spawns[ XORRandom(spawns.length) ];

    }

    return Vec2f(0, 0);

}

Vec2f getWarboatSpawn()
{
    Vec2f[] spawns;
    if (getMap().getMarkers("red spawn", spawns))
    {
	    return spawns[ XORRandom(spawns.length) ];
    }
    else if (getMap().getMarkers("red main spawn", spawns))
    {
	    return spawns[ XORRandom(spawns.length) ];
    }


    return Vec2f(0, 0);

}

/*void onPlayerRequestTeamChange(CRules@ this, CPlayer@ player, u8 newteam)
{
    player.server_setTeamNum(newteam);
    CBlob@ b = player.getBlob();
    if(b !is null)
        b.server_Die();
    else if(newteam != this.getSpectatorTeamNum())
        onPlayerRequestSpawn(this, player);

}*/

void onPlayerRequestSpawn(CRules@ this, CPlayer@ player)
{
    if(player is null)
        return;

    if(player.getTeamNum() == this.getSpectatorTeamNum())
        return;

    RespawnList@ respawns;
    this.get("respawns", @respawns);
    if(respawns is null) return;

    bool warmup = (this.isIntermission() || this.isWarmup());

    int team = player.getTeamNum();
    if(warmup)
    {
        if(team != 0)
        {
            player.server_setTeamNum(0);
            team = 0;

        }

        respawns.defenders.push_back(RespawnPlayer(player.getUsername(), getGameTime() + 1));
        return;

    }


    if(inRespawnQueue(respawns,player.getUsername()))
        return;

    int time = getGameTime();
    if(team == 0)
        time += this.get_s32("defender spawn");
    else
        time += this.get_s32("attacker spawn");

    if(instant)
        time = 0;

    RespawnPlayer rp(player.getUsername(), time);

    string prop = player.getUsername() + "_respawn";
    this.set_s32(prop, time);
    this.Sync(prop, true);

    if(team == 0)
        respawns.defenders.push_back(rp);
    else
        respawns.attackers.push_back(rp);

}

void onNewPlayerJoin( CRules@ this, CPlayer@ player)
{
    if(this.isMatchRunning())
    {
        player.server_setTeamNum(1);

    }
    else
    {
        player.server_setTeamNum(0);

    }

}

CBlob@ spawnPlayer(CRules@ this, CPlayer@ player)
{

    if(player.getBlob() !is null)
        player.getBlob().server_Die();

    int team = player.getTeamNum();
    if(team != 0 && (this.isWarmup() || this.isIntermission()))
    {
        team = 0;
        player.server_setTeamNum(0);

    }    

    string lastClass = player.lastBlobName;

    if(this.isWarmup())
        lastClass = "builder";

    if(lastClass.size() == 0)
    {
        if(team == 0)
        {
            lastClass = "builder";

        }
        else
        {
            lastClass = "knight";

        }

    }

    if(team == 0 && lastClass == "knight")
    {
        lastClass = "builder";

    }
    else if(team == 1 && lastClass == "builder")
    {
        lastClass = "knight";

    }

    CBlob@ blob = server_CreateBlob(lastClass, team, getSpawnLocation(team));
    blob.server_SetPlayer(player);
    return blob;

}

Vec2f getSpawnLocation(int team)
{
	Vec2f[] spawns;

    if(team == 0)
    {
	    if (getMap().getMarkers("blue spawn", spawns))
	    {
		    return spawns[ XORRandom(spawns.length) ];
	    }
	    else if (getMap().getMarkers("blue main spawn", spawns))
	    {
		    return spawns[ XORRandom(spawns.length) ];
	    }

    }
    else
    {
        CBlob@ warboat = getBlobByName("Caravel");
        if(warboat !is null)
        {
            return warboat.getPosition();

        }

        return getWarboatSpawn();

    }

	return Vec2f(0, 0);
}



void handleRespawns(CRules@ this)
{
    RespawnList@ respawns;
    this.get("respawns", @respawns);
    if(respawns is null) return;

    if(respawns.defenders.size() > 0)
    {
        if(respawns.defenders[0].time < getGameTime())
        {
            CPlayer@ player = getPlayerByUsername(respawns.defenders[0].name);
            if(player !is null)
            {
                spawnPlayer(this, player);

            }

            respawns.defenders.erase(0);

        }

    }
    
    /*
    if(respawns.attackers.size() > 0)
    {
        if(respawns.attackers[0].time < getGameTime())
        {
            CPlayer@ player = getPlayerByUsername(respawns.attackers[0].name);
            if(player !is null)
            {
                spawnPlayer(this, player);

            }

            respawns.attackers.erase(0);

        }

    }*/

}


void doResupply(CRules@ this)
{
    RespawnList@ respawns;
    this.get("respawns", @respawns);
    if(respawns is null) return;

    if(getGameTime()%5 == 0)
    {
        CBlob@[] spots;
        if(getBlobsByTag("givememats", @spots))
        {
            for(int i = 0; i < spots.size(); i++)
            {
                CBlob@ spot = spots[i];
                CBlob@[] overlapping;
                if (spot !is null && spot.getOverlapping(overlapping))
                {
                    for(int j = 0; j < overlapping.size(); j++)
                    {
                        CBlob@ overlapped = overlapping[j];
                        if(overlapped.getName() == "builder" && !overlapped.hasTag("dead") && overlapped.getTeamNum() == 0)
                        {
                            CPlayer@ player = overlapped.getPlayer();
                            if(player is null)
                                continue;

                            bool gotmats = gotMats(respawns, player);

                            if(!gotmats)
                            {
                                if(this.isWarmup() || this.isIntermission())
                                {
                                    SetMaterials(overlapped, "mat_wood", 300);
                                    SetMaterials(overlapped, "mat_stone", 100);

                                }
                                else
                                {
                                    SetMaterials(overlapped, "mat_wood", 120);
                                    SetMaterials(overlapped, "mat_stone", 30);

                                }
                                respawns.matsgiven.push_back(player.getUsername());

                            }
                  
                        }

                    }

                }

            }

        }

    }

}

void doSiegeDrop(CRules@ this)
{
    if(!this.isWarmup() && !this.isMatchRunning())
    {
        return;

    }

    Wave[]@ waves;
    this.get("waves", @waves);

    if(waves is null)
    {
        return;

    }
    
    int wavenum = this.get_s32("wave");

    if(wavenum >= 0)
    {
        Wave curwave = waves[wavenum];
        bool save = false;
        if(curwave.isSiegeDrop())
        {
            curwave.drop();
            save = true;

        }

        if(curwave.isCrateDrop())
        {
            curwave.dropCrate();
            save = true;

        }

        if(save)
        {
            waves[wavenum] = curwave;

        }

    }

    bool wavestart = (waves[wavenum+1].starttime < getGameTime());

    if(wavestart)
    {
        wavenum++;
        this.set_s32("wave", wavenum);
        this.Sync("wave", true);

        Wave wave = waves[wavenum]; //current spawning wave

        if(wave.unlockBombTech)
        {
            GiveFakeTech(getRules(), "bomb ammo", 0);
            GiveFakeTech(getRules(), "bomb ammo", 1);

        }

        this.set_s32("power crate time", waves[wavenum+1].starttime);

        //spawn wave code
        RespawnList@ respawns;
        this.get("respawns", @respawns);
        if(respawns is null) return;

        for(int i = 0; i < respawns.attackers.size(); i++)
        {
            CPlayer@ player = getPlayerByUsername(respawns.attackers[i].name);
            if(player !is null)
            {
                CBlob@ blob = spawnPlayer(this, player);
                wave.giveSpawnMats(blob);

            }

        }

        respawns.attackers.clear();

    }

}

void updateResupply(CRules@ this)
{
    RespawnList@ respawns;
    this.get("respawns", @respawns);
    if(respawns is null) return;

    bool resupply = this.get_s32("resupply time") < getGameTime() && (this.isWarmup() || this.isMatchRunning());
    if(resupply)
    {
        respawns.matsgiven.clear();
        this.set_s32("resupply time", getGameTime() + 45*30);
        this.Sync("resupply time", true);

    }

}

void onTick(CRules@ this)
{
    RespawnList@ respawns;
    this.get("respawns", @respawns);
    if(respawns is null) return;

    int gamestart = this.get_s32("gamestart");
    int gameDuration = this.get_s32("game duration");
    int buildTime = this.get_s32("build time");
	s32 ticksToStart = gamestart + buildTime - getGameTime();

    doSiegeDrop(this);

    updateResupply(this);
    doResupply(this);

    bool enoughplayers = getPlayersCount() >= 2;

    handleRespawns(this);

	if (ticksToStart <= 0 && (this.isWarmup()))
	{
		this.SetCurrentState(2); //game running
        CBlob@ princess = getBlobByName("princess");
        CBlob@ warboat = server_CreateBlob("Caravel", 1, getWarboatSpawn());
        server_CreateBlob("catapult", 1, warboat.getPosition());
        CBlob@ necro = server_CreateBlob("necromancer", 0, getSpawnLocation(0));
        CBlob@ spawn = getBlobByName("tdm_spawn");
        spawn.server_AttachTo(necro, "NECRO");

        server_CreateBlob("necromancer", 1, getSpawnLocation(1));

        //put people on red team

        int players = getPlayersCount();
        int aplayers = 0;
        for(int i = 0; i < players; i++)
        {
            CPlayer@ player = getPlayer(i);
            if(player !is null)
            {
                if(player.getTeamNum() == 0)
                    aplayers++;

            }

        }

        int numred = aplayers/2;
        while(numred > 0)
        {
            CPlayer@ player = getPlayer(rand.Next()%players);
            if(player !is null)
            {
                if(player.getTeamNum() == 0)
                {
                    player.server_setTeamNum(1);
                    numred--;

                    CBlob@ blob = player.getBlob();
                    if(blob !is null)
                    {
                        blob.server_Die(); //do this so they spawn on the other team
                        //onPlayerRequestSpawn(this, player);
                        respawns.ignorenext.push_back(player.getUsername());
                        respawns.attackers.push_back(RespawnPlayer(player.getUsername(), getGameTime() + 5));

                    }

                }

            }

        }

        instant = false;

	}

    if(!enoughplayers && (this.isMatchRunning() || this.isWarmup()))
    {
        this.SetCurrentState(0); //intermission
        LoadNextMap();
        this.RestartRules();

    }
	else if (this.isIntermission() && !enoughplayers)
	{
        instant = true;
		this.SetGlobalMessage("Not enough players in each team for the game to start.\nPlease wait for someone to join...");

	}
    else if(this.isIntermission() && enoughplayers)
    {
        this.SetCurrentState(1); //warmup
		gamestart = getGameTime();
        this.set_s32("gamestart", gamestart);
        this.Sync("gamestart", true);
		this.set_u32("game_end_time", gamestart + gameDuration);
    this.SetGlobalMessage("");

    }
    else if(this.isWarmup() && enoughplayers)
    {
    }
	else if (this.isMatchRunning())
	{
		this.SetGlobalMessage("");
        if(gamestart + gameDuration < getGameTime())
        {
            this.SetTeamWon(0);
            this.SetCurrentState(3);
            this.SetGlobalMessage("The Defenders survived!");

        }

        CBlob@ princess = getBlobByName("princess");
        if(princess is null || (princess !is null && princess.hasTag("dead")))
        {
            this.SetTeamWon(1);
            this.SetCurrentState(3);
            this.SetGlobalMessage("The Barbarians killed the princess!");

        }

	}

}

void onSetPlayer(CRules@ this, CBlob@ blob, CPlayer@ player)
{
	if (!getNet().isServer())
		return;

	if (blob !is null && player !is null)
	{
       
        int team = player.getTeamNum();
        if(team == 0 && blob.getName() == "builder")
        {
            RespawnList@ respawns;
            this.get("respawns", @respawns);
            if(respawns is null) return;

            bool gotmats = gotMats(respawns, player);

            if(!gotmats)
            {
                if(this.isWarmup() || this.isIntermission())
                {
                    SetMaterials(blob, "mat_wood", 300);
                    SetMaterials(blob, "mat_stone", 100);

                }
                else
                {
                    SetMaterials(blob, "mat_wood", 120);
                    SetMaterials(blob, "mat_stone", 45);

                }
                respawns.matsgiven.push_back(player.getUsername());

            }
              
        }
        else if(blob.getName() == "archer")
        {
            SetMaterials(blob, "mat_arrows", 30);

        }

	}
}
