// generates from a KAGGen config
// fileName is "" on client!

#include "LoaderUtilities.as"
#include "TreeDeeMap.as"
#include "IsLocalhost.as"

bool LoadMap(CMap@ map, const string& in fileName)
{
	print("GENERATING GROOB MAP " + fileName);
	
	//print("boool: "+getRules().get_bool("it_is_localhost_my_dudes_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"));

	return loadGroobMap(map, fileName);
}

bool loadGroobMap(CMap@ _map, const string& in filename)
{
	CMap@ map = _map;
	
	if (!isServer() || filename == "")
	{
		print(" ");
		print("filename is nothing or not server");
		SetupMap(map, 0, 0);
		//SetupBackgrounds(map);
		print(" ");
		print("Generating 3d mesh... "+map.getMapName());
		print(" ");
		ConfigFile cfg = ConfigFile(map.getMapName());
		string map_name = cfg.read_string("map_name", "error");
		string map_tile_sheet = cfg.read_string("map_tile_sheet", "error");
		string map_lightmap = cfg.read_string("map_lightmap", "error");
		string map_heightmap = cfg.read_string("map_heightmap", "error");
		string map_fancy = cfg.read_string("map_fancy", "error");
		string skybox_name = cfg.read_string("skybox_name", "error");
		
		ThreeDeeMap three_dee_map(map_name, map_tile_sheet, map_lightmap, map_heightmap, map_fancy, skybox_name);
		getRules().set("ThreeDeeMap", @three_dee_map);
		return true;
	}
	
	ConfigFile cfg = ConfigFile(filename);
	string map_name = cfg.read_string("map_name", "error");
	string map_heightmap = cfg.read_string("map_heightmap", "error");
	string map_objects = cfg.read_string("map_objects", "error");
	
	CFileImage@ mapimage = CFileImage( map_name );
	CFileImage@ heightMapImage = CFileImage( map_heightmap );
	CFileImage@ objectimage = CFileImage( map_objects );;
	
	if(mapimage.isLoaded() && objectimage.isLoaded() && heightMapImage.isLoaded())
	{
		SetupMap(map, mapimage.getWidth(), mapimage.getHeight());
		//SetupBackgrounds(map);
		print(" ");
		print("Generating solidity map... ");
		print(" ");
		while(mapimage.nextPixel())
		{
			SColor pixel = mapimage.readPixel();
			Vec2f pos = mapimage.getPixelPosition();
			const int offset = mapimage.getPixelOffset();
			
			heightMapImage.setPixelPosition(pos);
			uint minHeight = heightMapImage.readPixel().getRed()/10;
			if(minHeight > 0)
				map.SetTile(offset, CMap::tile_ground_back);
			else
				map.SetTile(offset, CMap::tile_ground);
			
			uint clr = pixel.color;
			
			switch(clr)
			{
			//	case map_colors::nodraw_solid:
			//	case map_colors::neutral_wall:
			//	case map_colors::weird_wall:
			//	case map_colors::green_brick:
			//	case map_colors::red_brick:
			//	case map_colors::green_metal:
			//	case map_colors::red_metal:
			//	{
			//		heightMapImage.setPixelPosition(pos);
			//		uint minHeight = heightMapImage.readPixel().getRed()/10;
			//		if(minHeight > 0)
			//			map.SetTile(offset, CMap::tile_ground_back);
			//		else
			//			map.SetTile(offset, CMap::tile_ground);
			//		break;
			//	}
				case map_colors::green_spawn:
				{
					map.AddMarker(map.getTileWorldPosition(offset)+Vec2f(8,24), "green main spawn");
			//		map.SetTile(offset, CMap::tile_ground_back);
					break;
				}
				case map_colors::red_spawn:
				{
					map.AddMarker(map.getTileWorldPosition(offset)+Vec2f(8,24), "red main spawn");
			//		map.SetTile(offset, CMap::tile_ground_back);
					break;
				}
			//	default:
			//	{
			//		map.SetTile(offset, CMap::tile_ground_back);
			//		break;
			//	}
			}
			getNet().server_KeepConnectionsAlive();
		}
		print("Solidity map generated. ");
		print(" ");
		
		if(isLocalhost())
		{
			print("localhost");
			print(" ");
			print("Generating 3d mesh... "+map.getMapName());
			print(" ");
			string map_tile_sheet = cfg.read_string("map_tile_sheet", "error");
			string map_lightmap = cfg.read_string("map_lightmap", "error");
			string map_heightmap = cfg.read_string("map_heightmap", "error");
			string map_fancy = cfg.read_string("map_fancy", "error");
			string skybox_name = cfg.read_string("skybox_name", "error");
			ThreeDeeMap three_dee_map(map_name, map_tile_sheet, map_lightmap, map_heightmap, map_fancy, skybox_name);
			getRules().set("ThreeDeeMap", @three_dee_map);
			//SetupBackgrounds(map);
			//return true;
		}
		
		print("Creating objects... ");
		while(objectimage.nextPixel())
		{
			SColor opixel = objectimage.readPixel();
			//const int offset = objectimage.getPixelOffset();
			Vec2f pos = objectimage.getPixelPosition()*16/2+Vec2f(4,4);
			
			uint oclr = opixel.color;
			
			switch(oclr)
			{
				case map_colors::barrel:
				{
					//CBlob@ b = server_CreateBlobNoInit("barrel");
					//if(b !is null)
					//{
					//	b.server_setTeamNum(-1);
					//	b.setPosition(pos+);
					//}
					server_CreateBlob("barrel", -1, pos);
					break;
				}
				case map_colors::box:
				{
					//CBlob@ b = server_CreateBlobNoInit("box");
					//if(b !is null)
					//{
					//	b.server_setTeamNum(-1);
					//	b.setPosition(pos);
					//}
					server_CreateBlob("box", -1, pos);
					break;
				}
				case map_colors::lamppost:
				{
					server_CreateBlob("lamppost", -1, pos);
					break;
				}
				default:
				{
					break;
				}
			}
			getNet().server_KeepConnectionsAlive();
		}
		print(" ");
		print("Objects created. ");
		print(" ");
		return true;
	}
	return false;
}

void SetupMap(CMap@ map, int width, int height)
{
	map.legacyTileVariations = map.legacyTileMinimap = false;
	map.CreateTileMap(width, height, 16.0f, "Sprites/world.png");
}
/*
void SetupBackgrounds(CMap@ map)
{
	// sky

	map.CreateSky(color_black, Vec2f(1.0f, 1.0f), 200, "Sprites/Back/cloud", 0);
	map.CreateSkyGradient("Sprites/skygradient.png");   // override sky color with gradient

	// plains

	map.AddBackground("Sprites/Back/BackgroundPlains.png", Vec2f(0.0f, 0.0f), Vec2f(0.3f, 0.3f), color_white);
	map.AddBackground("Sprites/Back/BackgroundTrees.png", Vec2f(0.0f,  19.0f), Vec2f(0.4f, 0.4f), color_white);
	//map.AddBackground( "Sprites/Back/BackgroundIsland.png", Vec2f(0.0f, 50.0f), Vec2f(0.5f, 0.5f), color_white );
	map.AddBackground("Sprites/Back/BackgroundCastle.png", Vec2f(0.0f, 50.0f), Vec2f(0.6f, 0.6f), color_white);

	// fade in
	SetScreenFlash(255, 0, 0, 0);
}
*/