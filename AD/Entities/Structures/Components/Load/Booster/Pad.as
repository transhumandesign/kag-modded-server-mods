// Pad.as

void onInit(CSprite@ this)
{
	CSpriteLayer@ layer = this.addSpriteLayer("blood", "Pad.png", 8, 8);
	layer.addAnimation("default", 0, false);
	layer.animation.AddFrame(1);
	layer.SetVisible(false);
}
