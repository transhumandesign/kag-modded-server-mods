/*
 * Pipe Funnel blob interface.
 * 
 * Author: ANybakk
 */

#include "StructureBlob.as";
#include "PipeFunnelBlob.as";
#include "PipeFunnelVariables.as";



void onInit(CBlob@ this) {
  
  ANybakk::PipeFunnelBlob::onInit(this);
  
}

void onTick(CBlob@ this) {
  
  ANybakk::PipeFunnelBlob::onTick(this);
  
}

void onSetStatic(CBlob@ this, const bool isStatic) {

	ANybakk::PipeFunnelBlob::onSetStatic(this, isStatic);
  
}

bool canBePickedUp(CBlob@ this, CBlob@ byBlob) {

  return ANybakk::StructureBlob::canBePickedUp(this, byBlob);
  
}

bool doesCollideWithBlob(CBlob@ this, CBlob@ other) {
  
  return ANybakk::PipeFunnelBlob::doesCollideWithBlob(this, other);
  
}

void onCollision(CBlob@ this, CBlob@ otherBlob, bool solid, Vec2f normal, Vec2f point1) {
  
  ANybakk::PipeFunnelBlob::onCollision(this, otherBlob, solid, normal, point1);
  
}