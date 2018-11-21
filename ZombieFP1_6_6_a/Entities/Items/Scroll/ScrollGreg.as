#include "Help.as";

int gregsToSpawnCount = 2;
int maxGregs = 20; //max gregs can be spawned
void onInit( CBlob@ this )
{
	HelpText help;
	this.addCommandID( "summon gregs" );
	SetHelp( this, "help use carried", "", "Be careful when using this!","", 20); 
}

void GetButtonsFor( CBlob@ this, CBlob@ caller )
{
	CBitStream params;
	params.write_u16(caller.getNetworkID());
	u8 kek = caller.getTeamNum();	
	if (kek == 1)
	{	
		caller.CreateGenericButton( 11, Vec2f_zero, this, this.getCommandID("summon gregs"), "Use this to summon 2 Gregs at your mouse position.", params );
	}
}

void onCommand( CBlob@ this, u8 cmd, CBitStream @params )
{
	
	if (cmd == this.getCommandID("summon gregs"))
	{
		ParticleZombieLightning( this.getPosition() );

		bool hit = false;
		CBlob@ caller = getBlobByNetworkID( params.read_u16() );
		CBlob@ greg;
		CBlob@[] gregsCount;
		getBlobsByName("pgreg", @gregsCount);
		
		for (int i = 0; i < gregsToSpawnCount; i++)
		{
			if (gregsCount.length >= maxGregs)
			{
				@greg = server_CreateBlob( "pgreg", caller.getTeamNum(), this.getPosition()); 
				if (gregsCount[i] !is null && gregsCount[i].getSprite() !is null)
				{
					gregsCount[i].getSprite().Gib();
					gregsCount[i].server_Die();
				}
			}
			else 
			{
				@greg = server_CreateBlob( "pgreg", caller.getTeamNum(), caller.getAimPos()); 
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