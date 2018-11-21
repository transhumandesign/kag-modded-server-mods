/* GrenadeLogic.as
 * author: Aphelion
 */

#include "IconsCommon.as";

#include "SoldierCommon.as";
#include "Requirements.as";
#include "ThrowCommon.as";

void onInit( CBlob@ this )
{
	this.addCommandID("get grenade");

	this.push("names to activate", "keg");

	this.set_u8("grenade type", 255);
	for (uint i = 0; i < grenadeTypeNames.length; i++)
	{
		this.addCommandID("pick " + grenadeTypeNames[i]);
	}

	this.getCurrentScript().runFlags |= Script::tick_not_attached;
	this.getCurrentScript().removeIfTag = "dead";
}

void onTick( CBlob@ this )
{
	const bool myplayer = this.isMyPlayer();

	// throwing grenades
	if (myplayer && !this.hasTag("cloaked"))
	{
		string weapon = getActiveItem(this);
		if    (weapon == "omni_tool") return;

		if (this.isKeyJustPressed(key_action3))
		{
			CBlob@ carried = this.getCarriedBlob();
			bool holding = carried !is null;// && carried.hasTag("exploding");

			CInventory@ inv = this.getInventory();
			bool thrown = false;

			u8  grenadeType = this.get_u8("grenade type");
			if (grenadeType == 255)
			{
				SetFirstAvailableGrenade(this);
				grenadeType = this.get_u8("grenade type");
			}

			if (grenadeType < grenadeTypeNames.length)
			{
				for (int i = 0; i < inv.getItemsCount(); i++)
				{
					CBlob@ item = inv.getItem(i);
					const string itemname = item.getName();
					if (!holding && grenadeTypeNames[grenadeType] == itemname)
					{
						if (grenadeType <= 3)
						{
							CBitStream params;
							params.write_u8(grenadeType);
							this.SendCommand(this.getCommandID("get grenade"), params);
							thrown = true;
						}
						else
						{
							this.server_Pickup(item);
							client_SendThrowOrActivateCommand(this);
							thrown = true;
						}
						break;
					}
				}
			}

			if (!thrown)
			{
				client_SendThrowOrActivateCommand(this);
				SetFirstAvailableGrenade(this);
			}
		}
	}
}

void onCommand(CBlob@ this, u8 cmd, CBitStream @params)
{
	string weapon = getActiveItem(this);
	if    (weapon == "omni_tool") return;
	
	if (cmd == this.getCommandID("get grenade"))
	{
		const u8 grenadeType = params.read_u8();
		if (grenadeType >= grenadeTypeNames.length)
			return;

		const string grenadeTypeName = grenadeTypeNames[grenadeType];
		this.Tag(grenadeTypeName + " done activate");

		if (hasItem(this, grenadeTypeName))
		{
			if (getNet().isServer())
			{
				string blobName = grenadeType == 2 ? "contact_grenade" :
				                  grenadeType == 1 ? "emp_grenade" :
				                                     "grenade";

				CBlob@ blob = server_CreateBlob(blobName, this.getTeamNum(), this.getPosition());

				if (blob !is null)
				{
					TakeItem(this, grenadeTypeName);
					ThrowGrenade(this, blob);
				}
			}

			SetFirstAvailableGrenade(this);
		}
	}
	else if (cmd == this.getCommandID("cycle"))  //from standardcontrols
	{
		// cycle arrows
		u8 type = this.get_u8("grenade type");
		int count = 0;
		while (count < grenadeTypeNames.length)
		{
			type++;
			count++;
			if (type >= grenadeTypeNames.length)
				type = 0;
			if (this.getBlobCount(grenadeTypeNames[type]) > 0)
			{
				this.set_u8("grenade type", type);
				if (this.isMyPlayer())
				{
					Sound::Play("/CycleInventory.ogg");
				}
				break;
			}
		}
	}
	else if (cmd == this.getCommandID("activate/throw"))
	{
		SetFirstAvailableGrenade(this);
	}
	else
	{
		for (uint i = 0; i < grenadeTypeNames.length; i++)
		{
			if (cmd == this.getCommandID("pick " + grenadeTypeNames[i]))
			{
				this.set_u8("grenade type", i);
				break;
			}
		}
	}
}

void ThrowGrenade( CBlob@ this, CBlob@ grenade )
{
	Vec2f vel = (this.getAimPos() - this.getPosition()) * 0.1f;
	f32 len = vel.Normalize();

	grenade.setVelocity(vel * Maths::Min(len, 10.0f));
	grenade.SetDamageOwnerPlayer(this.getPlayer());
}

//grenade management

bool hasItem(CBlob@ this, const string &in name)
{
	CBitStream reqs, missing;
	AddRequirement(reqs, "blob", name, "Grenades", 1);
	CInventory@ inv = this.getInventory();

	if (inv !is null)
	{
		return hasRequirements(inv, reqs, missing);
	}
	else
	{
		warn("our inventory was null! SoldierLogic.as");
	}

	return false;
}

void TakeItem(CBlob@ this, const string &in name)
{
	CBlob@ carried = this.getCarriedBlob();
	if (carried !is null)
	{
		if (carried.getName() == name)
		{
			carried.server_Die();
			return;
		}
	}

	CBitStream reqs, missing;
	AddRequirement(reqs, "blob", name, "Grenades", 1);
	CInventory@ inv = this.getInventory();

	if (inv !is null)
	{
		if (hasRequirements(inv, reqs, missing))
		{
			server_TakeRequirements(inv, reqs);
		}
		else
		{
			warn("took a grenade even though we dont have one! SoldierLogic.as");
		}
	}
	else
	{
		warn("our inventory was null! SoldierLogic.as");
	}
}

// grenade pick menu

void onCreateInventoryMenu(CBlob@ this, CBlob@ forBlob, CGridMenu @gridmenu)
{
	string weapon = getActiveItem(this);
	if    (weapon == "omni_tool") return;

	if (grenadeTypeNames.length == 0)
	{
		return;
	}

	this.ClearGridMenusExceptInventory();
	Vec2f pos(gridmenu.getUpperLeftPosition().x + 0.5f * (gridmenu.getLowerRightPosition().x - gridmenu.getUpperLeftPosition().x),
	          gridmenu.getUpperLeftPosition().y - 32 * 1 - 2 * 24);
	CGridMenu@ menu = CreateGridMenu(pos, this, Vec2f(grenadeTypeNames.length, 1), "Current grenade");
	u8 weaponSel = this.get_u8("grenade type");

	if (menu !is null)
	{
		menu.deleteAfterClick = false;

		for (uint i = 0; i < grenadeTypeNames.length; i++)
		{
			string matname = grenadeTypeNames[i];
			CGridButton @button = menu.AddButton(getIcon(grenadeTypeNames[i], this.getTeamNum()), grenadeNames[i], this.getCommandID("pick " + matname));

			if (button !is null)
			{
				bool enabled = this.getBlobCount(grenadeTypeNames[i]) > 0;
				button.SetEnabled(enabled);
				button.selectOneOnClick = true;
				if (weaponSel == i)
				{
					button.SetSelected(1);
				}
			}
		}
	}
}

void onAttach(CBlob@ this, CBlob@ attached, AttachmentPoint @attachedPoint)
{
	for (uint i = 0; i < grenadeTypeNames.length; i++)
	{
		if (attached.getName() == grenadeTypeNames[i])
		{
			this.set_u8("grenade type", i);
			break;
		}
	}
}

void onAddToInventory(CBlob@ this, CBlob@ blob)
{
	const string itemname = blob.getName();

	if (this.getInventory().getItemsCount() == 0 || itemname == "mat_grenades")
	{
		for (uint j = 0; j < grenadeTypeNames.length; j++)
		{
			if (itemname == grenadeTypeNames[j])
			{
				this.set_u8("grenade type", j);
				return;
			}
		}
	}
}

void SetFirstAvailableGrenade(CBlob@ this)
{
	u8 type = 255;
	if (this.exists("grenade type"))
		type = this.get_u8("grenade type");

	CInventory@ inv = this.getInventory();

	bool typeReal = (uint(type) < grenadeTypeNames.length);
	if (typeReal && inv.getItem(grenadeTypeNames[type]) !is null)
		return;

	for (int i = 0; i < inv.getItemsCount(); i++)
	{
		const string itemname = inv.getItem(i).getName();
		for (uint j = 0; j < grenadeTypeNames.length; j++)
		{
			if (itemname == grenadeTypeNames[j])
			{
				type = j;
				break;
			}
		}

		if (type != 255)
			break;
	}

	this.set_u8("grenade type", type);
}
