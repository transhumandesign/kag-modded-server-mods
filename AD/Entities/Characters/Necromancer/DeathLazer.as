#include "Hitters.as"

void onInit(CBlob@ this)
{
    this.set_u16("target", 0xffff);
    if(getNet().isServer())
        this.Sync("target", true);

    if(getNet().isClient())
    {
     
        CSprite@ sprite = this.getSprite();
        sprite.SetZ(-1.5);
        CSpriteLayer@ lazer = sprite.addSpriteLayer("lazer", "deathlazer.png", 32, 8);
		Animation@ anim = lazer.addAnimation("default", 0, false);
		anim.AddFrame(0);
		lazer.SetRelativeZ(-1.5f);
		lazer.SetVisible(false);
        lazer.SetOffset(Vec2f(-6, -6));

    }

}

void onTick(CBlob@ this)
{
    if(getNet().isServer() && getGameTime()%5 == 0)
    {
        u16 target = this.get_u16("target");
        u16 newtarget = 0xffff;
        bool sameTarget = false;

        CMap@ map = getMap();
        CBlob@[] targets;
        if(map.getBlobsInRadius(this.getPosition(), 120.0f, @targets))
        {
            for(int i = 0; i < targets.size(); i++)
            {
                CBlob@ b = targets[i];
                if(b !is null && b.hasTag("player") && !b.hasTag("dead")
                    && b.getTeamNum() != this.getTeamNum())
                {
                    if(target == b.getNetworkID())
                    {
                        sameTarget = true;
                        break;

                    }
                    else
                    {
                        newtarget = b.getNetworkID();

                    }

                }

            }

            if(!sameTarget)
            {
                target = newtarget;
                this.set_u16("target", target);
                this.Sync("target", true);


            }

        }
        else
        {
            target = 0xffff;
            this.Sync("target", true);

        }

        if(target == 0xffff)
            return;

        CBlob@ b = getBlobByNetworkID(target);
        if(b !is null)
        {
            this.server_Hit(b, b.getPosition(), Vec2f(0, 0), 0.5, Hitters::burn, false);

        }

    }

    if(getNet().isClient())
    {
        u16 target = this.get_u16("target");
        CSprite@ sprite = this.getSprite();
        CSpriteLayer@ lazer = sprite.getSpriteLayer("lazer");

        if(target == 0xffff)
        {
            lazer.SetVisible(false);
            return;

        }

        CBlob@ b = getBlobByNetworkID(target);


        if(b !is null)
        {

            this.SetFacingLeft(b.getPosition().x < this.getPosition().x);
            
            Vec2f shootPos = this.getPosition();
            shootPos.x += this.isFacingLeft() ? -6 : 6;
            shootPos.y += -6;

            lazer.SetVisible(true);
            Vec2f off = b.getPosition() - shootPos;
            f32 len = off.Length()/32.0f;
            lazer.ResetTransform();
            lazer.ScaleBy(Vec2f(len, 1.0f));
            lazer.TranslateBy(Vec2f(len * 16.0f, 0.0f));
            lazer.RotateBy(-off.Angle() , Vec2f(0, 0));

            if(getGameTime()%10 == 0)
            {
                ParticleZombieLightning(b.getPosition());

            }

        }
        else
        {
		    lazer.SetVisible(false);

        }

    }

}

bool doesCollideWithBlob( CBlob@ this, CBlob@ blob)
{
    return (blob.getTeamNum() != this.getTeamNum() &&
        blob.hasTag("player") && !blob.hasTag("dead"));

}
