#define CLIENT_ONLY

#include "CreatureCommon.as";

void onInit( CSprite@ this )
{
	this.getCurrentScript().runFlags |= Script::tick_onground;
	this.getCurrentScript().runFlags |= Script::tick_not_inwater;
	this.getCurrentScript().runFlags |= Script::tick_moving;
	this.getCurrentScript().removeIfTag = "dead";
}

void onTick( CSprite@ this )
{
    CBlob@ blob = this.getBlob();
	
    if (blob.isKeyPressed(key_left) || blob.isKeyPressed(key_right))
    {
		CreatureMoveVars@ moveVars;
		if (!blob.get( "moveVars", @moveVars ))
		{
			return;
		}
		if ((blob.getNetworkID() + getGameTime()) % 9 == 0)
		{
			f32 volume = Maths::Min( 0.1f + Maths::Abs(blob.getVelocity().x) * 0.1f, 1.0f );
			TileType tile = blob.getMap().getTile( blob.getPosition() + Vec2f( 0.0f, blob.getRadius() + 4.0f )).type;

			if (blob.getMap().isTileGroundStuff( tile ))
			{
				this.PlaySound("/EarthStep", volume );
			}
			else
			{
				this.PlaySound("/StoneStep", volume );
			}
		}
    }
}