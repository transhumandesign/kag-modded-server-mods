#include "TreeDeeSound.as"

#include "ParticleSystemClass.as"
#include "cloud.as"

void onInit(CBlob@ this)
{
	this.set_u8("prop_id", 2);
	
	CShape@ shape = this.getShape();
	shape.SetGravityScale(0.0f);
	shape.SetRotationsAllowed(false);
	//this.Tag("prop");
	
	if(isClient())
		PlayTreeDeeSound("Shoot.ogg", this.getPosition(), 1.3, 1.0);
	
	//this.SetLight(true);
    //this.SetLightRadius(40.0f);
    //this.SetLightColor(this.getTeamNum() == 0 ? SColor(255, 0, 0, 100) : SColor(255, 100, 0, 0));
}

bool doesCollideWithBlob( CBlob@ this, CBlob@ blob)
{
	if(blob.getTeamNum() == this.getTeamNum() || blob.getName() == "bullet" || blob.hasTag("invincible"))
	{
		return false;
	}
	return true;
}

void onCollision( CBlob@ this, CBlob@ blob, bool solid )
{
	//if(blob is null)	//map collision
	//	this.server_Die();
	if(this.hasTag("dead")) return;
	
	if(blob !is null)
	{
		if(blob.getTeamNum() == this.getTeamNum() || blob.hasTag("invincible") || blob.getConfig() == this.getConfig())
			return;
		//if(blob.getName() == "player" && blob.getTeamNum() != this.getTeamNum())
		//{
			this.server_Hit(blob, Vec2f_zero, Vec2f_zero, 0.5f, 1);
			//this.server_Die();
		//}
	}
	this.setVelocity(Vec2f_zero);
	this.server_SetTimeToDie(0.6f);
	this.Tag("dead");
	if(isClient())
	{
		CPlayer@ p = getLocalPlayer();
		if(p !is null)
		{
			CBlob@ b = p.getBlob();
			if(b !is null)
			{
				//float dist = this.getDistanceTo(b);
				//print("dist: "+dist);
				if(this.getDistanceTo(b) > 150) return;
			}
		}
		//particle_system@ PS = getParticleSystem();
		//int i = XORRandom(10)+45;
		//while(i>0)
		//{
		//	PS.add_particle(0.95, vec3d((0.5-rand_float())*50, (0.5-rand_float())*50, (0.5-rand_float())*50), vec3d(this.getPosition().y/16, 0.5, this.getPosition().x/16), XORRandom(10)+10);
		//	i--;
		//}
	}
	//this.server_Die();
}

void onTick(CBlob@ this)
{
	//print("getTimeToDie(): "+this.getTimeToDie());
	if(isClient())
	{
		CSprite@ sprite = this.getSprite();
		if(!this.hasTag("dead") && this.getVelocity().getLength() <= 0.2)
		{
			this.setVelocity(Vec2f_zero);
			//if(!sprite.isAnimation("death"))
			//{
				this.Tag("dead");
				//sprite.SetAnimation("death");
			//	return;
			//}
			//print("frame: "+sprite.getFrame());
			//if(sprite.isFrame(5))
			//{
			//	print("death");
			//	this.server_Die();
			//}
			CPlayer@ p = getLocalPlayer();
			if(p !is null)
			{
				CBlob@ b = p.getBlob();
				if(b !is null)
				{
					//float dist = this.getDistanceTo(b);
					//print("dist: "+dist);
					//if(this.getDistanceTo(b) <= 150)
					//{
					//	particle_system@ PS = getParticleSystem();
					//	int i = XORRandom(10)+45;
					//	while(i>0)
					//	{
					//		PS.add_particle(0.95, vec3d((0.5-rand_float())*50, (0.5-rand_float())*50, (0.5-rand_float())*50), vec3d(this.getPosition().y/16, 0.5, this.getPosition().x/16), XORRandom(10)+10);
					//		i--;
					//	}
					//}
				}
			}
			
			//PS.shoot_em_boi(10, 180, vec3d(this.getPosition().y/16, 0.75, this.getPosition().x/16));
			//PS.sprout();
		}
		if(this.hasTag("dead"))
		{
			this.setVelocity(Vec2f_zero);
			sprite.SetAnimation("death");
		}
	}
	if(isServer())
	{
		if(!this.hasTag("dead") && this.getVelocity().getLength() <= 0.2)
		{
			this.setVelocity(Vec2f_zero);
			this.server_SetTimeToDie(0.6f);
			this.Tag("dead");
			//if(!sprite.isAnimation("death"))
			//{
			//	this.Tag("dead");
				//sprite.SetAnimation("death");
			//	return;
			//}
			//print("frame: "+sprite.getFrame());
			//if(sprite.isFrame(5))
			//{
			//	print("death");
			//	this.server_Die();
			//}
		}
		if(this.hasTag("dead"))
		{
			this.setVelocity(Vec2f_zero);
		}
	}
}