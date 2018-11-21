#define CLIENT_ONLY

#include "RunnerCommon.as"

//Thanks to Mazey for the solution below for custom footstep sounds
//So far it only worked with the tiles declared in vanilla, not with custom ones, perhaps include customblocks here?
const string[] snowsteps =	 {"SnowStep1.ogg", "SnowStep2.ogg", "SnowStep3.ogg", "SnowStep4.ogg", "SnowStep5.ogg", "SnowStep6.ogg", "SnowStep7.ogg", "SnowStep8.ogg"};
const string[] gravelsteps = {"Gravel1.ogg", "Gravel2.ogg", "Gravel3.ogg", "Gravel4.ogg", "Gravel5.ogg", "Gravel6.ogg", "Gravel7.ogg", "Gravel8.ogg"};
const string[] woodsteps = {"WoodStep1.ogg", "WoodStep2.ogg", "WoodStep3.ogg", "WoodStep4.ogg", "WoodStep5.ogg", "WoodStep6.ogg", "WoodStep7.ogg"};
const string[] metalsteps = {"Metal01.ogg", "Metal02.ogg", "Metal03.ogg", "Metal04.ogg"};
const string filepathsnow = "../Mods/01/Entities/Characters/Sounds/Footsteps/";
const string filepathgravel = "../Mods/01/Entities/Characters/Sounds/Footsteps/";
const string filepathwood = "../Mods/01/Entities/Characters/Sounds/Footsteps/";
const string filepathmetal = "../Mods/01/Entities/Characters/Sounds/Footsteps/";


void onInit(CSprite@ this)
{
	this.getCurrentScript().runFlags |= Script::tick_onground;
	this.getCurrentScript().runFlags |= Script::tick_not_inwater;
	this.getCurrentScript().runFlags |= Script::tick_moving;
	this.getCurrentScript().removeIfTag = "dead";
}

void onTick(CSprite@ this)
{
	CBlob@ blob = this.getBlob();
	if (/*blob.isOnGround() && */(blob.isKeyPressed(key_left) || blob.isKeyPressed(key_right)))
	{
		RunnerMoveVars@ moveVars;
		if (!blob.get("moveVars", @moveVars))
		{
			return;
		}
		if ((blob.getNetworkID() + getGameTime()) % (moveVars.walkFactor < 1.0f ? 14 : 8) == 0)
		{
			f32 volume = Maths::Min(0.1f + Maths::Abs(blob.getVelocity().x) * 0.1f, 1.0f);
			TileType tile = blob.getMap().getTile(blob.getPosition() + Vec2f(0.0f, blob.getRadius() - 4.0f)).type; // shape changed how this behaved, it was +4.0f originally

			if (blob.getMap().isTileGround(tile))
			{
				this.PlayRandomSound("/EarthStep", volume);
			}		
			else if (blob.getMap().isTileThickStone(tile))
			{
				Sound::Play(filepathsnow + snowsteps[XORRandom(snowsteps.length)], blob.getPosition());
			}
			else if (blob.getMap().isTileBedrock(tile))
			{
				Sound::Play(filepathgravel + gravelsteps[XORRandom(gravelsteps.length)], blob.getPosition());
			}
			else if (blob.getMap().isTileStone(tile))
			{
				Sound::Play(filepathwood + woodsteps[XORRandom(woodsteps.length)], blob.getPosition());
			}
			/*else if (blob.getMap().isTileGold(tile))
			{
				Sound::Play(filepathmetal + metalsteps[XORRandom(metalsteps.length)], blob.getPosition());
			}*/
			else
			{
				this.PlayRandomSound("/StoneStep", volume);
			}
		}
	}
}

