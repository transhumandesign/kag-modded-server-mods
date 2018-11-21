namespace Block
{
	const int size = 8;

	enum Type 
	{
		PLATFORM = 0,
		PLATFORM2 = 1,
		SOLID = 4,
		BOMB = 19,
		BOMB_A1 = 20,
		BOMB_A2 = 21,

		TURRET = 22,
		TURRET_A1 = 11,
		TURRET_A2 = 12,
		
		COUPLING = 35,

		PROPELLER = 16,
		PROPELLER_A1 = 32,
		PROPELLER_A2 = 33,
		
		SEAT = 23,

		MOTHERSHIP1 = 80,
		MOTHERSHIP2 = 81,
		MOTHERSHIP3 = 82,
		MOTHERSHIP4 = 96,
		MOTHERSHIP5 = 97,
		MOTHERSHIP6 = 98,
		MOTHERSHIP7 = 112,
		MOTHERSHIP8 = 113,
		MOTHERSHIP9 = 114,
	};

	int minimapframe(Type block)
	{
		int frame;
		switch(block)
		{
			case SOLID:
			case PROPELLER:

				frame = 1;
				break;

			case MOTHERSHIP5:
				frame = 2;
				break;

			case MOTHERSHIP1:
			case MOTHERSHIP2:
			case MOTHERSHIP3:
			case MOTHERSHIP4:
			case MOTHERSHIP6:
			case MOTHERSHIP7:
			case MOTHERSHIP8:
			case MOTHERSHIP9:

				frame = 3;
				break;

			default:
				frame = 0;
				break;
		}
		return frame;
	}

	bool isSolid( const uint blockType )
	{ 
		return (blockType == Block::SOLID || blockType == Block::PROPELLER);
	}

	bool isCore( const uint blockType )
	{ 
		return (blockType >= Block::MOTHERSHIP1 && blockType <= Block::MOTHERSHIP9);
	}

	bool isType( CBlob@ blob, const uint blockType )
	{ 
		return (blob.getSprite().getFrame() == blockType);
	}	

	uint getType( CBlob@ blob )
	{ 
		return blob.getSprite().getFrame();
	}		

	const f32 BUTTON_RADIUS_FLOOR = 6;
	const f32 BUTTON_RADIUS_SOLID = 10;

};