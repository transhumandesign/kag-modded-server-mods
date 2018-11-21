#include "Help.as";

int chickensToSpawnCount = 5;
int maxChickens = 20; //max chickens can be spawned
void onInit( CBlob@ this )
{
	HelpText help;
	this.addCommandID( "summon chickens" );
	SetHelp( this, "help use carried", "", "Only 20 Chickens can be spawned!","", 20); 
}

void GetButtonsFor( CBlob@ this, CBlob@ caller )
{
	CBitStream params;
	params.write_u16(caller.getNetworkID());
	caller.CreateGenericButton( 11, Vec2f_zero, this, this.getCommandID("summon chickens"), "Use this to summon 5 chickens.", params );
}

void onCommand( CBlob@ this, u8 cmd, CBitStream @params )
{
	
	if (cmd == this.getCommandID("summon chickens"))
	{
		ParticleZombieLightning( this.getPosition() );

		bool hit = false;
		CBlob@ caller = getBlobByNetworkID( params.read_u16() );
		CBlob@ chicken;
		CBlob@[] chickensCount;
		getBlobsByName("chicken", @chickensCount);
		
		for (int i = 0; i < chickensToSpawnCount; i++)
		{
			if (chickensCount.length >= maxChickens)
			{
				@chicken = server_CreateBlob( "chicken", caller.getTeamNum(), this.getPosition()); 
				if (chickensCount[i] !is null && chickensCount[i].getSprite() !is null)
				{
					chickensCount[i].getSprite().Gib();
					chickensCount[i].server_Die();
				}
			}
			else 
			{
				@chicken = server_CreateBlob( "chicken", caller.getTeamNum(), caller.getAimPos()); 
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