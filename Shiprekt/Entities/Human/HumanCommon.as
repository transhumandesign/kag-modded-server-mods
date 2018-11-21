namespace Human
{
	const float walkSpeed = 1.0f;
	const float swimSlow = 0.4f;
};

// helper functions

namespace Human
{
	bool isHoldingBlocks( CBlob@ this )
	{
	   	CBlob@[]@ blob_blocks;
	    this.get( "blocks", @blob_blocks );
	    return blob_blocks.length > 0;
	}
}