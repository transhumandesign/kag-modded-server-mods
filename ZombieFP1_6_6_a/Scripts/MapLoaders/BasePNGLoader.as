// PNG loader base class - extend this to add your own PNG loading functionality!
// "every item" courtesy of Jackitch - updated 20 Sep 2013

#include "CustomBlocks.as"

// tiles
const SColor color_tile_ground(255, 132, 71, 21);
const SColor color_tile_ground_back(255, 59, 20, 6);
const SColor color_tile_stone(255, 139, 104, 73);
const SColor color_tile_thickstone(255, 66, 72, 75);
const SColor color_tile_bedrock(255, 45, 52, 45);
const SColor color_tile_gold(255, 254, 165, 61);
const SColor color_tile_castle(255, 100, 113, 96);
const SColor color_tile_castle_back(255, 49, 52, 18);
const SColor color_tile_castle_moss(255, 100, 143, 96);
const SColor color_tile_castle_back_moss(255, 49, 82, 18);
const SColor color_tile_ladder(255, 43, 21, 9);
const SColor color_tile_ladder_ground(255, 66, 36, 11);
const SColor color_tile_ladder_castle(255, 67, 47, 17);
const SColor color_tile_ladder_wood(255, 69, 57, 17);
const SColor color_tile_grass(255, 100, 155, 13);
const SColor color_tile_wood(255, 196, 135, 21);
const SColor color_tile_wood_back(255, 85, 42, 17);
const SColor color_water_air(255, 46, 129, 166);
const SColor color_water_backdirt(255, 51, 85, 102);
const SColor color_tile_sand(0xffecd590);
// objects
//aedificiis et officinas
const SColor color_zombie_main_spawn(0xff05ff05);
const SColor color_zombie_portal(0xff710d71);
const SColor color_zombie_statue(255, 61, 16, 123);
const SColor color_grave(0xffe900f0);
const SColor color_blue_main_spawn(255, 0, 255, 255);
const SColor color_red_main_spawn(255, 255, 0, 0);
const SColor color_green_main_spawn(0xff9dca22);
const SColor color_purple_main_spawn(0xffd379e0);
const SColor color_orange_main_spawn(0xffcd6120);
const SColor color_aqua_main_spawn(0xff2ee5a2);
const SColor color_teal_main_spawn(0xff5f84ec);
const SColor color_gray_main_spawn(0xffc4cfa1);
const SColor color_blue_spawn(255, 0, 200, 200);
const SColor color_red_spawn(255, 200, 0, 0);
const SColor color_knight_shop(0xffffbebe);
const SColor color_builder_shop(0xffbeffbe);
const SColor color_archer_shop(0xffffffbe);
const SColor color_boat_shop(0xffc8beff);
const SColor color_vehicle_shop(0xffe6e6e6);
const SColor color_quarters(0xfff0beff);
const SColor color_storage_noteam(255, 217, 255, 239);
const SColor color_barracks_noteam(255, 217, 218, 255);
const SColor color_factory_noteam(255, 255, 217, 237);
const SColor color_tunnel_blue(255, 220, 217, 254);
const SColor color_tunnel_red(255, 243, 217, 220);
const SColor color_tunnel_noteam(255, 243, 217, 254);
const SColor color_kitchen(255, 255, 217, 217);
const SColor color_nursery(255, 217, 255, 223);
const SColor color_research(255, 225, 225, 225);
const SColor color_workbench(255, 0, 255, 0);
const SColor color_campfire(0xffFBE28B);
const SColor color_saw(0xffCAA482);
//flora
const SColor color_tree(255, 13, 103, 34);
const SColor color_bush(0xff5b7e18);
const SColor color_grain(0xffa2b716);
const SColor color_flowers(255, 255, 102, 255);
const SColor color_log(255, 160, 140, 40);
//fauna
const SColor color_shark(0xff2cafde);
const SColor color_fish(0xff79a8a3);
const SColor color_bison(0xffb75646);
//ostia et pedicas
const SColor color_ladder(0xff42240B);
const SColor color_platform(0xffff9239);
const SColor color_door_1(255, 26, 78, 131);
const SColor color_door_2(255, 148, 27, 27);
const SColor color_door_noteam(255, 148, 148, 148);
const SColor color_stone_door_blue(255, 80, 90, 160);
const SColor color_stone_door_red(255, 160, 90, 80);
const SColor color_stone_door_noteam(255, 160, 160, 160);
const SColor color_trapblock_blue(0xff384C8E);
const SColor color_trapblock_red(0xff8E3844);
const SColor color_trapblock_noteam(255, 100, 100, 100);
const SColor color_spikes(255, 180, 42, 17);
const SColor color_spikes_ground(255, 180, 97, 17);
const SColor color_spikes_castle(255, 180, 42, 94);
const SColor color_spikes_wood(255, 200, 42, 94);
//objecta
const SColor color_drill(255, 210, 120, 0);
const SColor color_trampoline(255, 187, 59, 253);
const SColor color_lantern(0xfff1e7b1);
const SColor color_crate(255, 102, 0, 0);
const SColor color_bucket(255, 255, 220, 120);
const SColor color_sponge(255, 220, 0, 180);
const SColor color_steak(0xffdb8867);
const SColor color_burger(0xffcd8e4b);
//vehiculis
const SColor color_catapult(0xff67E5A5);
const SColor color_ballista(255, 100, 210, 160);
const SColor color_mountedbow(0xff38E8B8);
const SColor color_longboat(255, 0, 51, 255);
const SColor color_warboat(255, 50, 140, 255);
const SColor color_dinghy(0xffc99ef6);
const SColor color_raft(255, 70, 110, 155);
const SColor color_airship(255, 255, 175, 0);
const SColor color_bomber(255, 255, 190, 0);
//arma
const SColor color_bombs(0xfffbf157);
const SColor color_waterbombs(255, 210, 200, 120);
const SColor color_arrows(255, 200, 210, 70);
const SColor color_bombarrows(255, 200, 180, 10);
const SColor color_waterarrows(255, 200, 160, 10);
const SColor color_firearrows(255, 230, 210, 70);
const SColor color_bolts(255, 230, 230, 170);
const SColor color_blue_mine(255, 90, 100, 255);
const SColor color_red_mine(255, 255, 160, 90);
const SColor color_mine_noteam(0xffd74bff);
const SColor color_boulder(0xffA19585);
const SColor color_satchel(255, 170, 100, 0);
const SColor color_keg(255, 220, 60, 60);
//ligna, lapides, et aurum
const SColor color_gold(255, 255, 240, 160);
const SColor color_stone(255, 190, 190, 175);
const SColor color_wood(255, 200, 190, 140);
//bellus domina et odiosas magus
const SColor color_princess(0xffFB87FF);
const SColor color_necromancer(0xff9E3ABB);
const SColor color_necromancer_teleport(0xff621A83);

// stultus futuit
const SColor color_mook_knight(0xffff5f19);
const SColor color_mook_archer(0xff19ffb6);
const SColor color_mook_spawner(0xff3E0100);
const SColor color_mook_spawner_10(0xff56062C);

enum WAROffset {
	autotile_offset = 0,
	tree_offset,
	bush_offset,
	grain_offset,
	spike_offset,
	ladder_offset,
	offsets_count
};

//global
Random@ map_random = Random();

class PNGLoader
{
	
	PNGLoader()
	{
		offsets = array<array<int>>(offsets_count, array<int>(0));
	}
	
	CFileImage@ image;
	CMap@ map;
	
	array<array<int>> offsets;
	
	int current_offset_count;

	bool loadMap( CMap@ _map, const string& in filename)
	{
		@map = _map;
		@map_random = Random();

		if (!getNet().isServer())
		{
			SetupMap(0,0);
			SetupBackgrounds();
			return true;
		}

		@image = CFileImage( filename );
		
		if (image.isLoaded())
		{
			SetupMap(image.getWidth(), image.getHeight());
			
			while (image.nextPixel())
			{
				SColor pixel = image.readPixel();
				int offset = image.getPixelOffset();
				
				handlePixel(pixel, offset);
				
				getNet().server_KeepConnectionsAlive();
			}
						
			// late load - after placing tiles

			// load trees
			for (uint i = 0; i < offsets.length; ++i)
			{
				int[]@ offset_set = offsets[i];
				current_offset_count = offset_set.length;
				for (uint step = 0; step < current_offset_count; ++step)
				{
					handleOffset(i, offset_set[step], step, current_offset_count);
					
					getNet().server_KeepConnectionsAlive();
				}
			}

			SetupBackgrounds();	
			return true;
		}
		return false;
	}
	
	//override this to extend functionality per-pixel.
	void handlePixel(SColor pixel, int offset)
	{
		//TILES
	if (pixel == color_tile_ground) {
			map.SetTile(offset, CMap::tile_ground );
		}
		else if (pixel == color_tile_ground_back) {
			map.SetTile(offset, CMap::tile_ground_back );
		}
		else if (pixel == color_tile_stone) {
			map.SetTile(offset, CMap::tile_stone );
		}
		else if (pixel == color_tile_thickstone) {
			map.SetTile(offset, CMap::tile_thickstone );
		}
		else if (pixel == color_tile_bedrock) {
			map.SetTile(offset, CMap::tile_bedrock );
		}
		else if (pixel == color_tile_gold) {
			map.SetTile(offset, CMap::tile_gold );
		}
		else if (pixel == color_tile_castle) {
			map.SetTile(offset, CMap::tile_castle );
		}
		else if (pixel == color_tile_castle_back) {
			map.SetTile(offset, CMap::tile_castle_back );
		}
		else if (pixel == color_tile_castle_moss) {
			map.SetTile(offset, CMap::tile_castle_moss );
		}
		else if (pixel == color_tile_castle_back_moss) {
			map.SetTile(offset, CMap::tile_castle_back_moss );
		}
		else if (pixel == color_tile_wood) {
			map.SetTile(offset, CMap::tile_wood );
		}
		else if (pixel == color_tile_wood_back) {
			map.SetTile(offset, CMap::tile_wood_back );
		}
		else if (pixel == color_tile_grass) {
			map.SetTile(offset, CMap::tile_grass + map_random.NextRanged(3) );
		}
		else if (pixel == color_water_air) {
			map.server_setFloodWaterOffset( offset, true );
		}
		else if (pixel == color_water_backdirt)
		{
			map.server_setFloodWaterOffset( offset, true );
			map.SetTile( offset, CMap::tile_ground_back );
		}
		//BUILDINGS
		else if (pixel == color_zombie_main_spawn) {
			AddMarker( map, offset, "zombie spawn" );
		}		
		else if (pixel == color_zombie_portal) {
			AddMarker( map, offset, "zombie portal" );
		}		
		else if (pixel == color_grave) {
			AddMarker( map, offset, "grave" );
		}										
		else if (pixel == color_blue_main_spawn) {
			AddMarker( map, offset, "blue main spawn" );
		}
		else if (pixel == color_red_main_spawn) {
			AddMarker( map, offset, "red main spawn" );
		}
		else if (pixel == color_green_main_spawn) {
			AddMarker( map, offset, "green main spawn" );
		}
		else if (pixel == color_purple_main_spawn) {
			AddMarker( map, offset, "purple main spawn" );
		}
		else if (pixel == color_orange_main_spawn) {
			AddMarker( map, offset, "orange main spawn" );
		}
		else if (pixel == color_aqua_main_spawn) {
			AddMarker( map, offset, "aqua main spawn" );
		}	
		else if (pixel == color_blue_spawn) {
			AddMarker( map, offset, "blue spawn" );
		}
		else if (pixel == color_red_spawn) {
			AddMarker( map, offset, "red spawn" );
		}
		else if (pixel == color_knight_shop)
		{
			spawnBlob( map, "knightshop", offset, 255);
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_zombie_statue) {
			spawnBlob( map, "undeadstatue", offset, 255);
			offsets[autotile_offset].push_back( offset );
		}		
		else if (pixel == color_builder_shop)
		{
			spawnBlob( map, "buildershop", offset, 255);
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_archer_shop)
		{
			spawnBlob( map, "archershop", offset, 255);
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_boat_shop)
		{
			spawnBlob( map, "boatshop", offset, 255);
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_vehicle_shop)
		{
			spawnBlob( map, "vehicleshop", offset, 255);
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_quarters)
		{
			spawnBlob( map, "quarters", offset, 255);
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_storage_noteam)
		{
			spawnBlob( map, "storage", offset, 255);
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_barracks_noteam)
		{
			spawnBlob( map, "barracks", offset, 255);
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_factory_noteam)
		{
			spawnBlob( map, "factory", offset, 255);
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_tunnel_blue)
		{
			spawnBlob( map, "tunnel", offset, 0);
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_tunnel_red)
		{
			spawnBlob( map, "tunnel", offset, 1);
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_tunnel_noteam)
		{
			spawnBlob( map, "tunnel", offset, 255);
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_kitchen)
		{
			spawnBlob( map, "kitchen", offset, 255);
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_nursery)
		{
			spawnBlob( map, "nursery", offset, 255);
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_research)
		{
			spawnBlob( map, "research", offset, 255);
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_workbench)
		{
			spawnBlob( map, "workbench", offset, -1, true);
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_campfire)
		{
			spawnBlob( map, "fireplace", offset, -1, true, Vec2f(0.0f, -4.0f));
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_saw)
		{
			spawnBlob( map, "saw", offset, -1, false);
			offsets[autotile_offset].push_back( offset );
		}
		// TREES
		else if (pixel.getRed() == color_tree.getRed() && pixel.getBlue() == color_tree.getBlue() && pixel.getGreen() >= color_tree.getGreen() && pixel.getGreen() <= color_tree.getGreen()+3)
		{
			offsets[tree_offset].push_back( offset );
			offsets[autotile_offset].push_back( offset );
		}
		//NATURE
		else if (pixel == color_bush)
		{
			offsets[bush_offset].push_back( offset );
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_grain)
		{
			offsets[grain_offset].push_back( offset );
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_flowers)
		{
			spawnBlob( map, "flowers", offset, -1);
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_log)
		{
			spawnBlob( map, "log", offset, -1);
			offsets[autotile_offset].push_back( offset );
		}
		//ANIMALS
		else if (pixel == color_shark)
		{
			spawnBlob( map, "shark", offset, -1);
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_fish)
		{
			CBlob@ fishy = spawnBlob( map, "fishy", offset, -1);
			if (fishy !is null)
			{
				fishy.set_u8("age", (offset * 997) % 4 );
			}
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_bison)
		{
			spawnBlob( map, "bison", offset, -1, false);
			offsets[autotile_offset].push_back( offset );
		}
		//DOORS AND TRAPS
		else if (pixel == color_ladder || pixel == color_tile_ladder_ground ||
				 pixel == color_tile_ladder_castle || pixel == color_tile_ladder_wood)
		{
			offsets[ladder_offset].push_back( offset );
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_platform)
		{
			spawnBlob( map, "wooden_platform", offset, 255, true );
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_door_1)
		{
			spawnBlob( map, "wooden_door", offset, 0, true );
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_door_2)
		{
			spawnBlob( map, "wooden_door", offset, 1, true );
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_door_noteam)
		{
			spawnBlob( map, "wooden_door", offset, 255, true );
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_stone_door_blue)
		{
			spawnBlob( map, "stone_door", offset, 0, true );
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_stone_door_red)
		{
			spawnBlob( map, "stone_door", offset, 1, true );
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_stone_door_noteam)
		{
			spawnBlob( map, "stone_door", offset, 255, true );
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_trapblock_blue)
		{
			spawnBlob( map, "trap_block", offset, 0, true);
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_trapblock_red)
		{
			spawnBlob( map, "trap_block", offset, 1, true);
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_trapblock_noteam)
		{
			spawnBlob( map, "trap_block", offset, 255, true );
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_spikes) {
			offsets[spike_offset].push_back( offset );
		}
		else if (pixel == color_spikes_ground)
		{
			map.SetTile(offset, CMap::tile_ground_back );
			offsets[spike_offset].push_back( offset );
		}
		else if (pixel == color_spikes_castle)
		{
			map.SetTile(offset, CMap::tile_castle_back );
			offsets[spike_offset].push_back( offset );
		}
		else if (pixel == color_spikes_wood)
		{
			map.SetTile(offset, CMap::tile_wood_back );
			offsets[spike_offset].push_back( offset );
		}
		//ITEMS
		else if (pixel == color_drill)
		{
			spawnBlob( map, "drill", offset, -1);
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_trampoline)
		{
			CBlob@ trampoline = server_CreateBlobNoInit( "trampoline" );

			if (trampoline !is null)
			{
				trampoline.Tag("start unpacked");
				trampoline.Tag("invincible");
				trampoline.Tag("static");
				trampoline.setPosition( getSpawnPosition( map, offset ) );
				trampoline.Init();
			}

			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_lantern)
		{
			spawnBlob( map, "lantern", offset, -1, true);
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_crate)
		{
			spawnBlob( map, "crate", offset, -1);
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_bucket)
		{
			spawnBlob( map, "bucket", offset, -1);
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_sponge)
		{
			spawnBlob( map, "sponge", offset, -1);
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_steak)
		{
			spawnBlob( map, "steak", offset, -1);
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_burger)
		{
			spawnBlob( map, "food", offset, -1);
			offsets[autotile_offset].push_back( offset );
		}
		//VEHICLES
		else if (pixel == color_catapult)
		{
			spawnVehicle( map, "catapult", offset, 0); // HACK: team for Challenge
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_ballista)
		{
			spawnVehicle( map, "ballista", offset);
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_mountedbow)
		{
			spawnBlob( map, "mounted_bow", offset, -1, true, Vec2f(0.0f, 4.0f));
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_longboat)
		{
			spawnVehicle( map, "longboat", offset);
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_warboat)
		{
			spawnVehicle( map, "warboat", offset);
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_dinghy)
		{
			spawnVehicle( map, "dinghy", offset);
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_raft)
		{
			spawnVehicle( map, "raft", offset);
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_airship)
		{
			spawnVehicle( map, "airship", offset);
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_bomber)
		{
			spawnVehicle( map, "bomber", offset);
			offsets[autotile_offset].push_back( offset );
		}
		//WEAPONS
		else if (pixel == color_bombs)
		{
			AddMarker( map, offset, "mat_bombs" );
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_waterbombs)
		{
			spawnBlob( map, "mat_waterbombs", offset, -1);
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_arrows)
		{
			spawnBlob( map, "mat_arrows", offset, -1);
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_bombarrows)
		{
			spawnBlob( map, "mat_bombarrows", offset, -1);
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_waterarrows)
		{
			spawnBlob( map, "mat_waterarrows", offset, -1);
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_firearrows)
		{
			spawnBlob( map, "mat_firearrows", offset, -1);
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_bolts)
		{
			spawnBlob( map, "mat_bolts", offset, -1);
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_blue_mine)
		{
			spawnBlob( map, "mine", offset, 0);
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_red_mine)
		{
			spawnBlob( map, "mine", offset, 1);
			offsets[autotile_offset].push_back( offset );
		}
	else if (pixel == color_mine_noteam)
		{
			spawnBlob( map, "mine", offset, -1);
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_boulder)
		{
			spawnBlob( map, "boulder", offset, -1, false, Vec2f(8.0f, -8.0f));
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_satchel)
		{
			spawnBlob( map, "satchel", offset, -1);
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_keg)
		{
			spawnBlob( map, "keg", offset, -1);
			offsets[autotile_offset].push_back( offset );
		}
		//RESOURCES
		else if (pixel == color_gold)
		{
			spawnBlob( map, "mat_gold", offset, -1);
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_stone)
		{
			spawnBlob( map, "mat_stone", offset, -1);
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_wood)
		{
			spawnBlob( map, "mat_wood", offset, -1);
			offsets[autotile_offset].push_back( offset );
		}
		//FAIR LADY AND NASTY MAGE
		else if (pixel == color_princess)
		{
			spawnBlob( map, "princess", offset, 6, false);
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_necromancer)
		{
			spawnBlob( map, "necromancer", offset, 3, false);
			offsets[autotile_offset].push_back( offset );
		}
		else if (pixel == color_necromancer_teleport) {
			AddMarker( map, offset, "necromancer teleport" );
		}
		//HERP DERP HENRIES
		else if (pixel == color_mook_knight) {
			AddMarker( map, offset, "mook knight" );
		}
		else if (pixel == color_mook_archer) {
			AddMarker( map, offset, "mook archer" );
		}
		else if (pixel == color_mook_spawner) {
			AddMarker( map, offset, "mook spawner" );
		}
		else if (pixel == color_mook_spawner_10) {
			AddMarker( map, offset, "mook spawner 10" );
		}
	}
	
	//override this to add post-load offset types.
	void handleOffset(int type, int offset, int position, int count)
	{
		if (type == autotile_offset)
		{
			PlaceMostLikelyTile(map,offset);
		}
		else if (type == tree_offset)
		{
			if (map.isTileSolid( map.getTile(offset + map.tilemapwidth) )) // load trees only at the ground
			{
				CBlob@ tree = server_CreateBlobNoInit( map_random.NextRanged(35) < 21 ? "tree_pine" : "tree_bushy" );

				if (tree !is null)
				{
					tree.Tag("startbig");
					tree.setPosition( getSpawnPosition( map, offset ) );
					tree.Init();
					
					if (map.getTile(offset).type == CMap::tile_empty)
						map.SetTile(offset, CMap::tile_grass + map_random.NextRanged(3) );
				}
			}
		}
		else if (type == bush_offset)
		{
			server_CreateBlob( "bush", -1, map.getTileWorldPosition(offset) + Vec2f(4.0f, 4.0f)  );
		}
		else if (type == grain_offset)
		{
			CBlob@ grain = server_CreateBlobNoInit( "grain_plant" );
			if (grain !is null)
			{
				grain.Tag("instant_grow");
				grain.setPosition( map.getTileWorldPosition(offset) + Vec2f(4.0f, 4.0f) );
				grain.Init();
			}
		}
		else if (type == spike_offset)
		{
			CBlob@ spikes = server_CreateBlob( "spikes", -1, map.getTileWorldPosition(offset) + Vec2f(4.0f, 4.0f)  );

			if (spikes !is null) {
				spikes.getShape().SetStatic( true );
			}
		}
		else if (type == ladder_offset)
		{
			spawnLadder( map, offset );
		}
	}

	void SetupMap( int width, int height )
	{
		map.CreateTileMap( width, height, 8.0f, "Sprites/world.png" );
	}

	void SetupBackgrounds()
	{
		// sky

		map.CreateSky( color_black, Vec2f(1.0f,1.0f), 200, "Sprites/Back/cloud", 0);
		map.CreateSkyGradient( "Sprites/skygradient.png" ); // override sky color with gradient

		// plains

		map.AddBackground( "Sprites/Back/BackgroundPlains.png", Vec2f(0.0f, 0.0f), Vec2f(0.3f, 0.3f), color_white ); 
		map.AddBackground( "Sprites/Back/BackgroundTrees.png", Vec2f(0.0f,  19.0f), Vec2f(0.4f, 0.4f), color_white ); 
		//map.AddBackground( "Sprites/Back/BackgroundIsland.png", Vec2f(0.0f, 50.0f), Vec2f(0.5f, 0.5f), color_white ); 
		map.AddBackground( "Sprites/Back/BackgroundCastle.png", Vec2f(0.0f, 50.0f), Vec2f(0.6f, 0.6f), color_white ); 

		// fade in 				   
		SetScreenFlash( 255, 0, 0, 0 );

		SetupBlocks();
	}

	void SetupBlocks()
	{
	}

	CBlob@ spawnLadder( CMap@ map, int offset )
	{
		// should place?

		bool up = false, down = false, right = false, left = false;
		int[]@ ladders = offsets[ladder_offset];
		for (uint step = 0; step < ladders.length; ++step)
		{
			const int lof = ladders[step];
			if (lof == offset-map.tilemapwidth) {
				up = true;
			}
			if (lof == offset+map.tilemapwidth) {
				down = true;
			}
			if (lof == offset+1) {
				right = true;
			}
			if (lof == offset-1) {
				left = true;
			}
		}  
		if ( offset % 2 == 0 && ((left && right) || (up && down)) )
		{
			return null;
		}

		CBlob@ blob = server_CreateBlob( "ladder", -1, getSpawnPosition( map, offset) );
		if (blob !is null)
		{
			// check for horizontal placement
			for (uint step = 0; step < ladders.length; ++step)
			{						
				if (ladders[step] == offset-1 || ladders[step] == offset+1)
				{
					blob.setAngleDegrees( 90.0f );
					break;
				}
			}			  					
			blob.getShape().SetStatic( true );	
		}
		return blob;
	}
}

void PlaceMostLikelyTile( CMap@ map, int offset )
{
    TileType up = map.getTile( offset - map.tilemapwidth).type;
    TileType down = map.getTile( offset + map.tilemapwidth).type;
    TileType left = map.getTile( offset - 1).type;
    TileType right = map.getTile( offset + 1).type;

	bool upEmpty = (up == CMap::tile_empty);

    if (!upEmpty &&
			( up == CMap::tile_castle || up == CMap::tile_castle_back ||
			down == CMap::tile_castle || down == CMap::tile_castle_back ||
			left == CMap::tile_castle || left == CMap::tile_castle_back ||
			right == CMap::tile_castle || right == CMap::tile_castle_back))
	{
		map.SetTile(offset, CMap::tile_castle_back );
	}
	else if (!upEmpty &&
			( up == CMap::tile_wood || up == CMap::tile_wood_back ||
			 down == CMap::tile_wood || down == CMap::tile_wood_back ||
			 left == CMap::tile_wood || left == CMap::tile_wood_back ||
			 right == CMap::tile_wood || right == CMap::tile_wood_back))
	{
		map.SetTile(offset, CMap::tile_wood_back );
	}
	else if (!upEmpty &&
			( up == CMap::tile_ground || up == CMap::tile_ground_back ||
			 down == CMap::tile_ground || down == CMap::tile_ground_back ||
			 left == CMap::tile_ground || left == CMap::tile_ground_back ||
			 right == CMap::tile_ground || right == CMap::tile_ground_back) )
	{
		map.SetTile(offset, CMap::tile_ground_back );
	}
	else if ( map.isTileSolid(down) &&
			 (map.isTileGrass(left) || map.isTileGrass(right)) )
	{
		map.SetTile(offset, CMap::tile_grass + 2 + map_random.NextRanged(2) );
	}
}


Vec2f getSpawnPosition( CMap@ map, int offset )
{
    Vec2f pos = map.getTileWorldPosition(offset);
    f32 tile_offset = map.tilesize * 0.5f;
    pos.x += tile_offset;
    pos.y += tile_offset;
    return pos;
}

CBlob@ spawnBlob( CMap@ map, const string& in name, int offset, int team, bool attached_to_map, Vec2f posOffset )
{
    CBlob@ blob = server_CreateBlob( name, team, getSpawnPosition( map, offset) + posOffset );	 
    if (blob !is null && attached_to_map) {
        blob.getShape().SetStatic( true );
    }	
    return blob;
}

CBlob@ spawnBlob( CMap@ map, const string& in name, int offset, int team, bool attached_to_map = false )
{
	return spawnBlob( map, name, offset, team, attached_to_map, Vec2f_zero );
}

CBlob@ spawnVehicle( CMap@ map, const string& in name, int offset, int team = -1)
{
	CBlob@ blob = server_CreateBlob( name, team, getSpawnPosition( map, offset) );
	if (blob !is null) 
	{
		blob.RemoveScript( "DecayIfLeftAlone.as" );
	}

	return blob;
}


void AddMarker( CMap@ map, int offset, const string& in name)
{
    map.AddMarker( map.getTileWorldPosition( offset ), name );
    PlaceMostLikelyTile( map, offset );
}
