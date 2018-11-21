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
	this.set_Vec2f("shop menu size", Vec2f(5,2));
	this.set_string("shop description", "Exchange materials and buy stuff");
	this.set_u8("shop icon", 25);
	


	{
		ShopItem@ s = addShopItem( this, "Blue Lantern", "$bluelantern$", "bluelantern", "A lantern with a bigger light radius but with a dim ilumination.", true );
		AddRequirement( s.requirements, "coin", "", "Coins", 10 );
	}
	{
		ShopItem@ s = addShopItem( this, "Diving Helmet", "$divinghelmet$", "divinghelmet", "A helmet specially made for underwater exploring.", true );
		AddRequirement( s.requirements, "coin", "", "Coins", 50 );
	}
	{
		ShopItem@ s = addShopItem( this, "Gold Drill", "$golddrill$", "golddrill", "An improved drill.", true );
		AddRequirement( s.requirements, "coin", "", "Coins", 50 );
	}	
	{	 
		ShopItem@ s = addShopItem( this, "Shark", "$shark$", "fshark", "It eats zombies too.", false, true );
		s.crate_icon = 22;
		AddRequirement( s.requirements, "coin", "", "Coins", 200 );
	}
    /*{	 
		ShopItem@ s = addShopItem( this, "Bison", "$bison$", "bison", "Ride it to battle!.", false, true );
		s.crate_icon = 21;
		AddRequirement( s.requirements, "coin", "", "Coins", 150 );
	}*/	
	{
		ShopItem@ s = addShopItem( this, "Mage", "$mage$", "mage", "Hire a Mage who will help you.", false);
		AddRequirement( s.requirements, "coin", "", "Coins", 100 );
		AddRequirement(s.requirements, "blob", "migrantbot", "Migrant", 1);
	}
	{
		ShopItem@ s = addShopItem( this, "Scroll of Drought", "$drought$", "drought", "Dries a large water chunk of water.", true );
		AddRequirement( s.requirements, "coin", "", "Coins", 250 );
	}
	{	 
		ShopItem@ s = addShopItem( this, "Wood", "$mat_wood$", "mat_wood", "Exchange 50 Gold for 250 Wood", true );
		AddRequirement( s.requirements, "blob", "mat_gold", "Gold", 50 );
	}
	{
		ShopItem@ s = addShopItem( this, "Stone", "$mat_stone$", "mat_stone", "Exchange 100 Gold for 250 Stone", true );
		AddRequirement( s.requirements, "blob", "mat_gold", "Gold", 100 );
	}
	{
		ShopItem@ s = addShopItem( this, "Gold for coins", "$mat_gold$", "mat_gold", "Buy 250 gold for 500 coins.", true );
		AddRequirement( s.requirements, "coin", "", "Coins", 500 );
	}
	{
		ShopItem@ s = addShopItem( this, "Class Book", "$whitebook$", "randomBook", "Merge 10 white pages into a random class book.", true);
		AddRequirement( s.requirements, "blob", "whitepage", "White Pages", 10 );
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
		
		bool isServer = (getNet().isServer());
			
		u16 caller, item;
		
		if(!params.saferead_netid(caller) || !params.saferead_netid(item))
			return;
		
		CBlob@ blob = getBlobByNetworkID( caller );
		CBlob@ tree;
		Vec2f pos = this.getPosition();
		
		string name = params.read_string();
		
		{
			if(name == "randomBook")
			{
				if (isServer)
				{
					int r = XORRandom(6);
					if (r == 0)
						server_CreateBlob("spyro", this.getTeamNum(), this.getPosition());
					else if (r == 1)
						server_CreateBlob("sdragoon", this.getTeamNum(), this.getPosition());
					else if (r == 2)
						server_CreateBlob("scrossbow", this.getTeamNum(), this.getPosition());
					else if (r == 3)
						server_CreateBlob("swizard", this.getTeamNum(), this.getPosition());
					else if (r == 4)
						server_CreateBlob("sassassin", this.getTeamNum(), this.getPosition());	
					else if (r == 5)
						server_CreateBlob("sburd", this.getTeamNum(), this.getPosition());						
				}			
			}		
		}
	}
}

void onDie(CBlob@ this)
{
	Sound::Play("/Wilhelm.ogg", this.getPosition());
}

