f32 onHit( CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData )
{
    CRules@ rules = getRules();
    if(rules.isWarmup() || rules.isIntermission())
        return 0.0f;
    return damage;

}
