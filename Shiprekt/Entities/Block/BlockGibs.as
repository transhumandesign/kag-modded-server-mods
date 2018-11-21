#include "WaterEffects.as"
#include "BlockCommon.as"

Random _r(1569815698); //clientside

void onGib(CSprite@ this)
{
	u8 frame = this.getFrame();

	//no gibs tiles
	if(frame == Block::COUPLING)
		return;

    CBlob@ blob = this.getBlob();
    Vec2f pos = blob.getPosition();
    Vec2f vel = blob.getVelocity();

    const u8 team = blob.getTeamNum();
    
    for(int i = 0; i < 3; i++)
    {
    	Vec2f veladd(0,_r.NextFloat() + 0.1f * (i+1));
    	veladd.RotateBy(_r.NextFloat() * 360.0f, Vec2f());

	    CParticle@ gib     = makeGibParticle( "BlockGibs.png",
	    										pos,
	    										vel + veladd,
	    										0,
	    										_r.NextRanged(8),
	    										Vec2f (8,8),
	    										2.0f,
	    										0,
	    										"/BodyGibFall",
	    										team );

	    if(gib !is null)
	    {
	    	gib.damping = 0.95f;
	    	
	    	gib.freerotation = false;
	    	gib.rotation = gib.velocity;
	    	gib.rotation.Normalize();

	    	gib.timeout = 20 + _r.NextRanged(90);

	    	gib.Z = -5.0f + _r.NextFloat();
	    	gib.AddDieFunction("BlockGibs.as", "CreateWaterSplash");
	    }
	}
}

void CreateWaterSplash(CParticle@ p)
{
	MakeWaterParticle(p.position, p.velocity*0.5f);
}