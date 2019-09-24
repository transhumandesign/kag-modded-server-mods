void onInit(CBlob@ this)
{
	CShape@ shape = this.getShape();
	shape.SetGravityScale(0.0f);
	shape.SetRotationsAllowed(false);
	this.set_u8("ID", 1);
	this.Tag("prop");
	
	this.set_f32("dir_x", 0.0f);
	this.set_f32("dir_y", 0.0f);
}

