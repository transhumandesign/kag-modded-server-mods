/* Icons.as
 * author: Aphelion
 */

#include "IconsCommon.as";

#define CLIENT_ONLY;

void onInit( CRules@ this )
{
    printf("--- Adding icon tokens ---");

    // -- BUILDING
    AddBuildingIcon("teleporter", 0);
	AddBuildingIcon("munitions", 1);

	// -- ITEM
	AddItemIcon("mat_grenades", 2);
	AddItemIcon("mat_empgrenades", 3);
	AddItemIcon("mat_contactgrenades", 4);
	AddItemIcon("mat_cells", 5);
	AddItemIcon("mat_swarms", 6);
	AddItemIcon("mat_missiles", 7);
	AddItemIcon("proximity_mine", 1);
	AddItemIcon("c4", 0);

    // -- SUIT
	AddClassIcon("assault", 0);
	AddClassIcon("logistics", 1);
	AddClassIcon("sentinel", 2);
	AddClassIcon("infiltrator", 3);

	// -- PRIMARY
	AddWeaponIcon("omni_tool", 12);
	
	AddWeaponIcon("gauss_rifle", 1);
	AddWeaponIcon("gauss_carbine", 7);
	AddWeaponIcon("pulse_rifle", 1);
	AddWeaponIcon("combat_rifle", 7);
	AddWeaponIcon("battle_rifle", 6);
	AddWeaponIcon("arc_laser", 1);

	AddWeaponIcon("sniper_rifle", 2);
	AddWeaponIcon("submachine_gun_2", 3);
	AddWeaponIcon("scout_rifle", 6);
	AddWeaponIcon("scrambler_rifle", 6);
	AddWeaponIcon("plasma_cannon", 5);

	AddWeaponIcon("lmg", 9);
	AddWeaponIcon("missile_launcher", 10);
	AddWeaponIcon("gatling_laser", 5);
	AddWeaponIcon("scatter_cannon", 8);

	AddWeaponIcon("submachine_gun", 3);
	AddWeaponIcon("scatter_rifle", 4);
	AddWeaponIcon("plasma_launcher", 8);
	AddWeaponIcon("swarm_launcher", 11);

	// -- SIDEARM
	AddWeaponIcon("ion_pistol", 0);
	AddWeaponIcon("bolt_pistol", 0);
	AddWeaponIcon("scrambler_pistol", 0);
	AddWeaponIcon("scatter_pistol", 0);
	AddWeaponIcon("plasma_pistol", 0);

    printf("--- Icon tokens added ---");
}