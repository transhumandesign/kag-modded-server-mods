#include "/Entities/Common/Attacks/Hitters.as";	   
#include "/Entities/Common/Attacks/LimitedAttacks.as";

const int pierce_amount = 8;

const f32 hit_amount_ground = 0.2f;
const f32 hit_amount_air = 3.0f;
const f32 hit_amount_cata = 10.0f;

void onInit( CBlob @ this )
{
    this.set_u8("launch team",255);
    //this.server_setTeamNum(1);
	this.Tag("medium weight");
    
    LimitedAttack_setup(this);
    
    this.set_u8( "blocks_pierced", 0 );
    u32[] tileOffsets;
    this.set( "tileOffsets", tileOffsets );
    
    // damage
    this.set_f32("hit dmg modifier", hit_amount_ground);
	this.set_f32("map dmg modifier", 0.0f); //handled in this script
	this.set_u8("hurtoncollide hitter", Hitters::boulder);


	this.getShape().SetRotationsAllowed(true);
	this.getShape().getVars().waterDragScale = 8.0f;
	this.getShape().getConsts().collideWhenAttached = true;
	
	this.set_f32("explosive_radius",96.0f);
	this.set_f32("explosive_damage",10.0f);
	this.set_string("custom_explosion_sound", "Entities/Items/Explosives/KegExplosion.ogg");
	this.set_f32("map_damage_radius", 64.0f);
	this.set_f32("map_damage_ratio", 0.4f);
	this.set_bool("map_damage_raycast", true);
	this.set_bool("explosive_teamkill", false);
    this.Tag("exploding");

    this.set_Vec2f("fall_vector", Vec2f((XORRandom(400) - 200), 0));

	this.getCurrentScript().runFlags |= Script::tick_not_attached;
	this.getCurrentScript().tickFrequency = 3;
}

void onTick( CBlob@ this)
{
    SColor lightColor = SColor( 255, 255, 150, 0);
    this.SetLightColor( lightColor );
	//rock and roll mode
	if (!this.getShape().getConsts().collidable)
	{
		Vec2f vel = this.getVelocity();
		f32 angle = vel.Angle();
		Slam( this, angle, vel, this.getShape().vellen * 1.5f );
	}
	//normal mode
	else if (!this.isOnGround() && !this.isInWater())
	{
		this.set_f32("hit dmg modifier", hit_amount_air);
	}
	else
	{
		this.set_f32("hit dmg modifier", hit_amount_ground);
        if (getNet().isServer()) {
            Boom( this );
        }
	}

	this.AddForce( this.get_Vec2f("fall_vector") );
	makeSmokePuff(this);
}

void onCollision( CBlob@ this, CBlob@ blob, bool solid )
{
    f32 vellen = this.getOldVelocity().Length();
	Boom( this );
}

void makeSmokeParticle(CBlob@ this, const Vec2f vel, const string filename = "Smoke")
{
	if(!getNet().isClient()) return;
	//warn("making smoke");

	const f32 rad = this.getRadius();
	Vec2f random = Vec2f( XORRandom(128)-64, XORRandom(128)-64 ) * 0.015625f * rad;
	ParticleAnimated( "Smoke.png", this.getPosition() + random, vel, float(XORRandom(360)), 1.0f, 2 + XORRandom(3), -0.1f, false );
	//warn("smoke made");
}

void makeSmokePuff(CBlob@ this, const f32 velocity = 1.0f, const int smallparticles = 10, const bool sound = true)
{
	if (sound)
	{
		this.getSprite().PlaySound("Steam.ogg");
	}

	//makeSmokeParticle(this, Vec2f(), "Smoke");
	//for (int i = 0; i < smallparticles; i++)
	{
		f32 randomness = (XORRandom(32) + 32)*0.015625f * 0.5f + 0.75f;
		Vec2f vel = getRandomVelocity( -90, velocity * randomness, 360.0f );
		makeSmokeParticle(this, vel);
	}
}

void Boom( CBlob@ this )
{
    this.server_SetHealth(-1.0f);
    this.server_Die();
}

void Slam( CBlob @this, f32 angle, Vec2f vel, f32 vellen )
{
	if(vellen < 0.1f)
		return;

	CMap@ map = this.getMap();
	Vec2f pos = this.getPosition();
    HitInfo@[] hitInfos;
	u8 team = this.get_u8("launch team");

    if (map.getHitInfosFromArc( pos, -angle, 30, vellen, this, false, @hitInfos ))
    {
        for (uint i = 0; i < hitInfos.length; i++)
        {
            HitInfo@ hi = hitInfos[i];
            f32 dmg = 2.0f;

            if (hi.blob is null) // map
            {
            	if (BoulderHitMap( this, hi.hitpos, hi.tileOffset, vel, dmg, Hitters::cata_boulder ))
					return;
            }
			else if(team != u8(hi.blob.getTeamNum()))
			{
				this.server_Hit( hi.blob, pos, vel, dmg, Hitters::cata_boulder, true);
				this.setVelocity(vel*0.9f); //damp

				// die when hit something large
				if (hi.blob.getRadius() > 32.0f) {
					this.server_Hit( this, pos, vel, 10, Hitters::cata_boulder, true);
				}
			}
        }
    }

	// chew through backwalls

	Tile tile = map.getTile( pos );	 
	if (map.isTileBackgroundNonEmpty( tile ) )
	{			   
		if (map.getSectorAtPosition( pos, "no build") !is null) {
			return;
		}
		map.server_DestroyTile( pos + Vec2f( 7.0f, 7.0f), 10.0f, this );
		map.server_DestroyTile( pos - Vec2f( 7.0f, 7.0f), 10.0f, this );
	}
}

bool BoulderHitMap( CBlob@ this, Vec2f worldPoint, int tileOffset, Vec2f velocity, f32 damage, u8 customData )
{
    //check if we've already hit this tile
    u32[]@ offsets;
    this.get( "tileOffsets", @offsets );

    if( offsets.find(tileOffset) >= 0 ) { return false; }

    this.getSprite().PlaySound( "ArrowHitGroundFast.ogg" );
    f32 angle = velocity.Angle();
    CMap@ map = getMap();
    TileType t = map.getTile(tileOffset).type;
    u8 blocks_pierced = this.get_u8( "blocks_pierced" );
    bool stuck = false;

    if ( map.isTileCastle(t) || map.isTileWood(t) )
    {
		Vec2f tpos = this.getMap().getTileWorldPosition(tileOffset);
		if (map.getSectorAtPosition( tpos, "no build") !is null) {
			return false;
		}

		//make a shower of gibs here
		
        map.server_DestroyTile( tpos, 100.0f, this );
        Vec2f vel = this.getVelocity();
        this.setVelocity(vel*0.8f); //damp
        this.push( "tileOffsets", tileOffset );

        if (blocks_pierced < pierce_amount)
        {
            blocks_pierced++;
            this.set_u8( "blocks_pierced", blocks_pierced );
        }
        else {
            stuck = true;
        }
    }
    else
    {
        stuck = true;
    }

	if (velocity.LengthSquared() < 5)
		stuck = true;		

    if (stuck)
    {
       this.server_Hit( this, worldPoint, velocity, 10, Hitters::crush, true);
    }

	return stuck;
}

//sprite

void onInit( CSprite@ this )
{
    this.animation.frame = (this.getBlob().getNetworkID()%4);
	this.getCurrentScript().runFlags |= Script::remove_after_this;
}
