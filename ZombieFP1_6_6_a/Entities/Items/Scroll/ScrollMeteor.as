#include "Help.as";

int meteorsToSpawnCount = 1;
int maxMeteors = 20; //max meteors can be spawned
void onInit( CBlob@ this )
{
	HelpText help;
	this.addCommandID( "summon meteors" );
	SetHelp( this, "help use carried", "", "Be careful when using this!","", 20); 
}

void GetButtonsFor( CBlob@ this, CBlob@ caller )
{
	CBitStream params;
	params.write_u16(caller.getNetworkID());
	u8 kek = caller.getTeamNum();	
	if (kek == 0)
	{	
		caller.CreateGenericButton( 11, Vec2f_zero, this, this.getCommandID("summon meteors"), "Use this to summon a Meteor at your mouse position.", params );
	}
}

void onCommand( CBlob@ this, u8 cmd, CBitStream @params )
{
	
	if (cmd == this.getCommandID("summon meteors"))
	{
		ParticleZombieLightning( this.getPosition() );

		bool hit = false;
		CBlob@ caller = getBlobByNetworkID( params.read_u16() );
		CBlob@ meteor;
		CBlob@[] meteorsCount;
		getBlobsByName("meteor", @meteorsCount);
		
		for (int i = 0; i < meteorsToSpawnCount; i++)
		{
			if (meteorsCount.length >= maxMeteors)
			{
				@meteor = server_CreateBlob( "meteor", caller.getTeamNum(), this.getPosition()); 
				if (meteorsCount[i] !is null && meteorsCount[i].getSprite() !is null)
				{
					meteorsCount[i].getSprite().Gib();
					meteorsCount[i].server_Die();
				}
			}
			else 
			{
				@meteor = server_CreateBlob( "meteor", caller.getTeamNum(), caller.getAimPos()); 
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