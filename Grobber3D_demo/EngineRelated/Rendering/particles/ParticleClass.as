//ParticleClass.as

#include "Vec3dClass.as"
#include "ParticleConstants.as"
#include "cloud.as"

Vertex[] Default_Vertexes = {	Vertex(-0.02, 0.08, 0, 0,0,color_white),
								Vertex(0.06, 0.0, 0, 1,1,color_white),
								Vertex(-0.02, 0.0, 0, 0,1,color_white)};

class particle
{	
	float drag;
	vec3d old_position;
	vec3d position;
	vec3d velocity;
	float age;
	
	string name;
	Vertex[] Vertexes;
	
	particle()
	{
		//drag = float(XORRandom(1000))/1000.0f;
		//velocity = vec3d(vec3d(rand_float(), rand_float(), rand_float()), MIN_INIT_VELOCITY + XORRandom(10000) % (MAX_INIT_VELOCITY - MIN_INIT_VELOCITY));
		//position = vec3d((1-2*rand_float())*0.5, (1-2*rand_float())*0.5, (1-2*rand_float())*0.5);
		//old_position = position;
		//age = 2;
		
		//name = "bullet_0_particle";
		//Vertexes = Default_Vertexes;
	}

	particle(float _drag, vec3d _velocity, vec3d _position, float _age)
	{
		drag = _drag;
		velocity = _velocity;
		position = _position;
		old_position = _position;
		age = _age;
		
		name = "bullet_0_particle";
		Vertexes = Default_Vertexes;
	}

	//Function to advance state of particle by time t in ms and force in given direction
	bool update(vec3d gravitypoint)//, vec3d force)
	{
		age -= 1;
		if(age <= 0 || position.y < 0)
			return false;
		//calculating acceleration
		//vec3d acc = force / mass;
		//float drag = (mass/float(MAX_MASS));
		//print("drag: "+drag);
		//vec3d acc((velocity.x*drag)/3, drag*6, (velocity.z*drag)/3);
		//acc.printY();
		//velocity.printY();

		//calculating velocity
		//velocity = vec3d(velocity*(drag*t));//velocity - acc*t;//*(t/1000.0);
		//velocity.printY();
		//print(" "+t);
		
		//gravitypoint.y *= drag;
		//acceleration += gravitypoint*t;
		
		//velocity += acceleration*(t/1000.0);
		//float addX = drag*t;
		//float addY = drag*t;
		velocity.x *= drag;
		velocity.z *= drag;
		velocity.y -= (1-drag)*gravitypoint.y;
		
		
		//if(velocity.mag() >= MAX_VELOCITY)
		//	velocity = vec3d(velocity.unit(), MAX_VELOCITY);

		//changing position
		//old_position = position;
		position += velocity/MAX_VELOCITY;
		return true;
/*
		if(position.x <= -LENGTH)
			position.x = LENGTH;
		else if(position.x >= LENGTH)
			position.x = -LENGTH;

		if(position.y <= -LENGTH)
			position.y = LENGTH;
		else if(position.y >= LENGTH)
			position.y = -LENGTH;

		if(position.z <= -LENGTH)
			position.z = LENGTH;
		else if(position.z >= LENGTH)
			position.z = -LENGTH;*/
	}

	//Function to get position
	vec3d get_pos()
	{
		return position;
	}
	
	/*void draw(Vec2f player_pos)
	{
		vec3d pos = position;
			
		float[] _model;
		Matrix::MakeIdentity(_model);
		Matrix::SetTranslation(_model, pos.x-player_pos.y, pos.y, pos.z-player_pos.x);
		Render::SetModelTransform(_model);
		
		
		Render::RawTriangles("default.png", _Vertexes);
	}*/
};