// Aphelion (edited by Frikman)\\

#include "CreatureCommon.as"

void onInit( CMovement@ this )
{
    CreatureMoveVars moveVars;

    //walking vars
    moveVars.walkSpeed = 1.0f;
    moveVars.walkFactor = 1.0f;
    moveVars.walkLadderSpeed.Set( 0.15f, 0.6f );

    //climbing vars
    moveVars.climbingEnabled = false;

    //jumping vars
    moveVars.jumpMaxVel = 2.9f;
    moveVars.jumpStart = 1.0f;
    moveVars.jumpMid = 0.55f;
    moveVars.jumpEnd = 0.4f;
    moveVars.jumpFactor = 1.0f;
    moveVars.jumpCount = 0;
    
    //stopping forces
    moveVars.stoppingForce = 0.80f; //function of mass
    moveVars.stoppingForceAir = 0.60f; //function of mass
    moveVars.stoppingFactor = 1.0f;

	//
    this.getBlob().set( "moveVars", moveVars );
    this.getBlob().getShape().getVars().waterDragScale = 30.0f;
	this.getBlob().getShape().getConsts().collideWhenAttached = true;
}
