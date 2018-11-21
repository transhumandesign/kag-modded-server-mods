#include "AnimalConsts.as";

void onInit(CBlob@ this)
{
	this.set_u8(state_property, MODE_FRIENDLY);
	int team = this.getTeamNum();
	this.getSprite().ReloadSprites(team, team);
	this.getCurrentScript().tickFrequency = 30;
}

void onTick(CBlob@ this)
{
	const u16 friendId = this.get_netid(friend_property);
	CBlob@ friend = getBlobByNetworkID(friendId);
	if (friend !is null) return;

	CMap@ map = getMap();
	CBlob@[] blobs;
	if (map.getBlobsInRadius(this.getPosition(), 40, @blobs))
	{
		for (uint i = 0; i < blobs.length; i++)
		{
			CBlob@ blob = blobs[i];
			if (blob !is null)
			{
				if (blob.hasTag("player"))
				{
					this.server_setTeamNum(blob.getTeamNum());
					this.set_u8(state_property, MODE_FRIENDLY);
					this.set_netid(friend_property, blob.getNetworkID());
				}
			}
		}
	}
}