/* ExoSuits.as
 * author: Aphelion
 */

#include "RunnerCommon.as";

shared class ExoSuit
{

	string name;
	u32 flag;

	string default_primary;
	string default_sidearm;

	Vec2f gun_offset;
	f32 movement_factor;
	u8 shield;
	u8 armour;
	u8 energy;

	u8 shield_regen;
	u8 armour_regen;
	u8 energy_regen;

	ExoSuit( string _name, u32 _flag, string _default_primary, string _default_sidearm, Vec2f _gun_offset, f32 _movement_factor, u8 _shield, u8 _armour, u8 _energy, u8 _shield_regen, u8 _armour_regen, u8 _energy_regen )
	{
		name = _name;
		flag = _flag;

		default_primary = _default_primary;
		default_sidearm = _default_sidearm;

		gun_offset = _gun_offset;
		movement_factor = _movement_factor;
		shield = _shield;
		armour = _armour;
		energy = _energy;

		shield_regen = _shield_regen;
		armour_regen = _armour_regen;
		energy_regen = _energy_regen;
	}

}

namespace ExoSuits
{
	const u32 All = 0x0;
	const u32 Logistics = 0x1;
	const u32 Assault = 0x2;
	const u32 Infiltrator = 0x4;
	const u32 Sentinel = 0x8;

	ExoSuit[] suits =
	{
		ExoSuit("logistics", ExoSuits::Logistics, "gauss_rifle", "omni_tool", Vec2f(-2.0f, 7.0f), 0.95f, 35, 40, 10, 5, 1, 1),
		ExoSuit("infiltrator", ExoSuits::Infiltrator, "sniper_rifle", "ion_pistol", Vec2f(-2.0f, 7.0f), 1.1f, 40, 25, 10, 5, 0, 1),
		ExoSuit("sentinel", ExoSuits::Sentinel, "lmg", "ion_pistol", Vec2f(-2.0f, 8.0f), 0.85f, 15, 100, 10, 5, 0, 1),
		ExoSuit("assault", ExoSuits::Assault, "gauss_carbine", "ion_pistol", Vec2f(-2.0f, 7.0f), 1.0f, 25, 60, 10, 5, 1, 1),
	};
}
