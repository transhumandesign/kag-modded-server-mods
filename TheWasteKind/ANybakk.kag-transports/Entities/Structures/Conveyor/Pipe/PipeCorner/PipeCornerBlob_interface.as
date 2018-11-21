/*
 * Pipe Funnel blob interface.
 * 
 * Author: ANybakk
 */

#include "StructureBlob.as";
#include "PipeCornerBlob.as";
#include "PipeCornerVariables.as";



void onInit(CBlob@ this) {
  
  ANybakk::PipeCornerBlob::onInit(this);
  
}

void onTick(CBlob@ this) {
  
  ANybakk::PipeCornerBlob::onTick(this);
  
}

void onSetStatic(CBlob@ this, const bool isStatic) {

	ANybakk::PipeCornerBlob::onSetStatic(this, isStatic);
  
}

bool canBePickedUp(CBlob@ this, CBlob@ byBlob) {

  return ANybakk::StructureBlob::canBePickedUp(this, byBlob);
  
}

bool doesCollideWithBlob(CBlob@ this, CBlob@ other) {
  
  return ANybakk::PipeCornerBlob::doesCollideWithBlob(this, other);
  
}