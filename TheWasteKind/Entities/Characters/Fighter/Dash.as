//Dash v1.0 by Strathos

#include "MakeDustParticle.as";
#include "ActorHUDStartPos.as";

const u16 DASH_COOLDOWN = 30;//seconds * 30
const f32 DASH_FORCE = 370.0f;//force applied

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
	// const bool onground = this.isOnGround() || this.isOnLadder();
	const bool left = this.isKeyPressed( key_left );
	const bool right = this.isKeyPressed( key_right );
	const bool dash	= /*this.isKeyPressed( key_down ) ||*/ this.isKeyPressed( key_action2 );

	if ( !dashing )
	{
		if (dash && ( left || right ))
		{
			this.set_bool( "dashing", true );
			this.set_u8( "dashCoolDown", 0 );
			MakeDustParticle( this.getPosition() + Vec2f( 0.0f, 9.0f ), "/DustSmall.png");
			this.getSprite().PlaySound("/Ha_A.ogg");//StoneStep7.ogg, changed to custom sound
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
		if ( dashCoolDown > DASH_COOLDOWN * 1 )
			this.set_bool( "dashing", false );
	}
}

void onRender (CSprite@ this)
{
	CBlob@ blob = this.getBlob();
	if (blob is null)
		return;

	Vec2f tl = getActorHUDStartPosition(blob, 6);
	float dashCoolDown = blob.get_u8( "dashCoolDown");
	GUI::DrawProgressBar(tl, tl + Vec2f(160, 35), dashCoolDown / DASH_COOLDOWN);
}