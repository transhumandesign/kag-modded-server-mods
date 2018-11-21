#include "TetraBlocks.as"

Random _rb;
int randomBlock = 1;

void onInit( CRules@ this )
{
	this.addCommandID("take blocks");
	onRestart( this );
}

void onRestart( CRules@ this )
{
	ConfigFile cfg;
	if (cfg.loadFile( "TDMVars.cfg" )) 
	{
		 this.set_u8( "blocks count", cfg.read_u8("blocks_count"));
	}
	Reseed();
	if (getMap() !is null){
		_rb.Reset(XORRandom(9999999));
	}	
}

void ProduceBlock( CRules@ this, CBlob@ blob )
{
	const int blobTeam = blob.getTeamNum();
	//blob.getSprite().PlaySound( "select.ogg" );

	if (getNet().isServer())
	{
		int blockCount = this.get_u8( "blocks count");
		if (blockCount == 10){
			blockCount = 1 + _rb.NextRanged(4);
		}
		else if (blockCount == 11){
			if (randomBlock == 1)
				randomBlock = 2 + _rb.NextRanged(3);
			blockCount = randomBlock;
		}

		CBlob@[] blocks;
		MakeRandomBlocks( blockCount, Vec2f_zero, @blocks, blobTeam );

    	CBlob@[]@ blob_blocks;
	    blob.get( "blocks", @blob_blocks );
    	blob_blocks.clear();
    	for (uint i = 0; i < blocks.length; i++){
    		CBlob@ b = blocks[i];
        	blob_blocks.push_back( b );	        
        	b.set_u16( "ownerID", blob.getNetworkID() );
    		b.getShape().getVars().customData = -1; // don't push on island
    	}
	}    	
}


void onCommand( CRules@ this, u8 cmd, CBitStream @params )
{
    if (cmd == this.getCommandID("take blocks"))
    {
		CBlob@ caller = getBlobByNetworkID( params.read_netid() );
		if (caller !is null)
		{
			ProduceBlock( this, caller );
		}
    }
}
