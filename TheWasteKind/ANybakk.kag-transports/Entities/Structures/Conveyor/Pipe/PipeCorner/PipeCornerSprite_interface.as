/*
 * Pipe Funnel sprite interface.
 * 
 * Author: ANybakk
 */

#include "ConveyorSprite.as";
#include "PipeCornerSprite.as";
#include "PipeCornerVariables.as";



void onInit(CSprite@ this) {

  ANybakk::PipeCornerSprite::onInit(this);
  
}

void onTick(CSprite@ this) {

  ANybakk::PipeCornerSprite::onTick(this);
  
}

void onRender(CSprite@ this) {

  ANybakk::ConveyorSprite::onRender(this);
  
}