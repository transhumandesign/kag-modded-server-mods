// UndeadStalker logic

#include "Hitters.as"; 
#include "Knocked.as"; 
#include "ThrowCommon.as";
#include "RunnerCommon.as";
#include "Help.as";

void onInit(CBlob@ this)
{
	this.set_f32("gib health", -3.0f); 

	this.Tag("player"); 
	this.Tag("flesh"); 

	CShape@ shape = this.getShape(); 
	shape.SetRotationsAllowed(false); 
	shape.getConsts().net_threshold_multiplier = 0.5f;

	this.getCurrentScript().runFlags |= Script::tick_not_attached;
	this.getCurrentScript().removeIfTag = "dead";
	
	//add a command ID for each arrow type
	AddIconToken( "$Stalk$", "usSpellIcons.png", Vec2f(16,16), 0 );
	AddIconToken( "$Screech$", "usSpellIcons.png", Vec2f(16,16), 1 );
	  
	SetHelp( this, "help self action", "undeadstalker", "$Daggar$ Stab    $LMB$", "", 5 );
	SetHelp( this, "help self action2", "undeadstalker", "$Stalk$ Invisibility   $RMB$", "" );
	SetHelp( this, "help show", "undeadstalker", "$Screech$ Screech using V", "" );	
	
	this.set_s16("stab_cooldown",0);
}

void onSetPlayer(CBlob@ this, CPlayer@ player)
{
	if(player !is null)
	{
		player.SetScoreboardVars("ScoreboardIcons.png", 11, Vec2f(16, 16)); 
	}
}

void onTick(CBlob@ this) 
{
	if(this.isInInventory()) 
		return; 

	const bool ismyplayer = this.isMyPlayer(); 

	if(ismyplayer && getHUD().hasMenus()) 
	{
		return; 
	}

	if(ismyplayer) 
	{

		if(this.isKeyJustPressed(key_action3)) 
		{
			CBlob@ carried = this.getCarriedBlob(); 
			if(carried is null) 
			{
				client_SendThrowOrActivateCommand(this); 
			}
		}
	}
	
	if(this.get_s16("stab_cooldown") > 0)this.set_s16("stab_cooldown",this.get_s16("stab_cooldown")-1);
	if(this.isKeyPressed(key_action1) && !this.isKeyPressed(key_action2))
	{
		if(this.get_s16("stab_cooldown") <= 0){
			if(!this.isFacingLeft())DoAttack(this, 0.5f, 0.0f, 45.0f, Hitters::fire, 1);
			else DoAttack(this, 0.5f, 180.0f, 45.0f, Hitters::fire, 1);
			this.set_s16("stab_cooldown",24);
			this.getSprite().PlaySound("/SwordSlash.ogg");
		}
	}
	
	if(this.get_u32("invisible") >= 1) //lower the invisible timer
	{
		this.set_u32("invisible", this.get_u32("invisible") - 1);
	}		
}

void DoAttack(CBlob@ this, f32 damage, f32 aimangle, f32 arcdegrees, u8 type, int deltaInt)
{
	if (!getNet().isServer())
	{
		return;
	}

	if (aimangle < 0.0f)
	{
		aimangle += 360.0f;
	}

	Vec2f blobPos = this.getPosition();
	Vec2f vel = this.getVelocity();
	Vec2f thinghy(1, 0);
	thinghy.RotateBy(aimangle);
	Vec2f pos = blobPos - thinghy * 6.0f + vel + Vec2f(0, -2);
	vel.Normalize();

	f32 attack_distance = Maths::Min(8 + Maths::Max(0.0f, 1.75f * this.getShape().vellen * (vel * thinghy)), 8)*2;

	f32 radius = this.getRadius();
	CMap@ map = this.getMap();
	bool dontHitMore = false;
	bool dontHitMoreMap = false;
	const bool jab = true;

	f32 exact_aimangle = (this.getAimPos() - blobPos).Angle();

	HitInfo@[] hitInfos;
	if (map.getHitInfosFromArc(pos, aimangle, arcdegrees, radius + attack_distance, this, @hitInfos))
	{
		for (uint i = 0; i < hitInfos.length; i++)
		{
			HitInfo@ hi = hitInfos[i];
			CBlob@ b = hi.blob;
			if (b !is null && !dontHitMore)
			{
				if (b.hasTag("ignore sword")) continue;

				const bool large = b.hasTag("blocks sword") && !b.isAttached() && b.isCollidable();

				if (!canHit(this, b))
				{
					if (large)
						dontHitMore = true;

					continue;
				}

				if (!dontHitMore)
				{
					Vec2f velocity = b.getPosition() - pos;
					if(b.isFacingLeft() == this.isFacingLeft())
					{
						this.server_Hit(b, hi.hitpos, velocity, 1.0, type, true);
						this.getSprite().PlaySound("/KnifeStab.ogg"); 
					}
					else
					{
						this.server_Hit(b, hi.hitpos, velocity, 0.25, type, true);
						this.getSprite().PlaySound("/KnifeStab.ogg"); 
					}	
					if (large)
					{
						dontHitMore = true;
					}
				}
			}
			else
				if (!dontHitMoreMap && (deltaInt == 2 + 1))
				{
					bool ground = map.isTileGround(hi.tile);
					bool dirt_stone = map.isTileStone(hi.tile);
					bool gold = map.isTileGold(hi.tile);
					bool wood = map.isTileWood(hi.tile);
					if (ground || wood || dirt_stone || gold)
					{
						Vec2f tpos = map.getTileWorldPosition(hi.tileOffset) + Vec2f(4, 4);
						Vec2f offset = (tpos - blobPos);
						f32 tileangle = offset.Angle();
						f32 dif = Maths::Abs(exact_aimangle - tileangle);
						if (dif > 180)
							dif -= 360;
						if (dif < -180)
							dif += 360;

						dif = Maths::Abs(dif);

						if (dif < 20.0f)
						{

							int check_x = -(offset.x > 0 ? -1 : 1);
							int check_y = -(offset.y > 0 ? -1 : 1);
							if (map.isTileSolid(hi.hitpos - Vec2f(map.tilesize * check_x, 0)) &&
							        map.isTileSolid(hi.hitpos - Vec2f(0, map.tilesize * check_y)))
								continue;

							bool canhit = true; 

							canhit = canhit && map.getSectorAtPosition(tpos, "no build") is null;

							dontHitMoreMap = true;
							if (canhit)
							{
								map.server_DestroyTile(hi.hitpos, 0.1f, this);
							}
						}
					}
				}
		}
	}

	// destroy grass

	if (((aimangle >= 0.0f && aimangle <= 180.0f) || damage > 1.0f) &&    // aiming down or slash
	        (deltaInt == 2 + 1)) // hit only once
	{
		f32 tilesize = map.tilesize;
		int steps = Maths::Ceil(2 * radius / tilesize);
		int sign = this.isFacingLeft() ? -1 : 1;

		for (int y = 0; y < steps; y++)
			for (int x = 0; x < steps; x++)
			{
				Vec2f tilepos = blobPos + Vec2f(x * tilesize * sign, y * tilesize);
				TileType tile = map.getTile(tilepos).type;

				if (map.isTileGrass(tile))
				{
					map.server_DestroyTile(tilepos, damage, this);

					if (damage <= 1.0f)
					{
						return;
					}
				}
			}
	}
}

bool canHit(CBlob@ this, CBlob@ b)
{

	if (b.hasTag("invincible"))
		return false;

	if (b.isAttached())
	{

		CBlob@ carrier = b.getCarriedBlob();

		if (carrier !is null)
			if (carrier.hasTag("player")
			        && (this.getTeamNum() == carrier.getTeamNum() || b.hasTag("temp blob")))
				return false;

	}

	if (b.hasTag("dead"))
		return true;

	return b.getTeamNum() != this.getTeamNum();

}