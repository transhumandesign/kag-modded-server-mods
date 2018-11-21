#include "Help.as";

int elementalsToSpawnCount = 1;
int maxElementals = 20; //max elementals can be spawned
void onInit( CBlob@ this )
{
	HelpText help;
	this.addCommandID( "summon elementals" );
	SetHelp( this, "help use carried", "", "Only 20 Elementals can be spawned!","", 20); 
}

void GetButtonsFor( CBlob@ this, CBlob@ caller )
{
	CBitStream params;
	params.write_u16(caller.getNetworkID());
	u8 kek = caller.getTeamNum();	
	if (kek == 0)
	{		
		caller.CreateGenericButton( 11, Vec2f_zero, this, this.getCommandID("summon elementals"), "Use this to summon 4 elementals.", params );
	}
}

void onCommand( CBlob@ this, u8 cmd, CBitStream @params )
{
	
	if (cmd == this.getCommandID("summon elementals"))
	{
		ParticleZombieLightning( this.getPosition() );

		bool hit = false;
		CBlob@ caller = getBlobByNetworkID( params.read_u16() );
		CBlob@ elemental;
		CBlob@[] elementalsCount;
		getBlobsByName("fireelemental", @elementalsCount);
		
		for (int i = 0; i < elementalsToSpawnCount; i++)
		{
			if (elementalsCount.length >= maxElementals)
			{
				@elemental = server_CreateBlob( "fireelemental", caller.getTeamNum(), this.getPosition());
				server_CreateBlob( "waterelemental", caller.getTeamNum(), this.getPosition());
				server_CreateBlob( "airelemental", caller.getTeamNum(), this.getPosition());
				server_CreateBlob( "earthelemental", caller.getTeamNum(), this.getPosition());
				if (elementalsCount[i] !is null && elementalsCount[i].getSprite() !is null)
				{
					elementalsCount[i].getSprite().Gib();
					elementalsCount[i].server_Die();
				}
			}
			else 
			{
				@elemental = server_CreateBlob( "fireelemental", caller.getTeamNum(), caller.getAimPos());
				server_CreateBlob( "waterelemental", caller.getTeamNum(), caller.getAimPos());
				server_CreateBlob( "airelemental", caller.getTeamNum(), caller.getAimPos());
				server_CreateBlob( "earthelemental", caller.getTeamNum(), caller.getAimPos()); 
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