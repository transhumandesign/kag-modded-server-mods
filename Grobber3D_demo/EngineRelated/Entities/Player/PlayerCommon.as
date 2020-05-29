#include "bool.as"

const string camera_sync_cmd = "camerasync";
const string shooting_cmd = "shooting";

void SyncCamera(CBlob@ this)
{
	CBitStream bt;
	f32 dirX = this.get_f32("dir_x");
	bt.write_f32(dirX);
	
	uint8 cmnd = this.getCommandID(camera_sync_cmd);

	this.SendCommand(cmnd, bt);
}

void Shoot(CBlob@ this)
{
	CBitStream bt;
	//bt.write_Vec2f(this.getPosition()+(Vec2f(1,0).RotateBy(this.get_f32("dir_x"))*4));
	//bt.write_Vec2f(Vec2f(3.0f, 0.0f).RotateBy(this.get_f32("dir_x")));
	bt.write_Vec2f(this.getPosition());
	bt.write_f32(this.get_f32("dir_x"));
	bt.write_bool(boool(this.getTeamNum()));
	
	uint8 cmnd = this.getCommandID(shooting_cmd);
	this.SendCommand(cmnd, bt);
}

void CreateBullet(CBlob@ this, CBitStream@ bt)
{
	CBlob@ bullet = server_CreateBlobNoInit("bullet");
	if(bullet !is null)
	{
		Vec2f pos = bt.read_Vec2f();
		f32 dir = bt.read_f32();
		bullet.server_setTeamNum(unboool(bt.read_bool()));
		
		bullet.setPosition(pos);//+Rotate(Vec2f(4.5f, 0), dir));
		//bullet.setVelocity(Vec2f(14, 0));
		//bullet.getShape().SetAngleDegrees(dir);
		Vec2f velo = Vec2f(14,0).RotateByDegrees(dir);//Rotate(Vec2f(14, 0), dir).Normalize();
		bullet.setVelocity(velo);
		bullet.Init();
	}
}

void HandleCamera(CBlob@ this, CBitStream@ bt, bool apply)
{
	if(!apply) return;
	
	f32 dirX;// = bt.read_f32();
	if(!bt.saferead_f32(dirX)) return;

	this.set_f32("dir_x", dirX);
}

/*
const f32 DegToRad = Maths::Pi/180;

Vec2f Rotate(Vec2f v, f32 degrees)
{
	return RotateRadians(v, double(degrees * DegToRad));
}

Vec2f RotateRadians(Vec2f v, double radians)
{
	double ca = Maths::FastCos(radians);
	double sa = Maths::FastSin(radians);
	return Vec2f(double(ca*v.x - sa*v.y), double(sa*v.x + ca*v.y));
}
*/


/*
u8 floatAngleToUInt(f32 value)
{
	return u8(value/(360.00000000000f/255.00000000000f));
}

f32 UIntToFloatAngle(u8 value)
{
	return f32(value*(360.00000000000f/255.00000000000f));
}*/