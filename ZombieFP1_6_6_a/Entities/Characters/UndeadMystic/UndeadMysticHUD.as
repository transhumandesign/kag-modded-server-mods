//Priest HUD

#include "UndeadMysticCommon.as";
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
		getHUD().SetCursorImage("../UndeadMysticCursor.png", Vec2f(32,32));
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
		//GUI::DrawIcon( "wSpellIcons.png", 0, Vec2f(16,16), Vec2f(12,58));
		GUI::DrawIcon( "umSpellIcons.png", 0, Vec2f(16,16), Vec2f(11,106));
		//GUI::DrawText("Heal", Vec2f(13,77), SColor(255, 255, 216, 0));
		//GUI::DrawText("Blink", Vec2f(13,125), SColor(255, 255, 216, 0));
	}
	else
	{
		//GUI::DrawIcon( "MenuItems.png", 13, Vec2f(32,32), Vec2f(10,58), 0.5f);
		GUI::DrawIcon( "MenuItems.png", 13, Vec2f(32,32), Vec2f(10,106), 0.5f);
		//GUI::SetFont("menu"); GUI::DrawText("" + cooldownTeleportSecs, Vec2f(30,75), SColor(255, 255, 216, 0));
		GUI::SetFont("menu"); GUI::DrawText("" + cooldownTeleportSecs, Vec2f(30,123), SColor(255, 255, 216, 0));
	}
	//orb icons
	u8 count = blob.get_u8("magic fire count");
	int orbsCount = (count - ORB_LIMIT) * (-1);
	
	u32 lastFireTime = blob.get_u32("last magic fire");
	int diffOrb = gametime - (lastFireTime + ORB_BURST_COOLDOWN);
	double cooldownOrbSecs = (diffOrb / 30) * (-1);
	int cooldownOrbFullSecs = diffOrb % 30;
	double cooldownOrbSecsHUD;
	if (cooldownOrbFullSecs == 0 && cooldownOrbSecs >= 0) cooldownOrbSecsHUD = cooldownOrbSecs;
	
	//const u8 type = getOrbType( blob );
	
	f32 r = ORB_LIMIT/5*8;
	Vec2f delta(-r*Maths::Sin(6.283f/ORB_LIMIT), -r*Maths::Cos(6.283f/ORB_LIMIT));

	if(count == ORB_LIMIT)
	{
		GUI::DrawIcon( "MenuItems.png", 13, Vec2f(32,32), Vec2f(10,58), 0.5f);
		GUI::SetFont("menu"); GUI::DrawText("" + cooldownOrbSecs, Vec2f(30,75), SColor(255, 255, 216, 0));
	}
	else
	{
		GUI::DrawIcon( "umSpellIcons.png", 2, Vec2f(16,16), Vec2f(10,58), 1.0f, 1);
		GUI::SetFont("menu"); GUI::DrawText("" + orbsCount, Vec2f(30,75), SColor(255, 255, 216, 0));
	}	
	
	// draw inventory
	DrawInventoryOnHUD( blob, tl, Vec2f(0,100));

	// draw coins
	const int coins = player !is null ? player.getCoins() : 0;
	DrawCoinsOnHUD( blob, coins, tl, slotsSize-2 );

	// class weapon icon
	GUI::DrawIcon( iconsFilename, 13, Vec2f(16, 16), Vec2f(10, 10), 1.0f);
}
