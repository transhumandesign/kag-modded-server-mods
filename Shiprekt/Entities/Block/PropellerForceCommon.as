//Common file for getting forces from a propeller

#include "IslandsCommon.as"
#include "BlockCommon.as"

const f32 PROPELLER_SPEED = 0.5f;

void PropellerForces(CBlob@ this,
					 Island@ island,
					 float power,
					 Vec2f &out moveVel,
					 Vec2f &out moveNorm,
					 float &out angleVel)
{
	Vec2f pos = this.getPosition();

	moveVel = Vec2f(0.0f, PROPELLER_SPEED*power);
	moveVel.RotateBy( this.getAngleDegrees() );
	moveNorm = moveVel;
	const f32 moveSpeed = moveNorm.Normalize();

	// calculate "proper" force

	Vec2f fromCenter = pos - island.pos;
	f32 fromCenterLen = fromCenter.Normalize();			
	f32 directionMag = Maths::Abs( fromCenter * moveNorm );
	f32 dist = 35.0f;
	f32 centerMag = (dist - Maths::Min( dist, fromCenterLen ))/dist;
	f32 velCoef = (directionMag + centerMag)*0.5f;

	moveVel *= velCoef;

	f32 turnDirection = Vec2f(moveNorm.y, -moveNorm.x) * fromCenter;
	f32 angleCoef = (1.0f - velCoef) * (1.0f - directionMag) * turnDirection;
	angleVel = angleCoef * moveSpeed;
}

//overload with fewer params
void PropellerForces(CBlob@ this, Island@ island, float power, Vec2f &out moveVel, float &out angleVel)
{
	Vec2f _a;
	PropellerForces(this, island, power, moveVel, _a, angleVel);
}