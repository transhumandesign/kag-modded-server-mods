//Pyrokinesis
#include "UndeadArsonistCommon.as";
#include "Hitters.as";

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
		if(this.isKeyPressed( key_action2 )) {
			Vec2f delta = this.getPosition() - this.getAimPos();
			if(delta.Length() < TELEPORT_DISTANCE){
				this.set_u32("last teleport", gametime);
				this.set_bool("teleport ready", false );
				Pyrokinesis(this, this.getAimPos());
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

void Pyrokinesis( CBlob@ blob, Vec2f aimpos)	
{	
	CMap@ map = blob.getMap();
		
	CBlob@[] blobs;
	map.getBlobsInRadius(aimpos, 25.0f, @blobs);
		
	for(uint i = 0; i < blobs.length; i++)
	{
		CBlob@ burnt_blob = blobs[i];
		if (burnt_blob is blob)
				continue; //don't burn ourselves

		blob.server_Hit(burnt_blob, aimpos, Vec2f(0, 0), 0.25, Hitters::fire, true);
	}	
	ParticleAnimated( "Pyrokinesis.png", aimpos, Vec2f(0,0), 0.0f, 1.0f, 2.0, 0.0f, false );           
	blob.getSprite().PlaySound("/FireBall.ogg", 0.7f);
}
