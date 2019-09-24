// Simple chat processing example.
// If the player sends a command, the server does what the command says.
// You can also modify the chat message before it is sent to clients by modifying text_out
// By the way, in case you couldn't tell, "mat" stands for "material(s)"

#include "MakeSeed.as";
#include "MakeCrate.as";
#include "MakeScroll.as";
#include "TreeDeeMap.as";

bool onServerProcessChat(CRules@ this, const string& in text_in, string& out text_out, CPlayer@ player)
{
	//--------MAKING CUSTOM COMMANDS-------//
	// Making commands is easy - Here's a template:
	//
	// if (text_in == "!YourCommand")
	// {
	//	// what the command actually does here
	// }
	//
	// Switch out the "!YourCommand" with
	// your command's name (i.e., !cool)
	//
	// Then decide what you want to have
	// the command do
	//
	// Here are a few bits of code you can put in there
	// to make your command do something:
	//
	// blob.server_Hit(blob, blob.getPosition(), Vec2f(0, 0), 10.0f, 0);
	// Deals 10 damage to the player that used that command (20 hearts)
	//
	// CBlob@ b = server_CreateBlob('mat_wood', -1, pos);
	// insert your blob/the thing you want to spawn at 'mat_wood'
	//
	// player.server_setCoins(player.getCoins() + 100);
	// Adds 100 coins to the player's coins
	//-----------------END-----------------//

	// cannot do commands while dead

	if (player is null)
		return true;

	CBlob@ blob = player.getBlob(); // now, when the code references "blob," it means the player who called the command

	if (blob is null)
	{
		return true;
	}

	Vec2f pos = blob.getPosition(); // grab player position (x, y)
	int team = blob.getTeamNum(); // grab player team number (for i.e. making all flags you spawn be your team's flags)

	// MODDERS --- WRITE ALL COMMANDS BELOW!!

	// commands that don't rely on sv_test being on (sv_test = 1)

	if (text_in == "!bot" && player.isMod()) // TODO: whoaaa check seclevs
	{
		CPlayer@ bot = AddBot("Henry"); //when there are multiple "Henry" bots, they'll be differentiated by a number (i.e. Henry2)
		return true;
	}
	/*else if (text_in == "!map" && player.isMod()) // regen map
	{
		ConfigFile cfg = ConfigFile(getMap().getMapName());
		string map_name = cfg.read_string("map_name", "error");
		string map_tile_sheet = cfg.read_string("map_tile_sheet", "error");
		string map_lightmap = cfg.read_string("map_lightmap", "error");
		string map_heightmap = cfg.read_string("map_heightmap", "error");
		string skybox_name = cfg.read_string("skybox_name", "error");
		ThreeDeeMap three_dee_map(map_name, map_tile_sheet, map_lightmap, map_heightmap, skybox_name);
		this.set("ThreeDeeMap", @three_dee_map);
		print("epic gay sex");
	}*/
	
	else if (text_in.substr(0, 1) == "!")
	{
		// check if we have tokens
		string[]@ tokens = text_in.split(" ");

		if (tokens.length > 1)
		{
			//(see above for crate parsing example)
			if (tokens[0] == "!crate")
			{
				int frame = tokens[1] == "catapult" ? 1 : 0;
				string description = tokens.length > 2 ? tokens[2] : tokens[1];
				server_MakeCrate(tokens[1], description, frame, -1, Vec2f(pos.x, pos.y));
			}
			// eg. !team 2
			else if (tokens[0] == "!team")
			{
				// Picks team color from the TeamPalette.png (0 is blue, 1 is red, and so forth - if it runs out of colors, it uses the grey "neutral" color)
				int team = parseInt(tokens[1]);
				blob.server_setTeamNum(team);
				// We should consider if this should change the player team as well, or not.
			}
			else if (tokens[0] == "!scroll")
			{
				string s = tokens[1];
				for (uint i = 2; i < tokens.length; i++)
				{
					s += " " + tokens[i];
				}
				server_MakePredefinedScroll(pos, s);
			}

			return true;
		}

		// otherwise, try to spawn an actor with this name !actor
		string name = text_in.substr(1, text_in.size());

		if (server_CreateBlob(name, team, pos) is null)
		{
			client_AddToChat("blob " + text_in + " not found", SColor(255, 255, 0, 0));
		}
	}

	return true;
}

bool onClientProcessChat(CRules@ this, const string& in text_in, string& out text_out, CPlayer@ player)
{
	if (text_in == "!map") // regen map
	{
		ConfigFile cfg = ConfigFile(getMap().getMapName());
		string map_name = cfg.read_string("map_name", "error");
		string map_tile_sheet = cfg.read_string("map_tile_sheet", "error");
		string map_lightmap = cfg.read_string("map_lightmap", "error");
		string map_heightmap = cfg.read_string("map_heightmap", "error");
		string map_fancy = cfg.read_string("map_fancy", "error");
		string skybox_name = cfg.read_string("skybox_name", "error");
		ThreeDeeMap three_dee_map(map_name, map_tile_sheet, map_lightmap, map_heightmap, map_fancy, skybox_name);
		this.set("ThreeDeeMap", @three_dee_map);
		print("epic gay sex");
	}

	return true;
}
