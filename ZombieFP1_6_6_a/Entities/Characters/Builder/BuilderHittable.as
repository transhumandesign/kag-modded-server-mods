
//names of stuff which should be able to be hit by
//team builders, drills etc

const string[] builder_alwayshit =
{
	//handmade
	"workbench",
	//"fireplace",
	"ladder",

	//faketiles
	"spikes",
	"trap_block",
	"trap_bridge",
	"team_bridge",
	"fire_trap_block",
	"triangle",
	"torch",
	"woodenspikes",

	//buildings
	"factory",
	"tunnel",
	"building",
	"quarters",
	"storage",
	"dorm",
	"minibuildershop",
	"miniwshop",
	"miniarchershop",
	"miniknightshop",
	"minidorm",
	"minitradershop",
	"minitunnel",
	"minifarm",
	"minivehicleshop",
	"minieshop",
	"undeadtradershop",
	"undeadbarracks",
	"undeadtunnel",
	
	//mechanisms
	"bolter",
	"dispenser",
	"lamp",
	"clamp",
	"obstructor",
	"spiker",
	"diode",
	"emitter",
	"inverter",
	"junction",
	"magazine",
	"oscillator",
	"randomizer",
	"receiver",
	"resistor",
	"toggle",
	"transistor",
	"wire",
	"tee",
	"elbow",
	"coin_slot",
	"lever",
	"pressure_plate",
	"push_button",
	"team_bridge",
	"tramp_bridge",
	"booster",
	"flamer",
	"sensor",
	"conveyor",
	"conveyortriangle",	
};

//fragments of names, for semi-tolerant matching
// (so we don't have to do heaps of comparisions
//  for all the shops)
const string[] builder_alwayshit_fragment =
{
	"shop",
	"door"
};

bool BuilderAlwaysHit(CBlob@ blob)
{
	if(blob.hasTag("builder always hit"))
	{
		return true;
	}

	string name = blob.getName();
	for(uint i = 0; i < builder_alwayshit.length; ++i)
	{
		if (builder_alwayshit[i] == name)
			return true;
	}
	for(uint i = 0; i < builder_alwayshit_fragment.length; ++i)
	{
		if(name.find(builder_alwayshit_fragment[i]) != -1)
			return true;
	}
	return false;
}

bool isUrgent( CBlob@ this, CBlob@ b )
{
			//enemy players
	return (b.getTeamNum() != this.getTeamNum() || b.hasTag("enemy") || b.hasTag("dead")) && b.hasTag("player") ||
			//trees
			b.getName().find("tree") != -1 || 
			//spikes
			b.getName() == "spikes";
}