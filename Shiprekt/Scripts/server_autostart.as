void Configure()
{
    v_driver = 0;  // disable video
    s_soundon = 0; // disable audio
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
}
