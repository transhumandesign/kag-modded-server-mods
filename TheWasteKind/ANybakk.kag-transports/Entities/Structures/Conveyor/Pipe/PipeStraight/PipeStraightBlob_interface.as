/*
 * Pipe Straight blob interface.
 * 
 * Author: ANybakk
 */

#include "StructureBlob.as";
#include "PipeBlob.as";
#include "PipeStraightBlob.as";
#include "PipeStraightVariables.as";



void onInit(CBlob@ this) {
  
  ANybakk::PipeStraightBlob::onInit(this);
  
}

void onTick(CBlob@ this) {
  
  ANybakk::PipeStraightBlob::onTick(this);
  
}

void onSetStatic(CBlob@ this, const bool isStatic) {

	ANybakk::PipeStraightBlob::onSetStatic(this, isStatic);
  
}

bool canBePickedUp(CBlob@ this, CBlob@ byBlob) {

  return ANybakk::StructureBlob::canBePickedUp(this, byBlob);
  
}

bool doesCollideWithBlob(CBlob@ this, CBlob@ other) {
  
  return ANybakk::PipeBlob::doesCollideWithBlob(this, other);
  
}