void onInit(CBlob@ this)
{
	this.set_u8("prop_id", 4);
	
	CShape@ shape = this.getShape();
	shape.SetGravityScale(0.0f);
	shape.SetRotationsAllowed(false);
	shape.SetStatic(true);
	//this.Tag("prop");
}