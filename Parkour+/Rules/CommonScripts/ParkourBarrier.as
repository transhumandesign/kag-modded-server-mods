// red barrier before match starts

const f32 BARRIER_PERCENT = 0.175f;
//if the barrier has been set
bool barrier_set = false;
//
int barrier_wait = 30;
int barrier_timer = 0;

bool shouldBarrier(CRules@ this)
{
	return this.isIntermission() || this.isWarmup() || this.isBarrier();
}

void onTick(CRules@ this)
{
	if(!HandleSync(this)) return;

	if (shouldBarrier(this))
	{
		if (!barrier_set)
		{
			if (barrier_timer < barrier_wait)
			{
				barrier_timer++;
			}
			else
			{
				barrier_set = true;
				addBarrier();
			}
		}

		f32 x1, x2, y1, y2;
		getBarrierPositions(x1, x2, y1, y2);
		
		CBlob@[] players;
		getBlobsByTag("player", @players);
		for (int i = 0; i < players.length; i++)
		{
			CBlob@ b = players[i];
			if (b !is null)
			{
				b.setPosition(Vec2f(x1+8,y1+6));
				b.setVelocity(Vec2f_zero);							
			}
		}
	}
	else
	{
		if (barrier_set)
		{
			removeBarrier();
			barrier_set = false;
			barrier_timer = 0;
		}
	}
}

//if the barrier has been cached
bool done_sync = false;
bool HandleSync(CRules@ this)
{
	if(!done_sync)
	{
		if (isServer())
		{
			f32 x1, x2, y1, y2;
			getBarrierPositions(x1, x2, y1, y2);
			this.set_f32("barrier_x1", x1);
			this.Sync("barrier_x1", true);
			this.set_f32("barrier_x2", x2);
			this.Sync("barrier_x2", true);
			this.set_f32("barrier_y1", y1);
			this.Sync("barrier_y1", true);
			this.set_f32("barrier_y2", y2);
			this.Sync("barrier_y2", true);
			done_sync = true;
		}
		if(isClient())
		{
			if (this.get_f32("barrier_x1") != -1.0f)
			{
				done_sync = true;
			}
		}
	}
	return done_sync;
}

void onRestart(CRules@ this)
{
	barrier_set = false;
	barrier_timer = 0;

    if (isServer())
	{
	    //dummy these out
		this.set_f32("barrier_x1", -1.0f);
		this.set_f32("barrier_x2", -1.0f);
		this.set_f32("barrier_y1", -1.0f);
		this.set_f32("barrier_y2", -1.0f);
	}

	done_sync = false;
}

void onInit(CRules@ this)
{
	onRestart(this);
}

void onRender(CRules@ this)
{
	if (!done_sync) return;

	if (shouldBarrier(this))
	{
		f32 x1, x2, y1, y2;
		getBarrierPositions(x1, x2, y1, y2);
		float alpha = Maths::Clamp01(float(barrier_timer) / float(barrier_wait));
		GUI::DrawRectangle(
			getDriver().getScreenPosFromWorldPos(Vec2f(x1-4, y1-6)),
			getDriver().getScreenPosFromWorldPos(Vec2f(x2+4, y2+2)),
			SColor(int(100 * alpha), 235, 0, 0)
		);
	}
}

//extra area of no build around the barrier
//(unpopular)
const float noBuildExtra = 0.0f;

void getBarrierPositions(f32 &out x1, f32 &out x2, f32 &out y1, f32 &out y2)
{
	if (done_sync)
	{
		CRules@ rules = getRules();
		x1 = rules.get_f32("barrier_x1");
		x2 = rules.get_f32("barrier_x2");
		y1 = rules.get_f32("barrier_y1");
		y2 = rules.get_f32("barrier_y2");
		return;
	}

	CMap@ map = getMap();

	Vec2f barrierPosition;
	if (map.getMarker("blue main spawn", barrierPosition))
	{	
		x1 = barrierPosition.x+4 - map.tilesize;
		x2 = barrierPosition.x+4 + map.tilesize;

		y1 = barrierPosition.y+4 - map.tilesize;
		y2 = barrierPosition.y+4 + map.tilesize;
	}	
}

/**
 * Adding the barrier sector to the map
 */

void addBarrier()
{
	CMap@ map = getMap();

	f32 x1, x2, y1, y2;
	getBarrierPositions(x1, x2, y1, y2);

	Vec2f ul(x1, y1);
	Vec2f lr(x2, y2);

	if (map.getSectorAtPosition((ul + lr) * 0.5, "barrier") is null)
	{
		map.server_AddSector(Vec2f(x1, y1), Vec2f(x2, y2), "barrier");
	}
}

/**
 * Removing the barrier sector from the map
 */

void removeBarrier()
{
	CMap@ map = getMap();

	f32 x1, x2, y1, y2;
	getBarrierPositions(x1, x2, y1, y2);

	Vec2f mid( x1+8 , y1+8 );

	map.RemoveSectorsAtPosition(mid, "barrier");
}
