
//Zombies gamemode logic script
//Modded by Eanmig (Edited by Frikman)
#define SERVER_ONLY

#include "CTF_Structs.as";
#include "RulesCore.as";
#include "RespawnSystem.as";

//simple config function - edit the variables below to change the basics

void Config(ZombiesCore@ this)
{

    string configstr = "../Mods/" + sv_gamemode + "/Rules/zombies_vars.cfg";
	if (getRules().exists("Zombiesconfig")) {
	   configstr = getRules().get_string("Zombiesconfig");
	}
	ConfigFile cfg = ConfigFile( configstr );
	
	//how long for the game to play out?
    s32 gameDurationMinutes = cfg.read_s32("game_time",-1);
    if (gameDurationMinutes <= 0)
    {
		this.gameDuration = 0;
		getRules().set_bool("no timer", true);
	}
    else
    {
		this.gameDuration = (getTicksASecond() * 60 * gameDurationMinutes);
	}
	
    bool destroy_dirt = cfg.read_bool("destroy_dirt",true);
	getRules().set_bool("destroy_dirt", destroy_dirt);
	bool grave_spawn = cfg.read_bool("grave_spawn",false);
	
	s32 max_zombies = cfg.read_s32("game_time",125);
	if (max_zombies<50) max_zombies=50;
	s32 max_pzombies = cfg.read_s32("game_time",125);
	if (max_pzombies<25) max_pzombies=25;
	s32 max_migrantbots = cfg.read_s32("game_time",125);
	if (max_migrantbots<2) max_migrantbots=2;	
	getRules().set_s32("max_zombies", max_zombies);
	getRules().set_s32("max_pzombies", max_pzombies);
	getRules().set_s32("max_migrantbots", max_migrantbots);
	getRules().set_bool("grave_spawn", grave_spawn);
    //spawn after death time 
    this.spawnTime = (getTicksASecond() * cfg.read_s32("spawn_time", 30));
	
}

//Zombies spawn system

const s32 spawnspam_limit_time = 10;

shared class ZombiesSpawns : RespawnSystem
{
    ZombiesCore@ Zombies_core;

    bool force;
    s32 limit;
	
	void SetCore(RulesCore@ _core)
	{
		RespawnSystem::SetCore(_core);
		@Zombies_core = cast<ZombiesCore@>(core);
		
		limit = spawnspam_limit_time;
		getRules().set_bool("everyones_dead",false);
	}

    void Update()
    {
		int everyone_dead=0;
		int total_count=Zombies_core.players.length;
        for (uint team_num = 0; team_num < Zombies_core.teams.length; ++team_num )
        {
            CTFTeamInfo@ team = cast<CTFTeamInfo@>( Zombies_core.teams[team_num] );

            for (uint i = 0; i < team.spawns.length; i++)
            {
                CTFPlayerInfo@ info = cast<CTFPlayerInfo@>(team.spawns[i]);
                
                UpdateSpawnTime(info, i);
				if ( info !is null )
				{
					if (info.can_spawn_time>0) everyone_dead++;
					//total_count++;
				}
                DoSpawnPlayer( info );
            }
        }
		if (getRules().isMatchRunning())
		{
			if (everyone_dead == total_count && total_count!=0) getRules().set_bool("everyones_dead",true); 
			if (getGameTime() % (10*getTicksASecond()) == 0) warn("ED:"+everyone_dead+" TC:"+total_count);
		}
    }
    
    void UpdateSpawnTime(CTFPlayerInfo@ info, int i)
    {
		if ( info !is null )
		{
			u8 spawn_property = 255;
			
			if(info.can_spawn_time > 0) {
				info.can_spawn_time--;
				spawn_property = u8(Maths::Min(200,(info.can_spawn_time / 30)));
			}
			
			string propname = "Zombies spawn time "+info.username;
			
			Zombies_core.rules.set_u8( propname, spawn_property );
			Zombies_core.rules.SyncToPlayer( propname, getPlayerByUsername(info.username) );
		}
	}

	bool SetMaterials( CBlob@ blob,  const string &in name, const int quantity )
	{
		CInventory@ inv = blob.getInventory();

		//already got them?
		if(inv.isInInventory(name, quantity))
			return false;

		//otherwise...
		inv.server_RemoveItems(name, quantity); //shred any old ones

		CBlob@ mat = server_CreateBlob( name );
		if (mat !is null)
		{
			mat.Tag("do not set materials");
			mat.server_SetQuantity(quantity);
			if (!blob.server_PutInInventory(mat))
			{
				mat.setPosition( blob.getPosition() );
			}
		}

		return true;
	}

    void DoSpawnPlayer( PlayerInfo@ p_info )
    {
        if (canSpawnPlayer(p_info))
        {
			//limit how many spawn per second
			if(limit > 0)
			{
				limit--;
				return;
			}
			else
			{
				limit = spawnspam_limit_time;
			}	
			
            CPlayer@ player = getPlayerByUsername(p_info.username); // is still connected?

            if (player is null)
            {
				RemovePlayerFromSpawn(p_info);
                return;
            }
            /*if (player.getTeamNum() != int(p_info.team)) //this forced players to respawn always on blue
            {
				player.server_setTeamNum(p_info.team);
				warn("team"+p_info.team);
			}*/			

			// remove previous players blob	  			
			if (player.getBlob() !is null)
			{
				CBlob @blob = player.getBlob();
				blob.server_SetPlayer( null );
				blob.server_Die();					
			}
			
			u8 undead = player.getTeamNum();
			
			if (undead == 0)
			{
				p_info.blob_name = "builder"; //hard-set the survivors respawn blob
			}
			else if (undead == 1)
			{
				/*int r = XORRandom(3); //random undead on spawn
				if (r == 0)
				{
					p_info.blob_name = "undeadbuilder";
				}
				else if (r == 1)
				{
					p_info.blob_name = "undeadknight";
				}				
				else if (r == 2)
				{
					p_info.blob_name = "undeadarcher";
				}*/	
				p_info.blob_name = "undeadbuilder"; //hard-set the undead respawn blob
			}
			
            CBlob@ playerBlob = SpawnPlayerIntoWorld( getSpawnLocation(p_info), p_info);

            if (playerBlob !is null)
            {
                p_info.spawnsCount++;
                RemovePlayerFromSpawn(player);
				u8 blobfix = player.getTeamNum(); //hacky solution for player blobs not being the team color
				if (playerBlob.getTeamNum()!=blobfix)
				{
					playerBlob.server_setTeamNum(blobfix);
					warn("Team "+blobfix);
				}

				// spawn resources
				//SetMaterials( playerBlob, "mat_wood", 200 );
				//SetMaterials( playerBlob, "mat_stone", 100 );
            }
        }
    }

    bool canSpawnPlayer(PlayerInfo@ p_info)
    {
        CTFPlayerInfo@ info = cast<CTFPlayerInfo@>(p_info);

        if (info is null) { warn("Zombies LOGIC: Couldn't get player info ( in bool canSpawnPlayer(PlayerInfo@ p_info) ) "); return false; }

		//return true;
        //if (force) { return true; }

        return info.can_spawn_time <= 0;
    }

    Vec2f getSpawnLocation(PlayerInfo@ p_info)
    {
        CTFPlayerInfo@ c_info = cast<CTFPlayerInfo@>(p_info);
		if(c_info !is null)
        {
			CMap@ map = getMap();
			if(map !is null)
			{
				CPlayer@ player = getPlayerByUsername(p_info.username);
				u8 lemo = player.getTeamNum();
				if (lemo == 0) //survivors spawn point
				{
					CBlob@[] migrantbots;
					getBlobsByName("migrantbot", @migrantbots);
					for (int n = 0; n < migrantbots.length; n++)
					if(migrantbots[n] !is null) //check if we still have migrantbots and spawn us there
					{
						return Vec2f(migrantbots[n].getPosition()); 
					}	
				}
				else if (lemo == 1) //undead spawn point
				{
					CBlob@[] portals;
					getBlobsByName("undeadstatue", @portals);
					for (int n = 0; n < portals.length; n++)
					if(portals[n] !is null) //check if we still have portals and spawn us there
					{
						ParticleZombieLightning(portals[n].getPosition());
						return Vec2f(portals[n].getPosition()); 
					}										
				}
			}
        }
		CMap@ map = getMap();
		f32 x = XORRandom(2) == 0 ? 32.0f : map.tilemapwidth * map.tilesize - 32.0f;
		return Vec2f(x, map.getLandYAtX(s32(x/map.tilesize))*map.tilesize - 16.0f);	//in case portals/migrantbots are missing spawn at the edge
    }

    void RemovePlayerFromSpawn(CPlayer@ player)
    {
        RemovePlayerFromSpawn(core.getInfoFromPlayer(player));
    }
    
    void RemovePlayerFromSpawn(PlayerInfo@ p_info)
    {
        CTFPlayerInfo@ info = cast<CTFPlayerInfo@>(p_info);
        
        if (info is null) { warn("Zombies LOGIC: Couldn't get player info ( in void RemovePlayerFromSpawn(PlayerInfo@ p_info) )"); return; }

        string propname = "Zombies spawn time "+info.username;
        
        for (uint i = 0; i < Zombies_core.teams.length; i++)
        {
			CTFTeamInfo@ team = cast<CTFTeamInfo@>(Zombies_core.teams[i]);
			int pos = team.spawns.find(info);

			if (pos != -1) {
				team.spawns.erase(pos);
				break;
			}
		}
		
		Zombies_core.rules.set_u8( propname, 255 ); //not respawning
		Zombies_core.rules.SyncToPlayer( propname, getPlayerByUsername(info.username) ); 
		
		info.can_spawn_time = 0;
	}

    void AddPlayerToSpawn( CPlayer@ player )
    {
		s32 tickspawndelay = 0;
		if (player.getDeaths() != 0)
		{
			int gamestart = getRules().get_s32("gamestart");
			int day_cycle = getRules().daycycle_speed*60;
			int timeElapsed = ((getGameTime()-gamestart)/getTicksASecond()) % day_cycle;
			tickspawndelay = (day_cycle - timeElapsed)*getTicksASecond();
			warn("DC: "+day_cycle+" TE:"+timeElapsed);
			if (timeElapsed<30) tickspawndelay=0;
		}
		
		
		//; //
        
        CTFPlayerInfo@ info = cast<CTFPlayerInfo@>(core.getInfoFromPlayer(player));

        if (info is null) { warn("Zombies LOGIC: Couldn't get player info  ( in void AddPlayerToSpawn(CPlayer@ player) )"); return; }

		RemovePlayerFromSpawn(player);
		if (player.getTeamNum() == core.rules.getSpectatorTeamNum())
			return;
			
		print("ADD SPAWN FOR " + player.getUsername()+ "Spawn Delay: " +tickspawndelay);

		if (info.team < Zombies_core.teams.length)
		{
			CTFTeamInfo@ team = cast<CTFTeamInfo@>(Zombies_core.teams[info.team]);
			
			info.can_spawn_time = tickspawndelay;
			
			info.spawn_point = player.getSpawnPoint();
			team.spawns.push_back(info);
		}
		else
		{
			error("PLAYER TEAM NOT SET CORRECTLY!");
		}
    }

	bool isSpawning( CPlayer@ player )
	{
		CTFPlayerInfo@ info = cast<CTFPlayerInfo@>(core.getInfoFromPlayer(player));
		for (uint i = 0; i < Zombies_core.teams.length; i++)
        {
			CTFTeamInfo@ team = cast<CTFTeamInfo@>(Zombies_core.teams[i]);
			int pos = team.spawns.find(info);

			if (pos != -1) {
				return true;
			}
		}
		return false;
	}

};

shared class ZombiesCore : RulesCore
{
    s32 warmUpTime;
    s32 gameDuration;
    s32 spawnTime;

    ZombiesSpawns@ Zombies_spawns;

    ZombiesCore() {}

    ZombiesCore(CRules@ _rules, RespawnSystem@ _respawns )
    {
        super(_rules, _respawns );
    }
    
    void Setup(CRules@ _rules = null, RespawnSystem@ _respawns = null)
    {
        RulesCore::Setup(_rules, _respawns);
        @Zombies_spawns = cast<ZombiesSpawns@>(_respawns);
        server_CreateBlob( "Entities/Meta/WARMusic.cfg" );
		int gamestart = getGameTime();
		rules.set_s32("gamestart",gamestart);
		rules.SetCurrentState(WARMUP);
    }

    void Update()
    {
		
        if (rules.isGameOver()) { return; }
		int day_cycle = getRules().daycycle_speed * 60;
		int transition = rules.get_s32("transition");
		int max_zombies = rules.get_s32("max_zombies");
		int num_zombies = rules.get_s32("num_zombies");
		int max_pzombies = rules.get_s32("max_pzombies");
		int num_pzombies = rules.get_s32("num_pzombies");
		int max_migrantbots = rules.get_s32("max_migrantbots");
		int num_migrantbots = rules.get_s32("num_migrantbots");		
		int gamestart = rules.get_s32("gamestart");
		int timeElapsed = getGameTime()-gamestart;
		float difficulty = 1.7*(getGameTime()-gamestart)/getTicksASecond()/day_cycle; //default 2.0
		float actdiff = 3.7*((getGameTime()-gamestart)/getTicksASecond()/day_cycle); //default 4.0
		int dayNumber = ((getGameTime()-gamestart)/getTicksASecond()/day_cycle)+1;
		int num_zombiePortals = rules.get_s32("num_zombiePortals"); //newstart portals
		CBlob@[] zombiePortal_blobs;
			getBlobsByTag("ZP", @zombiePortal_blobs );
			num_zombiePortals = zombiePortal_blobs.length;
			rules.set_s32("num_zombiePortals", num_zombiePortals); //newend portals
		int num_survivors = rules.get_s32("num_survivors"); //newstart survivors
		CBlob@[] survivors_blobs;
			getBlobsByTag("survivorplayer", @survivors_blobs );
			num_survivors = survivors_blobs.length;
			rules.set_s32("num_survivors", num_survivors); //newend	 survivors		
		if (actdiff>13) { actdiff=13; difficulty=difficulty-1.0; } else { difficulty=1.0; } //default actdiff>9
		
		if (rules.isWarmup() && timeElapsed>getTicksASecond()*30) { rules.SetCurrentState(GAME); warn("TE:"+timeElapsed); }
		rules.set_f32("difficulty",difficulty/3.2); //default 3.0
		int intdif = difficulty;
		if (intdif<=0) intdif=1;
		int spawnRate = getTicksASecond() * (6-(difficulty/2.2)); //default 2.0
		int extra_zombies = 0;
		int extra_pzombies = 0;
		int extra_migrantbots = 0;
		if (dayNumber > 10) extra_zombies=(dayNumber-10)*5;
		if (extra_zombies>max_zombies-50) extra_zombies=max_zombies-50; //default 100
		if (extra_pzombies>max_pzombies-25) extra_pzombies=max_pzombies-25;
		if (extra_migrantbots>max_migrantbots-2) extra_migrantbots=max_migrantbots-2; //default 100
		if (spawnRate<8) spawnRate=8;
		int wraiteRate = 2 + (intdif/4);
		if (getGameTime() % 300 == 0)
		{
			CBlob@[] zombie_blobs;
			getBlobsByTag("zombie", @zombie_blobs );
			num_zombies = zombie_blobs.length;
			rules.set_s32("num_zombies",num_zombies);
			printf("Zombies: "+num_zombies+" Extra: "+extra_zombies);
			CBlob@[] pzombie_blobs;
			getBlobsByTag("pzombie", @pzombie_blobs );
			num_pzombies = pzombie_blobs.length;
			rules.set_s32("num_pzombies",num_pzombies);
			printf("Portal Zombies: "+num_pzombies+" Extra: "+extra_pzombies);
			CBlob@[] migrantbot_blobs;
			getBlobsByTag("migrantbot", @migrantbot_blobs );
			num_migrantbots = migrantbot_blobs.length;
			rules.set_s32("num_migrantbots",num_migrantbots);
			printf("Migrants: "+num_migrantbots+" Extra: "+extra_migrantbots);			
		}
			
	    if (getGameTime() % (spawnRate) == 0 && num_zombies<100+extra_zombies)
        {
			
			CMap@ map = getMap();
			if (map !is null)
			{
				Vec2f[] zombiePlaces;
				rules.SetGlobalMessage("Day " + dayNumber);
				//rules.SetGlobalMessage("        Day " + dayNumber + "\n(" + num_zombiePortals + " Portals left)");			
				
				getMap().getMarkers("zombie spawn", zombiePlaces );
				
				if (zombiePlaces.length<=0)
				{
					
					for (int zp=8; zp<16; zp++)
					{
						Vec2f col;
						getMap().rayCastSolid( Vec2f(zp*8, 0.0f), Vec2f(zp*8, map.tilemapheight*8), col );
						col.y-=16.0;
						zombiePlaces.push_back(col);
						
						getMap().rayCastSolid( Vec2f((map.tilemapwidth-zp)*8, 0.0f), Vec2f((map.tilemapwidth-zp)*8, map.tilemapheight*8), col );
						col.y-=16.0;
						zombiePlaces.push_back(col);
					}
					//zombiePlaces.push_back(Vec2f((map.tilemapwidth-8)*4,(map.tilemapheight/2)*8));
				}
				//if (map.getDayTime()>0.1 && map.getDayTime()<0.2)
               // if(map.getDayTime()>0.6 && map.getDayTime()<0.8)
				//{
					//client_AddToChat("Night is coming.", SColor(255, 255, 0, 0));
				//}
				if (map.getDayTime()>0.8 || map.getDayTime()<0.1)
                {
                    //Vec2f sp(XORRandom(4)*(map.tilemapwidth/4)*8+(90*8),(map.tilemapheight/2)*8);
               
                    Vec2f sp = zombiePlaces[XORRandom(zombiePlaces.length)];
                    int r;
                    if (actdiff>13) r = XORRandom(13); else r = XORRandom(actdiff); //default actdiff>9
                    int rr = XORRandom(14);
                    if (r==12 && rr<wraiteRate)
                    server_CreateBlob( "wraith", -1, sp);
                    else
                    if (r==10 && rr<wraiteRate)
                    server_CreateBlob( "greg", -1, sp);
                    else					
                    if (r==8)
                    server_CreateBlob( "zombieknight", -1, sp);
                    else
					if (r==6)
                    server_CreateBlob( "gasbag", -1, sp);
                    else
                    if (r>=6)
                    server_CreateBlob( "zbison", -1, sp);
                    else					
                    if (r>=4)
                    server_CreateBlob( "zombie", -1, sp);
					else
                    if (r>=3)
                    server_CreateBlob( "skeleton", -1, sp);
					else
                    if (r>=1)
                    server_CreateBlob( "catto", -1, sp);					
                    else					
                    server_CreateBlob( "zchicken", -1, sp);
                    if (transition == 1 && (dayNumber % 5) == 0)
					{
						transition=0;
						rules.set_s32("transition",0);
						Vec2f sp = zombiePlaces[XORRandom(zombiePlaces.length)];
						server_CreateBlob( "horror", -1, sp);
						server_CreateBlob( "pankou", -1, sp);
						server_CreateBlob( "phellknight", -1, sp);
						server_CreateBlob( "pbrute", -1, sp);
						server_CreateBlob( "pgreg", -1, sp);
						/*server_CreateBlob( "scrollundead", -1, sp);
						server_CreateBlob( "scrollundead", -1, sp);*/
						if(dayNumber >= 10){
							server_CreateBlob( "abomination", -1, sp);
							server_CreateBlob( "pankou", -1, sp);
							server_CreateBlob( "pankou", -1, sp);
							server_CreateBlob( "phellknight", -1, sp);
							server_CreateBlob( "phellknight", -1, sp);
							server_CreateBlob( "pbrute", -1, sp);
							server_CreateBlob( "pbrute", -1, sp);
							server_CreateBlob( "pbanshee", -1, sp);
							server_CreateBlob( "pgreg", -1, sp);
							server_CreateBlob( "pgreg", -1, sp);
							/*server_CreateBlob( "scrollundead", -1, sp);
							server_CreateBlob( "scrollundead", -1, sp);
							server_CreateBlob( "scrollundead", -1, sp);*/
							if(dayNumber >= 15){
								server_CreateBlob( "horror", -1, sp);
								server_CreateBlob( "abomination", -1, sp);
								server_CreateBlob( "pankou", -1, sp);
								server_CreateBlob( "pankou", -1, sp);
								server_CreateBlob( "pankou", -1, sp);
								server_CreateBlob( "pankou", -1, sp);
								server_CreateBlob( "phellknight", -1, sp);
								server_CreateBlob( "phellknight", -1, sp);
								server_CreateBlob( "phellknight", -1, sp);
								server_CreateBlob( "phellknight", -1, sp);
								server_CreateBlob( "pbrute", -1, sp);
								server_CreateBlob( "pbrute", -1, sp);
								server_CreateBlob( "pbrute", -1, sp);
								server_CreateBlob( "pbrute", -1, sp);
								server_CreateBlob( "pbanshee", -1, sp);
								server_CreateBlob( "pbanshee", -1, sp);
								server_CreateBlob( "pgreg", -1, sp);
								server_CreateBlob( "pgreg", -1, sp);
								server_CreateBlob( "pgreg", -1, sp);
							}
						}
					}
					
				}
				else
				{
					if (transition == 0)
					{	
						rules.set_s32("transition",1);
					}
				}
			}
		}
        RulesCore::Update(); //update respawns
        CheckTeamWon();

    }

    //team stuff

    void AddTeam(CTeam@ team)
    {
        CTFTeamInfo t(teams.length, team.getName());
        teams.push_back(t);
    }

    void AddPlayer(CPlayer@ player, u8 team, string default_config = "")
    {
        team = player.getTeamNum();
		CTFPlayerInfo p(player.getUsername(), team, "builder" ); 
        players.push_back(p);
        ChangeTeamPlayerCount(p.team, 1);
		warn("sync");
    }

	void onPlayerDie(CPlayer@ victim, CPlayer@ killer, u8 customData)
	{
		if (!rules.isMatchRunning()) { return; }

		if (victim !is null )
		{
			if (killer !is null && killer.getTeamNum() != victim.getTeamNum())
			{
				addKill(killer.getTeamNum());
				Zombify ( victim );
			}
		}
	}
	
	void Zombify( CPlayer@ player)
	{
		PlayerInfo@ pInfo = getInfoFromName( player.getUsername() );
		print( ":::ZOMBIFYING: " + pInfo.username );
		ChangePlayerTeam( player, 1 );
	}
	
    //checks
    void CheckTeamWon( )
    {
        if(!rules.isMatchRunning()) { return; }
        int gamestart = rules.get_s32("gamestart");	
        int num_zombiePortals = rules.get_s32("num_zombiePortals");
		int num_survivors = rules.get_s32("num_survivors");
		int day_cycle = getRules().daycycle_speed*60;			
		int dayNumber = ((getGameTime()-gamestart)/getTicksASecond()/day_cycle)+1;
		/*if(getRules().get_bool("everyones_dead")) 
		{
            rules.SetTeamWon(1);
			rules.SetCurrentState(GAME_OVER);
            rules.SetGlobalMessage( "You died on day "+ dayNumber+"." );		
			getRules().set_bool("everyones_dead",false); 
		}*/
		if(num_survivors == 0) //
		{
			rules.SetTeamWon(1);
			rules.SetCurrentState(GAME_OVER);
			rules.SetGlobalMessage("No survivors or migrants are left. You died on day "+ dayNumber+".");
		}		
		else if(dayNumber == 16)
		{
			rules.SetTeamWon(0);
			rules.SetCurrentState(GAME_OVER);
			rules.SetGlobalMessage("You survived for 15 days!");
		}	
		/*else if(num_zombiePortals == 0) //check if you want to win by destroying all Zombie Portals
		{
			rules.SetTeamWon(0);
			rules.SetCurrentState(GAME_OVER);
			rules.SetGlobalMessage("All Zombie Portals destroyed!");
		}*/
    }

    void addKill(int team)
    {
        if (team >= 0 && team < int(teams.length))
        {
            CTFTeamInfo@ team_info = cast<CTFTeamInfo@>( teams[team] );
        }
    }

};

//pass stuff to the core from each of the hooks

void spawnPortal(Vec2f pos)
{
	server_CreateBlob("ZombiePortal",-1,pos+Vec2f(0,-24.0));
}


void spawnGraves(Vec2f pos)
{
	bool grave_spawn = getRules().get_bool("grave_spawn");
	if (grave_spawn)
	{
		int r = XORRandom(8);
		if (r == 0)
			server_CreateBlob("casket2",-1,pos+Vec2f(0,-16.0));
		else if (r == 1)
			server_CreateBlob("grave1",-1,pos+Vec2f(0,-16.0));
		else if (r == 2)
			server_CreateBlob("grave2",-1,pos+Vec2f(0,-16.0));
		else if (r == 3)
			server_CreateBlob("grave3",-1,pos+Vec2f(0,-16.0));
		else if (r == 4)
			server_CreateBlob("grave4",-1,pos+Vec2f(0,-16.0));
		else if (r == 5)
			server_CreateBlob("grave5",-1,pos+Vec2f(0,-16.0));
		else if (r == 6)
			server_CreateBlob("grave6",-1,pos+Vec2f(0,-16.0));
		else if (r == 7)
			server_CreateBlob("casket1",-1,pos+Vec2f(0,-16.0));		
	}
}

void onInit(CRules@ this)
{
	Reset(this);
}

void onRestart(CRules@ this)
{
	Reset(this);
}

void Reset(CRules@ this)
{
    printf("Restarting rules script: " + getCurrentScriptName() );
    ZombiesSpawns spawns();
    ZombiesCore core(this, spawns);
    Config(core);
	Vec2f[] zombiePlaces;
	getMap().getMarkers("zombie portal", zombiePlaces );
	if (zombiePlaces.length>0)
	{
		for (int i=0; i<zombiePlaces.length; i++)
		{
			spawnPortal(zombiePlaces[i]);
		}
	}
	Vec2f[] gravePlaces;
	getMap().getMarkers("grave", gravePlaces );
	if (gravePlaces.length>0)
	{
		for (int i=0; i<gravePlaces.length; i++)
		{
			spawnGraves(gravePlaces[i]);
		}
	}
	
	//switching all players to survivors on game start
	for(u8 i = 0; i < getPlayerCount(); i++)
	{
		CPlayer@ p = getPlayer(i);
		if(p !is null)
		{
			p.server_setTeamNum(0);
		}
	}	

    //this.SetCurrentState(GAME);
    
    this.set("core", @core);
    this.set("start_gametime", getGameTime() + core.warmUpTime);
    this.set_u32("game_end_time", getGameTime() + core.gameDuration); //for TimeToEnd.as
}

