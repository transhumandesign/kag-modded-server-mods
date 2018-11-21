void makeSmallExplosionParticle(Vec2f pos)
{
    ParticleAnimated( "Entities/Effects/Sprites/SmallExplosion"+(XORRandom(3)+1)+".png",
                      pos, Vec2f(0,0.5f), 0.0f, 1.0f,
                      3+XORRandom(3),
                      0.0f, true );
}

void makeLargeExplosionParticle(Vec2f pos)
{
	ParticleAnimated( "Entities/Effects/Sprites/Explosion.png",
						pos, Vec2f(0,0.5f), 0.0f, 1.0f,
						3+XORRandom(3),
						0.0f, true );
}