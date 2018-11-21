/* Utils.as
 * author: Aphelion
 */

f32 getRatio( f32 val1, f32 val2 )
{
	return val1 / Maths::Max(val2, 1.0f);
}

f32 getPercentage( f32 stat, f32 stat_base, f32 mult = 1.0f )
{
	if (stat > 0 && stat_base > 0)
		return (stat / stat_base) * mult;
	else
	    return 0;
}

int NextInt( Random@ random, int min, int max )
{
    if (min == max)
	    return 0;
	else
        return random.NextRanged(max - min) + min;
}

float NextFloat( Random@ random, float min, float max )
{
    return min + (random.NextFloat() * (max - min));
}