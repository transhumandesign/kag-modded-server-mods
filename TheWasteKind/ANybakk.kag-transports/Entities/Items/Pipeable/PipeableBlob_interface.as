/*
 * Pipeable blob vanilla interface.
 * 
 * Author: ANybakk
 */

#include "PipeableVariables.as";
#include "PipeableBlob.as";



void onInit(CBlob@ this) {

  ANybakk::PipeableBlob::onInit(this);
  
}

void onTick(CBlob@ this) {

  ANybakk::PipeableBlob::onTick(this);
  
}

bool canBePickedUp(CBlob@ this, CBlob@ byBlob) {

  return ANybakk::PipeableBlob::canBePickedUp(this, byBlob);
  
}