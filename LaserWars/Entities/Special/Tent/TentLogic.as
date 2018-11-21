// TentLogic.as

#include "StandardRespawnCommand.as";
#include "LoadoutCommon.as";

void onInit(CBlob@ this)
{
	this.addCommandID(cmd_loadout);
	
	this.getSprite().SetZ(-50.0f);

	this.CreateRespawnPoint("tent", Vec2f(0.0f, -4.0f));
	InitClasses(this);
	this.Tag("change class drop inventory");

	this.Tag("respawn");

	// minimap
	this.SetMinimapOutsideBehaviour(CBlob::minimap_snap);
	this.SetMinimapVars("GUI/Minimap/MinimapIcons.png", 1, Vec2f(8, 8));
	this.SetMinimapRenderAlways(true);

	// defaultnobuild
	this.set_Vec2f("nobuild extend", Vec2f(0.0f, 4.0f));
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
	else
	{
	    onRespawnCommand(this, cmd, params);
	}
}
