Vec2f getSpawnPosition( CMap@ map, int offset )
{
	Vec2f pos = map.getTileWorldPosition(offset);
	f32 tile_offset = map.tilesize * 0.5f;
	pos.x += tile_offset;
	pos.y += tile_offset;
	return pos;
}

CBlob@ spawnBlob( CMap@ map, const string& in name, int offset, int team, bool attached_to_map = false )
{
	CBlob@ blob = server_CreateBlob( name, team, getSpawnPosition( map, offset) );

	if (blob !is null && attached_to_map) {
		blob.getShape().SetStatic( true );
	}

	return blob;
}

void AddMarker( CMap@ map, int offset, const string& in name)
{
	map.AddMarker( map.getTileWorldPosition( offset ), name );
	PlaceMostLikelyTile( map, offset );
}

void PlaceMostLikelyTile( CMap@ map, int offset )
{
	TileType down = map.getTile( offset + map.tilemapwidth).type;

	map.SetTile( offset, down );
	map.AddTileFlag( offset, Tile::BACKGROUND );
}


