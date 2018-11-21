// Aphelion \\

#include "CreatureCommon.as";

const u8 ATTACK_FREQUENCY = 30; // 30 = 1 second
const f32 ATTACK_DAMAGE = 0.5f;

const int COINS_ON_DEATH = 5;

void onInit(CBlob@ this)
{
	TargetInfo[] infos;

	{
		TargetInfo i("survivorplayer", 1.0f, true, true);
		infos.push_back(i);
	}
	{
		TargetInfo i("pet", 0.9f, true);
		infos.push_back(i);
	}	
	{
		TargetInfo i("lantern", 0.9f);
		infos.push_back(i);
	}
	{
		TargetInfo i("ally", 0.9f, true);
		infos.push_back(i);
	}			
	{
		TargetInfo i("wooden_door", 0.8f);
		infos.push_back(i);
	}
	{
		TargetInfo i("survivorbuilding", 0.6f, true);
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
	
	this.set("target infos", @infos);
	
	this.set_u8("attack frequency", ATTACK_FREQUENCY);
	this.set_f32("attack damage", ATTACK_DAMAGE);
	this.set_string("attack sound", "SkeletonAttack");
	this.set_u16("coins on death", COINS_ON_DEATH);
	this.set_f32(target_searchrad_property, 512.0f);

    this.getSprite().PlayRandomSound("/SkeletonSpawn");
	this.getShape().SetRotationsAllowed(false);

	this.getBrain().server_SetActive(true);

	this.set_f32("gib health", 0.0f);
    this.Tag("flesh");
	
	this.getCurrentScript().runFlags |= Script::tick_not_attached;
	this.getCurrentScript().removeIfTag = "dead";
}

void onTick(CBlob@ this)
{
	if (getNet().isClient() && XORRandom(768) == 0)
	{
		this.getSprite().PlaySound("/SkeletonSayDuh");
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