#include "Help.as";

int zombiesToSpawnCount = 5;
int maxZombies = 20; //max zombies can be spawned
void onInit( CBlob@ this )
{
	HelpText help;
	this.addCommandID( "summon zombies" );
	SetHelp( this, "help use carried", "", "Only 20 skeletons can be spawned!","", 20); 
}

void GetButtonsFor( CBlob@ this, CBlob@ caller )
{
	CBitStream params;
	params.write_u16(caller.getNetworkID());
	u8 kek = caller.getTeamNum();	
	if (kek == 1)
	{	
		caller.CreateGenericButton( 11, Vec2f_zero, this, this.getCommandID("summon zombies"), "Use this to summon 5 friendly skeletons.", params );
	}
}

void onCommand( CBlob@ this, u8 cmd, CBitStream @params )
{
	
	if (cmd == this.getCommandID("summon zombies"))
	{
		ParticleZombieLightning( this.getPosition() );

		bool hit = false;
		CBlob@ caller = getBlobByNetworkID( params.read_u16() );
		CBlob@ zombie;
		CBlob@[] zombiesCount;
		getBlobsByName("skeleton2", @zombiesCount);
		
		for (int i = 0; i < zombiesToSpawnCount; i++)
		{
			if (zombiesCount.length >= maxZombies)
			{
				@zombie = server_CreateBlob( "skeleton2", caller.getTeamNum(), this.getPosition()); 
				if (zombiesCount[i] !is null && zombiesCount[i].getSprite() !is null)
				{
					zombiesCount[i].getSprite().Gib();
					zombiesCount[i].server_Die();
				}
			}
			else 
			{
				@zombie = server_CreateBlob( "skeleton2", caller.getTeamNum(), caller.getAimPos()); 
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