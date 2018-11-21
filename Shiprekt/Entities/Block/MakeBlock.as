#include "BlockCommon.as"

CBlob@ makeBlock( Vec2f pos, Block::Type blockType, const int team = -1 )
{
	CBlob @block = server_CreateBlob( "block", team, pos );
	if (block !is null) {
		block.getSprite().SetFrame( blockType );
		block.SetMinimapVars("GUI/block_minimap.png", Block::minimapframe(Block::Type(blockType)), Vec2f(3,3));
	}	
	return block;
}
