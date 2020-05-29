//TreeDeeObjects.as

#include "IsLocalhost.as"
#include "TreeDeeMap.as"
#include "TreeDeeObjectsClass.as"

u16[] v_ids = {0,1,2};

void onInit(CBlob@ this)
{
	if(isClient() || isLocalhost())
	{
		//if(this.getPlayer().isMyPlayer()) return;
		if(this.getName() == "box")
		{
			//this.set_u8("prop_id", 3);
			ThreeDeeMap@ three_dee_map = getThreeDeeMap();
			if(three_dee_map !is null)
			{
				//print("box");
				Vec2f intPos = this.getPosition()/8;
				Vertex[] Vertexes = {	Vertex(-0.25, 1.0, 0, 0,0,three_dee_map.lightMapImage.get(intPos.x, intPos.y)),
										Vertex(0.75, 0.0, 0, 1,1,three_dee_map.lightMapImage.get(intPos.x, intPos.y)),
										Vertex(-0.25, 0.0, 0, 0,1,three_dee_map.lightMapImage.get(intPos.x, intPos.y))};
				string tile_sheet = "box";
				if(!Texture::exists(tile_sheet))
					Texture::createFromFile(tile_sheet, tile_sheet+".png");
				Object obj = Object(tile_sheet, Vertexes, v_ids);
				obj.addShadow(0.6);
				this.set("object", @obj);
			}
			//u16[] IDs = {0,1,2};
		}
		
		else if(this.getName() == "barrel")
		{
			//this.set_u8("prop_id", 4);
			ThreeDeeMap@ three_dee_map = getThreeDeeMap();
			if(three_dee_map !is null)
			{
				//print("box");
				Vec2f intPos = this.getPosition()/8;
				Vertex[] Vertexes = {	Vertex(-0.25, 1.0, 0, 0,0,three_dee_map.lightMapImage.get(intPos.x, intPos.y)),
										Vertex(0.75, 0.0, 0, 1,1,three_dee_map.lightMapImage.get(intPos.x, intPos.y)),
										Vertex(-0.25, 0.0, 0, 0,1,three_dee_map.lightMapImage.get(intPos.x, intPos.y))};
				string tile_sheet = "barrel";
				if(!Texture::exists(tile_sheet))
					Texture::createFromFile(tile_sheet, tile_sheet+".png");
				Object obj = Object(tile_sheet, Vertexes, v_ids);
				obj.addShadow(0.55);
				this.set("object", @obj);
			}
			//u16[] IDs = {0,1,2};
		}
		
		else if(this.getName() == "lamppost")
		{
			//this.set_u8("prop_id", 5);
			ThreeDeeMap@ three_dee_map = getThreeDeeMap();
			if(three_dee_map !is null)
			{
				//print("box");
				Vec2f intPos = this.getPosition()/8;
				Vertex[] Vertexes = {	Vertex(-0.5, 2.0, 0, 0,0,three_dee_map.lightMapImage.get(intPos.x, intPos.y)),
										Vertex(1.5, 0.0, 0, 1,1,three_dee_map.lightMapImage.get(intPos.x, intPos.y)),
										Vertex(-0.5, 0.0, 0, 0,1,three_dee_map.lightMapImage.get(intPos.x, intPos.y))};
				string tile_sheet = "lamppost";
				if(!Texture::exists(tile_sheet))
					Texture::createFromFile(tile_sheet, tile_sheet+".png");
				Object obj = Object(tile_sheet, Vertexes, v_ids);
				obj.addShadow(0.3);
				this.set("object", @obj);
			}
			//u16[] IDs = {0,1,2};
		}
		
		else if(this.getName() == "player")
		{
			//this.set_u8("prop_id", 1);
			ThreeDeeMap@ three_dee_map = getThreeDeeMap();
			if(three_dee_map !is null)
			{
				//print("box");
				Vec2f intPos = this.getPosition()/8;
				Vertex[] Vertexes = {	Vertex(-0.5, 2.0, 0, 	0,0,	three_dee_map.lightMapImage.get(intPos.x, intPos.y)),
										Vertex(1.5, 0.0, 0, 	0.125,0.25,	three_dee_map.lightMapImage.get(intPos.x, intPos.y)),
										Vertex(-0.5, 0.0, 0, 	0,0.25,	three_dee_map.lightMapImage.get(intPos.x, intPos.y))};
				string tile_sheet = "Player"+this.getTeamNum();
				if(!Texture::exists(tile_sheet))
					Texture::createFromFile(tile_sheet, tile_sheet+".png");
				Object obj = Object(tile_sheet, Vertexes, v_ids);
				obj.addShadow(0.75);
				this.set("object", @obj);
			}
			//u16[] IDs = {0,1,2};
		}
		
		else if(this.getName() == "bullet")
		{
			//this.set_u8("prop_id", 2);
			ThreeDeeMap@ three_dee_map = getThreeDeeMap();
			if(three_dee_map !is null)
			{
				//print("box"); 0,015625
				Vec2f intPos = this.getPosition()/8;
				Vertex[] Vertexes = {	Vertex(-0.203125,	0.609375, 0, 	0,		0,		color_white),
										Vertex(0.609375, 	-0.203125, 0, 	1, 		0.125,	color_white),
										Vertex(-0.203125, 	-0.203125, 0, 	0, 		0.125,	color_white)};
				string tile_sheet = "bullet"+this.getTeamNum();
				if(!Texture::exists(tile_sheet))
					Texture::createFromFile(tile_sheet, tile_sheet+".png");
				Object obj = Object(tile_sheet, Vertexes, v_ids);
				this.set("object", @obj);
			}
			//u16[] IDs = {0,1,2};
		}
	}
}

void onTick(CBlob@ this)
{
	if(isClient() || isLocalhost())
	{
		//if(this.getShape().isStatic() || this.getName() == "bullet") return;
		if(this.getShape().isStatic()) return;
		if(this.isMyPlayer()) return;
		ThreeDeeMap@ three_dee_map = getThreeDeeMap();
		if(three_dee_map !is null)
		{
			Object@ obj;
			this.get("object", @obj);
			if(obj !is null)
			{
				u8 id = this.get_u8("prop_id");
				//print("prop: "+id);
				//bool doLighting = false;
				switch(id)
				{
					case 1:
					{
						Vec2f pos = Vec2f_zero;
						Vec2f vel = Vec2f_zero;
						f32 dir_x = 0.01f;
						f32 dir_y = 0.01f;
						CPlayer@ p = getLocalPlayer();
						if(p !is null)
						{
							CBlob@ b = p.getBlob();
							if(b !is null)
							{
								pos = b.getInterpolatedPosition()/16;
								vel = b.getVelocity();
								dir_x = b.get_f32("dir_x");
								dir_y = b.get_f32("dir_y");
							}
						}
						//CSprite@ sprite = this.getSprite();
						//if(sprite !is null)
						//{
							f32 ybit = 1.0000f/4.0000f;
							f32 xbit = 1.0000f/8.0000f;
							u16 frame = this.getSprite().getFrame();
							u8 u = frame/8;
							
							Vec2f Edir = Vec2f(1,0).RotateByDegrees(this.get_f32("dir_x"));
							Vec2f Cdir = Vec2f(1,0).RotateByDegrees(Vec2f(pos.x*16-this.getPosition().x, pos.y*16-this.getPosition().y).getAngleDegrees());
							Edir.RotateByDegrees(360-Cdir.getAngleDegrees());
							f32 newangl = Edir.getAngleDegrees()+22.5;
							u8 l = (newangl/45) % 8;
							
							//Vertex[] edited_Vertexes = obj.Vertexes;
							
							obj.Vertexes[0].v = f32(u)*ybit;
							obj.Vertexes[1].v = obj.Vertexes[2].v = f32(u+1)*ybit;
							
							obj.Vertexes[1].u = (l+1)*xbit;
							obj.Vertexes[0].u = obj.Vertexes[2].u = l*xbit;
							
							obj.Vertexes[0].col = obj.Vertexes[1].col = obj.Vertexes[2].col = three_dee_map.lightMapImage.get(this.getPosition().x/8, this.getPosition().y/8);
							//doLighting = true;
							break;
						//}
					}
					case 2:
					{
						//Vertex[] edited_Vertexes = obj.Vertexes;
						obj.Vertexes[0].v = 0.125f*this.getSprite().getFrame();
						obj.Vertexes[1].v = obj.Vertexes[2].v = 0.125f+obj.Vertexes[0].v;
						break;
					}
					default:
					{
						break;
					}
				}
				
				//if(doLighting)
				//{
				//	Vec2f intPos = this.getPosition()/8;
				//	//Vertex[] Vertexes = obj.Vertexes;
				//	for(int i = 0; i < obj.Vertexes.length(); i++)
				//	{
				//		obj.Vertexes[i].col = three_dee_map.lightMapImage.get(intPos.x, intPos.y);
				//	}
				//}
			}
			//this.set("object", @obj);
			/*
			Vec2f intPos = this.getPosition()/16*3;
			Vertex[] Vertexes = {	Vertex(-0.25, 1.0, 0, 0,0,three_dee_map.lightMapImage.get(intPos.x, intPos.y)),
									Vertex(0.75, 0.0, 0, 1,1,three_dee_map.lightMapImage.get(intPos.x, intPos.y)),
									Vertex(-0.25, 0.0, 0, 0,1,three_dee_map.lightMapImage.get(intPos.x, intPos.y))};
			string tile_sheet = "box.png";
			Object obj = Object(tile_sheet, Vertexes);
			this.set("object", @obj);*/
		}
	}
}

/*
dictionary getThreeDeeObjectsHolder()
{
	dictionary@ three_dee_objects_holder;
	getRules().get("ThreeDeeObjectsHolder", @three_dee_objects_holder);
	return three_dee_objects_holder;
}

class Object
{
	Vertex[] Vertexes;
	u16[] IDs;
	Object(){}
	Object(Vertex[] _Vertexes, u16[] _IDs)
	{
		Vertexes = _Vertexes;
		IDs = _IDs;
	}
}
*/