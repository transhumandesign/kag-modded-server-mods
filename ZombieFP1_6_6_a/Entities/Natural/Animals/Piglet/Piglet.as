//bf_piglet
#include "AnimalConsts.as";

//sprite
void onInit(CSprite@ this)
{
    this.ReloadSprites(0,0);
	this.SetZ( -20.0f );
	this.getBlob().set_u32( "nextOink", 0 );
}

void onTick(CSprite@ this)
{
	CBlob@ blob = this.getBlob();
    
	f32 x = Maths::Abs(blob.getVelocity().x);
	if (x > 0.02f)
		this.SetAnimation("walk");
	else if(this.isAnimationEnded())
		this.SetAnimation("idle");
		
	 if ( getGameTime() > blob.get_u32( "nextOink" ) ) 
	{
		this.PlaySound( "/PigOink" );
		blob.set_u32( "nextOink", getGameTime() + ( XORRandom(25) + 25 ) * 30 );
	}
}

//blob
void onInit(CBlob@ this)
{
	this.set_f32("bite damage", 0.1f);
	this.Tag( "fauna" );
	
	//brain
	this.set_u8(personality_property, SCARED_BIT);
	this.getBrain().server_SetActive( true );
	this.set_f32(target_searchrad_property, 30.0f);
	this.set_f32(terr_rad_property, 75.0f);
	this.set_u8(target_lose_random,14);
	
	//for shape
	this.getShape().SetRotationsAllowed(false);
	
	//for flesh hit
	this.set_f32("gib health", 0.0f);	  	
	this.Tag("flesh");

	this.getShape().SetOffset(Vec2f(0,6));

	//this.getCurrentScript().runFlags |= Script::tick_blob_in_proximity;
	//this.getCurrentScript().runProximityTag = "player";
	//this.getCurrentScript().runProximityRadius = 320.0f;

	// movement
	this.set_u8( "maxStickiedTime", 40 );
	AnimalVars@ vars;
	if (!this.get( "vars", @vars ))
		return;
	vars.walkForce.Set(15.0f,-0.1f);
	vars.runForce.Set(30.0f,-1.0f);
	vars.slowForce.Set(10.0f,0.0f);
	vars.jumpForce.Set(0.0f,-20.0f);
	vars.maxVelocity = 2.2f;
}

void onTick(CBlob@ this)
{
	f32 x = this.getVelocity().x;		
	if (Maths::Abs(x) > 1.0f)
	{
		this.SetFacingLeft( x < 0 );
	}

	else
	{
		if (this.isKeyPressed(key_left)) {
			this.SetFacingLeft( true );
		}
		if (this.isKeyPressed(key_right)) {
			this.SetFacingLeft( false );
		}
	}
}

f32 onHit( CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData )
{
    this.Damage( damage, hitterBlob );
	//add sound
	//printf("gibHealth " + gibHealth + " health " + this.getHealth() );
    if (this.getHealth() <= 0.0f)
        this.server_Die();
	else if ( this.isOnGround() && XORRandom(3) == 0 )
	{	
		this.getSprite().PlaySound( "/PigSqueal" );
		this.AddForce( Vec2f( 0.0f, -180.0f ) );
	}
	return 0.0f;
}

void onDie( CBlob@ this )
{
	this.getSprite().Gib();
}

bool canBePickedUp( CBlob@ this, CBlob@ byBlob )
{
    return true;
}

bool doesCollideWithBlob( CBlob@ this, CBlob@ blob )
{
    return (blob.getName() != "bunny");
}