// BumperPiston animation

namespace BumperPiston
{
	enum State
	{
		idle = 0,
		bounce,
	}
}

void onTick( CSprite@ this )
{
    u8 state = this.getBlob().get_u8("BumperPistonState");

    //let the current anim finish
    if (this.isAnimationEnded())
    {
        if (state == BumperPiston::bounce)
        {
            this.SetAnimation("bounce");
            this.animation.SetFrameIndex(0);
        }
        else if (state == BumperPiston::idle)
        {
            if (this.isAnimation("bounce")) {
                this.SetAnimation("default");
            }
            else if (!this.isAnimation("default")) {
                this.SetAnimation("default");
            }
        }
    }
}
