// Aphelion (edited by Frikman)\\

#include "CreatureCommon.as";

const u8 ATTACK_FREQUENCY = 60; // 30 = 1 second
const f32 ATTACK_DAMAGE = 0.25f;
const f32 ATTACK_DISTANCE = 1.0f;

const int COINS_ON_DEATH = 10;

void onInit(CBlob@ this)
{
	TargetInfo[] infos;

	{
		TargetInfo i("survivorplayer", 1.0f, true, true);
		infos.push_back(i);
	}
	{
		TargetInfo i("ally", 0.9f, true);
		infos.push_back(i);
	}		
	{
		TargetInfo i("pet", 0.9f, true);
		infos.push_back(i);
	}
	{
		TargetInfo i("bison", 0.9f);
		infos.push_back(i);
	}		
	{
		TargetInfo i("lantern", 0.9f);
		infos.push_back(i);
	}
	{
		TargetInfo i("nzombie", 0.9f);
		infos.push_back(i);
	}	
	{
		TargetInfo i("nskeleton", 0.9f);
		infos.push_back(i);
	}
	{
		TargetInfo i("nzombieknight", 0.9f);
		infos.push_back(i);
	}		
	{
		TargetInfo i("mounted_bow", 0.6f);
		infos.push_back(i);		
	}	
	{
		TargetInfo i("mounted_bazooka", 0.6f);
		infos.push_back(i);		
	}	
	{
		TargetInfo i("glider", 0.6f);
		infos.push_back(i);		
	}
	{
		TargetInfo i("zeppelin", 0.6f);
		infos.push_back(i);		
	}		
	
	this.set("target infos", @infos);
	
	this.set_u8("attack frequency", ATTACK_FREQUENCY);
	this.set_f32("attack damage", ATTACK_DAMAGE);
	this.set_f32("attack distance", ATTACK_DISTANCE);
	this.set_string("attack sound", "ZombieBite2");
	this.set_u16("coins on death", COINS_ON_DEATH);
	this.set_f32(target_searchrad_property, 512.0f);
	
	this.getSprite().SetEmitSound("Wings2.ogg");
    this.getSprite().SetEmitSoundPaused(false);

    this.getSprite().PlayRandomSound("/GasbagIdle");
	this.getShape().SetRotationsAllowed(false);

	this.getBrain().server_SetActive(true);

	this.set_f32("gib health", 0.0f);
    this.Tag("flesh");
	
	this.getCurrentScript().runFlags |= Script::tick_not_attached;
	this.getCurrentScript().removeIfTag = "dead";
	this.server_SetTimeToDie(30);	
}

void onTick(CBlob@ this)
{
	if (getNet().isClient() && XORRandom(768) == 0)
	{
		this.getSprite().PlaySound("/GasbagIdle");
	}

	if (getNet().isServer() && getGameTime() % 10 == 0)
	{
		CBlob@ target = this.getBrain().getTarget();

		if (target !is null && this.getDistanceTo(target) < 72.0f)
		{
			this.Tag(chomp_tag);
		}
		else
		{
			this.Untag(chomp_tag);
		}

		this.Sync(chomp_tag, true);
	}
}

f32 onHit( CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData )
{
	if (damage >= 0.0f)
	{
	    this.getSprite().PlaySound("/SkeletonHit");
    }

	return damage;
}

void onDie( CBlob@ this )
{
    this.getSprite().PlaySound("/SkeletonBreak1");	
}