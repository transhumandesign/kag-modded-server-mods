#include "TreeDeeMap.as";

#define CLIENT_ONLY

Vertex[] RedFlash_vertexes = {Vertex(0,0,10,0,0,SColor(0x00FFFFFF)),Vertex(getScreenWidth(),0,10,1,0,SColor(0x00FFFFFF)),Vertex(getScreenWidth(),getScreenHeight(),10,1,1,SColor(0x00FFFFFF)),Vertex(0,getScreenHeight(),10,0,1,SColor(0x00FFFFFF))};

class BasicHUD
{
	Vertex[] gun_vertexes;
	
	Vertex[] crosshair_vertexes;
	
	Vertex[] backhud_vertexes;
	Vertex[] backhud_numbers_vertexes;
	
	BasicHUD()
	{
		Vec2f ScS = Vec2f(getDriver().getScreenWidth(), getDriver().getScreenHeight());
		Vertex[] _gun_vertexes = {Vertex(ScS.x/2-(ScS.y-ScS.y/2)/2+(ScS.y-ScS.y/2)/128, ScS.y/2, 0, 0, 0, color_white),Vertex(ScS.x/2+(ScS.y-ScS.y/2)/2+(ScS.y-ScS.y/2)/128, ScS.y/2, 0, 1.000f/3, 0, color_white),Vertex(ScS.x/2+(ScS.y-ScS.y/2)/2+(ScS.y-ScS.y/2)/128, ScS.y,   0, 1.000f/3, 1, color_white),Vertex(ScS.x/2-(ScS.y-ScS.y/2)/2+(ScS.y-ScS.y/2)/128, ScS.y,   0, 0, 1, color_white)};
		Vertex[] _crosshair_vertexes = {Vertex(ScS.x/2-16, ScS.y/2-16, 0,	0, 0, color_white),Vertex(ScS.x/2+16, ScS.y/2-16, 0,	1, 0, color_white),Vertex(ScS.x/2+16, ScS.y/2+16, 0,	1, 1, color_white),Vertex(ScS.x/2-16, ScS.y/2+16, 0,	0, 1, color_white)};
		
		f32 scale = int(getDriver().getScreenHeight()/48.0f)/10.0f;
		//print("scale: "+scale);
		Vertex[] _backhud_vertexes = {	Vertex(0, getDriver().getScreenHeight()-(48*scale), 0,	0, 0, color_white),
										Vertex(96*scale, getDriver().getScreenHeight()-(48*scale), 0,	1, 0, color_white),
										Vertex(96*scale, getDriver().getScreenHeight(), 0,	1, 1, color_white),
										Vertex(0, getDriver().getScreenHeight(), 0,	0, 1, color_white)};
		
		Vertex[] _backhud_numbers_vertexes = {	Vertex(8*scale, 					getDriver().getScreenHeight()-(32*scale)-(8*scale), 0,	0, 0, color_white),
												Vertex(32*scale+(8*scale),			getDriver().getScreenHeight()-(32*scale)-(8*scale), 0,	0.1, 0, color_white),
												Vertex(32*scale+(8*scale), 			getDriver().getScreenHeight()-(8*scale), 0,				0.1, 1, color_white),
												Vertex(8*scale, 					getDriver().getScreenHeight()-(8*scale), 0,				0, 1, color_white),
												
												Vertex(8*scale+20*scale, 			getDriver().getScreenHeight()-(32*scale)-(8*scale), 0,	0, 0, color_white),
												Vertex(32*scale+(8*scale)+20*scale, getDriver().getScreenHeight()-(32*scale)-(8*scale), 0,	0.1, 0, color_white),
												Vertex(32*scale+(8*scale)+20*scale, getDriver().getScreenHeight()-(8*scale), 0,				0.1, 1, color_white),
												Vertex(8*scale+20*scale, 			getDriver().getScreenHeight()-(8*scale), 0,				0, 1, color_white),
												
												Vertex(8*scale+40*scale, 			getDriver().getScreenHeight()-(32*scale)-(8*scale), 0,	0, 0, color_white),
												Vertex(32*scale+(8*scale)+40*scale, getDriver().getScreenHeight()-(32*scale)-(8*scale), 0,	0.1, 0, color_white),
												Vertex(32*scale+(8*scale)+40*scale,	getDriver().getScreenHeight()-(8*scale), 0,				0.1, 1, color_white),
												Vertex(8*scale+40*scale, 			getDriver().getScreenHeight()-(8*scale), 0,				0, 1, color_white)};

		this.gun_vertexes = _gun_vertexes;
		this.crosshair_vertexes = _crosshair_vertexes;
		this.backhud_vertexes = _backhud_vertexes;
		this.backhud_numbers_vertexes = _backhud_numbers_vertexes;
		
		if(!Texture::exists("Pistol0"))
			Texture::createFromFile("Pistol0", "Pistol0.png");
		if(!Texture::exists("Pistol1"))
			Texture::createFromFile("Pistol1", "Pistol1.png");
		if(!Texture::exists("Crosshair"))
			Texture::createFromFile("Crosshair", "Crosshair.png");
		if(!Texture::exists("HUDback"))
			Texture::createFromFile("HUDback", "HUDback.png");
		if(!Texture::exists("num0"))
			Texture::createFromFile("num0", "num0.png");
		if(!Texture::exists("num1"))
			Texture::createFromFile("num1", "num1.png");
	}
	
	void DrawBHUD(string type, u8 team, Vec2f height)
    {
		Render::RawQuads("Crosshair", this.crosshair_vertexes);
		Render::RawQuads("HUDback", this.backhud_vertexes);
		Render::RawQuads("num"+team, this.backhud_numbers_vertexes);
		float[] model;
		Matrix::MakeIdentity(model);
		Matrix::SetTranslation(model, height.x, height.y, 0);
		Render::SetModelTransform(model);
		Render::RawQuads("Pistol"+team, this.gun_vertexes);
		
    }
	
	void SetHPNumFrame(int index)
	{
		int num0 = index/100;
		int num1 = (index/10) % 10;
		int num2 = index % 10;
		//print(": "+num0+" "+num1+" "+num2);
		backhud_numbers_vertexes[0].u = backhud_numbers_vertexes[3].u = 0.1f*num0;
		backhud_numbers_vertexes[1].u = backhud_numbers_vertexes[2].u = 0.1f*num0+(num0 == 0 ? (0.0f) : (0.1f));
		
		backhud_numbers_vertexes[4].u = backhud_numbers_vertexes[7].u = 0.1f*num1;
		backhud_numbers_vertexes[5].u = backhud_numbers_vertexes[6].u = 0.1f*num1+(num0 == 0 && num1 == 0 ? (0.0f) : (0.1f));
		
		backhud_numbers_vertexes[8].u = backhud_numbers_vertexes[11].u = 0.1f*num2;
		backhud_numbers_vertexes[9].u = backhud_numbers_vertexes[10].u = 0.1f*num2+0.1f;
	}
	
	void SetGunFrame(int index)
	{
		gun_vertexes[0].u = gun_vertexes[3].u = 1.000f/3*index;
		gun_vertexes[1].u = gun_vertexes[2].u = 1.000f/3*index+1.000f/3;
	}
	
	void SetGunColor(SColor color)
	{
		gun_vertexes[0].col = gun_vertexes[3].col = gun_vertexes[1].col = gun_vertexes[2].col = color;
	}
};

void onInit(CBlob@ this)
{
	//if(!this.isMyPlayer()) return;
	Render::addBlobScript(Render::layer_posthud, this, "RenderHUDstuff.as", "hud");
	this.set_u8("alpha", 0);
	//this.set_s32("RenderId", RenderId);
	//Render::SetTransformScreenspace();
	BasicHUD BHUD = BasicHUD(); 
	this.set("BHUD", @BHUD);
	if(!Texture::exists("hit"))
		Texture::createFromFile("hit", "hit.png");
	//if(gun is null)
	//	gun = BasicGunHUD();
}

float bob = 0;

void hud(CBlob@ b, int id)
{
	if(b.getTickSinceCreated() >= 1)
	{
		if(!b.isMyPlayer())
		{
			Render::RemoveScript(id);
		}
	}
	if(!b.isMyPlayer()) return;
	
	Render::SetTransformScreenspace();
			
	float bob_add = (b.getVelocity().Length()*getRenderApproximateCorrectionFactor())/12;
	bob += bob_add;
	Vec2f height = Vec2f(Maths::Sin(bob)*(b.getVelocity().Length()), (1-Maths::Abs(Maths::Cos(bob)))*(b.getVelocity().Length()))*8;
			
	BasicHUD@ BHUD;
	b.get("BHUD", @BHUD);
	
	//draw red flash first, since after hud, it will be affected by gun bobbing
	if(b.get_u8("alpha") > 0)
	{
		Render::SetAlphaBlend(true);
		Render::RawQuads("hit", RedFlash_vertexes);
		Render::SetAlphaBlend(false);
	}
			
	BHUD.DrawBHUD(b.get_string("BHUD"), b.getTeamNum(), height);
}

int index = 0;

void onTick(CBlob@ this)
{
	if(this.getTickSinceCreated() >= 1)
	{
		if(!this.isMyPlayer())
		{
			this.getCurrentScript().runFlags |= Script::remove_after_this;
		}
	}
	if(!this.isMyPlayer()) return;
	
	BasicHUD@ BHUD;
	this.get("BHUD", @BHUD);
	
	// Update HP HUD
	BHUD.SetHPNumFrame(this.getHealth()*200*0.66666667f);
	//print("hp: "+(this.getHealth()*200));
	//--------------------------
	
	// Update gun
	if(index > 0)
		index--;
	else if(index == 0 && this.getSprite().getFrame() == 24)
		index = 4;
	BHUD.SetGunFrame(index/2);
	
	Vec2f intPos = this.getInterpolatedPosition()/8;
	ThreeDeeMap@ three_dee_map = getThreeDeeMap();
	BHUD.SetGunColor(three_dee_map.lightMapImage.get(intPos.x, intPos.y));
	this.set("BHUD", @BHUD);
	//--------------------------
	
	// Update red flash
	if(this.get_u8("alpha") > 0)
	{
		RedFlash_vertexes[0].col = RedFlash_vertexes[1].col = RedFlash_vertexes[2].col = RedFlash_vertexes[3].col = SColor(Maths::Clamp(this.get_u8("alpha"), 0, 255), 255, 255, 255);
		this.sub_u8("alpha", 4);
	}
}