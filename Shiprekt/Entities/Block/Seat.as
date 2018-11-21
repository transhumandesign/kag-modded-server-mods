#include "IslandsCommon.as"
#include "BlockCommon.as"
#include "PropellerForceCommon.as"

void onInit( CBlob@ this )
{
	this.set_string("seat label", "Steering seat");
	this.set_u8("seat icon", 7);
	this.Tag("seat");
}

void onTick( CBlob@ this )
{	
	if (this.getShape().getVars().customData <= 0)
		return;	

	AttachmentPoint@ seat = this.getAttachmentPoint(0);
	CBlob@ occupier = seat.getOccupied();
	if (occupier !is null)
	{
		const f32 angle = this.getAngleDegrees();
		
		if (getNet().isServer())
		{
			const bool up = occupier.isKeyPressed( key_up );
			const bool left = occupier.isKeyPressed( key_left );
			const bool right = occupier.isKeyPressed( key_right );
			const bool down = occupier.isKeyPressed( key_down );
			const bool space = occupier.isKeyPressed( key_action3 );

			occupier.setAngleDegrees( angle );

			// gather propellers
			CBlob@[] left_propellers;
			CBlob@[] right_propellers;
			CBlob@[] up_propellers;
			CBlob@[] down_propellers;
			CBlob@[] couplings;

			Island@ island = getIsland(this.getShape().getVars().customData);
			if (island !is null)
			{
				for (uint b_iter = 0; b_iter < island.blocks.length; ++b_iter)
				{
					IslandBlock@ isle_block = island.blocks[b_iter];
					if(isle_block is null) continue;

					CBlob@ block = getBlobByNetworkID( isle_block.blobID );
					if(block is null) continue;

					if (block.hasTag("propeller"))
					{
						Vec2f _veltemp, velNorm;
						float angleVel;
						PropellerForces(block, island, 1.0f, _veltemp, velNorm, angleVel);

						velNorm.RotateBy(-angle);
						
						const float angleLimit = 0.05f;
						const float forceLimit = 0.01f;
						const float forceLimit_side = 0.2f;

						if (angleVel < -angleLimit ||
							(velNorm.y < -forceLimit_side && angleVel < angleLimit) )
						{
							right_propellers.push_back(block);
						}
						else if (angleVel > angleLimit ||
							(velNorm.y > forceLimit_side && angleVel > -angleLimit) )
						{
							left_propellers.push_back(block);
						}

						if (velNorm.x > forceLimit)
						{
							down_propellers.push_back(block);
						}
						else if (velNorm.x < -forceLimit)
						{
							up_propellers.push_back(block);
						}

						block.set_f32("power", 0);					
					}
					if(block.hasTag("coupling") && !block.hasTag("_coupling_hitspace"))
					{
						couplings.push_back(block);
					}
				}

				const f32 power = -1;

				if (left){
					for (uint i = 0; i < left_propellers.length; ++i){
						left_propellers[i].set_f32("power", power);
					}				
				}
				if (right){
					for (uint i = 0; i < right_propellers.length; ++i){
						right_propellers[i].set_f32("power", power);
					}	
				}
				if (up){
					for (uint i = 0; i < up_propellers.length; ++i){
						up_propellers[i].set_f32("power", power);
					}					
				}
				if (down){
					for (uint i = 0; i < down_propellers.length; ++i){
						down_propellers[i].set_f32("power", power);
					}	
				}	
				//release couplings

				if(space)
				{
					for (uint i = 0; i < couplings.length; ++i){
						couplings[i].Tag("_coupling_hitspace");
						couplings[i].SendCommand(couplings[i].getCommandID("decouple"));
					}
				}
			}
		}
	}
}


