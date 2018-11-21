/* GunInfo.as
 * author: Aphelion
 */

#include "GunsCommon.as";
#include "Utils.as";

#include "SoldierCommon.as";
#include "GunCommon.as";
#include "Knocked.as";

#include "Requirements.as";

Random _random(0x1337);
Random sound_random(0x1337);

void UpdateGun( CBlob@ this, GunInfo[]@ gunInfos, CControls@ controls, const bool active, const int gunIndex )
{
	if (gunIndex == -1) return;

	GunInfo@ info = gunInfos[gunIndex];

	RegenerateAmmo(this, info);

	if (active)
	{
		FireGun(this, info, gunIndex);
	}
}

void FireGun( CBlob@ this, GunInfo@ info, const int gunIndex )
{
	CHUD@ hud = getHUD();

	FireInfo fireInfo = info.fireInfo;
	FireMode@ fireMode = fireInfo.mode;
	
	bool ability = this.hasTag("shield") || this.hasTag("cloaked");

	if (hud.hasMenus() || (ability && fireMode.name != "charge_to_fire"))
	{
		fireMode.Reset();
		return;
	}
	
	if (fireMode.Fire(this, info, HasAmmo(this, fireInfo)))
    {
        if (TakeAmmo(this, fireInfo))
    	{
    	    CSpriteLayer@ muzzle = this.getSprite().getSpriteLayer("muzzle");

    	    if (muzzle is null)
    	    {
    	    	warn("Muzzle offset layer is null");
    	    	return;
    	    }

    	    Vec2f offset = muzzle.getOffset();

    		ShootSound(this, fireInfo);
    		Shoot(this, offset, getAimAngle(this, this.getPosition() + offset), gunIndex);
    	}
	}
}

void onInit( CBlob@ this )
{
	setActive(this, ItemType::WEAPON_PRIMARY);
}

void onTick( CBlob@ this )
{
	bool bot = this.getPlayer() !is null && this.getPlayer().isBot();

	if (!this.isMyPlayer() && !bot) return;

	CControls@ controls = getControls();
	
	const u8 active_type = getActiveType(this);
	bool KEY_Z = controls.isKeyJustPressed(KEY_KEY_Z);
	bool KEY_X = controls.isKeyJustPressed(KEY_KEY_X);
	bool KEY_R = controls.isKeyJustPressed(KEY_KEY_R);
	if ( KEY_Z || KEY_X )
	{
        SwapWeapon(this, KEY_X ? ItemType::WEAPON_SIDEARM : ItemType::WEAPON_PRIMARY);
	}
	else if ( KEY_R )
	{
		SwapWeapon(this, active_type == WEAPON_PRIMARY ? ItemType::WEAPON_SIDEARM : ItemType::WEAPON_PRIMARY);
	}

	const u32 gametime = getGameTime();

	const string primary = getItem(this, ItemType::WEAPON_PRIMARY);
	const string sidearm = getItem(this, ItemType::WEAPON_SIDEARM);
	const string active = getActiveItem(this);

	GunInfo[]@ gunInfos = getGuns();

	UpdateGun(this, gunInfos, controls, active == primary, getGunInfoIndex(primary));
	UpdateGun(this, gunInfos, controls, active == sidearm, getGunInfoIndex(sidearm));
}

void ShootSound( CBlob@ this, FireInfo fireInfo )
{
	if (getNet().isServer())
	{
		return;
	}

	if (this.isMyPlayer() && !fireInfo.soundLegacy)
	{
	    Sound::Play(fireInfo.sound + XORRandom(1 + fireInfo.soundVariations) + ".ogg");
	}
	else
	{
	    Sound::Play(fireInfo.sound + "0.ogg", this.getPosition(), 2.0f, 1.0f + NextFloat(sound_random, -0.05f, 0.1f));
	}
}

void Shoot( CBlob@ this, const Vec2f gun_offset, const f32 aimangle, const u8 gun_index )
{
	CBitStream params;
	params.write_Vec2f(gun_offset);
	params.write_f32(aimangle);
	params.write_u8(gun_index);
	params.write_u8(XORRandom(255));
	
	this.SendCommand(GunCommon::SHOOT, params);
}

void SwapWeapon( CBlob@ this, const u8 slot )
{
    CBitStream params;
    params.write_u8(slot);
    this.SendCommand(GunCommon::SWAP_WEAPON, params);
}

void onCommand( CBlob@ this, u8 cmd, CBitStream@ params )
{
	if (cmd == GunCommon::SHOOT)
	{
		Vec2f gun_offset = params.read_Vec2f();
		f32 angle = params.read_f32();
		u8 gun_index = params.read_u8();
		u8 seed = params.read_u8();

		GunInfo@ gunInfo = getGunInfoByIndex(gun_index);
		if      (gunInfo is null) return;

		FireInfo@ fireInfo = gunInfo.fireInfo;

		if (fireInfo.ammoType == AmmoType::ITEM && getNet().isServer())
		{
			TakeAmmo(this, fireInfo);
		}

		Vec2f pos = this.getPosition();

		bool crouching = this.isKeyPressed(key_down);
		f32 recoil = fireInfo.recoil * this.get_f32("movement_factor");
		f32 deviation = fireInfo.deviation;
		int bullets = fireInfo.bullets;

		// pew pew pew
		if(!this.isMyPlayer())
		{
	        ShootSound(this, fireInfo);
	    }

	    // set random seed
		_random.Reset(seed);
		
		// projectiles
		for(uint step = 0; step < bullets; step++)
		{
			Vec2f velocity = gunInfo.projectileInfo.velocity;
			Vec2f recoil = Vec2f(-fireInfo.recoil, 0);
			Vec2f projectile_pos = pos + gun_offset;
			f32 _angle = angle;

			if (this.isFacingLeft())
			{
			    _angle += 180.0f;
			}

			velocity.RotateBy(_angle);
			recoil.RotateBy(_angle);

			if (fireInfo.shotgun)
			{
				f32 deviation_ = 0.0f;

				switch (step)
				{
					case 0:
					deviation_ =  NextFloat(_random, 0.0f, deviation);
					break;

					case 1:
				    deviation_ = -NextFloat(_random, 0.0f, deviation);
					break;
				}

				if (bullets == 5)
				{
					switch (step)
					{
						case 2:
					    deviation_ =  deviation +  NextFloat(_random, 0.0f, deviation);
						break;

						case 3:
					    deviation_ = -deviation + -NextFloat(_random, 0.0f, deviation);
						break;
					}
				}

		        velocity.RotateBy(deviation_);
		        recoil.RotateBy(deviation_);
			}
			else
			{
				f32 deviation_ = crouching ? deviation / 2 : deviation;

			    velocity.RotateBy(NextFloat(_random, -deviation_, deviation_));
			}

			this.AddForce(crouching ? recoil / 2 : recoil);

			if (getNet().isServer())
			{
				string blob = gunInfo.projectileInfo.blob;

				CBlob@ bullet = server_CreateBlobNoInit(blob);
				if    (bullet !is null)
				{
					if (blob == "laser")
					{
						bullet.set_u8("gun_index", gun_index);
					}
					
					bullet.setPosition(projectile_pos);
					bullet.setVelocity(velocity);
					bullet.Init();

					bullet.IgnoreCollisionWhileOverlapped(this);
					bullet.SetDamageOwnerPlayer(this.getPlayer());
					bullet.server_setTeamNum(this.getTeamNum());
				}
			}
		}
	}
	else if(cmd == GunCommon::SWAP_WEAPON)
	{
		u8 type = params.read_u8();
        
        setActive(this, type);

		this.ClearGridMenus();

    	if (this.getName() == "logistics")
		{
	        ClearCarriedBlock(this);
		}

        if (this.isMyPlayer())
        {
			GunInfo@ gun = getGunInfoByName(getItem(this, type));
			if      (gun is null) return;

			gun.fireInfo.mode.SwapTo(this, gun);
			gun.fireInfo.mode.Reset();
        }
	}
}

void ClearCarriedBlock(CBlob@ this)
{
	// clear variables
	this.set_u8("buildblob", 255);
	this.set_TileType("buildtile", 0);

	// remove carried block, if any
	CBlob@ carried = this.getCarriedBlob();
	if(carried !is null && carried.hasTag("temp blob"))
	{
		carried.Untag("temp blob");
		carried.server_Die();
	}
}
