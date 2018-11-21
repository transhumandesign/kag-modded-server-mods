void Configure()
{
    s_soundon = 1; // sound on
    v_driver = 5;  // default video driver
    sv_gamemode = "TDM";
    AddMod("Shiprekt");
}

void InitializeGame()
{
    RegisterFileExtensionScript( "WaterPNGMap.as", "png" );

	if (getNet().CreateServer())
	{
	    LoadRules(  "Rules/TDM/gamemode.cfg" );
	    LoadMapCycle( "Rules/TDM/mapcycle.cfg" );
	    LoadNextMap();
	}

 	getNet().Connect( "localhost", sv_port );
}
