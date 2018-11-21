//_always hit: it will get hit even if it's on the same team
//_never hit: it won't get hit even if on different teams

const string[] undeadbunny_alwayshit = {
};

const string[] undeadbunny_neverhit = {

};

bool searchBlobList( CBlob@ blob, const string[] @blobList )
{
	string name = blob.getName();
	for (uint i = 0; i < blobList.length; ++i)
	{
		if (blobList[i] == name)
			return true;
	}
	return false;
}

bool undeadbunnyCanHitMap( CBlob@ this, CMap@ map, Tile tile )
{
	string name = this.getName();
	if ( name == "" && ( map.isTileGroundStuff( tile.type ) || map.isTileGrass( tile.type) ) )
		return false;
	else
		return true;
}

bool undeadbunnyCanHit( CBlob@ this, CBlob@ hitBlob )
{
	if ( hitBlob.getTeamNum() == this.getTeamNum() )
		return searchBlobList( hitBlob,  @undeadbunny_alwayshit );
	else
		return !searchBlobList( hitBlob,  @undeadbunny_neverhit );
}
