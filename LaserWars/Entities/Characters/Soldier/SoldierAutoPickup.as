// SoldierAutoPickup.as

#define SERVER_ONLY

#include "SoldierCommon.as";

void onInit(CBlob@ this)
{
	this.getCurrentScript().removeIfTag = "dead";
}

void onCollision(CBlob@ this, CBlob@ blob, bool solid)
{
	if (blob is null || blob.getShape().vellen > 1.0f)
	{
		return;
	}

	string weapon = getItem(this, ItemType::PRIMARY);
	string blobName = blob.getName();

	if (blobName == "mat_grenades" || blobName == "mat_empgrenades" || blobName == "mat_contactgrenades" || (blobName == "mat_cells"   && (weapon == "plasma_launcher" || weapon == "plasma_cannon")) ||
		                                                                                                    (blobName == "mat_missiles" && weapon == "missile_launcher") || 
		                                                                                                    (blobName == "mat_swarms"   && weapon == "swarm_launcher"))
	{
		this.server_PutInInventory(blob);
	}
}
