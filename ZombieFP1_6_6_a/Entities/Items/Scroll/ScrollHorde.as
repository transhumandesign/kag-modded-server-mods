#include "Help.as";

int hellknightsToSpawnCount = 1;
int maxHellKnights = 20; //max hellknights can be spawned
void onInit( CBlob@ this )
{
	HelpText help;
	this.addCommandID( "summon hellknights" );
	SetHelp( this, "help use carried", "", "Be careful when using this!","", 20); 
}

void GetButtonsFor( CBlob@ this, CBlob@ caller )
{
	CBitStream params;
	params.write_u16(caller.getNetworkID());
	u8 kek = caller.getTeamNum();	
	if (kek == 1)
	{	
		caller.CreateGenericButton( 11, Vec2f_zero, this, this.getCommandID("summon hellknights"), "Use this to summon a horde at your mouse position.", params );
	}
}

void onCommand( CBlob@ this, u8 cmd, CBitStream @params )
{
	
	if (cmd == this.getCommandID("summon hellknights"))
	{
		ParticleZombieLightning( this.getPosition() );

		bool hit = false;
		CBlob@ caller = getBlobByNetworkID( params.read_u16() );
		CBlob@ hellknight;
		CBlob@[] hellknightsCount;
		getBlobsByName("phellknight", @hellknightsCount);
		
		for (int i = 0; i < hellknightsToSpawnCount; i++)
		{
			if (hellknightsCount.length >= maxHellKnights)
			{
				@hellknight = server_CreateBlob( "phellknight", caller.getTeamNum(), this.getPosition());
				server_CreateBlob( "pcrawler", caller.getTeamNum(), this.getPosition());
				server_CreateBlob( "pankou", caller.getTeamNum(), this.getPosition());
				server_CreateBlob( "pbrute", caller.getTeamNum(), this.getPosition());
				if (hellknightsCount[i] !is null && hellknightsCount[i].getSprite() !is null)
				{
					hellknightsCount[i].getSprite().Gib();
					hellknightsCount[i].server_Die();
				}
			}
			else 
			{
				@hellknight = server_CreateBlob( "phellknight", caller.getTeamNum(), caller.getAimPos());
				server_CreateBlob( "pcrawler", caller.getTeamNum(), caller.getAimPos());
				server_CreateBlob( "pankou", caller.getTeamNum(), caller.getAimPos());
				server_CreateBlob( "pbrute", caller.getTeamNum(), caller.getAimPos());
			}
			
			hit = true;
		}

		if (hit)
		{
			this.server_Die();
			Sound::Play( "SuddenGib.ogg" );
		}
	}
}