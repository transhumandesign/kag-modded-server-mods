// Zombie Portal

//#include "Requirements.as"
//#include "ShopCommon.as";
//#include "Descriptions.as";
//#include "WARCosts.as";
//#include "CheckSpam.as";

void onInit( CBlob@ this )
{	 
	//this.set_TileType("background tile", CMap::tile_wood_back);
	//this.getSprite().getConsts().accurateLighting = true;
	
	this.Tag("ZP");
	this.getSprite().SetZ(-50); //background
	CSpriteLayer@ portal = this.getSprite().addSpriteLayer( "portal", "ZombiePortal.png" , 64, 64, -1, -1 );
	CSpriteLayer@ lightning = this.getSprite().addSpriteLayer( "lightning", "EvilLightning.png" , 32, 32, -1, -1 );
	Animation@ anim = portal.addAnimation( "default", 0, true );
	Animation@ lanim = lightning.addAnimation( "default", 4, false );
	for (int i=0; i<7; i++) lanim.AddFrame(i*4);
	Animation@ lanim2 = lightning.addAnimation( "default2", 4, false );
	for (int i=0; i<7; i++) lanim2.AddFrame(i*4+1);
	anim.AddFrame(1);
	portal.SetRelativeZ( 1000 );
//	portal.SetOffset(Vec2f(0,-24));
//	lightning.SetOffset(Vec2f(0,-24));
	this.getShape().getConsts().mapCollisions = false;
	this.set_bool("portalbreach",false);
	this.set_bool("portalplaybreach",false);
	this.SetLight(false);
	this.SetLightRadius( 64.0f );
}

void onDie( CBlob@ this)
{
	server_DropCoins(this.getPosition() + Vec2f(0,-32.0f), 1000);
	
	{
	int r = XORRandom(3);
	if (r == 0)
		server_CreateBlob("wooden_chest", this.getTeamNum(), this.getPosition());
	else if (r == 1)
		server_CreateBlob("iron_chest", this.getTeamNum(), this.getPosition());
	else if (r == 2)
		server_CreateBlob("gold_chest", this.getTeamNum(), this.getPosition());
	}
	
}
void onTick( CBlob@ this)
{
	int spawnRate = 18 + (190*this.getHealth() / 44.0);
	if (getGameTime() % spawnRate == 0 && this.get_bool("portalbreach"))
	{
		this.getSprite().PlaySound("Thunder");
		CSpriteLayer@ lightning = this.getSprite().getSpriteLayer("lightning");
		if (XORRandom(4)>2) lightning.SetAnimation("default"); else lightning.SetAnimation("default2");
		//lightning.SetFrame(0);
	}

	if (this.get_bool("portalplaybreach")) {
		this.getSprite().PlaySound("PortalBreach");
		this.set_bool("portalplaybreach",false);
		this.SetLight(true);
		this.SetLightRadius( 128.0f );		
	}
	if (!getNet().isServer()) return;
	int num_pzombies = getRules().get_s32("num_pzombies");
	if (this.get_bool("portalbreach"))
	{
		if ((getGameTime() % spawnRate == 0) && num_pzombies < 20)
		{
		CBlob@[] blobs;
		getMap().getBlobsInRadius( this.getPosition(), 250, @blobs );
		if (blobs.length == 0) return;
		
			Vec2f sp = this.getPosition();
			
			int r;
			r = XORRandom(13);
			int rr = XORRandom(14);
			if (r==8 && rr<3)
			server_CreateBlob( "pbanshee", -1, sp);
			else										
			if (r==7 && rr<3)
			server_CreateBlob( "pgreg", -1, sp);
			else					
			if (r==4)
			server_CreateBlob( "phellknight", -1, sp);
			else
			if (r==3)
			server_CreateBlob( "pbrute", -1, sp);
			else
			if (r==2)
			server_CreateBlob( "pankou", -1, sp);
			else			
			server_CreateBlob( "pcrawler", -1, sp);
			if ((r==7 && rr<3) || (r==8 && rr<3) || (r<7))
			{
				num_pzombies++;
				getRules().set_s32("num_pzombies",num_pzombies);
				
			}
		}
	}
	else
	{
		if (getGameTime() % 600 == 0)
		{
			Vec2f sp = this.getPosition();
			
		
			CBlob@[] blobs;
			this.getMap().getBlobsInRadius( sp, 64, @blobs );
			for (uint step = 0; step < blobs.length; ++step)
			{
				CBlob@ other = blobs[step];
				if (other.hasTag("survivorplayer"))
				{
					this.set_bool("portalbreach",true);
					this.set_bool("portalplaybreach",true);
					this.Sync("portalplaybreach",true);
					this.Sync("portalbreach",true);
				}
			}
		}
	}
}
							   
