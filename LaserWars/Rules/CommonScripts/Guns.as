/* Guns.as
 * author: Aphelion
 */

#include "GunsCommon.as";

void onInit( CRules@ this )
{
	GunInfo[] guns;
	AddGunInfos(guns);
	
	this.set(gun_infos_property, guns);
}
