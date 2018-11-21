// Dorm

#include "Requirements.as"
#include "ShopCommon.as";
#include "Descriptions.as";
#include "WARCosts.as";
#include "CheckSpam.as";
#include "ClassSelectMenu.as";
#include "StandardRespawnCommand.as";

void onInit( CBlob@ this )
{

	InitRespawnCommand(this);
	InitClasses(this);
	this.Tag("change class drop inventory");
	
	this.set_TileType("background tile", CMap::tile_wood_back);
	this.SetLight(true);
	this.SetLightRadius(64.0f );
	//this.getSprite().getConsts().accurateLighting = true;
	

	this.getSprite().SetZ(-50); //background
	this.getShape().getConsts().mapCollisions = false;
	
}

void GetButtonsFor( CBlob@ this, CBlob@ caller )
{
		if (caller.getTeamNum() == this.getTeamNum())
	{
		CBitStream params;
		params.write_u16(caller.getNetworkID());
		CButton@ button = caller.CreateGenericButton("$change_class$", Vec2f(0, 0), this, SpawnCmd::buildMenu, "Change class", params);
	}
}
								   
void onCommand( CBlob@ this, u8 cmd, CBitStream @params )
{
	if (cmd == SpawnCmd::buildMenu || cmd == SpawnCmd::changeClass)
	{
		onRespawnCommand(this, cmd, params);
	}	
}

void onInit(CSprite@ this)
{
	this.SetFrame(0);

	CSpriteLayer@ fire = this.addSpriteLayer( "fire", 4,4 );
	if(fire !is null)
	{
		fire.addAnimation("default",3,true);
		int[] frames = {12,13,14};
		fire.animation.AddFrames(frames);
		fire.SetOffset(Vec2f(2, 2));
		fire.SetRelativeZ(0.1f);
	}
	
}

void onHealthChange(CBlob@ this, f32 oldHealth)
{
	CSprite@ sprite = this.getSprite();
	if(sprite !is null)
	{
		Animation@ destruction = sprite.getAnimation("destruction");
		if(destruction !is null)
		{
			f32 frame = Maths::Floor((this.getInitialHealth() - this.getHealth()) / (this.getInitialHealth() / sprite.animation.getFramesCount()));
			sprite.animation.frame = frame;
		}
	}
}