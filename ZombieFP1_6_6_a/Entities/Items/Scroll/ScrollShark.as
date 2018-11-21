#include "Help.as";

int sharksToSpawnCount = 1;
int maxSharks = 20; //max sharks can be spawned
void onInit( CBlob@ this )
{
	HelpText help;
	this.addCommandID( "summon sharks" );
	SetHelp( this, "help use carried", "", "Be careful when using this!","", 20); 
}

void GetButtonsFor( CBlob@ this, CBlob@ caller )
{
	CBitStream params;
	params.write_u16(caller.getNetworkID());
	u8 kek = caller.getTeamNum();	
	if (kek == 1)
	{	
		caller.CreateGenericButton( 11, Vec2f_zero, this, this.getCommandID("summon sharks"), "Use this to summon a Punished Shark at your mouse position.", params );
	}
}

void onCommand( CBlob@ this, u8 cmd, CBitStream @params )
{
	
	if (cmd == this.getCommandID("summon sharks"))
	{
		ParticleZombieLightning( this.getPosition() );

		bool hit = false;
		CBlob@ caller = getBlobByNetworkID( params.read_u16() );
		CBlob@ shark;
		CBlob@[] sharksCount;
		getBlobsByName("shark", @sharksCount);
		
		for (int i = 0; i < sharksToSpawnCount; i++)
		{
			if (sharksCount.length >= maxSharks)
			{
				@shark = server_CreateBlob( "shark", caller.getTeamNum(), this.getPosition()); 
				if (sharksCount[i] !is null && sharksCount[i].getSprite() !is null)
				{
					sharksCount[i].getSprite().Gib();
					sharksCount[i].server_Die();
				}
			}
			else 
			{
				@shark = server_CreateBlob( "shark", caller.getTeamNum(), caller.getAimPos()); 
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