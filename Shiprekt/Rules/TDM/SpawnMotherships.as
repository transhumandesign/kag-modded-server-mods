#include "MakeBlock.as"

void onInit( CRules@ this )
{
	onRestart( this );
}

void onRestart( CRules@ this )
{   
	if (getNet().isServer())
	{
    	Vec2f[] spawns;			 
    	if (getMap().getMarkers("spawn", spawns )) {
	    	for (int i=0; i < Maths::Min( this.getTeamsNum(), spawns.length ); i++){
        		SpawnMothership( spawns[i], i );
        	}
    	}
    }

    CCamera@ camera = getCamera();
    if (camera !is null)
    	camera.setRotation(0.0f);
}

void SpawnMothership( Vec2f pos, const int team )
{
	// platforms

	makeBlock( pos + Vec2f(-Block::size, -Block::size), Block::MOTHERSHIP1, team );
	makeBlock( pos + Vec2f(0, -Block::size), Block::MOTHERSHIP2, team );
	makeBlock( pos + Vec2f(Block::size, -Block::size), Block::MOTHERSHIP3, team );

	makeBlock( pos + Vec2f(-Block::size, 0), Block::MOTHERSHIP4, team );	
	makeBlock( pos, Block::MOTHERSHIP5, team ).AddScript("Mothership.as");
	makeBlock( pos + Vec2f(Block::size, 0), Block::MOTHERSHIP6, team );

	makeBlock( pos + Vec2f(-Block::size, Block::size), Block::MOTHERSHIP7, team );
	makeBlock( pos + Vec2f(0, Block::size), Block::MOTHERSHIP8, team );
	makeBlock( pos + Vec2f(Block::size, Block::size), Block::MOTHERSHIP9, team );

	// surrounding

	makeBlock( pos + Vec2f(-Block::size*2, -Block::size*1), Block::SOLID, team );
	makeBlock( pos + Vec2f(-Block::size*2, -Block::size*2), Block::SOLID, team );
	makeBlock( pos + Vec2f(-Block::size*1, -Block::size*2), Block::SOLID, team );

	makeBlock( pos + Vec2f( 0, -Block::size*2), Block::PLATFORM2, team );

	makeBlock( pos + Vec2f( Block::size*1, -Block::size*2), Block::SOLID, team );
	makeBlock( pos + Vec2f( Block::size*2, -Block::size*2), Block::SOLID, team );
	makeBlock( pos + Vec2f( Block::size*2, -Block::size*1), Block::SOLID, team );

	makeBlock( pos + Vec2f( Block::size*2, 0), Block::PLATFORM2, team );

	makeBlock( pos + Vec2f( Block::size*2, Block::size*1), Block::SOLID, team );
	makeBlock( pos + Vec2f( Block::size*2, Block::size*2), Block::SOLID, team );
	makeBlock( pos + Vec2f( Block::size*1, Block::size*2), Block::SOLID, team );

	makeBlock( pos + Vec2f( 0, Block::size*2), Block::PLATFORM2, team );

	makeBlock( pos + Vec2f( -Block::size*1, Block::size*2), Block::SOLID, team );
	makeBlock( pos + Vec2f( -Block::size*2, Block::size*2), Block::SOLID, team );
	makeBlock( pos + Vec2f( -Block::size*2, Block::size*1), Block::SOLID, team );

	makeBlock( pos + Vec2f( -Block::size*2, 0), Block::PLATFORM2, team );
}
