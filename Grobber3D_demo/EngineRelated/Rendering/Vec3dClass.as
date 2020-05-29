//Vec3dClass.as

class vec3d
{
	float x;
	float y;
	float z;
	
	vec3d(){}
	
	vec3d(float _x, float _y, float _z)
	{
		x = _x;
		y = _y;
		z = _z;
	}
	
	
	vec3d(vec3d vec, float mag)
	{
		vec.Normalize();
		if(mag == 0)
			print("invalid vector");
		x=mag*vec.x;
		y=mag*vec.y;
		z=mag*vec.z;
	}
	
	vec3d opAdd(const vec3d &in oof)
	{
		return vec3d(x + oof.x, y + oof.y, z + oof.z);
	}
	
	vec3d opSub(const vec3d &in oof)
	{
		return vec3d(x - oof.x, y - oof.y, z - oof.z);
	}
	
	vec3d opMul(const vec3d &in oof)
	{
		return vec3d(x * oof.x, y * oof.y, z * oof.z);
	}
	
	vec3d opMul(const float &in oof)
	{
		return vec3d(x * oof, y * oof, z * oof);
	}
	
	vec3d opDiv(const vec3d &in oof)
	{
		return vec3d(x / oof.x, y / oof.y, z / oof.z);
	}
	
	vec3d opDiv(const float &in oof)
	{
		return vec3d(x / oof, y / oof, z / oof);
	}
	
	void opAddAssign(const vec3d &in oof)
	{
		x+=oof.x;
		y+=oof.y;
		z+=oof.z;
	}
	
	void opAssign(const vec3d &in oof)
	{
		x=oof.x;
		y=oof.y;
		z=oof.z;
	}
	
	vec3d unit()
	{
		float lenght = this.mag();
		if(lenght == 0)
			print("(uint) invalid vector");
		return vec3d(x/lenght, y/lenght, z/lenght);
	}
	
	vec3d lerp(vec3d desired, float t)
	{
		return vec3d((((1 - t) * this.x) + (t * desired.x)), (((1 - t) * this.y) + (t * desired.y)), (((1 - t) * this.z) + (t * desired.z)));
	}
	
	void printY()
	{
		print("x: "+x+"; y: "+y+"; z: "+z);
	}
	
	void Normalize()
	{
		float lenght = this.mag();
		if(lenght == 0)
			print("(Normalize) invalid vector");
		x /= lenght;
		y /= lenght;
		z /= lenght;
	}
	
	float mag()
	{
		//print("x: "+x);
		//print("y: "+y);
		//print("z: "+z);
		float boi = Maths::Sqrt(x*x + y*y + z*z);
		//print("boi: "+boi);
		if(boi == 0) return 1;
		return boi;
	}
}