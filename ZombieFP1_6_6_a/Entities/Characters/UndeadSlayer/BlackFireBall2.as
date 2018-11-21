//FireBall
//based on Goo Ball

#include "Hitters.as";
#include "BlackFireParticle.as";

const f32 DAMAGE = 0.5f;
const f32 HITDAMAGE = 0.5f;
const f32 AOE = 10.0f;//radius

void onInit( CBlob@ this )
{
	this.SetLight(true);
	this.SetLightRadius(48.0f);
	this.SetLightColor(SColor(255, 211, 121, 224));

	CShape@ shape = this.getShape();
	ShapeConsts@ consts = shape.getConsts();
    consts.mapCollisions = true;
	consts.bullet = false;
	consts.net_threshold_multiplier = 4.0f;
	
	this.server_SetTimeToDie( 3 );
	this.getCurrentScript().tickFrequency = 5;

}

void onTick( CBlob@ this )
{
	makeFireParticle(this.getPosition(), 1);
	//through ground server check
	if ( getNet().isServer() && getMap().rayCastSolidNoBlobs( this.getShape().getVars().oldpos, this.getPosition() ) )
		this.server_Die();
}

void onCollision( CBlob@ this, CBlob@ blob, bool solid, Vec2f normal, Vec2f worldPoint )
{
	Vec2f pos = this.getPosition();
	
	if (blob !is null && doesCollideWithBlob(this, blob))
	{
		this.server_Hit( blob, pos, Vec2f_zero, HITDAMAGE, Hitters::fire);
		this.server_Die();
	}	
	else if (solid)
	{	
		//reached ground
		CMap@ map = getMap();
		Tile tileBelowLeft = map.getTile( worldPoint + Vec2f( -4, 3 ) );
		Tile tileBelowRight = map.getTile( worldPoint + Vec2f( 4, 3 ) );

		if ( map.isTileSolid( tileBelowLeft ) && map.isTileSolid( tileBelowRight ) )
			this.server_Die();
	}
}

bool doesCollideWithBlob( CBlob@ this, CBlob@ blob )
{
return (this.getTeamNum() != blob.getTeamNum() && blob.hasTag("flesh")) || blob.hasTag("survivorbuilding") || blob.hasTag("dead") || blob.hasTag("enemy");
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
				this.server_Hit( blob, pos, Vec2f_zero, DAMAGE, Hitters::fire);
		}
	}
	
	this.getSprite().PlaySound( "Bomb.ogg" );
	ParticleAnimated( "/LargeSmoke.png",
				  this.getPosition(), Vec2f(0,0), 0.0f, 1.0f,
				  3,
				  -0.1f, false );
	ParticleAnimated( "/BlackFireFlash.png",
				  this.getPosition(), Vec2f(0,0), 0.0f, 1.0f,
				  3,
				  -0.1f, false );			  
}