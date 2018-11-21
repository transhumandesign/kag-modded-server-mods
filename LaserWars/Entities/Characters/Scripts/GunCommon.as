/* GunCommon.as
 * author: Aphelion
 */

#include "GunsCommon.as";

const string weapon_layer = "weapon layer";

namespace GunCommon
{
	enum Cmd
	{
		SHOOT = 98,
		SWAP_WEAPON = 99,
	};

	const f32 AUDIO_THRESHOLD = 20.0f * 8.0f;
}

Vec2f getGunOrigin( CSprite@ this )
{
	Vec2f origin;
	
    PixelOffset@ po = getDriver().getPixelOffset(this.getFilename(), this.getFrame());
	if (po !is null)
	{
		origin.Set(this.getFrameWidth() / 2, -this.getFrameHeight() / 2);
		origin += this.getOffset();
		origin += Vec2f(-po.x, po.y);
	}
	return origin;
}

f32 getArmAngle( CSprite@ this, CBlob@ blob )
{
	return getArmAngle(this, blob, blob.getPosition());
}

f32 getArmAngle( CSprite@ this, CBlob@ blob, Vec2f pos )
{
	Vec2f vec = blob.getAimPos() - pos;
	f32 angle = vec.Angle();
	f32 armangle = -angle;
	
	if (this.isFacingLeft())
		armangle = 180.0f - angle;
	
	while (armangle > 180.0f)
		armangle -= 360.0f;

	while (armangle < -180.0f)
		armangle += 360.0f;
	
    return armangle;
}

f32 getAimAngle( CBlob@ this, Vec2f pos )
{
 	Vec2f aimvector = this.getAimPos() - pos;
    return this.isFacingLeft() ? -aimvector.Angle() + 180.0f : -aimvector.Angle();
}
