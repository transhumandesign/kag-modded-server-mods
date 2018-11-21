//necromancer HUD

#include "UndeadNecromancerCommon.as";
#include "nActorHUDStartPos.as";

const string iconsFilename = "jclass.png";
const int slotsSize = 6;

void onInit( CSprite@ this )
{
	this.getCurrentScript().runFlags |= Script::tick_myplayer;
	this.getCurrentScript().removeIfTag = "dead";
	this.getBlob().set_u8("gui_HUD_slots_width", slotsSize);
}

void ManageCursors( CBlob@ this )
{
	// set cursor
	if (getHUD().hasButtons()) {
		getHUD().SetDefaultCursor();
	}
	else
	{
		// set cursor
		getHUD().SetCursorImage("UndeadNecromancerCursor.png", Vec2f(32,32));
		getHUD().SetCursorOffset( Vec2f(-32, -32) );
		// frame set in logic
	}
}

void onRender( CSprite@ this )
{
	if (g_videorecording)
		return;

	CBlob@ blob = this.getBlob();
	CPlayer@ player = blob.getPlayer();
	const u32 gametime = getGameTime();

	ManageCursors( blob );

	Vec2f tl = getActorHUDStartPosition(blob, slotsSize);
	
	GUI::DrawIcon("GUI/jslot.png", 1, Vec2f(32,32), Vec2f(2,50));
	GUI::DrawIcon("GUI/jslot.png", 1, Vec2f(32,32), Vec2f(2,98));
	
	//teleport icon
	u32 lastTeleport = blob.get_u32("last teleport");
	int diff = gametime - (lastTeleport + TELEPORT_FREQUENCY);
	double cooldownTeleportSecs = (diff / 30) * (-1);
	int cooldownTeleportFullSecs = diff % 30;
	double cooldownTeleportSecsHUD;
	if (cooldownTeleportFullSecs == 0 && cooldownTeleportSecs >= 0) cooldownTeleportSecsHUD = cooldownTeleportSecs;
	
	if (diff > 0)
	{
		GUI::DrawIcon( "SpellIcons.png", 0, Vec2f(16,16), Vec2f(11,58));
		GUI::DrawIcon( "SpellIcons.png", 1, Vec2f(16,16), Vec2f(10,106));
	}
	else
	{
		GUI::DrawIcon( "MenuItems.png", 13, Vec2f(32,32), Vec2f(10,58), 0.5f);
		GUI::DrawIcon( "MenuItems.png", 13, Vec2f(32,32), Vec2f(10,106), 0.5f);
		GUI::SetFont("menu"); GUI::DrawText("" + cooldownTeleportSecs, Vec2f(25,75), SColor(255, 255, 216, 0));
		GUI::SetFont("menu"); GUI::DrawText("" + cooldownTeleportSecs, Vec2f(25,123), SColor(255, 255, 216, 0));
	}
	// draw inventory
	DrawInventoryOnHUD( blob, tl, Vec2f(0,100));

	const u8 type = getOrbType( blob );
	u8 arrow_frame = 0;

	// draw coins
	const int coins = player !is null ? player.getCoins() : 0;
	DrawCoinsOnHUD( blob, coins, tl, slotsSize-2 );

	// class weapon icon
	GUI::DrawIcon( iconsFilename, 14, Vec2f(16, 16), Vec2f(9, 10), 1.0f);
}
