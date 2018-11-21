// Scripts by Diprog, sprite by AsuMagic. If you want to copy/change it and upload to your server ask creators of this file. You can find them at KAG forum.

#include "Requirements.as"
#include "ShopCommon.as";
#include "CheckSpam.as";

void onInit( CBlob@ this )
{	 
	this.set_TileType("background tile", CMap::tile_wood_back);
	this.SetLight(true);
	this.SetLightRadius(64.0f );
	//this.getSprite().getConsts().accurateLighting = true;
	

	this.getSprite().SetZ(-50); //background
	this.getShape().getConsts().mapCollisions = false;

	// SHOP
	this.set_Vec2f("shop offset", Vec2f(0, 0));
	this.set_Vec2f("shop menu size", Vec2f(2,2));
	this.set_string("shop description", "Exchange materials and buy stuff");
	this.set_u8("shop icon", 25);
	


	{
		ShopItem@ s = addShopItem( this, "Chicken", "$chicken$", "chicken", "Pluck.", false );
		AddRequirement( s.requirements, "coin", "", "Coins", 25 );
	}
	{
		ShopItem@ s = addShopItem( this, "Piglet", "$piglet$", "piglet", "Oink.", false );
		AddRequirement( s.requirements, "coin", "", "Coins", 25 );
	}	
	{
		ShopItem@ s = addShopItem( this, "Bunny", "$bunny$", "bunny", "I don't know how the hell a bunny sounds like.", false );
		AddRequirement( s.requirements, "coin", "", "Coins", 25 );
	}
	{
		ShopItem@ s = addShopItem( this, "Birb", "$birb$", "birb", "Chirp chirp.", false );
		AddRequirement( s.requirements, "coin", "", "Coins", 25 );
	}	

}

void GetButtonsFor( CBlob@ this, CBlob@ caller )
{
	u8 kek = caller.getTeamNum();	
	if (kek == 0)
	{
		this.set_bool("shop available", this.isOverlapping(caller) /*&& caller.getName() == "builder"*/ );
	}
}
								   
void onCommand( CBlob@ this, u8 cmd, CBitStream @params )
{
	if (cmd == this.getCommandID("shop made item"))
	{
		this.getSprite().PlaySound( "/ChaChing.ogg" );
	}
}