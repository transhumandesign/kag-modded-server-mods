/* SoldierBrain.as
 * author: Aphelion
 */

#define SERVER_ONLY

#include "SoldierCommon.as";
#include "GunsCommon.as";

#include "BrainCommon.as";

void onInit( CBrain@ this )
{
	InitBrain(this);
}

void onTick( CBrain@ this )
{
	if(!getRules().get_bool("ai")) return;
	
	ClosestTarget(this);

	CBlob@ blob = this.getBlob();
	CBlob@ target = this.getTarget();

	if (sv_test)
	{
		blob.setKeyPressed( key_action2, true );
		return;
	}

	// logic for target
	this.getCurrentScript().tickFrequency = 29;

	if (target !is null)
	{
		this.getCurrentScript().tickFrequency = 1;

		u8 strategy = blob.get_u8("strategy");

		f32 distance;
		const bool visibleTarget = isVisible(blob, target, distance);

		if (visibleTarget)
			strategy = HasAmmo(blob) ? Strategy::attacking :
			                           Strategy::retreating;
		else
			strategy = Strategy::chasing;

		UpdateBlob(blob, target, strategy);

		// lose target if its killed (with random cooldown)

		if (LoseTarget(this, target))
		{
			strategy = Strategy::idle;
		}

		blob.set_u8("strategy", strategy);
	}
	else
	{
		RandomTurn(blob);
	}

	FloatInWater(blob);
}

void UpdateBlob( CBlob@ blob, CBlob@ target, const u8 strategy )
{
	Vec2f targetPos = target.getPosition();
	Vec2f myPos = blob.getPosition();

	if (strategy == Strategy::chasing)
	{
		HandleAbility(blob, strategy);

		DefaultChaseBlob(blob, target);
	}
	else if (strategy == Strategy::retreating)
	{
		HandleAbility(blob, strategy);

		DefaultRetreatBlob(blob, target);
	}
	else if (strategy == Strategy::attacking)
	{
		AttackBlob(blob, target);
	}
}

void HandleAbility( CBlob@ blob, const u8 strategy )
{
	ExoSuit@ suit = getSuit(getItem(blob, ItemType::EXO_SUIT));

	f32 shield_perc = getStatPercentage(blob, Stats::SHIELD);
	f32 health_perc = getStatPercentage(blob, Stats::HEALTH);
	f32 energy_perc = getStatPercentage(blob, Stats::ENERGY);

	if (suit.name == "logistics")
	{
		blob.setKeyPressed(key_action2, health_perc < 1.0f);
		return;
	}

	if (strategy == Strategy::chasing)
	{
		blob.setKeyPressed(key_action2, suit.name == "assault" || suit.name == "infiltrator");
	}
	else if (strategy == Strategy::retreating)
	{
		blob.setKeyPressed(key_action2, suit.name == "assault" || suit.name == "infiltrator");
	}
	else if (strategy == Strategy::attacking)
	{
		//blob.setKeyPressed(key_action2, suit.name == "sentinel" && energy_perc >= 0.5f);
	}
}

void AttackBlob( CBlob@ blob, CBlob@ target )
{
	Vec2f mypos = blob.getPosition();
	Vec2f targetPos = target.getPosition();
	Vec2f targetVector = targetPos - mypos;
	f32 targetDistance = targetVector.Length();
	const s32 difficulty = blob.get_s32("difficulty");
	const u32 gametime = getGameTime();

	blob.setAimPos(targetPos);
	
	JumpOverObstacles(blob);

	GunInfo@ info = getGunInfoByName(getActiveItem(blob));

	if (info is null)
	{
		return;
	}

	f32 myWeaponRange = info.projectileInfo.range;
	f32 targetWeaponRange = 9999.0f;

	GunInfo@ targetGunInfo = getGunInfoByName(getActiveItem(target));
	if (targetGunInfo !is null)
	{
		targetWeaponRange = targetGunInfo.projectileInfo.range;
	}

	f32 tileDistance = targetDistance / 8.0f;

	if (info.fireInfo.shotgun)
	{
		myWeaponRange *= 0.8f;
	}

	if (tileDistance < myWeaponRange)
	{
		if (tileDistance <= targetWeaponRange && myWeaponRange > targetWeaponRange)
		{
			HandleAbility(blob, Strategy::retreating);

			Runaway(blob, target);
		}
		else
		{
		    HandleAbility(blob, Strategy::attacking);
		}
		
		string mode = info.fireInfo.mode.name;

		if (mode == "full_automatic")
		    blob.setKeyPressed(key_action1, true);
		else if (mode == "charge_to_fire")
			blob.setKeyPressed(key_action1, blob.get_u16("interval") < info.fireInfo.interval);
		else
		    blob.setKeyPressed(key_action1, gametime % info.fireInfo.interval == 0);
	}
	else
	{
		HandleAbility(blob, Strategy::chasing);

		Chase(blob, target);
	}
}
