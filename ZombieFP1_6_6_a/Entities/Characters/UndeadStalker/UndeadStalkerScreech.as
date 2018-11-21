#include "Knocked.as";
f32 SCREECH_DISTANCE = 256.0f;
const int TELEPORT_FREQUENCY = 12 * 30; //12 secs
const int TELEPORT_DISTANCE = 999;//getMap().tilesize;

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
		if(this.isKeyJustPressed( key_taunts )) {
			Vec2f delta = this.getPosition() - this.getAimPos();
			if(delta.Length() < TELEPORT_DISTANCE){
				this.set_u32("last teleport", gametime);
				this.set_bool("teleport ready", false );
				Screech(this);
			} else if(this.isMyPlayer()) {
				Sound::Play("option.ogg");
			}
		}
	} else {		
		u32 lastTeleport = this.get_u32("last teleport");
		int diff = gametime - (lastTeleport + TELEPORT_FREQUENCY);
		
		if(this.isKeyJustPressed( key_taunts ) && this.isMyPlayer()){
			Sound::Play("Entities/Characters/Sounds/NoAmmo.ogg");
		}

		if (diff > 0)
		{
			this.set_bool("teleport ready", true );
			this.getSprite().PlaySound("/Cooldown1.ogg"); 
		}
	}
}

void Screech( CBlob@ this )
{
	CBlob@[] nearBlobs;
	this.getMap().getBlobsInRadius( this.getPosition(), SCREECH_DISTANCE, @nearBlobs );
	
	// play annoying sound at three times the volume
	this.getSprite().PlaySound("/BansheeScreech", 3.0f);
	
	for(int step = 0; step < nearBlobs.length; ++step)
	{
		CBlob@ recipent = nearBlobs[step]; // :)
		if    (recipent !is null &&! recipent.hasTag("dead") && recipent.hasTag("survivorplayer"))
		{
            // that was loud!
			SetKnocked( recipent, 60 + XORRandom(60) );
		}
	}
}
