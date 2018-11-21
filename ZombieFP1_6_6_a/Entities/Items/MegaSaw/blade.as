
#include "Hitters.as";
#include "ShieldCommon.as";
#include "FireParticle.as"
#include "ArcherCommon.as";
#include "BombCommon.as";
#include "SplashWater.as";
#include "TeamStructureNear.as";
#include "Knocked.as"

const s32 bomb_fuse = 120;
const f32 arrowMediumSpeed = 8.0f;
const f32 arrowFastSpeed = 13.0f;
//maximum is 15 as of 22/11/12 (see ArcherCommon.as)

const f32 ARROW_PUSH_FORCE = 12.0f;
const f32 SPECIAL_HIT_SCALE = 1.0f;

const s32 FIRE_IGNITE_TIME = 5;


//Arrow logic

//blob functions
void onInit( CBlob@ this )
{
    CShape@ shape = this.getShape();
	ShapeConsts@ consts = shape.getConsts();
    consts.mapCollisions = false;	 // weh ave our own map collision
	consts.bullet = false;
	consts.net_threshold_multiplier = 4.0f;
	//shape.SetGravityScale( 0.5f );	doesnt work
	this.Tag("projectile");

	// 20 seconds of floating around - gets cut down for fire arrow
	// in ArrowHitMap
	this.server_SetTimeToDie( 20 );

	CSprite@ sprite = this.getSprite();
    //set a random frame
    {
		Animation@ anim = sprite.addAnimation("blade",0,false);
		anim.AddFrame(0);
		sprite.SetAnimation(anim);
	}
	this.set_f32("spin angle",0);
	
}

void onTick( CBlob@ this )
{
	CShape@ shape = this.getShape();
	Vec2f vel = this.get_Vec2f("initvel");
	this.setVelocity(vel);
	f32 angle;
	bool processSticking = true;
    if (!this.hasTag("collided")) //we haven't hit anything yet!
    {
        angle = (this.getVelocity()).Angle();
        Pierce( this ); //map
		int spin_angle = this.get_f32("spin angle");
		int not_stupid = (-angle+this.get_f32("spin angle")) % 360;
        this.setAngleDegrees(not_stupid);
		if (spin_angle <360) spin_angle+=30.0;
		spin_angle = spin_angle;
		this.set_f32("spin angle",spin_angle);
		
	//	printf("vell " + shape.vellen);
		if (shape.vellen > 0.0001f)
		{
			if (shape.vellen > 13.5f)
				shape.SetGravityScale( 0.1f );
			else
				shape.SetGravityScale( Maths::Min( 1.0f, 1.0f/(shape.vellen*0.1f) ) );

			processSticking = false;
		}	   		
    }
    
	
	// sticking
	if (processSticking)
    {
		//no collision
		shape.getConsts().collidable = false;
		
		if(!this.hasTag("_collisions"))
		{
			this.Tag("_collisions");
			// make everyone recheck their collisions with me
			const uint count = this.getTouchingCount();
			for (uint step = 0; step < count; ++step)
			{
				CBlob@ _blob = this.getTouchingByIndex(step);
				_blob.getShape().checkCollisionsAgain = true;
			}
		}
		
		angle = Maths::get360DegreesFrom256(this.get_u8( "angle" ));
		this.setVelocity(Vec2f(0,0));
		this.setPosition(this.get_Vec2f("lock"));
		shape.SetStatic(true);
		
    }

}

void onCollision( CBlob@ this, CBlob@ blob, bool solid, Vec2f normal, Vec2f point1 )
{
    if (blob !is null && doesCollideWithBlob( this, blob ) && !this.hasTag("collided"))
    {
		if ((blob.getName() != "tree_bushy") && (blob.getName() != "tree_pine") && (blob.getName() != "log") && !solid && !blob.hasTag("flesh") && !specialArrowHit(blob) && (blob.getName() != "mounted_bow" || this.getTeamNum() != blob.getTeamNum()))
		{
			return;
		}

		Vec2f initVelocity = this.getOldVelocity();
		f32 vellen = initVelocity.Length();
		if (vellen < 0.1f)
			return;
		
		f32 dmg = blob.getTeamNum() == this.getTeamNum() ? 0.0f : getArrowDamage( this, vellen );
		if ( blob.getName() != "log" ) 
		{
			// this isnt synced cause we want instant collision for arrow even if it was wrong
			if (blob.getName() != "tree_bushy" && blob.getName() != "tree_pine") { 
			dmg = ArrowHitBlob( this, point1, initVelocity, dmg, blob, Hitters::arrow, 0 );
			}
			if (dmg > 0.0f) {
				this.server_Hit( blob, point1, initVelocity, dmg, Hitters::saw);
			}
		}

		if (blob.getName() != "log"  && blob.getName() != "tree_bushy" && blob.getName() != "tree_pine") { // dont stick bomb arrows
			this.Tag("collided");
		}
		
		if ( blob.getName() == "log") 
		{
			blob.Tag("sawed");
			if (getNet().isServer())
			{
				CBlob @wood = server_CreateBlob( "mat_wood", this.getTeamNum(), this.getPosition() + Vec2f(0,12) );	
				if (wood !is null)
				{
					wood.server_SetQuantity( (blob.getHealth() / 0.014f) + 1 );
					wood.setVelocity( Vec2f(0, -4.0f) );
				}
				blob.server_SetHealth(-1.0f);
				blob.server_Die();
			}
			this.getSprite().PlaySound( "SawLog.ogg" );
		}
		else
		this.getSprite().PlaySound( "SawOther.ogg" );
	}
}

bool doesCollideWithBlob( CBlob@ this, CBlob@ blob )
{	   
	if (specialArrowHit(blob)) //anything to always hit
	{
		return true;
	}
	
	if (this.getTeamNum() != blob.getTeamNum() || (blob.getShape().isStatic() && !blob.getShape().getConsts().platform))
	{
		if (this.getShape().isStatic() || this.hasTag("collided") || blob.hasTag("dead")){
			return false;
		}
		return true;
	}
	return false;
}

bool specialArrowHit(CBlob@ blob)
{
	string bname = blob.getName();
	return (bname == "fishy" || bname == "food" || blob.hasTag("dead"));
}

void Pierce( CBlob @this )
{
    CMap@ map = this.getMap();
	Vec2f end;

	if (map.rayCastSolidNoBlobs(this.getShape().getVars().oldpos, this.getPosition() ,end))
	{
		ArrowHitMap( this, end, this.getOldVelocity(), 0.5f, Hitters::arrow );
	}
}


f32 ArrowHitBlob( CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitBlob, u8 customData, const u8 arrowType )
{
    if (hitBlob !is null)
    {
	
		if(specialArrowHit(hitBlob))
		{
			const f32 scale = SPECIAL_HIT_SCALE;
			f32 force = (ARROW_PUSH_FORCE * 0.125f) * Maths::Sqrt(hitBlob.getMass() + 1) * scale;
			if (this.hasTag("bow arrow"))
			{
				force *= 1.3f;
			}

			hitBlob.AddForce(velocity * force);

			//die
			this.server_Hit(this, this.getPosition(), Vec2f(), 1.0f, Hitters::crush);
		}
		
		// check if shielded
		const bool hitShield = false;//(hitBlob.hasTag("shielded") && blockAttack(hitBlob, velocity, 0.0f));

        CSprite@ sprite = hitBlob.getSprite();
        if (sprite !is null && !hitShield && arrowType != ArrowType::bomb)
        {
            CSpriteLayer@ arrow = sprite.addSpriteLayer( "arrow", "/blade.png", 16, 16, this.getTeamNum(), this.getSkinNum() );

            if (arrow !is null)
            {
                Animation@ anim = arrow.addAnimation( "default", 0, true );

                if (this.getSprite().animation !is null) {
                    anim.AddFrame(0);    //always use broken frame
                }
                else
                {
                    warn("exception: arrow has no anim");
                    anim.AddFrame(0);
                }

                arrow.SetAnimation( anim );
				Vec2f normal = worldPoint-hitBlob.getPosition();
				f32 len = normal.Length();
				if (len > 0.0f)
					normal /= len;
                Vec2f soffset = normal * (len + 0);

				// wow, this is shit
				// movement existing makes setfacing matter?
                if(hitBlob.getMovement() is null)
                {
                   // soffset.x *= -1;
                    arrow.RotateBy(180.0f, Vec2f(0,0));
					arrow.SetFacingLeft(true);
                }
				else
				{
					soffset.x *= -1;
					arrow.SetFacingLeft(false);
				}
				
				arrow.SetIgnoreParentFacing(true); //dont flip when parent flips


                arrow.SetOffset(soffset);
                arrow.SetRelativeZ(-0.01f);

                f32 angle = velocity.Angle();
                arrow.RotateBy(-angle - hitBlob.getAngleDegrees(), Vec2f(0,0));
            }
        }

/*
		// play sound
		if (!hitShield)
		{
			if (hitBlob.hasTag("flesh"))
			{
				{
					if (velocity.Length() > arrowFastSpeed) {
						this.getSprite().PlaySound( "ArrowHitFleshFast.ogg" );
					}
					else {
						this.getSprite().PlaySound( "ArrowHitFlesh.ogg" );
					}
				}
			}
			else
			{
				if (velocity.Length() > arrowFastSpeed) {
					this.getSprite().PlaySound( "ArrowHitGroundFast.ogg" );
				}
				else {
					this.getSprite().PlaySound( "ArrowHitGround.ogg" );
				}
			}
		}
		else {
			if (arrowType != ArrowType::normal)
				damage = 0.0f;
		}*/
        {
			this.getShape().SetStatic(true); // for client
            this.getSprite().SetVisible(false);
            this.doTickScripts = false;
            this.server_Die();
        }

    }

	return damage;
}

void ArrowHitMap( CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, u8 customData )
{
	if (velocity.Length() > arrowFastSpeed) {
		this.getSprite().PlaySound( "ArrowHitGroundFast.ogg" );
	}
	else {
		this.getSprite().PlaySound( "ArrowHitGround.ogg" );
	}

	f32 radius = this.getRadius();

	f32 angle = velocity.Angle();

	this.set_u8( "angle", Maths::get256DegreesFrom360(angle)  );

	Vec2f norm = velocity;
	norm.Normalize();
	norm *= (1.5f * radius);
	Vec2f lock = worldPoint - norm;
	this.set_Vec2f( "lock", lock );

	this.Sync("lock",true);
	this.Sync("angle",true);

	this.setVelocity(Vec2f(0,0));
	this.setPosition(lock);
	//this.getShape().server_SetActive( false );
	this.getShape().SetStatic(true); // for client

	this.Tag("collided");

	const u8 arrowType = this.get_u8("arrow type");
	if (arrowType == ArrowType::bomb)
	{
		if(!this.hasTag("dead"))
		{
			this.getShape().SetStatic(true); // for client
			this.getSprite().SetVisible(false);
			this.doTickScripts = false;
			this.server_Die(); //explode
		}
		this.Tag("dead");
	}
	else if (arrowType == ArrowType::water)
	{
		SplashArrow(this);
	}
	else if (arrowType == ArrowType::fire)
	{
		this.server_SetTimeToDie( FIRE_IGNITE_TIME );
	}

	this.set_Vec2f( "fire pos", (worldPoint + (norm * 0.5f) ) );
}

void FireUp( CBlob@ this )
{
	Vec2f burnpos;
	Vec2f head = Vec2f(this.getRadius()*1.2f,0.0f);
	f32 angle = this.getAngleDegrees();
	head.RotateBy( -angle );
	burnpos = this.getPosition() + head;


	// this.getMap() NULL ON ONDIE!
	CMap@ map = getMap();
	if (map !is null)
	{
		// bruninate
		if (!isTeamStructureNear( this ))
		{
			map.server_setFireWorldspace( burnpos,true );
			map.server_setFireWorldspace( this.get_Vec2f( "fire pos" ) + head*0.4f,true );
			map.server_setFireWorldspace( this.getPosition() ,true); //burn where i am as well
		}
	}
}

void onDie( CBlob@ this )
{
	const u8 arrowType = this.get_u8("arrow type");
	if (arrowType == ArrowType::fire) {
		FireUp(this);
	}
}

void onThisAddToInventory( CBlob@ this, CBlob@ inventoryBlob )
{
    if (!getNet().isServer()) {
        return;
    }

	const u8 arrowType = this.get_u8("arrow type");
	if (arrowType == ArrowType::bomb)
	{
		return;
	}

    // merge arrow into mat_arrows

    for (int i = 0; i < inventoryBlob.getInventory().getItemsCount(); i++)
    {
        CBlob @blob = inventoryBlob.getInventory().getItem(i);

        if (blob !is this && blob.getName() == "mat_arrows")
        {
            blob.server_SetQuantity( blob.getQuantity() + 1 );
            this.server_Die();
            return;
        }
    }

    // mat_arrows not found
    // make arrow into mat_arrows
    CBlob @mat = server_CreateBlob( "mat_arrows" );

    if (mat !is null)
    {
        inventoryBlob.server_PutInInventory( mat );
        mat.server_SetQuantity(1);
        this.server_Die();
    }
}

f32 onHit( CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData )
{
	const u8 arrowType = this.get_u8("arrow type");
	
    return damage;
}

void onHitBlob( CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitBlob, u8 customData )
{
	const u8 arrowType = this.get_u8("arrow type");
	// unbomb, stick to blob
	if (this !is hitBlob && customData == Hitters::arrow)
	{
		// affect players velocity
		
		const f32 scale = specialArrowHit(hitBlob) ? SPECIAL_HIT_SCALE : 1.0f;
		
		Vec2f vel = velocity;
		const f32 speed = vel.Normalize();
		if (speed > ArcherParams::shoot_max_vel*0.5f)
		{	
			f32 force = (ARROW_PUSH_FORCE * 0.125f) * Maths::Sqrt(hitBlob.getMass()+1);
			
			if (this.hasTag("bow arrow")) {
				force *= 1.3f;
			}

			hitBlob.AddForce( velocity * force );

			//printf("this " + this.getTickSinceCreated() );
			//printf(" " + hitBlob.isOnGround() + " " + vel.y + " " + speed);

			// stun if shot real close

			if (this.getTickSinceCreated() <= 4 && speed > ArcherParams::shoot_max_vel*0.845f &&
				hitBlob.hasTag("player") )
			{
				SetKnocked( hitBlob, 20 );
				Sound::Play("/Stun", hitBlob.getPosition(), 1.0f, this.getSexNum() == 0 ? 1.0f : 2.0f);	
			}
		}
	}
}


f32 getArrowDamage( CBlob@ this, f32 vellen = -1.0f )
{
	return 5.0;
	if(vellen < 0) //grab it - otherwise use cached
	{
		CShape@ shape = this.getShape();
		if(shape is null)
			vellen = this.getOldVelocity().Length();
		else
			vellen = this.getShape().getVars().oldvel.Length();
	}
	
    if (vellen >= arrowFastSpeed) {
        return 1.0f;
    }
    else if (vellen >= arrowMediumSpeed) {
        return 1.0f;
    }

    return 0.5f;
}

void SplashArrow( CBlob@ this )
{
	Splash( this, 2, 2, 0.7f );
	this.getSprite().PlaySound( "GlassBreak" );
	this.server_Die();
	//TODO: glass break noise and gibs;
}
