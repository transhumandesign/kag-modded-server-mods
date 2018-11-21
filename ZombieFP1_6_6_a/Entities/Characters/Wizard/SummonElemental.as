#include "WizardCommon.as";

void onInit( CBlob@ this )
{
	this.set_u32("last teleport", 0 );
	this.set_bool("teleport ready", true );
}


void onTick( CBlob@ this ) 
{	
	bool ready = this.get_bool("teleport ready");
	const u32 gametime = getGameTime();
	
	if(ready) {
		if(this.isKeyJustPressed( key_action2 )) {
			Vec2f delta = this.getPosition() - this.getAimPos();
			if(delta.Length() < TELEPORT_DISTANCE){
				this.set_u32("last teleport", gametime);
				this.set_bool("teleport ready", false );
				SummonElemental(this, this.getAimPos());
			} else if(this.isMyPlayer()) {
				Sound::Play("option.ogg");
			}
		}
	} else {		
		u32 lastTeleport = this.get_u32("last teleport");
		int diff = gametime - (lastTeleport + TELEPORT_FREQUENCY);
		
		if(this.isKeyJustPressed( key_action2 ) && this.isMyPlayer()){
			Sound::Play("Entities/Characters/Sounds/NoAmmo.ogg");
		}

		if (diff > 0)
		{
			this.set_bool("teleport ready", true );
			this.getSprite().PlaySound("/Cooldown1.ogg"); 
		}
	}
}

void SummonElemental( CBlob@ blob, Vec2f aimpos)	
{	
	int r = XORRandom(4);
	if (r == 0)
	{
		server_CreateBlob( "waterelemental", 0, aimpos );
	}
	else if (r == 1)
	{
		server_CreateBlob( "airelemental", 0, aimpos );
	}				
	else if (r == 2)
	{
		server_CreateBlob( "fireelemental", 0, aimpos );
	}
	else if (r == 3)
	{
		server_CreateBlob( "earthelemental", 0, aimpos );
	}	
	ParticleZombieLightning( aimpos );           
    blob.getSprite().PlaySound("/Respawn.ogg");
}
