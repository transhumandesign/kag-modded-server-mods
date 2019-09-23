#include "Default/DefaultGUI.as"
#include "Default/DefaultLoaders.as"

void onInit(CRules@ this)
{
	RegisterFileExtensionScript( "WaterPNGMap.as", "png" );
    particles_gravity.y = 0.0f; 
    sv_gravity = 0;    
    //sv_maxplayers = 8; //dont force this stuff (also cant be changed)
    v_camera_ints = false;
    sv_visiblity_scale = 2.0f;

	s_effects = false;
}