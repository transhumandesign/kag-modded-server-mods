/*
 * Belt Conveyor blob interface.
 * 
 * Author: ANybakk
 */

#include "ConveyorBlob.as";
#include "BeltConveyorBlob.as";
#include "BeltConveyorVariables.as";



void onInit(CBlob@ this) {
  
  ANybakk::BeltConveyorBlob::onInit(this);
  
}

void onTick(CBlob@ this) {
  
  ANybakk::BeltConveyorBlob::onTick(this);
  
}

void onSetStatic(CBlob@ this, const bool isStatic) {

	ANybakk::BeltConveyorBlob::onSetStatic(this, isStatic);
  
}

bool canBePickedUp(CBlob@ this, CBlob@ byBlob) {

  return ANybakk::ConveyorBlob::canBePickedUp(this, byBlob);
  
}

bool doesCollideWithBlob(CBlob@ this, CBlob@ other) {
  
  return ANybakk::ConveyorBlob::doesCollideWithBlob(this, other);
  
}

void onCollision(CBlob@ this, CBlob@ other, bool solid, Vec2f normal, Vec2f point1) {

  ANybakk::BeltConveyorBlob::onCollision(this, other, solid, normal, point1);
  
}

void onEndCollision(CBlob@ this, CBlob@ blob) {

  ANybakk::BeltConveyorBlob::onEndCollision(this, blob);
  
}

void onDie(CBlob@ this) {

  ANybakk::BeltConveyorBlob::onDie(this);
  
}