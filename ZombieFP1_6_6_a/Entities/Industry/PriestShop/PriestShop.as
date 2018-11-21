// Wizard Workshop

#include "Requirements.as";
#include "ShopCommon.as";
#include "Descriptions.as";
#include "CheckSpam.as";
#include "CTFShopCommon.as";

void onInit( CBlob@ this )
{	 
	this.set_TileType("background tile", CMap::tile_wood_back);
	//this.getSprite().getConsts().accurateLighting = true;
	

	this.getSprite().SetZ(-50); //background
	this.getShape().getConsts().mapCollisions = false;

	// SHOP

	this.set_Vec2f("shop offset", Vec2f(0, 0));
	this.set_Vec2f("shop menu size", Vec2f(4,1));	
	this.set_string("shop description", "Buy Orbs");
	this.set_u8("shop icon", 25);

	// CLASS
	this.set_Vec2f("class offset", Vec2f(-6, 0));
	this.set_string("required class", "priest");	


	{
		ShopItem@ s = addShopItem( this, "30 Regular Orbs", "$mat_orbs$", "mat_orbs", "The basic kind of orbs.", true);
		AddRequirement( s.requirements, "coin", "", "Coins", 25 );
	}
	{
		ShopItem@ s = addShopItem( this, "5 Fire Orbs", "$mat_fireorbs$", "mat_fireorbs", "Made of fire.", true);
		AddRequirement( s.requirements, "coin", "", "Coins", 30 );
	}
	{
		ShopItem@ s = addShopItem( this, "3 Bomb Orbs", "$mat_bomborbs$", "mat_bomborbs", "Far more explosive, they also destroy terrain.", true);
		AddRequirement( s.requirements, "coin", "", "Coins", 35 );
	}
	{
		ShopItem@ s = addShopItem( this, "10 Water Orbs", "$mat_waterorbs$", "mat_waterorbs", "They might stun.", true);
		AddRequirement( s.requirements, "coin", "", "Coins", 20 );
	}
	/*{
		ShopItem@ s = addShopItem( this, "Knight Corpse to Warrior", "$nwarrior$", "summonWarrior", "Turn a Knight Corpse into a Zombie Warrior.", false);
		AddRequirement( s.requirements, "blob", "knight", "Dead Knight", 1 );
	}
	
	{
		ShopItem@ s = addShopItem( this, "Archer Corpse to Arsonist", "$narsonist$", "summonSkeleton", "Turn an Archer Corpse into a Skeleton Arsonist.", false);
		AddRequirement( s.requirements, "blob", "archer", "Dead Archer", 1 );
	}	

	{
		ShopItem@ s = addShopItem( this, "Builder Corpse to Migrant", "$nmigrant$", "summonZombie", "Turn a Builder Corpse into a Zombie Migrant.", false);
		AddRequirement( s.requirements, "blob", "builder", "Dead Builder", 1 );
	}
	{
		ShopItem@ s = addShopItem( this, "Wizard Corpse to Gargoyle", "$ngarg$", "summonGargoyle", "Turn a Wizard Corpse into a Flame Gargoyle.", false);
		AddRequirement( s.requirements, "blob", "wizard", "Dead Wizard", 1 );
	}*/	
	
	this.set_string("required class", "priest");
}

void GetButtonsFor(CBlob@ this, CBlob@ caller)
{
	u8 kek = caller.getTeamNum();	
	if (kek == 0)
	{
		if(caller.getConfig() == this.get_string("required class"))
		{
			this.set_Vec2f("shop offset", Vec2f_zero);
		}
		else
		{
			this.set_Vec2f("shop offset", Vec2f(6, 0));
		}
		this.set_bool("shop available", this.isOverlapping(caller));
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
		CBlob@ zombie;
		CBlob@ corpse;
		
		string name = params.read_string();
		
		{
			if(name == "summonWarrior")
			{
				if (isServer)
				{
					if (blob !is null)  
					{
						@corpse = server_CreateBlob( "knight", blob.getTeamNum(), this.getPosition()); 
						@zombie = server_CreateBlob( "nwarrior", blob.getTeamNum(), this.getPosition());
					}
				}
				if (corpse !is null) 
				{
					corpse.getSprite().Gib();
					corpse.server_Die();
				}
				if (zombie !is null) ParticleZombieLightning(zombie.getPosition());				
			}
			
			if(name == "summonZombie")
			{
				if (isServer)
				{
					if (blob !is null)  
					{
						@corpse = server_CreateBlob( "builder", blob.getTeamNum(), this.getPosition()); 
						@zombie = server_CreateBlob( "nzombie", blob.getTeamNum(), this.getPosition());
					}
				}
				if (corpse !is null) 
				{
					corpse.getSprite().Gib();
					corpse.server_Die();
				}
				if (zombie !is null) ParticleZombieLightning(zombie.getPosition());				
			}
			
			if(name == "summonSkeleton")
			{
				if (isServer)
				{
					if (blob !is null)  
					{
						@corpse = server_CreateBlob( "archer", blob.getTeamNum(), this.getPosition()); 
						@zombie = server_CreateBlob( "nskeleton", blob.getTeamNum(), this.getPosition());
					}
				}
				if (corpse !is null) 
				{
					corpse.getSprite().Gib();
					corpse.server_Die();
				}
				if (zombie !is null) ParticleZombieLightning(zombie.getPosition());
			}
			
			if(name == "summonGargoyle")
			{
				if (isServer)
				{
					if (blob !is null)  
					{
						@corpse = server_CreateBlob( "wizard", blob.getTeamNum(), this.getPosition()); 
						@zombie = server_CreateBlob( "ngarg", blob.getTeamNum(), this.getPosition());
					}
				}
				if (corpse !is null) 
				{
					corpse.getSprite().Gib();
					corpse.server_Die();
				}
				if (zombie !is null) ParticleZombieLightning(zombie.getPosition());
			}			
		}
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