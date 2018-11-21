namespace CMap
{
	// tiles
	const SColor color_water(255, 77, 133, 188);
	const SColor color_tree(255, 43, 85, 67);
	// objects
	const SColor color_main_spawn(255, 0, 255, 255);

	enum Blocks {
		water = 0,
		grass_1 = 1,
		grass_2 = 2,
		grass_3 = 3,
		tree = 4
	};

	//
	void SetupMap( CMap@ map, int width, int height )
	{
		map.CreateTileMap( width, height, 8.0f, "SpriteSheet.png" );
		map.CreateSky( color_water );
		map.topBorder = map.bottomBorder = map.rightBorder = map.leftBorder = true;
	}  	

	//
	void handlePixel( CMap@ map, SColor pixel, int offset)
	{
		if (pixel == CMap::color_water) 
		{				
			map.AddTileFlag( offset, Tile::BACKGROUND );
			map.AddTileFlag( offset, Tile::LIGHT_PASSES );
			//map.SetTile(offset, CMap::grass + random % 3 );

		}		
		else if (pixel == CMap::color_tree) 
		{
			map.SetTile(offset, CMap::tree );
			map.AddTileFlag( offset, Tile::BACKGROUND );
			map.AddTileFlag( offset, Tile::SOLID );
		}		
		else if (pixel == CMap::color_main_spawn) {
			AddMarker( map, offset, "spawn" );
			PlaceMostLikelyTile(map, offset);
		}  
	}

}
