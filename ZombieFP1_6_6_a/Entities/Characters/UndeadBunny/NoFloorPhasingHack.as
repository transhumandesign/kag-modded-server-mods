#define CLIENT_ONLY

void onTick( CShape@ this )
{
	if ( getMap().rayCastSolidNoBlobs( this.getVars().oldpos, this.getPosition() ) )
	{
		this.SetVelocity( Vec2f( this.getVelocity().x, 0.0f ) );
		
		if ( ( this.getVars().oldpos - this.getPosition() ).getLength() > 0.1f )
			this.SetPosition( this.getVars().oldpos );
		
		this.checkCollisionsAgain = true;
		this.ResolveInsideMapCollision();
		
		if ( this.getBlob().isMyPlayer() )
			print( ":::Debug: stopped ground phasing!" );
	}
}
