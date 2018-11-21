// Aphelion \\

#define SERVER_ONLY

#include "CreatureCommon.as";

u16 OBSTRUCTION_THRESHOLD = 90; // 30 = 1 second

void onInit( CBrain@ this )
{
	this.getBlob().set_u16(obstruction_threshold, 0);

	this.getCurrentScript().removeIfTag	= "dead";
	this.getCurrentScript().runFlags |= Script::tick_not_attached;
}

void onTick( CBrain@ this )
{
	// know when we're stuck, and fix it
	DetectObstructions( this, this.getBlob() );
}

void DetectObstructions( CBrain@ this, CBlob@ blob)
{
	u16 threshold = blob.get_u16(obstruction_threshold);

	Vec2f mypos = blob.getPosition();

	const bool left = blob.isKeyPressed(key_left);
	const bool right = blob.isKeyPressed(key_right);
	const bool up = blob.isKeyPressed(key_up);
	const bool down = blob.isKeyPressed(key_down);
	const f32 radius = blob.getRadius();

	bool obstructed = up && getMap().isTileSolid( mypos - Vec2f( 0.0f, 1.3f * radius) * 1.0f );
	if  (obstructed)
	{
		threshold++;
	}
	else if(threshold > 0)
		    threshold--;
	
	if (threshold >= OBSTRUCTION_THRESHOLD)
	{
		RemoveTarget(this);
		ResetDestination(blob);
		
		// for the wraith
		blob.Tag("enraged");
		blob.Sync("enraged", true);

		threshold = 0;
	}
	
	blob.set_u16(obstruction_threshold, threshold);
}
