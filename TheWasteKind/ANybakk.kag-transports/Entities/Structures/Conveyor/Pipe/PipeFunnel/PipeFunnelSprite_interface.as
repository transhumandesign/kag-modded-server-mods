/*
 * Pipe Funnel sprite interface.
 * 
 * Author: ANybakk
 */

#include "ConveyorSprite.as";
#include "PipeFunnelSprite.as";
#include "PipeFunnelVariables.as";



void onInit(CSprite@ this) {

  ANybakk::PipeFunnelSprite::onInit(this);
  
}

void onTick(CSprite@ this) {

  ANybakk::PipeFunnelSprite::onTick(this);
  
}

void onRender(CSprite@ this) {

  ANybakk::ConveyorSprite::onRender(this);
  
}