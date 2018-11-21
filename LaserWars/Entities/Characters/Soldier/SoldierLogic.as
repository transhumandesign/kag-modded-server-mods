/* SoldierLogic.as
 * author: Aphelion
 */

#include "SoldierCommon.as";

void onInit( CBlob@ this )
{
	this.UnsetMinimapVars();
	
	this.set_f32("gib health", -3.0f);
	this.Tag("player");
	this.Tag("flesh");

	CShape@ shape = this.getShape();
	shape.SetRotationsAllowed(false);
	shape.getConsts().net_threshold_multiplier = 0.5f;
	
	this.set_Vec2f("inventory offset", Vec2f(0.0f, 96.0f));

	this.getCurrentScript().runFlags |= Script::tick_not_attached;
	this.getCurrentScript().removeIfTag = "dead";
}

void onSetPlayer( CBlob@ this, CPlayer@ player )
{
	if (player !is null)
	{
		player.SetScoreboardVars("ScoreboardIcons.png", 2, Vec2f(16, 16));

		server_Setup(this, player);
	}
}

void onTick( CBlob@ this )
{
	RunnerMoveVars@ moveVars;
	if (!this.get("moveVars", @moveVars)) return;

	const bool myplayer = this.isMyPlayer();

	f32 suit_movement_factor = this.get_f32("movement_factor");

	moveVars.walkFactor *= suit_movement_factor;
	moveVars.jumpFactor *= suit_movement_factor;

	// shooting
	if (this.isKeyPressed(key_action1) || this.hasTag("shield"))
	{
		moveVars.walkFactor *= 0.75f;
		moveVars.jumpFactor *= 0.75f;
	}
}
