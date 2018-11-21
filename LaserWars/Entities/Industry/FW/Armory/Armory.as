// Armory.as

#include "LoadoutCommon.as";

void onInit(CBlob@ this)
{
	this.addCommandID(cmd_loadout);

	this.set_TileType("background tile", CMap::tile_castle_back);

	this.getSprite().SetZ(-50); //background
	this.getShape().getConsts().mapCollisions = false;
}

void GetButtonsFor(CBlob@ this, CBlob@ caller)
{
	CBitStream params;
	params.write_u16(caller.getNetworkID());

    caller.CreateGenericButton(11, Vec2f(0.0f, 0.0f), this, this.getCommandID(cmd_loadout), "Loadout", params);
}

void onCommand( CBlob@ this, u8 cmd, CBitStream@ params )
{
	if (cmd == this.getCommandID(cmd_loadout))
	{
		u16 id;
		if(!params.saferead_u16(id)) return;

		CBlob@ caller = getBlobByNetworkID(id);
		if    (caller is null) return;

		caller.SendCommand(LoadoutMenu::SHOW_MENU, params);
	}
}

void onHealthChange(CBlob@ this, f32 oldHealth)
{
	CSprite@ sprite = this.getSprite();
	if (sprite !is null)
	{
		Animation@ destruction = sprite.getAnimation("destruction");
		if (destruction !is null)
		{
			f32 frame = Maths::Floor((this.getInitialHealth() - this.getHealth()) / (this.getInitialHealth() / sprite.animation.getFramesCount()));
			sprite.animation.frame = frame;
		}
	}
}
