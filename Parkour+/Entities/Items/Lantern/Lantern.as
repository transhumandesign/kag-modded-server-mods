// Lantern script

void onInit(CBlob@ this)
{
	this.SetLight(true);
	this.SetLightRadius(96.0f);
	this.SetLightColor(SColor(255, 255, 240, 171));

	this.Tag("fire source");
}

