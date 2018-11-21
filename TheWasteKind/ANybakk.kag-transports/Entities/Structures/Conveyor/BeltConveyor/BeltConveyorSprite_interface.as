/*
 * Belt Conveyor sprite interface.
 * 
 * Author: ANybakk
 */

#include "ConveyorSprite.as";
#include "BeltConveyorSprite.as";
#include "BeltConveyorVariables.as";



void onInit(CSprite@ this) {

  ANybakk::BeltConveyorSprite::onInit(this);
  
}

void onTick(CSprite@ this) {

  ANybakk::BeltConveyorSprite::onTick(this);
  
}

void onRender(CSprite@ this) {

  ANybakk::ConveyorSprite::onRender(this);
  
}
