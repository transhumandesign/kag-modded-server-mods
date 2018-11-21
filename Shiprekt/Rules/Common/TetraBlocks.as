#include "MakeBlock.as"

Block::Type[] pool =		{ Block::PLATFORM,
							  Block::PLATFORM2, 
							  Block::SOLID,
							  Block::BOMB,
							  Block::SEAT,
							  Block::PROPELLER,
							  Block::TURRET,
							  Block::COUPLING };

f32[] weights = 			{ 2.2f,
							  0.7f, 
							  1.2f,
							  0.2f,
							  0.15f,
							  0.5f,
							  0.1f,
							  0.2f };

Random@[] _r;
void Reseed()
{
	CMap@ map = getMap();
	if(map is null)
	{
		warn("MAP IS MISSING: ONRESTART TETRABLOCKS.AS");
		return;
	}

	u32 rseed = XORRandom(9999999); // map.getMapSeed() - doesn't work properly :(

	_r.clear();
	for (uint i = 0; i < getRules().getTeamsCount(); i++){
		_r.push_back(Random(rseed));
	}
}

void MakeMultiBlock( Block::Type[]@ types, Vec2f[]@ offsets, Vec2f pos, CBlob@[]@ list, const uint count, const uint team )
{
	for (uint i = 0; i < count; i++)
		MakeBlock( types[i], offsets[i], pos, list, team );
}

void MakeBlock( Block::Type type, Vec2f offset, Vec2f pos, CBlob@[]@ list, const uint team )
{
	CBlob@ b = makeBlock( pos + offset*Block::size, type, team );
	list.push_back(b);
	b.set_Vec2f("offset", b.getPosition() );
	switch(type)		
	{
		case Block::PROPELLER:
		b.AddScript("Propeller.as");
		break;
		case Block::SEAT:
		b.AddScript("GetInSeat.as"); // so oninit doesnt override
		b.AddScript("Seat.as");
		break;
		case Block::BOMB:
		b.AddScript("Bomb.as");
		break;			
		case Block::TURRET:
		b.AddScript("GetInSeat.as");
		b.AddScript("Turret.as");
		break;
		case Block::COUPLING:
		b.AddScript("Coupling.as");
		break;
	}
}

void MakeRandomBlocks( const int blocksCount, Vec2f pos, CBlob@[]@ list, const uint team = -1 )
{
	Vec2f[] offsets;
	Block::Type[] types;
	getRandomBlockTypes( @types, team );
	getRandomBlockShape( @offsets, blocksCount, team );
	if (blocksCount > 1 && blocksCount <= 4){		
		MakeMultiBlock( @types, @offsets, pos, list, blocksCount, team );
	}
	else {
		MakeBlock( types[0], Vec2f_zero, pos, list, team );
	}
}

void getRandomBlockTypes( Block::Type[]@ types, int team )
{
	//load weights from config
	ConfigFile cfg;
	if (cfg.loadFile( "TDMVars.cfg" )) 
	{
		f32[] weights;
		weights.push_back(cfg.read_f32("platform1_weight", 1.0f));
		weights.push_back(cfg.read_f32("platform2_weight", 1.0f));
		weights.push_back(cfg.read_f32("solid_weight", 1.0f));
		weights.push_back(cfg.read_f32("bomb_weight", 1.0f));
		weights.push_back(cfg.read_f32("seat_weight", 1.0f));
		weights.push_back(cfg.read_f32("propeller_weight", 1.0f));
		weights.push_back(cfg.read_f32("turret_weight", 1.0f));
		weights.push_back(cfg.read_f32("coupling_weight", 1.0f));
		
		Block::Type[] weighted_pool;
		const uint count = pool.length;
		for (uint weights_iter = 0; weights_iter < count; weights_iter++)
		{
			uint amount = Maths::Ceil( weights[weights_iter] * float(count) );
			while (amount > 0)
			{
				weighted_pool.push_back( pool[weights_iter] );
				amount--;
			}
		}

		if (_r.length == 0){
			Reseed();
		}

		for (uint i = 0; i < 4; i++)
		{
			types.push_back( weighted_pool[ _r[team].NextRanged(weighted_pool.length) ] );
		}
	}
}

void getRandomBlockShape( Vec2f[]@ offsets, const int blocksCount, int team )
{
	if (blocksCount == 4)
	{
		const uint shape = _r[team].NextRanged(7);
		switch (shape)
		{
			case 0: // O
			offsets.push_back(Vec2f(0, 0));
			offsets.push_back(Vec2f(1, 0));
			offsets.push_back(Vec2f(1, 1));
			offsets.push_back(Vec2f(0, 1));
			break;

			case 1: // I
			offsets.push_back(Vec2f(-1, 0));
			offsets.push_back(Vec2f(0, 0));
			offsets.push_back(Vec2f(1, 0));
			offsets.push_back(Vec2f(2, 0));
			break;

			case 2: // Z
			offsets.push_back(Vec2f(-1, 0));
			offsets.push_back(Vec2f(0, 0));
			offsets.push_back(Vec2f(0, 1));
			offsets.push_back(Vec2f(1, 1));
			break;

			case 3: // S
			offsets.push_back(Vec2f(0, 0));
			offsets.push_back(Vec2f(1, 0));
			offsets.push_back(Vec2f(-1, 1));
			offsets.push_back(Vec2f(0, 1));
			break;

			case 4: // L
			offsets.push_back(Vec2f(0, -1));
			offsets.push_back(Vec2f(0, 0));
			offsets.push_back(Vec2f(0, 1));
			offsets.push_back(Vec2f(1, 1));
			break;

			case 5: // J
			offsets.push_back(Vec2f(1, -1));
			offsets.push_back(Vec2f(1, 0));
			offsets.push_back(Vec2f(1, 1));
			offsets.push_back(Vec2f(0, 1));
			break;

			case 6: // T
			offsets.push_back(Vec2f(-1, 0));
			offsets.push_back(Vec2f(0, 0));
			offsets.push_back(Vec2f(1, 0));
			offsets.push_back(Vec2f(0, 1));
			break;
		}
	}
	else if (blocksCount == 2)
	{
		offsets.push_back(Vec2f(0, 0));
		offsets.push_back(Vec2f(1, 0));
	}
	else if (blocksCount == 3)
	{
		const uint shape = _r[team].NextRanged(3);
		switch (shape)
		{
			case 0: // O
			offsets.push_back(Vec2f(0, 0));
			offsets.push_back(Vec2f(1, 0));
			offsets.push_back(Vec2f(1, 1));
			break;

			case 1: // I
			offsets.push_back(Vec2f(-1, 0));
			offsets.push_back(Vec2f(0, 0));
			offsets.push_back(Vec2f(1, 0));
			break;

			case 2: // Z
			offsets.push_back(Vec2f(-1, 0));
			offsets.push_back(Vec2f(0, 0));
			offsets.push_back(Vec2f(0, 1));
			break;

			case 3: // S
			offsets.push_back(Vec2f(0, 0));
			offsets.push_back(Vec2f(1, 0));
			offsets.push_back(Vec2f(-1, 1));
			break;

			case 4: // L
			offsets.push_back(Vec2f(-1, 0));
			offsets.push_back(Vec2f(0, 0));
			offsets.push_back(Vec2f(1, 0));
			break;

			case 5: // J
			offsets.push_back(Vec2f(-1, 0));
			offsets.push_back(Vec2f(0, 0));
			offsets.push_back(Vec2f(1, 0));
			break;

			case 6: // T
			offsets.push_back(Vec2f(-1, 0));
			offsets.push_back(Vec2f(0, 0));
			offsets.push_back(Vec2f(1, 0));
			break;
		}
	}	

	// todo: add obligatory tetris trolling code
}