/* GunsCommon.as
 * author: Aphelion
 */

const string gun_infos_property = "gun infos";

enum AmmoType
{
	PRIMARY,
	SIDEARM,
	ITEM,
}

namespace FireModes
{

	FireMode@ FULL_AUTOMATIC = BasicFireMode("automatic", true);
	FireMode@ SEMI_AUTOMATIC = BasicFireMode("semi_automatic", false);
	FireMode@ CHARGE_TO_FIRE = ChargeToFire("charge_to_fire");
	FireMode@ SCRAMBLER_RIFLE = ScramblerRifle("scrambler_rifle");
	FireMode@ GATLING_LASER = GatlingLaser("gatling_laser");
	FireMode@ TEST_RIFLE = TestRifle("test_rifle");
	FireMode@ PULSE_RIFLE = BurstFire("", 2, 3);
	FireMode@ SCRAMBLER_PISTOL = BurstFire("", 3, 2);

}

class ScramblerRifle : FireMode
{
	u16 heat_per_shot = 6;
	u16 heat_cooldown = 10;
	u16 heat_max = 100;
	u16 heat = 0;

	ScramblerRifle( string _name )
	{
		name = _name;
	}

	bool Fire( CBlob@ this, GunInfo@ info, bool has_energy )
	{
        SetCursorFrame(Maths::Min(int(float(heat) / float(heat_max) * 9), 9));

		u16 timer = getTimer(this);

		if (timer > 0)
			SetTimer(this, timer - 1);
		
		if (getTimer(this) == 0)
		{
            if (this.isKeyJustPressed(key_action1) && heat < heat_max)
			{
	            heat += heat_per_shot;
				SetTimer(this, info.fireInfo.interval);
		        return true;
			}

			if (getGameTime() % 15 == 0)
			{
				heat = Maths::Max(heat - heat_cooldown, 0);
			}
			return false;
		}
		return false;
	}
}

class GatlingLaser : FireMode
{
	GatlingLaser( string _name )
	{
		name = _name;
	}

	u16 shots_fired = 0;

	bool Fire( CBlob@ this, GunInfo@ info, bool has_energy )
	{
		u16 timer = getTimer(this);

		if (timer > 0)
			SetTimer(this, timer - 1);
		
		if (!this.isKeyPressed(key_action1) || !has_energy)
		{
			Reset();
		}
		else if (getTimer(this) == 0)
		{
            shots_fired++;
            SetCursorFrame(Maths::Min(int(1 + float(shots_fired) / float(24) * 8), 9));

			SetTimer(this, Maths::Max(info.fireInfo.interval - Maths::Floor(shots_fired / 8), 2));
			return true;
		}
		return false;
	}

	void Reset()
	{
		shots_fired = 0;
		SetCursorFrame(0);
	}
}

class TestRifle : FireMode
{
	TestRifle( string _name )
	{
		name = _name;
	}

	u16 shots_fired = 0;

	bool Fire( CBlob@ this, GunInfo@ info, bool has_energy )
	{
		u16 timer = getTimer(this);

		if (timer > 0)
			SetTimer(this, timer - 1);
		
		if (!this.isKeyPressed(key_action1) || !has_energy)
		{
			shots_fired = 0;
			SetCursorFrame(0);
		}
		else if (getTimer(this) == 0)
		{
            shots_fired++;
            SetCursorFrame(Maths::Min(int(1 + float(shots_fired) / float(8) * 8), 9));

			SetTimer(this, Maths::Max(info.fireInfo.interval - Maths::Floor(shots_fired / 1.3f), 5));
			return true;
		}
		return false;
	}

	void Reset()
	{
		shots_fired = 0;
	}
}

class BurstFire : FireMode
{
	u8 shots_per_burst;
	u8 interval;

	u8 shots_fired = 0;
	bool bursting = false;

	BurstFire( string _name, u8 _shots_per_burst, u8 _interval )
	{
		name = _name;
		shots_per_burst = _shots_per_burst;
		interval = _interval;
	}

	bool Fire( CBlob@ this, GunInfo@ info, bool has_energy )
	{
		SetCursorFrame(0);

		u16 timer = getTimer(this);

		if (timer > 0)
			SetTimer(this, timer - 1);
		
		if (getTimer(this) == 0)
		{
			if (!bursting)
			{
				shots_fired = 0;
			}

			if (this.isKeyJustPressed(key_action1) || bursting)
			{
				shots_fired++;

				if (shots_fired < shots_per_burst)
				{
					SetTimer(this, interval);
				    bursting = true;
				}
				else
				{
					SetTimer(this, info.fireInfo.interval);
					bursting = false;
				}
				return true;
			}
		}
		return false;
	}

	void Reset()
	{
		shots_fired = 0;
		bursting = false;
	}
}

class ChargeToFire : FireMode
{
	ChargeToFire( string _name )
	{
		name = _name;
	}

	bool Fire( CBlob@ this, GunInfo@ info, bool has_energy )
	{
		u16 timer = getTimer(this);

		if (this.isKeyPressed(key_action1) && has_energy)
		{
			if (timer < info.fireInfo.interval)
			    SetTimer(this, timer + 1);

			SetCursorFrame(Maths::Min(int(1 + float(getTimer(this)) / float(info.fireInfo.interval) * 8), 9));
		}
		else if (!this.hasTag("shield") && !this.hasTag("cloaked")) // charge up weapons, but don't fire during shield/cloak
		{
			SetCursorFrame(0);

			if (timer >= info.fireInfo.interval)
			{
				SetTimer(this, 0);
				return true;
			}

			SetTimer(this, 0);
		}
		return false;
	}

	void SwapTo( CBlob@ this, GunInfo@ info )
	{
		SetTimer(this, 0);
	}
}

class BasicFireMode : FireMode
{
	bool automatic;

	BasicFireMode( string _name, bool _automatic )
	{
		name = _name;
		automatic = _automatic;
	}

	bool Fire( CBlob@ this, GunInfo@ info, bool has_energy )
	{
		SetCursorFrame(0);

		u16 timer = getTimer(this);
		if (timer > 0)
			SetTimer(this, timer - 1);

		if (getTimer(this) == 0)
		{
			if (automatic ? this.isKeyPressed(key_action1) : this.isKeyJustPressed(key_action1))
			{
				SetTimer(this, info.fireInfo.interval);
				return true;
			}
		}
		return false;
	}
}

shared class FireMode
{
	string name;

	FireMode( string _name )
	{
		name = _name;
	}

	bool Fire( CBlob@ this, GunInfo@ info, bool has_energy ) { return false; }

	void SwapTo( CBlob@ this, GunInfo@ info )
	{
		SetTimer(this, info.fireInfo.interval);
	}

	void Reset() {}

	u16 getTimer( CBlob@ this )
	{
		return this.get_u16("interval");
	}

	void SetTimer( CBlob@ this, u16 value )
	{
		this.set_u16("interval", value);
	}

	void SetCursorFrame( int frame )
	{
		CHUD@ hud = getHUD();

		if(!hud.hasButtons())
		{
			hud.SetCursorFrame(frame);
		}
	}
}

shared class FireInfo
{
	FireMode@ mode;
	bool soundLegacy;
	u8 soundVariations;
	string sound;
    u8 interval;
    u8 magazine;
	u8 bullets;

	f32 recoil;
	f32 deviation;
	bool shotgun;

    f32 ammoRegen;
    u8 ammoType;
	string ammoBlob;
	u8 ammoRequired;

	FireInfo() {}

	FireInfo( FireMode@ _mode, bool _soundLegacy, u8 _soundVariations, string _sound, u8 _interval, u8 _magazine, f32 _ammoRegen, u8 _bullets, f32 _recoil, f32 _deviation, bool _shotgun = false, u8 _ammoType = AmmoType::PRIMARY, string _ammoBlob = "", u8 _ammoRequired = 1 )
	{
		@mode = _mode;
		soundLegacy = _soundLegacy;
		soundVariations = _soundVariations;
		sound = _sound;
		interval = _interval;
		magazine = _magazine;
		bullets = _bullets;
		recoil = _recoil;
		deviation = _deviation;
		shotgun = _shotgun;
		ammoRegen = _ammoRegen;
		ammoType = _ammoType;
		ammoBlob = _ammoBlob;
		ammoRequired = _ammoRequired;
	}
}

shared class ProjectileInfo
{
	string blob;

	float damage;
	u8 range;
	Vec2f velocity;
	
	ProjectileInfo() {}
	
	ProjectileInfo( string _blob, float _damage, u8 _range, Vec2f _velocity )
	{
	    blob = _blob;
		damage = _damage;
		range = _range;
		velocity = _velocity;
	}
}

shared class GunInfo
{
	FireInfo fireInfo;
	ProjectileInfo projectileInfo;

	string name;
	u8 frame;

    Vec2f bulletOffset;
	Vec2f rotationOffset;
	
	GunInfo() {}
	
	GunInfo( FireInfo _fireInfo, ProjectileInfo _projectileInfo, string _name, u8 _frame, Vec2f _bulletOffset, Vec2f _rotationOffset )
	{
		fireInfo = _fireInfo;
		projectileInfo = _projectileInfo;
		name = _name;
		frame = _frame;
		bulletOffset = _bulletOffset;
		rotationOffset = _rotationOffset;
	}
}

void AddGunInfos( GunInfo[]@ guns )
{
	// -- LOGISTICS AND ASSAULT

	{
    	// Gauss Rifle
    	FireInfo f(FireModes::FULL_AUTOMATIC, false, 15, "GaussHeavy", 4, 25, 4, 1, 0.0f, 0.5f);
	    ProjectileInfo p("laser", 0.8f, 40, Vec2f(27.5f, 0.0f));
		GunInfo g(f, p, "gauss_rifle", 1, Vec2f(0.0f, -3.0f), Vec2f(-6.0f, -2.0f));
		guns.push_back(g);
	}
	{
		// Gauss Carbine
    	FireInfo f(FireModes::FULL_AUTOMATIC, false, 15, "GaussLight", 3, 30, 6, 1, 0.0f, 0.75f);
	    ProjectileInfo p("laser", 0.6f, 40, Vec2f(25.0f, 0.0f));
		GunInfo g(f, p, "gauss_carbine", 7, Vec2f(0.0f, -3.0f), Vec2f(-6.0f, -2.0f));
		guns.push_back(g);
	}
	{
		// Pulse Rifle
    	FireInfo f(FireModes::PULSE_RIFLE, false, 15, "GaussLight", 4, 21, 5, 1, 0.0f, 0.25f);
	    ProjectileInfo p("laser", 0.9f, 45, Vec2f(27.5f, 0.0f));
		GunInfo g(f, p, "pulse_rifle", 1, Vec2f(0.0f, -3.0f), Vec2f(-6.0f, -2.0f));
		guns.push_back(g);
	}
	{
		// Battle Rifle
    	FireInfo f(FireModes::SEMI_AUTOMATIC, false, 3, "RifleBattle", 8, 14, 2.5f, 1, 85.0f, 0.1f);
	    ProjectileInfo p("laser", 1.2f, 55, Vec2f(30.0f, 0.0f));
		GunInfo g(f, p, "battle_rifle", 6, Vec2f(0.0f, -3.0f), Vec2f(-6.0f, -2.0f));
		guns.push_back(g);
	}
	{
    	// Arc Laser
    	FireInfo f(FireModes::FULL_AUTOMATIC, false, 3, "LaserArc", 7, 21, 4, 1, 0.0f, 0.25f);
	    ProjectileInfo p("laser_arc", 1.2f, 40, Vec2f(25.0f, 0.0f));
		GunInfo g(f, p, "arc_laser", 1, Vec2f(0.0f, -4.0f), Vec2f(-6.0f, -2.0f));
		guns.push_back(g);
	}

	// -- SENTINEL

	{
		// Light Machine Gun
    	FireInfo f(FireModes::FULL_AUTOMATIC, false, 15, "GaussLight", 3, 50, 6, 1, 0.0f, 0.1f);
	    ProjectileInfo p("laser", 0.55f, 40, Vec2f(30.0f, 0.0f));
		GunInfo g(f, p, "lmg", 9, Vec2f(0.0f, -3.0f), Vec2f(-6.0f, -2.0f));
		guns.push_back(g);
	}
	{
		// Missile Launcher
    	FireInfo f(FireModes::CHARGE_TO_FIRE, false, 3, "LauncherMissile", 45, 2, 0.25f, 1, 45.0f, 1.5f, false, AmmoType::ITEM, "mat_missiles");
		ProjectileInfo p("missile_l", 1.4f, 25, Vec2f(25.0f, 0.0f));
		GunInfo g(f, p, "missile_launcher", 10, Vec2f(0.0f, -5.0f), Vec2f(-6.0f, -2.0f));
		guns.push_back(g);
	}
	{
		// Gatling Laser
    	FireInfo f(FireModes::GATLING_LASER, true, 0, "LaserGatling", 5, 75, 4, 1, 0.0f, 2.0f);
	    ProjectileInfo p("laser", 0.6f, 35, Vec2f(27.5f, 0.0f));
		GunInfo g(f, p, "gatling_laser", 5, Vec2f(0.0f, -2.0f), Vec2f(-6.0f, -2.0f));
		guns.push_back(g);
	}
	{
		// Scatter Cannon
    	FireInfo f(FireModes::CHARGE_TO_FIRE, false, 6, "RifleScatter", 24, 3, 0.25f, 5, 45.0f, 1.5f, true);
		ProjectileInfo p("laser", 1.4f, 25, Vec2f(25.0f, 0.0f));
		GunInfo g(f, p, "scatter_cannon", 8, Vec2f(0.0f, -3.0f), Vec2f(-6.0f, -2.0f));
		guns.push_back(g);
	}
	{
		// Plasma Thrower
	}

	// -- INFILTRATOR

	{
		// Sniper Rifle
    	FireInfo f(FireModes::CHARGE_TO_FIRE, false, 3, "RifleSniper", 45, 1, 0.25f, 1, 175.0f, 0.0f);
	    ProjectileInfo p("laser", 5.0f, 100, Vec2f(35.0f, 0.0f));
		GunInfo g(f, p, "sniper_rifle", 2, Vec2f(0.0f, -3.0f), Vec2f(-6.0f, -2.0f));
		guns.push_back(g);
	}
    {
    	// Mag-Sec SMG
    	FireInfo f(FireModes::FULL_AUTOMATIC, true, 0, "SMG", 3, 30, 6, 1, 0.0f, 0.5f);
	    ProjectileInfo p("laser", 0.7f, 30, Vec2f(30.0f, 0.0f));
		GunInfo g(f, p, "submachine_gun_2", 3, Vec2f(0.0f, -2.0f), Vec2f(-6.0f, -2.0f));
		guns.push_back(g);
	}
	{
		// Scout Rifle
    	FireInfo f(FireModes::FULL_AUTOMATIC, false, 15, "GaussLight", 3, 25, 6, 1, 0.0f, 0.25f);
	    ProjectileInfo p("laser", 0.7f, 50, Vec2f(27.5f, 0.0f));
		GunInfo g(f, p, "scout_rifle", 6, Vec2f(0.0f, -3.0f), Vec2f(-6.0f, -2.0f));
		guns.push_back(g);
	}
	{
		// Scrambler Rifle
    	FireInfo f(FireModes::SEMI_AUTOMATIC, false, 3, "RifleScrambler", 3, 15, 3, 1, 22.5f, 2.0f, false);
	    ProjectileInfo p("laser", 0.8f, 35, Vec2f(30.0f, 0.0f));
		GunInfo g(f, p, "scrambler_rifle", 6, Vec2f(0.0f, -3.0f), Vec2f(-6.0f, -2.0f));
		guns.push_back(g);
	}
	{
		// Plasma Cannon
    	FireInfo f(FireModes::CHARGE_TO_FIRE, false, 3, "CannonPlasma", 90, 1, 0.25f, 1, 175.0f, 0.1f, false, AmmoType::ITEM, "mat_cells", 2);
	    ProjectileInfo p("plasma_c", 0.0f, 40, Vec2f(25.0f, 0.0f));
		GunInfo g(f, p, "plasma_cannon", 5, Vec2f(0.0f, -3.0f), Vec2f(-6.0f, -2.0f));
		guns.push_back(g);
	}

	// -- UNIVERSAL

    {
    	// Submachine Gun
    	FireInfo f(FireModes::FULL_AUTOMATIC, true, 1, "SMG", 2, 35, 7, 1, 0.0f, 1.0f);
	    ProjectileInfo p("laser", 0.5f, 25, Vec2f(27.5f, 0.0f));
		GunInfo g(f, p, "submachine_gun", 3, Vec2f(0.0f, -2.0f), Vec2f(-6.0f, -2.0f));
		guns.push_back(g);
	}
	{
		// Scatter Rifle
    	FireInfo f(FireModes::SEMI_AUTOMATIC, false, 6, "RifleScatter", 8, 6, 0.75f, 3, 45.0f, 6.5f, true);
		ProjectileInfo p("laser", 1.0f, 20, Vec2f(25.0f, 0.0f));
		GunInfo g(f, p, "scatter_rifle", 4, Vec2f(0.0f, -3.0f), Vec2f(-6.0f, -2.0f));
		guns.push_back(g);
	}
	{
		// Plasma Launcher
    	FireInfo f(FireModes::SEMI_AUTOMATIC, false, 3, "LauncherPlasma", 24, 8, 0.4f, 1, 100.0f, 1.5f, false, AmmoType::ITEM, "mat_cells");
	    ProjectileInfo p("plasma_l", 0.0f, 15, Vec2f(18.0f, 0.0f));
		GunInfo g(f, p, "plasma_launcher", 8, Vec2f(0.0f, -3.0f), Vec2f(-6.0f, -2.0f));
		guns.push_back(g);
	}
	{
		// Swarm Launcher
    	FireInfo f(FireModes::CHARGE_TO_FIRE, false, 3, "LauncherSwarm", 45, 2, 0.25f, 3, 45.0f, 8.5f, true, AmmoType::ITEM, "mat_swarms");
		ProjectileInfo p("missile_s", 1.4f, 25, Vec2f(25.0f, 0.0f));
		GunInfo g(f, p, "swarm_launcher", 11, Vec2f(0.0f, -5.0f), Vec2f(-6.0f, -2.0f));
		guns.push_back(g);
	}
	{
		// Beam Laser?
	}
	{
		// Long distance weapon?
	}

	// -- SIDEARMS

	{
		// Ion Pistol
    	FireInfo f(FireModes::SEMI_AUTOMATIC, true, 0, "PistolIon", 7, 8, 2.0f, 1, 75.0f, 0.25f, false, AmmoType::SIDEARM);
	    ProjectileInfo p("laser", 1.5f, 30, Vec2f(22.5f, 0.0f));
		GunInfo g(f, p, "ion_pistol", 0, Vec2f(0.0f, -3.0f), Vec2f(-6.0f, -2.0f));
		guns.push_back(g);
	}
	{
		// Scrambler Pistol
    	FireInfo f(FireModes::SCRAMBLER_PISTOL, true, 0, "PistolScrambler", 4, 18, 3.5f, 1, 0.0f, 2.5f, false, AmmoType::SIDEARM);
	    ProjectileInfo p("laser", 0.9f, 20, Vec2f(25.0f, 0.0f));
		GunInfo g(f, p, "scrambler_pistol", 0, Vec2f(0.0f, -3.0f), Vec2f(-6.0f, -2.0f));
		guns.push_back(g);
	}
	{
		// Bolt Pistol
    	FireInfo f(FireModes::CHARGE_TO_FIRE, true, 0, "PistolBolt", 18, 5, 0.5f, 1, 75.0f, 0.0f, false, AmmoType::SIDEARM);
	    ProjectileInfo p("laser", 2.5f, 50, Vec2f(27.5f, 0.0f));
		GunInfo g(f, p, "bolt_pistol", 0, Vec2f(0.0f, -3.0f), Vec2f(-6.0f, -2.0f));
		guns.push_back(g);
	}
	{
		// Scatter Pistol
    	FireInfo f(FireModes::SEMI_AUTOMATIC, true, 0, "PistolScatter", 15, 4, 0.5f, 3, 72.5f, 5.5f, true, AmmoType::SIDEARM);
	    ProjectileInfo p("laser", 1.4f, 12, Vec2f(22.5f, 0.0f));
		GunInfo g(f, p, "scatter_pistol", 0, Vec2f(0.0f, -3.0f), Vec2f(-6.0f, -2.0f));
		guns.push_back(g);
	}
}

GunInfo[]@ getGuns()
{
	GunInfo[]@ guns;

    getRules().get(gun_infos_property, @guns);
	return guns;
}

GunInfo@ getGunInfoByIndex( int index )
{
    GunInfo[]@ guns;

    if (getRules().get(gun_infos_property, @guns))
    {
        return guns[index];
    }
	return null;
}

GunInfo@ getGunInfoByName( string name )
{
    GunInfo[]@ guns;
    
    if (getRules().get(gun_infos_property, @guns))
    {
    	int index = getGunInfoIndex(name);
    	if (index != -1)
    	{
    		return guns[index];
    	}
    }
	return null;
}

int getGunInfoIndex( string name )
{
    GunInfo[]@ guns;

    if (getRules().get(gun_infos_property, @guns))
    {
        for (uint i = 0; i < guns.length; i++)
        {
            if (guns[i].name == name)
            {
                return i;
            }
        }
    }
	return -1;
}
