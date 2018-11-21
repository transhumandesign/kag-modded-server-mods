//Dash v1.0 by Strathos
 
#include "MakeDustParticle.as";
#include "ActorHUDStartPos.as";
 
const u16 DASH_COOLDOWN=    15;//seconds*30
const u16 DASH_MAX=         2;//seconds*30
const f32 DASH_FORCE=   95.0f;//force applied
 
void onInit(CBlob@ this)
{
    this.set_u8( "dashCoolDown", 0 );
    this.set_u8( "dashesDone", 0 );
    this.getCurrentScript().removeIfTag=    "dead";
}
void onTick( CBlob@ this )
{
    u8 dashesDone=this.get_u8("dashesDone");
    bool onGround=  this.isOnGround() || this.isOnLadder();
    Vec2f aimPos=   this.getAimPos();
    Vec2f pos=      this.getPosition();
    Vec2f vel=      this.getVelocity();
 
    if( dashesDone<DASH_MAX )
    {
        if (this.isKeyPressed( key_action2 ))
        {
            this.set_u8("dashesDone",dashesDone+1);
            this.set_u8( "dashCoolDown", 0 );
            MakeDustParticle( pos + Vec2f( 0.0f, 9.0f ), "/DustSmall.png");
            this.getSprite().PlaySound("/Ha_A.ogg");//StoneStep7.ogg, changed to custom HA sound
            Vec2f force=ActualNormalize(aimPos-pos)*DASH_FORCE;
            this.AddForce(force);//Vec2f(Clamp(aimPos.x-pos.x,-1,1),Clamp(aimPos.x-pos.x,-1,1)) );
        }
    }
    else
    {
        u8 dashCoolDown = this.get_u8( "dashCoolDown" );
        this.set_u8( "dashCoolDown", ( dashCoolDown + 1 ) );
        if(dashCoolDown>DASH_COOLDOWN*1 && onGround){
            this.set_u8("dashesDone",0);
        }
    }
}
void onRender (CSprite@ this)
{
    CBlob@ blob=    this.getBlob();
    if(blob is null)
        return;
 
    Vec2f tl=   getActorHUDStartPosition(blob,6);
    float dashCoolDown= blob.get_u8("dashCoolDown");
    GUI::DrawProgressBar(tl,tl+Vec2f(160,35),dashCoolDown / DASH_COOLDOWN);
}
Vec2f ActualNormalize(Vec2f value)
{
    float dis=  Maths::Sqrt(value.x*value.x+value.y*value.y);
    return Vec2f(value.x/dis,value.y/dis);
}