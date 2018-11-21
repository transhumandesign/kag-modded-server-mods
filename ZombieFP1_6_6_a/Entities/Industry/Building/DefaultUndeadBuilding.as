// A default building init script

void onInit( CBlob@ this )
{	 	 
	this.getSprite().SetZ(-50); //background
	this.getShape().getConsts().mapCollisions = false;
	this.getSprite().getConsts().accurateLighting = true;
	this.Tag("building");

	this.SetLight(true);
	this.SetLightRadius( 30.0f );
}
		

void onTick( CBlob@ this )
{
	if (this.getTickSinceCreated() == 10)
	{
		// make window
		Vec2f tilepos = this.getPosition()-Vec2f(0,4);
		getMap().server_SetTile(tilepos, CMap::tile_empty);

		//check overlapping buildings and die if we have any
		CBlob@[] overlapping;
		if(this.getOverlapping( overlapping ))
		{
			for(uint i = 0; i < overlapping.length; ++i)
			{
				CBlob@ _b = overlapping[i];
				if(_b.hasTag("building"))
				{
					this.server_Die();
					break;
				}
			}
		}

		this.getCurrentScript().runFlags |= Script::remove_after_this;
	}
}

// SPRITE

//void onInit(CSprite@ this)
//{
//	CBlob@ blob = this.getBlob();
//	CSpriteLayer@ lantern = this.addSpriteLayer( "lantern", "Lantern.png" , 8, 8, blob.getTeamNum(), blob.getSkinNum() );
//	
//	if (lantern !is null)
//    {
//		lantern.SetOffset(Vec2f(9,-5));
//		
//        Animation@ anim = lantern.addAnimation( "default", 3, true );
//        anim.AddFrame(0);
//        anim.AddFrame(1);
//        anim.AddFrame(2);
//        
//        blob.SetLight(true);
//		blob.SetLightRadius( 32.0f );
//    }
//}
