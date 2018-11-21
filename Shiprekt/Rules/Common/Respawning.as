#define SERVER_ONLY

const string PLAYER_BLOB = "human";
const string SPAWN_TAG = "mothership";

bool oneTeamLeft = false;

shared class Respawn
{
	string username;
	u32 timeStarted;

	Respawn( const string _username, const u32 _timeStarted ){
		username = _username;
		timeStarted = _timeStarted;
	}
};

void onInit(CRules@ this)
{
	Respawn[] respawns;
	this.set("respawns", respawns);
    onRestart(this);
}

void onReload(CRules@ this)
{
    this.clear("respawns");    
    for (int i = 0; i < getPlayerCount(); i++)
    {
        CPlayer@ player = getPlayer(i);
        if (player.getBlob() is null)
        {
            Respawn r(player.getUsername(), getGameTime());
            this.push("respawns", r);
        }
    }    
}

Random _teamrandom(0x7ea177);

s32 getRandomMinimumTeam(CRules@ this, const int higherThan = -1)
{
    const int teamsCount = this.getTeamsNum();
    int[] playersperteam;
    for(int i = 0; i < teamsCount; i++)
        playersperteam.push_back(0);

    //gather the per team player counts
    const int playersCount = getPlayersCount();
    for(int i = 0; i < playersCount; i++)
    {
        CPlayer@ p = getPlayer(i);
        s32 pteam = p.getTeamNum();
        if(pteam >= 0 && pteam < teamsCount)
        {
            playersperteam[pteam]++;
        }
    }

    //calc the minimum player count
    int minplayers = 1000;
    for(int i = 0; i < teamsCount; i++)
    {
        if (playersperteam[i] < higherThan)
            playersperteam[i] = 1000;
        minplayers = Maths::Min(playersperteam[i], minplayers);
    }

    //choose a random team with minimum player count
    s32 team;
    do {
        team = _teamrandom.NextRanged(teamsCount);
    } while(playersperteam[team] > minplayers);

    return team;
}

void onRestart(CRules@ this)
{
	this.clear("respawns");    
    for (int i = 0; i < getPlayerCount(); i++)
	{
		CPlayer@ player = getPlayer(i);
        player.server_setTeamNum( getRandomMinimumTeam(this) );
    	Respawn r(player.getUsername(), getGameTime());
    	this.push("respawns", r);
	}

    this.SetCurrentState(GAME);
    this.SetGlobalMessage( "" );
}

void onPlayerRequestSpawn( CRules@ this, CPlayer@ player )
{
	if (!isRespawnAdded( this, player.getUsername()))
	{
    	Respawn r(player.getUsername(), player.getDeaths() == 0 ? 0 : getGameTime());
    	this.push("respawns", r);
    }
}

void onTick( CRules@ this )
{
	const u32 gametime = getGameTime();
	if (this.isMatchRunning() && gametime % 30 == 0)
	{
		Respawn[]@ respawns;
		if (this.get("respawns", @respawns))
		{
			for (uint i = 0; i < respawns.length; i++)
			{
				Respawn@ r = respawns[i];
				if (r.timeStarted == 0 || r.timeStarted + this.playerrespawn_seconds*getTicksASecond() <= gametime)
				{
					SpawnPlayer( this, getPlayerByUsername( r.username ));
					respawns.erase(i);
					i = 0;
				}
			}
		}

        CBlob@[] cores;
        getBlobsByTag(SPAWN_TAG, cores);
        oneTeamLeft = (cores.length <= 1 || allPlayersInOneTeam(this));

		if (oneTeamLeft)
		{
            // give points to winning team
            if (!this.isGameOver())
            {
                for (uint coreIt = 0; coreIt < cores.length; coreIt++)
                {
                    for (int i = 0; i < getPlayerCount(); i++)
                    {
                        CPlayer@ player = getPlayer(i);
                        if (player.getTeamNum() == cores[coreIt].getTeamNum())
                        {
                            player.setScore( player.getScore() + 1 );
                        }
                    }
                }                
            }

			this.SetGlobalMessage( "Game Over!" );
			this.SetCurrentState(GAME_OVER);

            //TODO: honk sound here
        }
        else
        {
            this.SetGlobalMessage( "" );
        }
	}
}

CBlob@ SpawnPlayer( CRules@ this, CPlayer@ player )
{
    if (player !is null)
    {
        // remove previous players blob
        CBlob @blob = player.getBlob();		   
        if (blob !is null)
        {
            CBlob @blob = player.getBlob();
            blob.server_SetPlayer( null );
            blob.server_Die();
        }

        const u8 teamsCount = this.getTeamsNum();
		u8 team = player.getTeamNum();
        team = team > 32 ? getRandomMinimumTeam(this) : team;
        player.server_setTeamNum(team);
    
        CBlob@ ship = getMothership( team );
        if (ship is null)
        {
        	team = getRandomMinimumTeam(this);
        	@ship = getMothership( team );
        	int count = 0;
        	while (ship is null && count <= 3*teamsCount)
        	{
        		team = getRandomMinimumTeam(this, count%teamsCount);
        		@ship = getMothership( team );
        		count++;
        	}

        	// spawn as shark if cant find a ship
        	if (ship is null)
        	{            	
	            return SpawnAsShark( this, player );
        	}
        	else {
        		player.server_setTeamNum(team);
        	}
        }

        CBlob @newBlob = server_CreateBlob( PLAYER_BLOB, team, ship.getPosition() );
	    if (newBlob !is null) {
		   newBlob.server_SetPlayer( player );
		   newBlob.set_u16( "shipID", ship.getNetworkID() );
	    }
        return newBlob;        
    }

    return null;
}

CBlob@ getMothership( const u8 team )
{
    CBlob@[] ships;
    getBlobsByTag( SPAWN_TAG, @ships );
    for (uint i=0; i < ships.length; i++)
    {
        CBlob@ ship = ships[i];  
        if (ship.getTeamNum() == team)
            return ship;
    }
    return null;
}

bool isRespawnAdded( CRules@ this, const string username )
{
	Respawn[]@ respawns;
	if (this.get("respawns", @respawns))
	{
		for (uint i = 0; i < respawns.length; i++)
		{
			Respawn@ r = respawns[i];
			if (r.username == username)
				return true;
		}
	}	
	return false;
}

Vec2f getSpawnPosition( const uint team )
{
    Vec2f[] spawns;			 
    if (getMap().getMarkers("spawn", spawns )) {
    	if (team >= 0 && team < spawns.length)
    		return spawns[team];
    }
    CMap@ map = getMap();
    return Vec2f( map.tilesize*map.tilemapwidth/2, map.tilesize*map.tilemapheight/2);
}

CBlob@ SpawnAsShark( CRules@ this, CPlayer@ player )
{
    CBlob @shark = server_CreateBlob( "shark", this.getSpectatorTeamNum(), getSpawnPosition( player.getTeamNum() ) );
    if (shark !is null) {
        shark.server_SetPlayer( player );
    }    
    return shark;
}

void onPlayerRequestTeamChange( CRules@ this, CPlayer@ player, u8 newteam )
{
    CBlob@ blob = player.getBlob();

    if (newteam == this.getSpectatorTeamNum())
    { 
        if (blob !is null && blob.getName() == "human")
            SpawnAsShark( this, player);
    }

    if (blob !is null)
        blob.server_Die();    
}

bool allPlayersInOneTeam( CRules@ this )
{    
    if (getPlayerCount() <= 1)
        return false;

    int team = -1;
    for (int i = 0; i < getPlayerCount(); i++)
    {
        CPlayer@ player = getPlayer(i);
        if (i == 0){
            team = player.getTeamNum();
        }
        else if (team != player.getTeamNum())
        {
            return false;
        }
    }

    return true;
}