// default startup functions for autostart scripts

#include "Default/DefaultGUI.as"
#include "Default/DefaultLoaders.as"

void RunServer()
{
    if (getNet().CreateServer())
    {
		if(LoadMapCycle( "../Mods/" + sv_gamemode + "/Rules/gamemode.cfg" )){
			LoadRules( "../Mods/" + sv_gamemode + "/Rules/gamemode.cfg" );
		} else {
			LoadRules(  "Rules/" + sv_gamemode + "/gamemode.cfg" );	
		}

        if (sv_mapcycle.size() > 0) {
            LoadMapCycle( sv_mapcycle );
        } else {
            if(!LoadMapCycle( "../Mods/" + sv_gamemode + "/Rules/mapcycle.cfg" ))
				LoadMapCycle( "Rules/" + sv_gamemode + "/mapcycle.cfg" );
        }
		LoadDefaultMapLoaders();
        LoadNextMap();
    }
}

void ConnectLocalhost()
{
    getNet().Connect( "localhost", sv_port );
}

void RunLocalhost()
{
    RunServer();
    ConnectLocalhost();
}

void LoadDefaultMenuMusic()
{
	CMixer@ mixer = getMixer();	 
	if (mixer !is null) 
	{
		mixer.ResetMixer();
		mixer.AddTrack( "Sounds/Music/KAGWorldIntroA.ogg", 0 );
		mixer.FadeInRandom(0, 0.1f );
	}
}
