// Dorm

#include "WARCosts.as";
#include "ShopCommon.as";
#include "Descriptions.as";
#include "MigrantCommon.as";
#include "ClassSelectMenu.as";
#include "StandardRespawnCommand.as";

void onInit( CBlob@ this )
{	 
	InitRespawnCommand(this);
	InitClasses(this);
	this.Tag("change class drop inventory");
	
	this.SetLight(true);
	this.SetLightRadius(64.0f );
	
	this.set_TileType("background tile", CMap::tile_wood_back);
	this.Tag("bed");
	
	// from TheresAMigrantInTheRoom
	this.set_u8("migrants max", 1 );		   		 // how many physical migrants it needs	

	this.getSprite().SetZ(-50); //background
	this.getShape().getConsts().mapCollisions = false;	
}	  

void GetButtonsFor( CBlob@ this, CBlob@ caller )
{
	u8 kek = caller.getTeamNum();	
	if (kek == 0)
	{
		if (caller.getTeamNum() == this.getTeamNum())
		{
			CBitStream params;
			params.write_u16(caller.getNetworkID());
			CButton@ button = caller.CreateGenericButton("$change_class$", Vec2f(0, 0), this, SpawnCmd::buildMenu, "Change class", params);
		}
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

	CSpriteLayer@ fire = this.addSpriteLayer( "fire", 8,8 );
	if(fire !is null)
	{
		fire.addAnimation("default",3,true);
		int[] frames = {10,11,42,43};
		fire.animation.AddFrames(frames);
		fire.SetOffset(Vec2f(-9, 5));
		fire.SetRelativeZ(0.1f);
	}
}
