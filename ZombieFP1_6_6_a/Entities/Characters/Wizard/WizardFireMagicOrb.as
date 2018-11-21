
#include "WizardCommon.as";
#include "OrbCommon.as";

void onInit( CBlob@ this )
{
	this.set_u32("last magic fire", 0 );
	this.set_u8("magic fire count", 0 );
}

void onTick( CBlob@ this )
{
	// if (getNet().isServer() && this.isKeyPressed( key_action1 ))
	// {
	u8 count = this.get_u8("magic fire count");
	const u32 gametime = getGameTime();
		
	if(count < ORB_LIMIT){
		if(this.isKeyPressed( key_action1 )) {
			u32 lastFireTime = this.get_u32("last magic fire");
			int diff = gametime - (lastFireTime + FIRE_FREQUENCY);
			if (diff > 0)
			{
				Vec2f pos = this.getPosition();
				Vec2f aim = this.getAimPos();
				
				u16 targetID = 0xffff;
				CMap@ map = this.getMap();
				if(map !is null)
				{
					CBlob@[] targets;
					if(map.getBlobsInRadius( aim, 32.0f, @targets ))
					{
						for(uint i = 0; i < targets.length; i++)
						{
							CBlob@ b = targets[i];
							if (b !is null && isEnemy(this, b))
							{
								targetID = b.getNetworkID();
							}
						}
					}
				}
				
				this.set_u32("last magic fire", gametime);
				
				Vec2f norm = aim - pos;
				norm.Normalize();
					
				CBlob@ orb;
				int h = 1;
				u16 orbs = 1;
				
				WizardInfo@ wizard;
				if (!this.get( "wizardInfo", @wizard )) {
					return;
				}
				{ 
					{
						if (getNet().isServer())
						{
							@orb = server_CreateBlob( "wizard_orb", this.getTeamNum(), pos + norm*this.getRadius());
							if (orb !is null)
							{
								orb.SetDamageOwnerPlayer( this.getPlayer() );
								orb.setVelocity( norm * (diff <= FIRE_FREQUENCY/3 ? ORB_SPEED/2.0f : ORB_SPEED) );
								orb.Tag("Regular Orb");
							}
						}
					}
				}
			}
		}
	} else {
			u32 lastFireTime = this.get_u32("last magic fire");
			int diff = gametime - (lastFireTime + ORB_BURST_COOLDOWN);
			
			if(this.isKeyJustPressed( key_action1 ) && this.isMyPlayer()){ 
				Sound::Play("Entities/Characters/Sounds/NoAmmo.ogg");
			}
			
			if (diff > 0)
			{
				this.set_u8("magic fire count", 0 );
			}
	}
		
	// }   
}
