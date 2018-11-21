
#include "OrbCommon.as";
#include "FUNHitters.as";
#include "PriestCommon.as";
#include "TeamColour.as";
#include "Explosion.as";

void onInit( CBlob@ this )
{
	
}	

void onTick( CBlob@ this )
{  
	if(this.getCurrentScript().tickFrequency == 1)
	{
		this.getShape().SetGravityScale( 0.0f );
		this.server_SetTimeToDie(ORB_TIME_TO_DIE);
		this.SetLight( true );
		this.SetLightRadius( 32.0f );

		//Make it explode on death
		this.Tag("exploding");

		if (this.getTeamNum() == 0) 
			this.SetLightColor( SColor(0, 44, 175, 222 ) );
		else 
			this.SetLightColor( SColor(0, 213, 84, 63 ) );

		this.set_string("custom_explosion_sound", "OrbExplosion.ogg");
		this.getSprite().PlaySound("OrbFireSound.ogg");
		this.getSprite().SetZ(1000.0f);
		
		if (this.hasTag("Regular Orb"))
		{
			print("regular");
			this.getSprite().SetAnimation("normal");
			this.set_f32("explosive_radius", 12.0f );
			this.set_f32("explosive_damage", 0.75f);
			this.set_f32("map_damage_radius", 0.0f);
			this.set_f32("map_damage_ratio", -1.0f); //heck no!		
			//this.set_u8("custom_hitter", FUNHitters::orb);			
		}
		else if (this.hasTag("Fire Orb"))
		{
			this.getSprite().SetAnimation("fire");
			this.set_f32("explosive_radius", 12.0f );
			this.set_f32("explosive_damage", 1.0f);
			this.set_f32("map_damage_radius", 15.0f);
			this.set_f32("map_damage_ratio", -1.0f); //heck no!
			//this.set_u8("custom_hitter", FUNHitters::fire_orb);
		}
		else if (this.hasTag("Bomb Orb"))
		{
			this.getSprite().SetAnimation("bomb");	
			this.set_f32("explosive_radius", 16.0f );
			this.set_f32("explosive_damage", 1.5f);
			this.set_f32("map_damage_radius", 16.0f);
			this.set_f32("map_damage_ratio", 1.0f); //heck no!
			this.set_bool("map_damage_raycast", true);
			//this.set_u8("custom_hitter", FUNHitters::bomb_orb);
		}
		else if (this.hasTag("Water Orb"))
		{
			this.getSprite().SetAnimation("water");	
			this.set_f32("explosive_radius", 0.0f );
			this.set_f32("explosive_damage", 0.0f);
			this.set_f32("map_damage_radius", 0.0f);
			this.set_f32("map_damage_ratio", -1.0f); //heck no!	
			//this.set_u8("custom_hitter", FUNHitters::water_orb);
		}
		this.getCurrentScript().tickFrequency = 3;
	}
	
	
	Vec2f target;
	bool targetSet;
	bool brake;
	
	CPlayer@ p = this.getDamageOwnerPlayer();
	if( p !is null)	{
		CBlob@ b = p.getBlob();
		if( b !is null)	{
			target = b.getAimPos();
			targetSet = true;
			brake = b.isKeyPressed( key_action3 );
		}
	}
	
	if(targetSet){
		Vec2f vel = this.getVelocity();
		Vec2f dir = target-this.getPosition();
		if(!brake){
			float perc = 1.0f - Maths::Min((Maths::Max(dir.Length(), 24.0f)-24.0f)/48.0f, 1.0f);
			dir.Normalize();
			vel += dir * 1.4f * perc;
			if(vel.Length() > ORB_SPEED){
				vel.Normalize();
				vel *= ORB_SPEED;
			}
		} else {
			float perc = Maths::Min((Maths::Max(dir.Length(), 24.0f)-24.0f)/48.0f, 1.0f);
			if(vel.Length() > ORB_SPEED * perc){
				vel.Normalize();
				vel *= ORB_SPEED * perc;
			}
		}
		
		this.setVelocity(vel);
	}
}	

bool doesCollideWithBlob( CBlob@ this, CBlob@ b )
{	
	if ( b.hasTag("blocks water"))
	{
		return true;
	}
	else return (
		isEnemy(this, b) 
		|| b.hasTag("door") 
		|| (b.getPlayer() !is null 
			&& this.getDamageOwnerPlayer() !is null
			&& b.getPlayer() is this.getDamageOwnerPlayer()
		|| b.getName() == this.getName()
		)
	); 
}

void onCollision( CBlob@ this, CBlob@ blob, bool solid, Vec2f normal)
{
	if (solid){
		if(blob !is null && blob.getTeamNum() != this.getTeamNum())
		{
			ExplodeOrb(this);
		} 
		else 
		{

		}
	}
}
void ExplodeOrb(CBlob@ this)
{
	if (this.hasTag("Fire Orb")) 
	{
		makeFire(this, 2);
	}
	else if (this.hasTag("Water Orb"))
	{
		this.Untag("exploding");
		Splash( this, 2, 2, 0.7f );
		this.getSprite().PlaySound( "GlassBreak" );
	}
	
	this.server_SetHealth(-1.0f);
	this.server_Die();
}

void makeFire(CBlob@ this, int doFire)
{
	CMap@ map = getMap();
	if (map !is null)	
	{
		for (int i = doFire; i <= (doFire * 8); i += 8)
		{
			map.server_setFireWorldspace(Vec2f(this.getPosition().x, this.getPosition().y + i), true);
			map.server_setFireWorldspace(Vec2f(this.getPosition().x, this.getPosition().y - i), true);
			map.server_setFireWorldspace(Vec2f(this.getPosition().x + i, this.getPosition().y), true);
			map.server_setFireWorldspace(Vec2f(this.getPosition().x - i, this.getPosition().y), true);
			map.server_setFireWorldspace(Vec2f(this.getPosition().x + i, this.getPosition().y + i), true);
			map.server_setFireWorldspace(Vec2f(this.getPosition().x - i, this.getPosition().y - i), true);
			map.server_setFireWorldspace(Vec2f(this.getPosition().x + i, this.getPosition().y - i), true);
			map.server_setFireWorldspace(Vec2f(this.getPosition().x - i, this.getPosition().y + i), true);
		}
	}
}
	