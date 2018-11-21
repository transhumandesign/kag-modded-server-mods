#include "DecayCommon.as";
#include "VehicleCommon.as"	

#define SERVER_ONLY

void onInit(CBlob@ this)
{
	this.getCurrentScript().tickFrequency = 84; // opt
}

void onTick(CBlob@ this)
{
	if (dissalowDecaying(this))
		return;

	if (isFlipped(this))
	{
		if (DECAY_DEBUG)
			printf(this.getName() + " decay flipped");
		SelfDamage(this);
	}
}


void Vehicle_onFire( CBlob@ this, VehicleInfo@ v, CBlob@ bullet, const u8 charge ) {}
bool Vehicle_canFire( CBlob@ this, VehicleInfo@ v, bool isActionPressed, bool wasActionPressed, u8 &out chargeValue ) {return false;}