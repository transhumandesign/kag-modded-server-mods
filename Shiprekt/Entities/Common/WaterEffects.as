Random _waterparticlerandom(0x1a73a);

CParticle@ MakeWaterParticle(Vec2f pos, Vec2f vel)
{
	CParticle@ p = ParticleAnimated( "Sprites/water_splash.png",
											  pos, vel,
											  _waterparticlerandom.NextFloat() * 360.0f, //angle
											  0.5f+_waterparticlerandom.NextFloat() * 0.5f, //scale
											  5, //animtime
											  0.0f, //gravity
											  true ); //selflit
	if(p !is null)
		p.Z = -10.0f;

	return p;
}

CParticle@ MakeWaterWave(Vec2f pos, Vec2f vel, float angle)
{
	CParticle@ p = ParticleAnimated( "Sprites/water_wave.png",
											  pos, vel,
											  angle, //angle
											  0.8f+_waterparticlerandom.NextFloat() * 0.4f, //scale
											  7, //animtime
											  0.0f, //gravity
											  true ); //selflit
	if(p !is null){
		p.Z = -20.0f;
	}

	return p;
}