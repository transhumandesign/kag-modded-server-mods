#define CLIENT_ONLY

#include "WaterEffects.as"

Random _r(157681529);
Vec2f wind_direction;

void onTick( CRules@ this )
{
	if(getGameTime() % 3 == 0)
	{
		//randomly permute the wind direction
		wind_direction.RotateBy( (_r.NextFloat() - 0.5f) * 3.0f, Vec2f());

		CCamera@ camera = getCamera();
		Driver@ d = getDriver();
		if(camera is null || d is null) return;

		Vec2f wavepos = camera.getPosition() + Vec2f( -d.getScreenWidth()/2 + _r.NextRanged(d.getScreenWidth()), -d.getScreenHeight()/2 + _r.NextRanged(d.getScreenHeight()) );
		MakeWaterWave(wavepos, wind_direction, wind_direction.Angle() );
	}
}
