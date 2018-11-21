#include "WaterEffects.as"

Random _r(1569815698); //clientside

void onGib(CSprite@ this)
{
	/**
	 register the 
	 */

	string effectname = "BV: Emit Blood";
	if(!CustomEmitEffectExists(effectname))
	{
		SetupCustomEmitEffect( effectname, "HumanGibs.as", "EmitBlood", 10, 5, 45 );
	}
	u8 emiteffect = GetCustomEmitEffectID(effectname);

	CBlob@ blob = this.getBlob();
    Vec2f pos = blob.getPosition();
    Vec2f vel = blob.getVelocity() * 0.5f;

    const u8 team = blob.getTeamNum();
    
    for(int i = 0; i < 10; i++)
    {
    	Vec2f veladd(0,_r.NextFloat() + 0.1f * (i+1));
    	veladd.RotateBy(_r.NextFloat() * 360.0f, Vec2f());

	    CParticle@ gib     = makeGibParticle( "worker_gibs.png",
	    										pos,
	    										vel + veladd,
	    										(i < 4 ? i : _r.NextRanged(4)),
	    										(i < 4 ? 0 : 2) + _r.NextRanged(2),
	    										Vec2f (8,8),
	    										0.0f,
	    										20,
	    										"/BodyGibFall",
	    										team );

	    if(gib !is null)
	    {
	    	gib.damping = 0.95f;
	    	
	    	gib.freerotation = false;
	    	gib.rotation = gib.velocity;
	    	gib.rotation.Normalize();

	    	gib.timeout = 20 + _r.NextRanged(90);

	    	gib.emiteffect = emiteffect;

	    	gib.Z = 5.0f + _r.NextFloat();
	    	gib.AddDieFunction("HumanGibs.as", "CreateWaterSplash");
	    }
	}
}

void CreateWaterSplash(CParticle@ p)
{
	MakeWaterParticle(p.position, p.velocity*0.5f);
}

void EmitBlood(CParticle@ p)
{
	Vec2f veladd(0,_r.NextFloat() * 0.1f);
    veladd.RotateBy(_r.NextFloat() * 360.0f, Vec2f());

	CParticle@ pixel = ParticlePixel(p.position, p.velocity*0.1f + veladd, SColor(255, 86+_r.NextRanged(80), 0, 0), true);
	if (pixel !is null){
		pixel.Z = p.Z - 0.1f;
	}
}