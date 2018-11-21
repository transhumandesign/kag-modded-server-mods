// Eatable.as

#include "Stats.as";

const string heal_id = "heal command";

void onInit(CBlob@ this)
{
	if (!this.exists("eat sound"))
	{
		this.set_string("eat sound", "/Eat.ogg");
	}

	this.addCommandID(heal_id);
}

void Heal(CBlob@ this, CBlob@ blob)
{
	bool exists = getBlobByNetworkID(this.getNetworkID()) !is null;

	if (getNet().isServer() && blob.hasTag("player") && getStat(blob, Stats::HEALTH) < getBaseStat(blob, Stats::HEALTH) && !this.hasTag("healed") && exists)
	{
		CBitStream params;
		params.write_u16(blob.getNetworkID());

		u8 heal_amount = 255; // 255 means full hp

        if (this.getName() == "food")
		{
			heal_amount = 50;
		}
		else if (this.getName() == "heart" || this.getName() == "grain")
		{
			heal_amount = 10;
		}

		params.write_u8(heal_amount);

		this.SendCommand(this.getCommandID(heal_id), params);

		this.Tag("healed");
	}
}

void onCommand(CBlob@ this, u8 cmd, CBitStream@ params)
{
	if (cmd == this.getCommandID(heal_id))
	{
		this.getSprite().PlaySound(this.get_string("eat sound"));

		if (getNet().isServer())
		{
			u16 blob_id;
			if (!params.saferead_u16(blob_id)) return;

			CBlob@ theBlob = getBlobByNetworkID(blob_id);
			if (theBlob !is null)
			{
				u8 heal_amount;
				if (!params.saferead_u8(heal_amount)) return;

				if (heal_amount == 255)
				{
					server_SetStat(theBlob, Stats::HEALTH, getBaseStat(theBlob, Stats::HEALTH), 0, false);
				}
				else
				{
					server_SetStat(theBlob, Stats::HEALTH, getStat(theBlob, Stats::HEALTH) + heal_amount, 0, false);
				}

			}

			this.server_Die();
		}
	}
}

void onCollision(CBlob@ this, CBlob@ blob, bool solid)
{
	if (blob is null)
	{
		return;
	}

	if (getNet().isServer() && !blob.hasTag("dead"))
	{
		Heal(this, blob);
	}
}

void onAttach(CBlob@ this, CBlob@ attached, AttachmentPoint @attachedPoint)
{
	if (getNet().isServer())
	{
		Heal(this, attached);
	}
}

void onDetach(CBlob@ this, CBlob@ detached, AttachmentPoint @attachedPoint)
{
	if (getNet().isServer())
	{
		Heal(this, detached);
	}
}
