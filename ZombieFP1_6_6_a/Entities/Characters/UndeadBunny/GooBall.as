//GooBall
const f32 DAMAGE = 1.0f;
const f32 AOE = 20.0f;//radius

void onInit( CBlob@ this )
{
	this.set_u8( "gooTime", 50 );
    CShape@ shape = this.getShape();
	ShapeConsts@ consts = shape.getConsts();
    consts.mapCollisions = true;
	consts.bullet = false;
	consts.net_threshold_multiplier = 4.0f;
	
	this.server_SetTimeToDie( 7 );
	this.getCurrentScript().tickFrequency = 30;

}

void onTick( CBlob@ this )
{
	//through ground server check
	if ( getNet().isServer() && getMap().rayCastSolidNoBlobs( this.getShape().getVars().oldpos, this.getPosition() ) )
		this.server_Die();
	//reached ground
	if ( this.getSprite().isAnimation( "static" ) && this.getVelocity().Length() < 0.1f )
	{
		this.getShape().SetStatic( true );
		this.getCurrentScript().tickFrequency = 0;
	}
}

void onCollision( CBlob@ this, CBlob@ blob, bool solid, Vec2f normal, Vec2f worldPoint )
{
	if ( blob !is null && doesCollideWithBlob( this, blob ) )
		this.server_Die();
	else if ( solid )
	{	
		//reached ground
		CMap@ map = getMap();
		Tile tileBelowLeft = map.getTile( worldPoint + Vec2f( -4, 3 ) );
		Tile tileBelowRight = map.getTile( worldPoint + Vec2f( 4, 3 ) );

		if ( map.isTileSolid( tileBelowLeft ) && map.isTileSolid( tileBelowRight ) )
			this.getSprite().SetAnimation( "static" );//GooBallAnim does the rest
		else
			this.server_Die();
	}
}

bool doesCollideWithBlob( CBlob@ this, CBlob@ blob )
{
	return this.getTeamNum() != blob.getTeamNum() && ( blob.hasTag( "flesh" ) || blob.hasTag( "block" ) || blob.hasTag( "survivorbuilding" ) );//use blob.isCollidable()?
}

void onDie( CBlob@ this )
{
	Vec2f pos = this.getPosition();
	CBlob@[] aoeBlobs;
	CMap@ map = getMap();
	
	if ( getNet().isServer() )
	{
		map.getBlobsInRadius( pos, AOE, @aoeBlobs );
		for ( u8 i = 0; i < aoeBlobs.length(); i++ )
		{
			CBlob@ blob = aoeBlobs[i];
			if ( !getMap().rayCastSolidNoBlobs( pos, blob.getPosition() ) )
				this.server_Hit( blob, pos, Vec2f_zero, DAMAGE, 40, blob.getName() == "gooball" );
		}
	}
	
	this.getSprite().PlaySound( "splat.ogg" );
	ParticleAnimated( "/GooSplat.png",
				  this.getPosition(), Vec2f(0,0), 0.0f, 1.5f,
				  3,
				  -0.1f, false );				  
	
	Tile tile = map.getTile( pos );
	if ( !this.isOnGround() && !this.isInWater() && map.isTileBackground( tile ) && !map.isTileGrass( tile.type) )
		server_CreateBlob( "gooladder", 1, pos );		
}