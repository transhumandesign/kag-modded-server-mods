// default startup functions for autostart scripts

void RunServer()
{
	
	if (getNet().CreateServer())
	{
		
		LoadRules("grobmode.cfg");
		
		
		//getRules().set_bool("it_is_localhost_my_dudes_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa", true);
		//print("check: "+getRules().get_bool("it_is_localhost_my_dudes_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"));

		if (sv_mapcycle.size() > 0)
		{
			LoadMapCycle(sv_mapcycle);
		}
		else
		{
			LoadMapCycle("grobcycle.cfg");
		}

		LoadNextMap();
	}
}

void ConnectLocalhost()
{
	
	getNet().Connect("localhost", sv_port);
}

void RunLocalhost()
{
	
	RunServer();
	ConnectLocalhost();
}

void LoadDefaultMenuMusic()
{
	
	if (s_menumusic)
	{
		CMixer@ mixer = getMixer();
		if (mixer !is null)
		{
			mixer.ResetMixer();
			mixer.AddTrack("Sounds/Music/world_intro.ogg", 0);
			mixer.PlayRandom(0);
		}
	}
}
