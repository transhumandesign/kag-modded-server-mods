/* Abilities.as
 * author: Aphelion
 */

#include "CustomParticles.as";
#include "SoldierCommon.as";
#include "Stats.as";

#include "ShieldCommon.as";

namespace Abilities
{
    const string TOGGLE_ABILITY = "toggle ability";
    const f32 SHIELD_BLOCK_ANGLE = 180.0f;
    const f32 SHIELD_BREAK_FORCE = 2.0f;

    const int COINS_PER_HEAL = 10;

	enum Abilities
	{
		NONE = 0,
		FLIGHT,
		HEALING,
		SHIELD,
		CLOAKING
	}

	const Ability[] abilities =
	{
		Ability(Abilities::NONE, "none", 0.0f, 0.0f),
		Ability(Abilities::FLIGHT, "jetpack", 2.5f, 1.5f),
		Ability(Abilities::HEALING, "healing", 1.0f, 1.0f),
		Ability(Abilities::SHIELD, "shield", 0.5f, 0.5f),
		Ability(Abilities::CLOAKING, "cloaked", 1.0f, 1.5f),
	};
}

shared class Ability
{
	u8 index;
	string tag;
	f32 energy_per_toggle;
	f32 energy_per_tick;

	Ability() {}

	Ability(u8 _index, string _tag, f32 _energy_per_toggle, f32 _energy_per_tick)
	{
		index = _index;
		tag = _tag;
		energy_per_toggle = _energy_per_toggle;
		energy_per_tick = _energy_per_tick;
	}
}

void onRender( CSprite@ this )
{
	CBlob@ blob = this.getBlob();

	if (blob.hasTag("shield"))
	{
		blob.RenderForHUD(RenderStyle::outline_front);
	}
}

void onInit( CBlob@ this )
{
	this.addCommandID(Abilities::TOGGLE_ABILITY);

	addShieldVars(this, Abilities::SHIELD_BLOCK_ANGLE, Abilities::SHIELD_BREAK_FORCE);
	setShieldEnabled(this, false);
}

void onTick( CBlob@ this )
{
    Ability@ ability = getAbility(this);
    if      (ability.index == Abilities::NONE) return;
    
    if (ability.index == Abilities::HEALING)
    {
    	string weapon = getActiveItem(this);
    	if    (weapon == "omni_tool") return;
    }

	if (this.hasTag("dead"))
	{
		ToggleAbility(this, ability.index, false);

		this.getCurrentScript().runFlags |= Script::remove_after_this;
		return;
	}

    bool bot = this.getPlayer() !is null && this.getPlayer().isBot();

	if (this.isMyPlayer() || bot)
	{
    	bool enabled = this.hasTag(ability.tag);

	    if (!enabled && this.isKeyJustPressed(key_action2))
	    {
	    	if (client_TakeStat(this, Stats::ENERGY, ability.energy_per_toggle))
	    	{
	    		ToggleAbility(this, ability.index, true);
	    	}
	    }
	    else if (enabled && !this.isKeyPressed(key_action2))
	    {
	    	ToggleAbility(this, ability.index, false);
	    }

	    if (enabled)
	    {
	    	switch (ability.index)
	    	{
	    		case Abilities::CLOAKING:
	    		{
	    			UpdateCloak(this, ability);
	    			break;
	    		}

	    		default:
	    		{
	    			UpdateAbility(this, ability);
	    			break;
	    		}
	    	}
	    }
	}

    bool enabled = this.hasTag(ability.tag);
    if  (enabled)
    {
    	switch(ability.index)
    	{
    		case Abilities::FLIGHT:
    		{
    			JetpackEffect(this, ability);
    			break;
    		}

    		case Abilities::HEALING:
    		{
    			HealingEffect(this, ability);
    			break;
    		}

    		case Abilities::SHIELD:
    		{
    			ShieldEffect(this, ability);
    			break;
    		}
    	}
    }
}

void onCommand( CBlob@ this, u8 cmd, CBitStream@ params )
{
	if (cmd == this.getCommandID(Abilities::TOGGLE_ABILITY))
	{
		u8 index;
		bool on;

		if (!params.saferead_u8(index)) return;
		if (!params.saferead_bool(on)) return;

		Ability ability = Abilities::abilities[index];

		if (on)
		{
			this.Tag(ability.tag);
		}
		else
		{
			this.Untag(ability.tag);
		}

		switch(index)
		{
			case Abilities::CLOAKING:
			{
				ToggleCloak(this, on);
				break;
			}

			case Abilities::SHIELD:
			{
				ToggleShield(this, on);
				break;
			}
		}
	}
}

void ToggleAbility( CBlob@ this, u8 index, bool on )
{
	CBitStream params;
	params.write_u8(index);
	params.write_bool(on);

	this.SendCommand(this.getCommandID(Abilities::TOGGLE_ABILITY), params);
}

void JetpackEffect( CBlob@ this, Ability ability )
{
	Vec2f vel = -this.getVelocity();

	for(int i = 0; i < 3; i++)
	{
		MakeJetpackParticle(this, vel);
	}
}

void HealingEffect( CBlob@ this, Ability ability )
{
	if (getGameTime() % 15 == 0)
	{
        CPlayer@ player = this.getPlayer();

        CMap@ map = getMap();

        Vec2f pos = this.getPosition();

		CBlob@[] blobs;
		if(!map.getBlobsInRadius(this.getPosition(), 64.0f, @blobs)) return;

		for(uint i = 0; i < blobs.length; i++)
		{
			CBlob@ blob = blobs[i];
			if    (blob !is null && blob.hasTag("player") && blob.getTeamNum() == this.getTeamNum())
			{
                if (blob is this || !map.rayCastSolid(pos, blob.getPosition()))
                {
            		u8 health = getStat(blob, Stats::HEALTH);
                	u8 health_max = getBaseStat(blob, Stats::HEALTH);

                	if (health < health_max)
                	{
                		if (getNet().isClient())
                		{
							Vec2f vel = -blob.getVelocity();

							for(int i = 0; i < 5; i++)
							{
								MakeHealingParticle(blob, vel);
							}
                		}
                		else
                		{
		            		if (player !is null && blob !is this)
		            		{
		            			player.server_setCoins(player.getCoins() + Abilities::COINS_PER_HEAL);
		            		}

		            		server_SetStat(blob, Stats::HEALTH, health + 5, 0, false);
                		}
                		
                	}
                }
			}
		}
	}
}

void ShieldEffect( CBlob@ this, Ability ability )
{
	int horiz = this.isFacingLeft() ? 1 : -1;
	
	setShieldDirection(this, Vec2f(horiz, 0));
}

void UpdateAbility( CBlob@ this, Ability ability )
{
	if (getGameTime() % 15 == 0)
	{
		if (!client_TakeStat(this, Stats::ENERGY, ability.energy_per_tick))
		{
			ToggleAbility(this, ability.index, false);
		}
	}
}

void UpdateCloak( CBlob@ this, Ability ability )
{
	if (getGameTime() % 15 == 0)
	{
		f32 vellen = this.getVelocity().getLength();
		if (vellen > 1.0f && !client_TakeStat(this, Stats::ENERGY, ability.energy_per_tick))
		{
			ToggleAbility(this, ability.index, false);
		}
	}
}

void ToggleCloak( CBlob@ this, bool on )
{
	CSprite@ sprite = this.getSprite();

	CBlob@ localBlob = getLocalPlayerBlob();
	
	if (this.isMyPlayer() || (localBlob !is null && localBlob.getTeamNum() == this.getTeamNum()))
	{
		sprite.setRenderStyle(on ? RenderStyle::light :
			                       RenderStyle::normal);
	}
	else
	{
	    sprite.SetVisible(!on);
	}

	sprite.PlaySound("Cloak", this.isMyPlayer() ? 1.2f : 1.0f, on ? 1.4f : 1.0f);
}

void ToggleShield( CBlob@ this, bool on )
{
	setShieldEnabled(this, on);
}

Ability getAbility( CBlob@ this )
{
	const string suit = getItem(this, ItemType::EXO_SUIT);

    if (suit == "assault")
		return Abilities::abilities[Abilities::FLIGHT];
    else if (suit == "logistics")
		return Abilities::abilities[Abilities::HEALING];
	else if (suit == "sentinel")
		return Abilities::abilities[Abilities::SHIELD];
	else if (suit == "infiltrator")
		return Abilities::abilities[Abilities::CLOAKING];
	else
	    return Abilities::abilities[Abilities::NONE];
}
