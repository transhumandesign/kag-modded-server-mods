//cloud.as

#include "ParticleConstants.as"

float rand_float()
{
	float value = float(XORRandom(RAND_MAX))/float(RAND_MAX);
	return value;
}