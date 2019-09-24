//TreeDeeObjectsClass.as

class Object
{
	string tile_sheet;
	Vertex[] Vertexes;
	u16[] IDs;
	
	bool draw_shadow = false;
	Vertex[] shadow_Vertexes;
	
	Object(){}
	
	Object(string _tile_sheet, Vertex[] _Vertexes, u16[] _IDs)
	{
		tile_sheet = _tile_sheet;
		Vertexes = _Vertexes;
		IDs = _IDs;
	}
	
	void addShadow(float diametr)
	{
		//print("shadow added");
		if(!Texture::exists("shadow"))
			Texture::createFromFile("shadow", "shadow.png");
		
		draw_shadow = true;
		
		float radius = diametr/2;
		//print("diametr: "+diametr+"  radius: "+radius);
		//Vertex[] _shadow_Vertexes = {	Vertex(-radius,	0.01,	-radius,	0,0,color_white),
		//								Vertex(-radius,	0.01,	radius,		1,0,color_white),
		//								Vertex(radius,	0.01,	radius,		1,1,color_white),
		//								Vertex(radius,	0.01,	-radius,	0,1,color_white)};
		Vertex[] _shadow_Vertexes = {	Vertex(-(radius*3),			0.01,	-radius,			0,0,color_white),
										Vertex(radius,			0.01,	radius*3,		1,1,color_white),
										Vertex(radius,			0.01,	-radius,			0,1,color_white)};
		shadow_Vertexes = _shadow_Vertexes;
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