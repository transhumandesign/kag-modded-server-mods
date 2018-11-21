/* CustomParticles.as
 * author: Aphelion
 */

#include "TeamColour.as";

Random particle_random(0x1337);

void MakeJetpackParticle( CBlob@ this, Vec2f vel )
{
	Vec2f rpos = Vec2f(particle_random.NextFloat() * -8 + 8, particle_random.NextFloat() * -8 + 8);

	CParticle@ p = ParticleAnimated(  this.getTeamNum() == 1 ? "JetpackRed.png" :
		                                                       "JetpackBlue.png",
									  this.getPosition() + Vec2f(-4, -8) + rpos, (vel + Vec2f(0, -1)) * (-0.8f + particle_random.NextFloat() * -0.3f),
									  particle_random.NextFloat() * 360.0f, //angle
									  0.4f + particle_random.NextFloat() * 0.4f, //scale
									  4 + particle_random.NextRanged(3), //animtime
									  0.05f, //gravity 0.1f
									  true ); //selflit
	if(p !is null)
	   p.Z = -10.0f;
}

void MakeHealingParticle( CBlob@ this, Vec2f vel )
{
	Vec2f rpos = Vec2f(particle_random.NextFloat() * -8 + 8, particle_random.NextFloat() * -8 + 4);

	CParticle@ p = ParticleAnimated( "Healing.png",
									  this.getPosition() + Vec2f(-4, -8) + rpos, (vel + Vec2f(0, -1)) * (-0.5f + particle_random.NextFloat() * -0.3f),
									  particle_random.NextFloat() * 360.0f, //angle
									  0.5f + particle_random.NextFloat() * 0.5f, //scale
									  5 + particle_random.NextRanged(8), //animtime
									  0.0f, //gravity
									  true ); //selflit
	if(p !is null)
	   p.Z = 10.0f;
}

void team_sparks(u8 team, Vec2f at, f32 angle, f32 damage)
{
	int amount = damage * 2.5f + XORRandom(5);

	for (int i = 0; i < amount; i++)
	{
		Vec2f vel = getRandomVelocity(angle, damage * 1.5f, 180.0f);
		vel.y = -Maths::Abs(vel.y) + Maths::Abs(vel.x) / 3.0f - 2.0f - float(XORRandom(100)) / 100.0f;
		ParticlePixel(at, vel, getTeamColor(team), true);
	}
}
