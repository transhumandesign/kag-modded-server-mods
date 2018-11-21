// Aphelion (edited by Frikman)\\

#include "CreatureCommon.as";

const s32 TIME_TO_EXPLODE = 5 * 30;

const int COINS_ON_DEATH = 0;

void onInit(CBlob@ this)
{
	TargetInfo[] infos;

	{
		TargetInfo i("enemy", 1.0f, true);
		infos.push_back(i);
	}	

	this.set("target infos", infos);

	this.set_u16("coins on death", COINS_ON_DEATH);
	this.set_f32(target_searchrad_property, 512.0f);

    this.getSprite().PlaySound("WraithSpawn.ogg");

    this.getSprite().SetEmitSound("WraithFly.ogg");
    this.getSprite().SetEmitSoundPaused(false);
	this.getShape().SetRotationsAllowed(false);

	this.getBrain().server_SetActive(true);
	
	this.set_f32("gib health", 0.0f);
    this.Tag("flesh");

	// explosiveness
	this.set_f32("explosive_radius", 48.0f);
	this.set_f32("explosive_damage", 5.0f);
	this.set_string("custom_explosion_sound", "Entities/Items/Explosives/KegExplosion.ogg");
	this.set_f32("map_damage_radius", 0.0f);
	this.set_f32("map_damage_ratio", -1.0f);
	this.set_bool("map_damage_raycast", true);
	this.set_bool("explosive_teamkill", true);
	//

	this.getCurrentScript().runFlags |= Script::tick_not_attached;
	this.getCurrentScript().removeIfTag = "dead";
}

void onTick(CBlob@ this)
{
	if (this.hasTag("enraged"))
	{
		if(!this.exists("exploding"))
		{
			this.Tag("exploding");
		    this.set_s32("explosion_timer", getGameTime() + TIME_TO_EXPLODE);

            this.getSprite().PlaySound("/WraithDie");
		}

		if (getNet().isServer())
		{
        	s32 timer = this.get_s32("explosion_timer") - getGameTime();
       	 	if (timer <= 0)
        	{
            	// boom
                this.server_SetHealth(-1.0f);
                this.server_Die();
            }
		}
		else
		{
            this.SetLight( true );
            this.SetLightRadius(this.get_f32("explosive_radius") * 0.5f);
            this.SetLightColor( SColor(255, 211, 121, 224) );

            if (XORRandom(128) == 0)
            {
            	this.getSprite().PlaySound("/WraithDie");
            }
		}
	}
}

f32 onHit( CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData )
{
	if (damage >= 0.0f)
	{
	    this.getSprite().PlaySound("/ZombieHit");
    }

	return damage;
}