
void LoadDefaultMapLoaders()
{
	printf("############ GAMEMODE " + sv_gamemode );
	RegisterFileExtensionScript( "Scripts/MapLoaders/LoadPNGMap.as", "png" );
	RegisterFileExtensionScript( "../Mods/" + sv_gamemode + "/Scripts/MapLoaders/GenerateFromKAGGen.as", "cfg" );
}
