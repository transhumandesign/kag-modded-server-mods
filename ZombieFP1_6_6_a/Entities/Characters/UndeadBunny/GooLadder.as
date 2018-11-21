const f32 SPAN = 3.5f;//seconds

void onInit( CBlob@ this )
{
	this.server_SetTimeToDie( SPAN );
}

void onInit( CSprite@ this )
{
	this.SetZ(-40.0f);
	this.SetAnimation( "default" );
	this.animation.time = Maths::Round( SPAN*30/this.animation.getFramesCount() );
	// this.RotateBy( XORRandom( 360 ), Vec2f_zero );
}

void onInit( CShape@ this )
{
	this.SetStatic( true );
}

bool canBePickedUp( CBlob@ this, CBlob@ byBlob )
{
	return false;
}