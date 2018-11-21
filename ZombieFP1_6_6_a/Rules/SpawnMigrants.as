#define SERVER_ONLY

const int min_migrant = 2;
const string migrant_name = "migrantbot";

void onTick(CRules@ this)
{
	if (getGameTime() %29 != 0) return;
	//if (XORRandom(512) < 256) return; //50% chance of actually doing anything

	CMap@ map = getMap();
	if (map is null || map.tilemapwidth < 2) return; //failed to load map?

	CBlob@[] migrant;
	getBlobsByName(migrant_name, @migrant);
	
	if (migrant.length < min_migrant && map.getDayTime()>0.4 && map.getDayTime()<0.6)
	{
		f32 x = XORRandom(2) == 0 ? 32.0f : map.tilemapwidth * map.tilesize - 32.0f;

		Vec2f top = Vec2f(x, map.tilesize);
		Vec2f bottom = Vec2f(x, map.tilemapheight * map.tilesize);
		Vec2f end;

		if (map.rayCastSolid(top, bottom, end))
		{
			f32 y = end.y;
			int i = 0;
			while (i ++ < 3)
			{
				Vec2f pos = Vec2f(x, y - i * map.tilesize);
				//if (!map.isInWater(pos))
				{
					server_CreateBlob("migrantbot", 0, pos);
					Sound::Play("MigrantSayHello.ogg", pos, 1.5f);
					break;
				}
			}
		}
	}
}
