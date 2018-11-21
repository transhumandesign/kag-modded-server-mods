// Aphelion \\

#include "CreatureCommon.as";
#include "Hitters.as";

const u8 ATTACK_FREQUENCY = 30;
const f32 ATTACK_DAMAGE = 1.25f;

const int COINS_ON_DEATH = 0;

void onInit(CBlob@ this)
{
	TargetInfo[] infos;

	{
		TargetInfo i("undeadplayer", 1.0f, true, true);
		infos.push_back(i);
	}
	{
		TargetInfo i("enemy", 0.9f, true);
		infos.push_back(i);
	}
	{
		TargetInfo i("dead", 0.5f, true);
		infos.push_back(i);
	}	
	
	//for EatOthers
	string[] tags = {"dead"};
	this.set("tags to eat", tags);
	
	this.set_f32("bite damage", 0.5f);
	
	this.set("target infos", infos);
	
	this.set_u8("attack frequency", ATTACK_FREQUENCY);
	this.set_f32("attack damage", ATTACK_DAMAGE);
	this.set_string("attack sound", "AirAttack");
	this.set_u16("coins on death", COINS_ON_DEATH);
	this.set_f32(target_searchrad_property, 512.0f);
	
	this.SetLight(true);
	this.SetLightRadius(64.0f);
	this.SetLightColor(SColor(255, 81, 132, 19));	

    this.getSprite().PlayRandomSound("/AirDie");
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
		this.getSprite().PlaySound("/AirIdle");
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
	    this.getSprite().PlaySound("/AirIdle");
    }

	return damage;
}

void onDie( CBlob@ this )
{
	server_DropCoins(this.getPosition() + Vec2f(0, -3.0f), COINS_ON_DEATH);

    this.getSprite().PlaySound("AirDie");	
}