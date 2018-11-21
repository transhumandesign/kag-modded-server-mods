//GooBallAnim
const f32 initialSize = 0.5f;
const f32 scaleFactor = 1.01f;
const u8 maxticks = 70;//-log(ini)/log(scaleF)

void onInit( CSprite@ this )
{
	this.SetZ( 500.0f );
	this.ScaleBy( Vec2f( initialSize, initialSize ) );
    CSpriteLayer@ trail = this.addSpriteLayer( "trail", this.getConsts().filename, 11, 7 );
	if (trail !is null)
    {
		Animation@ anim = trail.addAnimation( "default", 0, false );
		anim.AddFrame(2);
		trail.ScaleBy( Vec2f( initialSize, initialSize ) );
		trail.SetRelativeZ( -1.0f );
    }
}

void onTick( CSprite@ this )
{
	CBlob@ blob = this.getBlob();
	CSpriteLayer@ trail = this.getSpriteLayer( "trail" );

	if ( this.isAnimation( "static" ) )//set by GooBall.as
	{
		f32 scale = 1/( 0.5f * ( Maths::Pow( scaleFactor, Maths::Min( maxticks, blob.getTickSinceCreated() ) ) ) );
		this.ScaleBy( Vec2f( scale, scale * 1.1f ) );
		//this.SetOffset( Vec2f( 0, 0.3f ) );
		trail.SetVisible( false );
		this.PlaySound( "/wetfall2.ogg" );//or: WaterBubble
		this.getCurrentScript().runFlags |= Script::remove_after_this;
		return;
	}
	
	if ( trail is null )	return;

	f32 trailOffset = Maths::Min( maxticks, blob.getTickSinceCreated() )/20.0f + 3.75f ;
	//print( "trailOffset: " + trailOffset );
	Vec2f vel = blob.getVelocity();
	vel.y *= -1;

	if ( vel.Length() > 4.0f )
	{
		trail.ResetTransform();
		trail.SetOffset( Vec2f( trailOffset, 0 ) );
		trail.RotateBy( vel.Angle(), Vec2f( -trailOffset, 0 ) );
		
		trail.SetVisible( true );
	}
	else
		trail.SetVisible( false );
	
	if ( blob.getTickSinceCreated() < maxticks )
	{
		this.ScaleBy( Vec2f( scaleFactor, scaleFactor ) );
		trail.ScaleBy( Vec2f( scaleFactor, scaleFactor ) );
	}
}