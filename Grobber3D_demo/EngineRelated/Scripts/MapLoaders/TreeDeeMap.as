//TreeDeeMap.as

ThreeDeeMap@ getThreeDeeMap()
{
	ThreeDeeMap@ three_dee_map;
	getRules().get("ThreeDeeMap", @three_dee_map);
	return three_dee_map;
}

class ThreeDeeMap
{
	string map_tile_sheet;
	Vertex[] Vertexes;
	//u16[] IDs;
	
	string sky_texture;
	
	Vertex[] skybox_Vertexes = {Vertex(0,-0.965912,0.258869,0.75,0.916667,color_white),Vertex(-0.129409,-0.965914,0.224194,0.666667,0.916667,color_white),Vertex(0,-1,5.2e-005,0.708333,1,color_white),Vertex(0,0.500045,0.866,0.75,0.333333,color_white),Vertex(-0.482963,0.258863,0.836502,0.666667,0.416667,color_white),Vertex(0,0.258869,0.965912,0.75,0.416667,color_white),Vertex(-0.482963,-0.258775,0.836529,0.666667,0.583333,color_white),Vertex(0,-0.499955,0.866051,0.75,0.666667,color_white),Vertex(0,-0.258769,0.965939,0.75,0.583333,color_white),Vertex(0,1,-5.2e-005,0.708333,0,color_white),Vertex(-0.129409,0.965938,0.224094,0.666667,0.083333,color_white),Vertex(0,0.96594,0.258769,0.75,0.083333,color_white),Vertex(0,-0.865999,0.500045,0.75,0.833333,color_white),Vertex(-0.25,-0.866002,0.433058,0.666667,0.833333,color_white),Vertex(-0.353553,0.707139,0.612336,0.666667,0.25,color_white),Vertex(0,0.707144,0.70707,0.75,0.25,color_white),Vertex(-0.5,4.5e-005,0.866025,0.666667,0.5,color_white),Vertex(0,5.2e-005,1,0.75,0.5,color_white),Vertex(-0.353553,-0.707075,0.612408,0.666667,0.75,color_white),Vertex(-0.25,0.866048,0.432968,0.666667,0.166667,color_white),Vertex(0,0.866051,0.499955,0.75,0.166667,color_white),Vertex(0,-0.70707,0.707143,0.75,0.75,color_white),Vertex(-0.866025,2.6e-005,0.5,0.583333,0.5,color_white),Vertex(-0.612372,-0.707088,0.35359,0.583333,0.75,color_white),Vertex(-0.612372,0.707126,0.353517,0.583333,0.25,color_white),Vertex(-0.836516,0.258844,0.482949,0.583333,0.416667,color_white),Vertex(-0.433013,-0.499961,0.750026,0.666667,0.666667,color_white),Vertex(-0.224144,0.965933,0.12936,0.583334,0.083333,color_white),Vertex(-0.224144,-0.965919,0.12946,0.583334,0.916667,color_white),Vertex(0,-1,5.2e-005,0.625,1,color_white),Vertex(-0.75,0.500023,0.432987,0.583333,0.333333,color_white),Vertex(-0.433013,0.500039,0.749974,0.666667,0.333333,color_white),Vertex(-0.75,-0.499977,0.433039,0.583333,0.666667,color_white),Vertex(0,1,-5.2e-005,0.625,0,color_white),Vertex(-0.965925,-0.258819,1.3e-005,0.5,0.583333,color_white),Vertex(-0.836516,-0.258794,0.482976,0.583333,0.583333,color_white),Vertex(0,1,-5.2e-005,0.541667,0,color_white),Vertex(-0.258819,0.965926,-5e-005,0.5,0.083333,color_white),Vertex(-0.433012,-0.866012,0.250045,0.583333,0.833333,color_white),Vertex(-0.258819,-0.965926,5e-005,0.5,0.916667,color_white),Vertex(-0.707107,0.707107,-3.7e-005,0.5,0.25,color_white),Vertex(-1,0,-0,0.5,0.5,color_white),Vertex(-0.707106,-0.707107,3.6e-005,0.5,0.75,color_white),Vertex(-0.433013,0.866038,0.249955,0.583333,0.166667,color_white),Vertex(-0.965926,0.258819,-1.4e-005,0.5,0.416667,color_white),Vertex(-0.866025,-0.5,2.6e-005,0.5,0.666667,color_white),Vertex(-0.5,0.866025,-4.5e-005,0.5,0.166667,color_white),Vertex(0,-1,5.2e-005,0.541667,1,color_white),Vertex(-0.866025,0.5,-2.6e-005,0.5,0.333333,color_white),Vertex(-0.836516,0.258794,-0.482976,0.416667,0.416667,color_white),Vertex(-0.75,-0.500022,-0.432986,0.416667,0.666667,color_white),Vertex(-0.224144,0.96592,-0.129459,0.416667,0.083333,color_white),Vertex(-0.224144,-0.965932,-0.129359,0.416667,0.916667,color_white),Vertex(0,-1,5.2e-005,0.458334,1,color_white),Vertex(0,1,-5.2e-005,0.458334,0,color_white),Vertex(-0.433012,-0.866038,-0.249954,0.416667,0.833333,color_white),Vertex(-0.5,-0.866025,4.5e-005,0.5,0.833333,color_white),Vertex(-0.75,0.499978,-0.433038,0.416667,0.333333,color_white),Vertex(-0.866025,-2.6e-005,-0.499999,0.416667,0.5,color_white),Vertex(-0.612372,-0.707125,-0.353517,0.416667,0.75,color_white),Vertex(-0.612372,0.707089,-0.35359,0.416667,0.25,color_white),Vertex(-0.5,-4.5e-005,-0.866025,0.333333,0.5,color_white),Vertex(-0.836516,-0.258844,-0.482949,0.416667,0.583333,color_white),Vertex(-0.25,-0.866047,-0.432967,0.333333,0.833334,color_white),Vertex(-0.433012,0.866012,-0.250045,0.416667,0.166667,color_white),Vertex(-0.353553,0.707076,-0.612409,0.333333,0.25,color_white),Vertex(-0.482963,0.258776,-0.83653,0.333333,0.416667,color_white),Vertex(-0.433012,-0.500039,-0.749973,0.333333,0.666667,color_white),Vertex(-0.25,0.866003,-0.433057,0.333333,0.166667,color_white),Vertex(-0.129409,-0.965937,-0.224093,0.333333,0.916667,color_white),Vertex(0,-1,5.2e-005,0.375,1,color_white),Vertex(-0.433013,0.499961,-0.750025,0.333333,0.333333,color_white),Vertex(-0.482963,-0.258862,-0.836503,0.333333,0.583333,color_white),Vertex(0,1,-5.2e-005,0.375,0,color_white),Vertex(-0.129409,0.965915,-0.224193,0.333333,0.083333,color_white),Vertex(0,0.499955,-0.866051,0.25,0.333333,color_white),Vertex(0,-0.258869,-0.965912,0.25,0.583333,color_white),Vertex(0,1,-5.2e-005,0.291667,0,color_white),Vertex(0,0.965913,-0.258869,0.25,0.083333,color_white),Vertex(0,-0.866051,-0.499954,0.25,0.833334,color_white),Vertex(0,-0.707143,-0.70707,0.25,0.75,color_white),Vertex(-0.353553,-0.707138,-0.612336,0.333333,0.75,color_white),Vertex(0,0.865999,-0.500044,0.25,0.166666,color_white),Vertex(0,0.258769,-0.965939,0.25,0.416667,color_white),Vertex(0,-0.965939,-0.258768,0.25,0.916667,color_white),Vertex(0,-1,5.2e-005,0.291667,1,color_white),Vertex(0.482963,0.258776,-0.83653,0.166667,0.416667,color_white),Vertex(0,-5.2e-005,-0.999999,0.25,0.5,color_white),Vertex(0.433012,-0.500039,-0.749973,0.166667,0.666667,color_white),Vertex(0,-0.500045,-0.865999,0.25,0.666667,color_white),Vertex(0.25,0.866003,-0.433057,0.166667,0.166667,color_white),Vertex(0.129409,-0.965937,-0.224093,0.166667,0.916667,color_white),Vertex(0,-1,5.2e-005,0.208333,1,color_white),Vertex(0,1,-5.2e-005,0.208333,0,color_white),Vertex(0.129409,0.965915,-0.224193,0.166667,0.083333,color_white),Vertex(0.353553,0.707076,-0.612409,0.166667,0.25,color_white),Vertex(0,0.707071,-0.707143,0.25,0.25,color_white),Vertex(0.482963,-0.258862,-0.836503,0.166667,0.583333,color_white),Vertex(0.353553,-0.707138,-0.612336,0.166667,0.75,color_white),Vertex(0.612372,0.707089,-0.35359,0.083333,0.25,color_white),Vertex(0.433013,0.499961,-0.750025,0.166667,0.333333,color_white),Vertex(0.866025,-2.6e-005,-0.499999,0.083333,0.5,color_white),Vertex(0.5,-4.5e-005,-0.866025,0.166667,0.5,color_white),Vertex(0.612372,-0.707125,-0.353517,0.083333,0.75,color_white),Vertex(0.25,-0.866047,-0.432967,0.166667,0.833334,color_white),Vertex(0.224144,0.96592,-0.129459,0.083333,0.083333,color_white),Vertex(0.224143,-0.965932,-0.129359,0.083333,0.916667,color_white),Vertex(0,-1,5.2e-005,0.125,1,color_white),Vertex(0.836516,0.258794,-0.482976,0.083333,0.416667,color_white),Vertex(0.75,-0.500022,-0.432986,0.083333,0.666667,color_white),Vertex(0,1,-5.2e-005,0.125,0,color_white),Vertex(0.433012,-0.866038,-0.249954,0.083333,0.833333,color_white),Vertex(0.258819,-0.965926,5e-005,0,0.916667,color_white),Vertex(0,-1,5.2e-005,0.041666,1,color_white),Vertex(0.75,0.499978,-0.433038,0.083333,0.333333,color_white),Vertex(0.965925,0.258819,-1.4e-005,0,0.416667,color_white),Vertex(0.965925,-0.258819,1.3e-005,0,0.583333,color_white),Vertex(0.836516,-0.258844,-0.482949,0.083333,0.583333,color_white),Vertex(0,1,-5.2e-005,0.041666,0,color_white),Vertex(0.258819,0.965926,-5e-005,0,0.083333,color_white),Vertex(0.707107,0.707107,-3.7e-005,0,0.25,color_white),Vertex(0.499999,-0.866025,4.5e-005,0,0.833333,color_white),Vertex(0.433013,0.866012,-0.250044,0.083333,0.166667,color_white),Vertex(0.866025,-0.5,2.6e-005,0,0.666667,color_white),Vertex(0.5,0.866025,-4.5e-005,1,0.166667,color_white),Vertex(0.612372,0.707126,0.353517,0.916667,0.25,color_white),Vertex(0.707107,0.707107,-3.7e-005,1,0.25,color_white),Vertex(0.836516,0.258844,0.482949,0.916667,0.416667,color_white),Vertex(0.999999,0,1e-006,1,0.5,color_white),Vertex(0.965925,0.258819,-1.4e-005,1,0.416667,color_white),Vertex(0.749999,-0.499977,0.433039,0.916667,0.666667,color_white),Vertex(0.707106,-0.707107,3.7e-005,1,0.75,color_white),Vertex(0.866025,-0.5,2.6e-005,1,0.666667,color_white),Vertex(0.258819,0.965926,-5e-005,1,0.083333,color_white),Vertex(0.433012,0.866038,0.249955,0.916667,0.166667,color_white),Vertex(0.258819,-0.965926,5e-005,1,0.916667,color_white),Vertex(0.224143,-0.965919,0.12946,0.916666,0.916667,color_white),Vertex(0,-1,5.2e-005,0.958333,1,color_white),Vertex(0.75,0.500023,0.432987,0.916667,0.333333,color_white),Vertex(0.866025,0.5,-2.6e-005,1,0.333333,color_white),Vertex(0.836516,-0.258794,0.482976,0.916667,0.583333,color_white),Vertex(0.965925,-0.258819,1.3e-005,1,0.583333,color_white),Vertex(0,1,-5.2e-005,0.958333,0,color_white),Vertex(0.224144,0.965933,0.12936,0.916666,0.083333,color_white),Vertex(0.433012,-0.866012,0.250045,0.916667,0.833333,color_white),Vertex(0.499999,-0.866025,4.5e-005,1,0.833333,color_white),Vertex(0.25,-0.866002,0.433058,0.833333,0.833333,color_white),Vertex(0.433012,0.500039,0.749974,0.833333,0.333333,color_white),Vertex(0.5,4.5e-005,0.866025,0.833333,0.5,color_white),Vertex(0.866025,2.6e-005,0.5,0.916667,0.5,color_white),Vertex(0.612372,-0.707088,0.35359,0.916667,0.75,color_white),Vertex(0.25,0.866048,0.432968,0.833333,0.166667,color_white),Vertex(0.353553,-0.707075,0.612408,0.833333,0.75,color_white),Vertex(0.129409,-0.965914,0.224194,0.833333,0.916667,color_white),Vertex(0,-1,5.2e-005,0.875,1,color_white),Vertex(0.482963,0.258863,0.836502,0.833333,0.416667,color_white),Vertex(0.482963,-0.258775,0.836529,0.833333,0.583333,color_white),Vertex(0,1,-5.2e-005,0.875,0,color_white),Vertex(0.129409,0.965938,0.224094,0.833333,0.083333,color_white),Vertex(0,-1,5.2e-005,0.791667,1,color_white),Vertex(0.433012,-0.499961,0.750026,0.833333,0.666667,color_white),Vertex(0,1,-5.2e-005,0.791667,0,color_white),Vertex(0.353553,0.707139,0.612336,0.833333,0.25,color_white),Vertex(0.866025,0.5,-2.6e-005,0,0.333333,color_white),Vertex(0.999999,0,1e-006,0,0.5,color_white),Vertex(0.707106,-0.707107,3.7e-005,0,0.75,color_white),Vertex(0.5,0.866025,-4.5e-005,0,0.166667,color_white)};
	u16[] skybox_IDs = {1,0,2,4,3,5,7,6,8,10,9,11,12,1,13,3,14,15,8,16,17,18,12,13,15,19,20,17,4,5,18,7,21,20,10,11,6,22,16,13,23,18,24,19,14,16,25,4,23,26,18,19,27,10,28,1,29,4,30,31,32,6,26,27,33,10,28,13,1,31,24,14,32,34,35,37,36,27,39,38,28,30,40,24,35,41,22,38,42,23,40,43,24,22,44,25,23,45,32,46,27,43,39,28,47,25,48,30,41,49,44,42,50,45,46,51,37,52,39,53,49,48,44,50,34,45,51,54,37,39,55,56,57,40,48,34,58,41,56,59,42,60,46,40,62,61,58,63,59,55,65,64,60,58,66,49,59,67,50,68,51,64,69,52,70,49,71,57,50,72,62,74,73,51,52,63,55,71,60,57,66,75,71,67,76,72,78,77,74,69,79,63,75,65,71,76,61,72,63,80,81,65,82,68,61,83,66,80,67,81,68,78,74,84,69,85,87,86,83,80,88,89,90,78,82,91,84,92,86,75,83,88,76,89,94,93,78,91,79,84,75,95,96,97,87,76,79,98,80,95,82,96,100,99,95,97,101,102,104,103,98,99,90,95,101,86,102,103,88,98,90,105,94,106,91,107,108,100,86,109,97,88,105,110,94,91,111,104,112,106,113,115,114,108,109,116,117,119,118,105,112,111,106,114,120,99,116,101,117,121,103,111,120,122,99,101,115,108,103,123,109,122,119,105,125,124,126,128,127,129,131,130,132,134,133,124,136,135,137,129,138,139,132,140,141,143,142,133,135,144,145,138,126,139,140,128,141,144,131,145,136,146,144,147,125,138,140,148,149,146,150,144,125,151,134,148,127,149,152,130,150,151,143,134,153,136,154,155,138,127,130,156,140,158,157,143,20,158,151,0,153,159,5,147,155,160,8,156,11,161,158,12,153,0,147,15,162,156,17,148,152,12,21,162,20,151,148,5,155,21,160,152,31,3,4,26,6,7,0,1,12,31,14,3,6,16,8,21,12,18,14,19,15,16,4,17,26,7,18,19,10,20,35,22,6,38,23,13,43,19,24,22,25,16,32,26,23,43,27,19,25,30,4,35,6,32,38,13,28,30,24,31,45,34,32,56,38,39,48,40,30,34,41,35,56,42,38,46,43,40,41,44,22,42,45,23,37,27,46,44,48,25,58,49,41,59,50,42,64,51,46,57,48,49,62,34,50,52,55,39,60,40,57,62,58,34,55,59,56,64,46,60,72,61,62,81,59,63,68,64,65,61,66,58,81,67,59,74,51,68,66,71,49,67,72,50,69,63,52,65,60,71,83,75,66,89,76,67,84,79,69,96,65,75,87,61,76,79,80,63,96,82,65,87,83,61,89,67,80,82,78,68,102,86,87,98,88,80,94,78,90,100,75,86,97,76,88,104,79,91,100,95,75,102,87,97,104,98,79,90,82,95,114,99,100,117,101,97,111,103,104,122,90,99,108,86,101,109,88,103,122,105,90,114,100,108,117,97,109,106,111,91,163,114,115,123,116,109,121,111,112,163,120,114,164,101,116,165,103,121,166,122,120,164,115,101,165,123,103,166,119,122,134,124,125,149,127,128,150,130,131,143,133,134,127,138,129,130,140,132,136,144,135,125,126,138,149,128,140,150,131,144,153,146,136,162,125,147,156,148,140,152,150,146,162,151,125,155,127,148,160,130,152,158,143,151,147,138,155,160,156,130,11,158,20,3,147,5,7,8,160,146,153,12,3,15,147,8,17,156,146,12,152,15,20,162,17,5,148,7,160,21};
		
	ImageData@ mapImage;
	
	int mapWidth = 0;
	int mapHeight = 0;
	
	ImageData@ lightMapImage;
	
	ImageData@ heightMapImage;
	
	ImageData@ mapFancyImage;

	ThreeDeeMap()
	{
		
	}
	
	ThreeDeeMap(string _map_name, string _map_tile_sheet, string _map_lightmap, string _map_heightmap, string _map_fancy, string _skybox_name)
	{
		Vertexes.clear();
		map_tile_sheet = _map_tile_sheet;
		sky_texture = _skybox_name;
		
		if(Texture::exists(map_tile_sheet))
		{
			Texture::destroy(map_tile_sheet);
			Texture::createFromFile(map_tile_sheet, map_tile_sheet+".png");
		}
		else
			Texture::createFromFile(map_tile_sheet, map_tile_sheet+".png");
			
		if(Texture::exists(sky_texture))
		{
			Texture::destroy(sky_texture);
			Texture::createFromFile(sky_texture, sky_texture+".png");
		}
		else
			Texture::createFromFile(sky_texture, sky_texture+".png");
		
		if(Texture::exists(_map_name))
		{
			Texture::destroy(_map_name);
			Texture::createFromFile(_map_name, _map_name+".png");
		}
		else
			Texture::createFromFile(_map_name, _map_name+".png");

		@mapImage = Texture::data(_map_name);
		mapWidth = mapImage.width();
		mapHeight = mapImage.height();
		
		if(Texture::exists(_map_lightmap))
		{
			Texture::destroy(_map_lightmap);
			Texture::createFromFile(_map_lightmap, _map_lightmap+".png");
		}
		else
			Texture::createFromFile(_map_lightmap, _map_lightmap+".png");
		
		@lightMapImage = Texture::data(_map_lightmap);
		
		if(Texture::exists(_map_heightmap))
		{
			Texture::destroy(_map_heightmap);
			Texture::createFromFile(_map_heightmap, _map_heightmap+".png");
		}
		else
			Texture::createFromFile(_map_heightmap, _map_heightmap+".png");
		
		@heightMapImage = Texture::data(_map_heightmap);
		
		if(Texture::exists(_map_fancy))
		{
			Texture::destroy(_map_fancy);
			Texture::createFromFile(_map_fancy, _map_fancy+".png");
		}
		else
			Texture::createFromFile(_map_fancy, _map_fancy+".png");
		
		@mapFancyImage = Texture::data(_map_fancy);
		
		if(Texture::exists(_map_tile_sheet))
		{
			Texture::destroy(_map_tile_sheet);
			Texture::createFromFile(_map_tile_sheet, _map_tile_sheet+".png");
		}
		else
			Texture::createFromFile(_map_tile_sheet, _map_tile_sheet+".png");
		
		ImageData@ TileSheetImage = Texture::data(_map_tile_sheet);
		
		f32 x_UVStep = 1.00000000f/f32(TileSheetImage.width()/TileSheetImage.height()); // 10 is amount of tiles in tile sheet
	
		if(mapImage.size() > 1)
		{
			for(int y = 0; y < mapHeight; y++)
			{
				for(int x = 0; x < mapWidth; x++)
				{
					bool wall = false;
					
					SColor pixel = mapImage.get(x, y);
				
					uint clr = pixel.color;
					
					if(clr == map_colors::nodraw_solid) continue;
					
					uint height_start = heightMapImage.get(x, y).getRed()/10; // if > 24 - no roof
					uint height_end = heightMapImage.get(x, y).getGreen()/10; // max 24, 25 - no walls
					
					//int id = IDfromColor(clr);
					
					if(height_end >= height_start)
					{
						uint id = WallIDfromColor(clr);

						if(height_start > 0)
						{
							if(id >= 13 && id <= 15)
							{
								//floor
								Vertexes.push_back(Vertex(y,	0,	x,		1-x_UVStep*2,	0,	lightMapImage.get(x*2, 		y*2)));
								Vertexes.push_back(Vertex(y,	0,	x+1,	1-x_UVStep*1,	0,	lightMapImage.get(x*2+1, 	y*2)));
								Vertexes.push_back(Vertex(y+1,	0,	x+1,	1-x_UVStep*1,	1,	lightMapImage.get(x*2+1, 	y*2+1)));
								Vertexes.push_back(Vertex(y+1,	0,	x,		1-x_UVStep*2,	1,	lightMapImage.get(x*2, 		y*2+1)));

								//ceiling
								if(height_start < 25)
								{
									Vertexes.push_back(Vertex(y,	height_start,	x+1,	1-x_UVStep,	0,	lightMapImage.get(x*2+1,	y*2)));
									Vertexes.push_back(Vertex(y,	height_start,	x,		1,			0,	lightMapImage.get(x*2,		y*2)));
									Vertexes.push_back(Vertex(y+1,	height_start,	x,		1,			1,	lightMapImage.get(x*2,		y*2+1)));
									Vertexes.push_back(Vertex(y+1,	height_start,	x+1,	1-x_UVStep,	1,	lightMapImage.get(x*2+1,	y*2+1)));
								}
							}
							
							else
							{
								//floor
								Vertexes.push_back(Vertex(y,	0,	x,		1-x_UVStep*4,	0,	lightMapImage.get(x*2, 		y*2)));
								Vertexes.push_back(Vertex(y,	0,	x+1,	1-x_UVStep*3,	0,	lightMapImage.get(x*2+1, 	y*2)));
								Vertexes.push_back(Vertex(y+1,	0,	x+1,	1-x_UVStep*3,	1,	lightMapImage.get(x*2+1, 	y*2+1)));
								Vertexes.push_back(Vertex(y+1,	0,	x,		1-x_UVStep*4,	1,	lightMapImage.get(x*2, 		y*2+1)));

								//ceiling
								if(height_start < 25)
								{
									Vertexes.push_back(Vertex(y,	height_start,	x+1,	1-x_UVStep*3,	0,	lightMapImage.get(x*2+1,	y*2)));
									Vertexes.push_back(Vertex(y,	height_start,	x,		1-x_UVStep*2,	0,	lightMapImage.get(x*2,		y*2)));
									Vertexes.push_back(Vertex(y+1,	height_start,	x,		1-x_UVStep*2,	1,	lightMapImage.get(x*2,		y*2+1)));
									Vertexes.push_back(Vertex(y+1,	height_start,	x+1,	1-x_UVStep*3,	1,	lightMapImage.get(x*2+1,	y*2+1)));
								}
							}
						}
						
						//uint id = WallIDfromColor(clr);
						
						//right
						uint r_height_start = heightMapImage.get(x+1, y).getRed()/10;
						uint r_height_end = heightMapImage.get(x+1, y).getGreen()/10;
						uint r_prev_start_height = height_start;
						bool r_start = false;
						
						//left
						uint l_height_start = heightMapImage.get(x-1, y).getRed()/10;
						uint l_height_end = heightMapImage.get(x-1, y).getGreen()/10;
						uint l_prev_start_height = height_start;
						bool l_start = false;
						
						//up
						uint u_height_start = heightMapImage.get(x, y-1).getRed()/10;
						uint u_height_end = heightMapImage.get(x, y-1).getGreen()/10;
						uint u_prev_start_height = height_start;
						bool u_start = false;
						
						//down
						uint d_height_start = heightMapImage.get(x, y+1).getRed()/10;
						uint d_height_end = heightMapImage.get(x, y+1).getGreen()/10;
						uint d_prev_start_height = height_start;
						bool d_start = false;
						
						// right loop
						for(uint i = height_end; i > height_start; i--)
						{
							if((i<r_height_start+1 || i>r_height_end) || (r_height_end>=25 && r_height_start>=25))
							{
								if(!r_start)
								{
									r_start = true;
									r_prev_start_height = i;
									Vertexes.push_back(Vertex(y+1,	i,	x+1,	id*x_UVStep,			0,	lightMapImage.get(x*2+1, y*2+1)));
									Vertexes.push_back(Vertex(y,	i,	x+1,	id*x_UVStep+x_UVStep,	0,	lightMapImage.get(x*2+1, y*2)));
								}
							}
							else if(r_start)
							{
								r_start = false;
								Vertexes.push_back(Vertex(y,	i,	x+1,	id*x_UVStep+x_UVStep,	r_prev_start_height-i,	lightMapImage.get(x*2+1, y*2)));
								Vertexes.push_back(Vertex(y+1,	i,	x+1,	id*x_UVStep,			r_prev_start_height-i,	lightMapImage.get(x*2+1, y*2+1)));
							}
						}
						if(r_start)
						{
							r_start = false;
							Vertexes.push_back(Vertex(y,	height_start,	x+1,	id*x_UVStep+x_UVStep,	r_prev_start_height-height_start,	lightMapImage.get(x*2+1, y*2)));
							Vertexes.push_back(Vertex(y+1,	height_start,	x+1,	id*x_UVStep,			r_prev_start_height-height_start,	lightMapImage.get(x*2+1, y*2+1)));
						}
						
						// left loop
						for(uint i = height_end; i > height_start; i--)
						{
							if((i<l_height_start+1 || i>l_height_end) || (l_height_end>=25 && l_height_start>=25))
							{
								if(!l_start)
								{
									l_start = true;
									l_prev_start_height = i;
									Vertexes.push_back(Vertex(y,	i,	x,	id*x_UVStep,			0,	lightMapImage.get(x*2, y*2)));
									Vertexes.push_back(Vertex(y+1,	i,	x,	id*x_UVStep+x_UVStep,	0,	lightMapImage.get(x*2, y*2+1)));
								}
							}
							else if(l_start)
							{
								l_start = false;
								Vertexes.push_back(Vertex(y+1,	i,	x,	id*x_UVStep+x_UVStep,	l_prev_start_height-i,	lightMapImage.get(x*2, y*2+1)));
								Vertexes.push_back(Vertex(y,	i,	x,	id*x_UVStep,			l_prev_start_height-i,	lightMapImage.get(x*2, y*2)));
							}
						}
						if(l_start)
						{
							l_start = false;
							Vertexes.push_back(Vertex(y+1,	height_start,	x,	id*x_UVStep+x_UVStep,	l_prev_start_height-height_start,	lightMapImage.get(x*2, y*2+1)));
							Vertexes.push_back(Vertex(y,	height_start,	x,	id*x_UVStep,			l_prev_start_height-height_start,	lightMapImage.get(x*2, y*2)));
						}
						
						// up loop
						for(uint i = height_end; i > height_start; i--)
						{
							if((i<u_height_start+1 || i>u_height_end) || (u_height_end>=25 && u_height_start>=25))
							{
								if(!u_start)
								{
									u_start = true;
									u_prev_start_height = i;
									Vertexes.push_back(Vertex(y,	i,	x+1,	id*x_UVStep,			0,	lightMapImage.get(x*2+1, y*2)));
									Vertexes.push_back(Vertex(y,	i,	x,		id*x_UVStep+x_UVStep,	0,	lightMapImage.get(x*2, y*2)));
								}
							}
							else if(u_start)
							{
								u_start = false;
								Vertexes.push_back(Vertex(y,	i,	x,		id*x_UVStep+x_UVStep,	u_prev_start_height-i,	lightMapImage.get(x*2, y*2)));
								Vertexes.push_back(Vertex(y,	i,	x+1,	id*x_UVStep,			u_prev_start_height-i,	lightMapImage.get(x*2+1, y*2)));
							}
						}
						if(u_start)
						{
							u_start = false;
							Vertexes.push_back(Vertex(y,	height_start,	x,		id*x_UVStep+x_UVStep,	u_prev_start_height-height_start,	lightMapImage.get(x*2, y*2)));
							Vertexes.push_back(Vertex(y,	height_start,	x+1,	id*x_UVStep,			u_prev_start_height-height_start,	lightMapImage.get(x*2+1, y*2)));
						}
						
						// down loop
						for(uint i = height_end; i > height_start; i--)
						{
							if((i<d_height_start+1 || i>d_height_end) || (d_height_end>=25 && d_height_start>=25))
							{
								if(!d_start)
								{
									d_start = true;
									d_prev_start_height = i;
									Vertexes.push_back(Vertex(y+1,	i,	x,		id*x_UVStep,			0,	lightMapImage.get(x*2, y*2+1)));
									Vertexes.push_back(Vertex(y+1,	i,	x+1,	id*x_UVStep+x_UVStep,	0,	lightMapImage.get(x*2+1, y*2+1)));
								}
							}
							else if(d_start)
							{
								d_start = false;
								Vertexes.push_back(Vertex(y+1,	i,	x+1,	id*x_UVStep+x_UVStep,	d_prev_start_height-i,	lightMapImage.get(x*2+1, y*2+1)));
								Vertexes.push_back(Vertex(y+1,	i,	x,		id*x_UVStep,			d_prev_start_height-i,	lightMapImage.get(x*2, y*2+1)));
							}
						}
						if(d_start)
						{
							d_start = false;
							Vertexes.push_back(Vertex(y+1,	height_start,	x+1,	id*x_UVStep+x_UVStep,	d_prev_start_height-height_start,	lightMapImage.get(x*2+1, y*2+1)));
							Vertexes.push_back(Vertex(y+1,	height_start,	x,		id*x_UVStep,			d_prev_start_height-height_start,	lightMapImage.get(x*2, y*2+1)));
						}
					}
					
					//banners, decals, other shit
					{
						SColor Fpixel = mapFancyImage.get(x, y);
						
						if(Fpixel.getRed() > 64) continue;
					
						float Fid = (Fpixel.getRed()+64)*x_UVStep;
						float FposY = float(Fpixel.getGreen())/10.0000000;
						
						bool up = false;
						bool right = false;
						bool down = false;
						bool left = false;
						
						getSidefFromBlue(Fpixel.getBlue(), right, up, left, down);
						
						if(!up && !right && !down && !left) continue;
						
						if(right)
						{
							Vertexes.push_back(Vertex(y+1,	FposY+1,	x+1.01,	Fid,			0,	lightMapImage.get(x*2+1, y*2+1)));
							Vertexes.push_back(Vertex(y,	FposY+1,	x+1.01,	Fid+x_UVStep,	0,	lightMapImage.get(x*2+1, y*2)));
							Vertexes.push_back(Vertex(y,	FposY,		x+1.01,	Fid+x_UVStep,	1,	lightMapImage.get(x*2+1, y*2)));
							Vertexes.push_back(Vertex(y+1,	FposY,		x+1.01,	Fid,			1,	lightMapImage.get(x*2+1, y*2+1)));
						}
						
						if(left)
						{
							Vertexes.push_back(Vertex(y,	FposY+1,	x-0.01,	Fid,			0,	lightMapImage.get(x*2, y*2)));
							Vertexes.push_back(Vertex(y+1,	FposY+1,	x-0.01,	Fid+x_UVStep,	0,	lightMapImage.get(x*2, y*2+1)));
							Vertexes.push_back(Vertex(y+1,	FposY,		x-0.01,	Fid+x_UVStep,	1,	lightMapImage.get(x*2, y*2+1)));
							Vertexes.push_back(Vertex(y,	FposY,		x-0.01,	Fid,			1,	lightMapImage.get(x*2, y*2)));
						}
						
						if(up)
						{
							Vertexes.push_back(Vertex(y-0.01,	FposY+1,	x+1,	Fid,			0,	lightMapImage.get(x*2+1, y*2)));
							Vertexes.push_back(Vertex(y-0.01,	FposY+1,	x,		Fid+x_UVStep,	0,	lightMapImage.get(x*2, y*2)));
							Vertexes.push_back(Vertex(y-0.01,	FposY,		x,		Fid+x_UVStep,	1,	lightMapImage.get(x*2, y*2)));
							Vertexes.push_back(Vertex(y-0.01,	FposY,		x+1,	Fid,			1,	lightMapImage.get(x*2+1, y*2)));
						}
						
						if(down)
						{
							Vertexes.push_back(Vertex(y+1.01,	FposY+1,	x,		Fid,			0,	lightMapImage.get(x*2, y*2+1)));
							Vertexes.push_back(Vertex(y+1.01,	FposY+1,	x+1,	Fid+x_UVStep,	0,	lightMapImage.get(x*2+1, y*2+1)));
							Vertexes.push_back(Vertex(y+1.01,	FposY,		x+1,	Fid+x_UVStep,	1,	lightMapImage.get(x*2+1, y*2+1)));
							Vertexes.push_back(Vertex(y+1.01,	FposY,		x,		Fid,			1,	lightMapImage.get(x*2, y*2+1)));
						}
					}
					
					getNet().server_KeepConnectionsAlive();
				}
			}
		}
	}
}

namespace map_colors
{
	enum color
	{
		nodraw_solid		= 0xFF000000,

		green_spawn			= 0xFF2BE471,
		red_spawn			= 0xFFD8002B,

		floor				= 0xFFFFFFFF,
		neutral_wall		= 0xFF42484B,
		weird_wall			= 0xFF844715,
		green_brick			= 0xFF1DAE71,
		red_brick			= 0xFFB73333,
		green_metal			= 0xFF00D927,
		red_metal			= 0xFFFF0000,
		green_sheet_metal	= 0xFF00AD1C,
		red_sheet_metal		= 0xFFAD1111,
		brown_brick			= 0xFF915D32,
		gray_brick			= 0xFF859096,
		green_tiles			= 0xFF1DAD37,
		red_tiles			= 0xFFC62B2B,
		brown_tiles			= 0xFFA86C3A,
		cobble				= 0xFF5F676B,
		cobble_r			= 0xFF666E3E,
		cobble_l			= 0xFF68703E,
		pipes				= 0xFF4B5254,
		
		//green_banner		= 0xFF3AFF61,
		//red_banner		= 0xFFFFA500,

		barrel				= 0xFF38ACFF,
		box					= 0xFFC67823,
		lamppost			= 0xFF99846B
	};	
}

uint WallIDfromColor(uint color)
{
	switch(color)
	{
		//case map_colors::green_banner:
		//case map_colors::red_banner:
		case map_colors::green_spawn:
		case map_colors::red_spawn:
		case map_colors::floor:
		case map_colors::neutral_wall:
			return 0;
			break;
		case map_colors::weird_wall:
			return 1;
			break;
		case map_colors::green_brick:
			return 2;
			break;
		case map_colors::red_brick:
			return 3;
			break;
		case map_colors::green_metal:
			return 4;
			break;
		case map_colors::red_metal:
			return 5;
			break;
		case map_colors::green_sheet_metal:
			return 6;
			break;
		case map_colors::red_sheet_metal:
			return 7;
			break;
		case map_colors::brown_brick:
			return 8;
			break;
		case map_colors::gray_brick:
			return 9;
			break;
		case map_colors::green_tiles:
			return 10;
			break;
		case map_colors::red_tiles:
			return 11;
			break;
		case map_colors::brown_tiles:
			return 12;
			break;
		case map_colors::cobble:
			return 13;
			break;
		case map_colors::cobble_r:
			return 14;
			break;
		case map_colors::cobble_l:
			return 15;
			break;
		case map_colors::pipes:
			return 16;
			break;
		
		//case map_colors::red_banner:
		//	return 63;
		//	break;
		//case map_colors::green_banner:
		//	return 64;
		//	break;
	}
	return -1;
}

Vec2f[] positionsFour = {	Vec2f(1,0),
							Vec2f(0,1),
							Vec2f(-1,0),
							Vec2f(0,-1)};

void getSidefFromBlue(uint blue, bool &out right, bool &out up, bool &out left, bool &out down)
{
	switch(blue)
	{
		case 0:
		{
			up = true;
			right = true;
			down = true;
			left = true;
			break;
		}
		case 1:
		{
			up = false;
			right = false;
			down = true;
			left = false;
			break;
		}
		case 2:
		{
			up = false;
			right = true;
			down = false;
			left = false;
			break;
		}
		case 3:
		{
			up = true;
			right = false;
			down = false;
			left = false;
			break;
		}
		case 4:
		{
			up = false;
			right = false;
			down = false;
			left = true;
			break;
		}
		case 5:
		{
			up = true;
			right = false;
			down = true;
			left = false;
			break;
		}
		case 6:
		{
			up = false;
			right = true;
			down = false;
			left = true;
			break;
		}
		case 7:
		{
			up = false;
			right = true;
			down = true;
			left = false;
			break;
		}
		case 8:
		{
			up = true;
			right = true;
			down = false;
			left = false;
			break;
		}
		case 9:
		{
			up = true;
			right = false;
			down = false;
			left = true;
			break;
		}
		case 10:
		{
			up = false;
			right = false;
			down = true;
			left = true;
			break;
		}
		case 11:
		{
			up = true;
			right = true;
			down = true;
			left = false;
			break;
		}
		case 12:
		{
			up = true;
			right = true;
			down = false;
			left = true;
			break;
		}
		case 13:
		{
			up = true;
			right = false;
			down = true;
			left = true;
			break;
		}
		case 14:
		{
			up = false;
			right = true;
			down = true;
			left = true;
			break;
		}
		default:
		{
			up = false;
			right = false;
			down = false;
			left = false;
			break;
		}
	}
}






