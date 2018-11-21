/* GasbagMovementInit.as
 * author: Aphelion3371 (edited by Frikman)
 */

#include "CreatureCommon.as"

void onInit( CMovement@ this )
{
    CreatureMoveVars moveVars;

    //flying vars
    moveVars.flySpeed = 2.2f;
    moveVars.flyFactor = 1.5f;
    
    //stopping forces
    moveVars.stoppingForce = 0.90f; //function of mass
    moveVars.stoppingForceAir = 0.70f; //function of mass
    moveVars.stoppingFactor = 1.2f;

	//
    this.getBlob().set( "moveVars", moveVars );
    this.getBlob().getShape().getVars().waterDragScale = 30.0f;
	this.getBlob().getShape().getConsts().collideWhenAttached = true;
}
