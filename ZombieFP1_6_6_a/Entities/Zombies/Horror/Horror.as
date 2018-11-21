// Aphelion (edited by Frikman) \\

#include "CreatureCommon.as";
#include "Hitters.as";

const u8 ATTACK_FREQUENCY = 45;
const f32 ATTACK_DAMAGE = 0.5f;
const f32 ATTACK_DISTANCE = 2.0f;


const int COINS_ON_DEATH = 200;

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
		TargetInfo i("stone_door", 0.8f);
		infos.push_back(i);
	}
	{
		TargetInfo i("wooden_door", 0.8f);
		infos.push_back(i);
	}
	{
		TargetInfo i("stone_block", 0.7f);
		infos.push_back(i);
	}
	{
		TargetInfo i("wood_block", 0.7f);
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

	//for EatOthers
	string[] tags = {"dead"};
	this.set("tags to eat", tags);
	
	this.set("target infos", infos);
	
	this.set_u8("attack frequency", ATTACK_FREQUENCY);
	this.set_f32("attack damage", ATTACK_DAMAGE);
	this.set_f32("attack distance", ATTACK_DISTANCE);
	this.set_u8("attack hitter", Hitters::fire);
	this.set_string("attack sound", "BossAttack");
	this.set_u16("coins on death", COINS_ON_DEATH);
	this.set_f32(target_searchrad_property, 512.0f);

    this.getSprite().PlayRandomSound("/BossSpawn");
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
		this.getSprite().PlaySound("/BossIdle");
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
		this.getSprite().PlaySound("/ZombieHit");
	}

	return damage;
}