// CommonBuilderBlocks.as

//////////////////////////////////////
// Builder menu documentation
//////////////////////////////////////

// To add a new page;

// 1) initialize a new BuildBlock array, 
// example:
// BuildBlock[] my_page;
// blocks.push_back(my_page);

// 2) 
// Add a new string to PAGE_NAME in 
// BuilderInventory.as
// this will be what you see in the caption
// box below the menu

// 3)
// Extend BuilderPageIcons.png with your new
// page icon, do note, frame index is the same
// as array index

// To add new blocks to a page, push_back
// in the desired order to the desired page
// example:
// BuildBlock b(0, "name", "icon", "description");
// blocks[3].push_back(b);

#include "BuildBlock.as";
#include "Requirements.as";

const string blocks_property = "blocks";
const string inventory_offset = "inventory offset";

void addCommonBuilderBlocks(BuildBlock[][]@ blocks, int team)
{
	CRules@ rules = getRules();
	const bool CTF = rules.gamemode_name == "CTF";
	const bool TTH = rules.gamemode_name == "TTH";
	const bool SBX = rules.gamemode_name == "Sandbox";

	BuildBlock[] page_0;
    blocks.push_back(page_0);

    if(team == 0)
    {

        {
	        BuildBlock b(CMap::tile_castle, "stone_block", "$stone_block$", "Stone Block\nBasic building block");
	        AddRequirement(b.reqs, "blob", "mat_stone", "Stone", 10);
	        blocks[0].push_back(b);
        }
        {
	        BuildBlock b(CMap::tile_castle_back, "back_stone_block", "$back_stone_block$", "Back Stone Wall\nExtra support");
	        AddRequirement(b.reqs, "blob", "mat_stone", "Stone", 2);
	        blocks[0].push_back(b);
        }
        {
	        BuildBlock b(0, "stone_door", "$stone_door$", "Stone Door\nPlace next to walls");
	        AddRequirement(b.reqs, "blob", "mat_stone", "Stone", 40);
	        blocks[0].push_back(b);
        }


    }

	{
		BuildBlock b(CMap::tile_wood, "wood_block", "$wood_block$", "Wood Block\nCheap block\nwatch out for fire!");
		AddRequirement(b.reqs, "blob", "mat_wood", "Wood", 10);
		blocks[0].push_back(b);
	}
	{
		BuildBlock b(CMap::tile_wood_back, "back_wood_block", "$back_wood_block$", "Back Wood Wall\nCheap extra support");
		AddRequirement(b.reqs, "blob", "mat_wood", "Wood", 2);
		blocks[0].push_back(b);
	}
	{
		BuildBlock b(0, "wooden_door", "$wooden_door$", "Wooden Door\nPlace next to walls");
		AddRequirement(b.reqs, "blob", "mat_wood", "Wood", 30);
		blocks[0].push_back(b);
	}

    if(team == 0)
    {
	    {
		    BuildBlock b(0, "trap_block", "$trap_block$", "Trap Block\nOnly enemies can pass");
		    AddRequirement(b.reqs, "blob", "mat_stone", "Stone", 20);
		    blocks[0].push_back(b);
	    }

    }

	{
		BuildBlock b(0, "ladder", "$ladder$", "Ladder\nAnyone can climb it");
		AddRequirement(b.reqs, "blob", "mat_wood", "Wood", 10);
		blocks[0].push_back(b);
	}

    if(team == 0)
    {

	    {
		    BuildBlock b(0, "wooden_platform", "$wooden_platform$", "Wooden Platform\nOne way platform");
		    AddRequirement(b.reqs, "blob", "mat_wood", "Wood", 15);
		    blocks[0].push_back(b);
	    }
	    {
		    BuildBlock b(0, "spikes", "$spikes$", "Spikes\nPlace on Stone Block\nfor Retracting Trap");
		    AddRequirement(b.reqs, "blob", "mat_stone", "Stone", 30);
		    blocks[0].push_back(b);
	    }

    }

	if(team == 0)
	{
		BuildBlock b(0, "building", "$building$", "Workshop\nStand in an open space\nand tap this button.");
		AddRequirement(b.reqs, "blob", "mat_wood", "Wood", 100);
		b.buildOnGround = true;
		b.size.Set(40, 24);
		blocks[0].push_back(b);
	}

	if(team == 0)
	{
		BuildBlock[] page_1;
		blocks.push_back(page_1);
		{
			BuildBlock b(0, "wire", "$wire$", "Wire");
			AddRequirement(b.reqs, "blob", "mat_wood", "Wood", 2);
			blocks[1].push_back(b);
		}
		{
			BuildBlock b(0, "junction", "$junction$", "Junction");
			AddRequirement(b.reqs, "blob", "mat_stone", "Stone", 2);
			blocks[1].push_back(b);
		}
		{
			BuildBlock b(0, "lever", "$lever$", "Lever");
			AddRequirement(b.reqs, "blob", "mat_wood", "Wood", 10);
			AddRequirement(b.reqs, "blob", "mat_stone", "Stone", 30);
			blocks[1].push_back(b);
		}
		{
			BuildBlock b(0, "oscillator", "$oscillator$", "Oscillator");
			AddRequirement(b.reqs, "blob", "mat_stone", "Stone", 30);
			blocks[1].push_back(b);
		}
		{
			BuildBlock b(0, "push_button", "$pushbutton$", "Button");
			AddRequirement(b.reqs, "blob", "mat_stone", "Stone", 20);
			blocks[1].push_back(b);
		}
		{
			BuildBlock b(0, "sensor", "$sensor$", "Motion Sensor");
			AddRequirement(b.reqs, "blob", "mat_stone", "Stone", 20);
			blocks[1].push_back(b);
		}
		{
			BuildBlock b(0, "pressure_plate", "$pressureplate$", "Pressure Plate");
			AddRequirement(b.reqs, "blob", "mat_wood", "Wood", 10);
			AddRequirement(b.reqs, "blob", "mat_stone", "Stone", 30);
			blocks[1].push_back(b);
		}
		{
            BuildBlock b(0, "flamer", "$flamer$", "Flamer");
			AddRequirement(b.reqs, "blob", "mat_wood", "Wood", 20);
			AddRequirement(b.reqs, "blob", "mat_stone", "Stone", 20);
            blocks[1].push_back(b);
		}
		{
            BuildBlock b(0, "splasher", "$splasher$", "Splasher");
			AddRequirement(b.reqs, "blob", "mat_wood", "Wood", 20);
			AddRequirement(b.reqs, "blob", "mat_stone", "Stone", 20);
            blocks[1].push_back(b);
		}
        {
            BuildBlock b(0, "booster", "$booster$", "Booster");
			AddRequirement(b.reqs, "blob", "mat_wood", "Wood", 10);
			AddRequirement(b.reqs, "blob", "mat_stone", "Stone", 20);
            blocks[1].push_back(b);

        }
		{
			BuildBlock b(0, "bolter", "$bolter$", "Bolter");
			AddRequirement(b.reqs, "blob", "mat_wood", "Wood", 25);
			AddRequirement(b.reqs, "blob", "mat_stone", "Stone", 40);
			blocks[1].push_back(b);
		}
		{
			BuildBlock b(0, "spiker", "$spiker$", "Spiker");
			AddRequirement(b.reqs, "blob", "mat_wood", "Wood", 10);
			AddRequirement(b.reqs, "blob", "mat_stone", "Stone", 20);
			blocks[1].push_back(b);
		}

	}
}
