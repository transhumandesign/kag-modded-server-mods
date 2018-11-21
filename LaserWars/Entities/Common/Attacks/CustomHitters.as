// CustomHitters.as

namespace Hitters
{
	shared enum custom_hitters
	{
		guns_start = 100,

		gun,
		plasma,
		swarm_missile,
		light_missile,
		heavy_missile,
		
		guns_end,

		emp,
		emp_force,
	};
};

bool isCustomExplosionHitter(u8 type)
{
	return type == Hitters::plasma ||
	       type == Hitters::swarm_missile ||
	       type == Hitters::light_missile ||
	       type == Hitters::heavy_missile;
}
