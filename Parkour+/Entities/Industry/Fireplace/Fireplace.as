// Fireplace

#include "ProductionCommon.as";
#include "Requirements.as"
#include "MakeFood.as"
#include "FireParticle.as"

void onInit(CBlob@ this)
{
	this.getShape().getConsts().mapCollisions = false;
	this.getCurrentScript().tickFrequency = 64;
	this.getSprite().SetEmitSound("CampfireSound.ogg");

	this.SetLight(true);
	this.SetLightRadius(164.0f);
	this.SetLightColor(SColor(255, 255, 240, 171));

	this.Tag("fire source");
	//this.server_SetTimeToDie(60*3);
	this.getSprite().SetZ(-500.0f);
}

void onTick(CBlob@ this)
{
	if (XORRandom(3) == 0)
	{
		makeSmokeParticle(this.getPosition(), -0.05f);

		this.getSprite().SetEmitSoundPaused(false);
	}
	else
		makeFireParticle(this.getPosition() + getRandomVelocity(90.0f, 3.0f, 360.0f));
}

void onInit(CSprite@ this)
{
	this.SetZ(-50); //background

	//init flame layer
	CSpriteLayer@ fire = this.addSpriteLayer("fire_animation_large", "Entities/Effects/Sprites/LargeFire.png", 16, 16, -1, -1);

	if (fire !is null)
	{
		fire.SetRelativeZ(100);
		{
			Animation@ anim = fire.addAnimation("bigfire", 6, true);
			anim.AddFrame(1);
			anim.AddFrame(2);
			anim.AddFrame(3);
		}
		{
			Animation@ anim = fire.addAnimation("smallfire", 6, true);
			anim.AddFrame(4);
			anim.AddFrame(5);
			anim.AddFrame(6);
		}
		fire.SetVisible(true);
	}
}
