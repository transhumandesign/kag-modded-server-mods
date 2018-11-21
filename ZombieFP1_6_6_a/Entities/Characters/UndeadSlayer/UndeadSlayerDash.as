//Dash v1.0 by Strathos (edited by Frikman)

#include "MakeDustParticle.as";

const u16 DASH_COOLDOWN = 45;//seconds * 30
const f32 DASH_FORCE = 440.0f;//force applied

void onInit( CBlob@ this )
{
	this.set_u8( "dashCoolDown", 0 );
	this.set_bool( "dashing", false );
	this.getCurrentScript().removeIfTag = "dead";
}

void onTick( CBlob@ this )
{
	bool dashing = this.get_bool( "dashing" );
	
	Vec2f vel = this.getVelocity();
	const bool onground = this.isOnGround() || this.isOnLadder();
	const bool left = this.isKeyPressed( key_left );
	const bool right = this.isKeyPressed( key_right );
	const bool down	= this.isKeyPressed( key_taunts );

	if ( !dashing )
	{
		if ( onground && down && ( left || right ) && vel.Length() < 3.0f )
		{
			this.set_bool( "dashing", true );
			this.set_u8( "dashCoolDown", 0 );
			MakeDustParticle( this.getPosition() + Vec2f( 0.0f, 9.0f ), "/DustSmall.png");
			this.getSprite().PlaySound("/StoneJump");//StoneStep7.ogg
			f32 xCompensate;
			if ( left )
			{
				xCompensate = 50.0f * ( vel.x > 0.0f ? vel.x : vel.x * 1.5f );
				this.AddForce( Vec2f( -DASH_FORCE, 10.0f ) - Vec2f( xCompensate, 0.0f ) );
			}
			else if ( right )
			{
				xCompensate = 50.0f * ( vel.x < 0.0f ? vel.x : vel.x * 1.5f );
				this.AddForce( Vec2f( DASH_FORCE, 10.0f ) - Vec2f( xCompensate, 0.0f ) );
			}
		}
	}
	else
	{
		u8 dashCoolDown = this.get_u8( "dashCoolDown" );
		this.set_u8( "dashCoolDown", ( dashCoolDown + 1 ) );
		if ( ( onground && ( !down || ( !left && !right ) ) && dashCoolDown > DASH_COOLDOWN ) || dashCoolDown > DASH_COOLDOWN * 3 )
			this.set_bool( "dashing", false );
	}
}