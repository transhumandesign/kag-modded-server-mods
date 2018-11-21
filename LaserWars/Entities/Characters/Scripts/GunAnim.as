/* GunInfo.as
 * author: Aphelion
 */

#include "GunsCommon.as";
#include "Utils.as";

#include "SoldierCommon.as";
#include "WorkerCommon.as";
#include "GunCommon.as";
#include "Knocked.as";

#include "Requirements.as";

void onInit( CSprite@ this )
{
	this.RemoveSpriteLayer("muzzle");
	CSpriteLayer@ muzzle = this.addSpriteLayer("muzzle", "Weapons_Muzzle.png", 32, 16, this.getBlob().getTeamNum(), this.getBlob().getSkinNum());

	if (muzzle !is null)
	{
		Animation@ anim = muzzle.addAnimation("default", 0, false);
		anim.AddFrame(0);
		
		muzzle.SetRelativeZ(500);
		muzzle.SetVisible(false);
	}

	this.RemoveSpriteLayer(weapon_layer);
	CSpriteLayer@ weapon = this.addSpriteLayer(weapon_layer, "Weapons.png", 32, 16, this.getBlob().getTeamNum(), this.getBlob().getSkinNum());

	if (weapon !is null)
	{
		Animation@ anim = weapon.addAnimation("default", 0, false);
		for (uint i = 0; i < 20; i++)
		{
			anim.AddFrame(i);
		}
		
		weapon.SetRelativeZ(1);
		weapon.SetVisible(false);
	}
}

void UpdateLayers( CSprite@ this, CBlob@ blob, CSpriteLayer@ layer, GunInfo@ gunInfo, bool visible )
{
	CBlob@ localBlob = getLocalPlayerBlob();
	
	if (blob.isMyPlayer() || (localBlob !is null && localBlob.getTeamNum() == blob.getTeamNum()))
	{
		layer.SetVisible(visible);
		layer.setRenderStyle(blob.hasTag("cloaked") ? RenderStyle::light : RenderStyle::normal);
	}
	else
	{
	    layer.SetVisible(visible && !blob.hasTag("cloaked"));
	}

	if (visible)
	{
		string exosuit = getItem(blob, ItemType::EXO_SUIT);

		ExoSuit@ suit = getSuit(exosuit);

		if (suit !is null)
		{
			f32 direction = (blob.isFacingLeft() ? 1.0f : -1.0f);
			Vec2f rotationOffset = Vec2f(gunInfo.rotationOffset.x * direction, gunInfo.rotationOffset.y);
			Vec2f origin = getGunOrigin(this);

			CSpriteLayer@ muzzle = this.getSpriteLayer("muzzle");
			{
				f32 armangle = getArmAngle(this, blob);
				Vec2f offset = origin + suit.gun_offset + Vec2f(0, gunInfo.bulletOffset.y);

				//muzzle.SetVisible(g_debug != 0);
				muzzle.ResetTransform();
				muzzle.RotateBy(armangle, rotationOffset);
				muzzle.SetOffset(blob.isFacingLeft() ? Vec2f(-offset.x, offset.y) : offset);
				muzzle.animation.frame = gunInfo.frame;
			}
			{
				f32 armangle = getArmAngle(this, blob, blob.getPosition() + muzzle.getOffset());
				Vec2f offset = origin + suit.gun_offset;

				layer.ResetTransform();
				layer.RotateBy(armangle, rotationOffset);
				layer.SetOffset(offset);
				layer.animation.frame = gunInfo.frame;
			}
		}
	}
}

void onRender( CSprite@ this )
{
	if (g_debug == 0) return;

	CBlob@ blob = this.getBlob();

	CSpriteLayer@ muzzle = this.getSpriteLayer("muzzle");
	CSpriteLayer@ weapon = this.getSpriteLayer("weapon layer");
	if           (muzzle is null ||
		          weapon is null) return;
    
    //GUI::DrawLine(blob.getPosition() + weapon.getOffset(), blob.getAimPos(), SColor(255, 0, 255, 0));
    GUI::DrawArrow(blob.getPosition() + muzzle.getOffset(), blob.getAimPos(), SColor(255, 255, 0, 0));
}

void onTick( CSprite@ this )
{
    CBlob@ blob = this.getBlob();
	
	const int type = getActiveType(blob);
	const string item = getItem(blob, type);

	GunInfo@ gunInfo = getGunInfoByName(item);

	CSpriteLayer@ weapon = this.getSpriteLayer(weapon_layer);

	if (weapon !is null)
	{
	    UpdateLayers(this, blob, weapon, gunInfo, gunInfo !is null);
	}
}
