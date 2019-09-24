//ParticleSystemClass.as

#include "Vec3dClass.as"
#include "ParticleClass.as"
#include "ParticleConstants.as"

void InitParticleSystem(CRules@ rules)
{
	particle_system PS = particle_system(1);
	PS.set_gravity(vec3d(0,60,0));
	rules.set("ParticleSystem", @PS);
}

particle_system@ getParticleSystem()
{
	particle_system@ PS;
	getRules().get("ParticleSystem", @PS);
	return PS;
}

class particle_system
{
	particle[] particles;
	vec3d gravity_point;

	particle_system(){}

	particle_system(int n)
	{
		if(n > MAX_PARTICLES)
			n = MAX_PARTICLES;

		for(int i = 0; i < n; i++)
		{
			particle temp;//(3, vec3d(rand_float(),0.5,rand_float()), vec3d(2.5,0.5,2.5));
			particles.push_back(temp);
		}
	}

		
	//Function to advance state of particle system by time t in ms
	void update()
	{
		for(int it = 0; it < particles.length(); it++)
		{
			//vec3d force = vec3d((gravity_point - particles[it].get_pos()).unit(), FORCE_MAG);
			if(!particles[it].update(gravity_point))//;//, force);
			//if(particles[it].age <= 0)
				delete_particle(it);
		}
	}

	//Function to set gravity point
	void set_gravity(vec3d gravity){
		gravity_point = gravity;
	}

	//Function to add particles
	bool add_particles(int num)
	{
		int i;
		for(i = 0; i < num && particles.length() < MAX_PARTICLES; i++)
		{
			particle p;//(3, vec3d(rand_float(),0.5,rand_float()), vec3d(2.5,0.5,2.5));
			particles.push_back(p);
		}
		return (i >= num);
	}
	
	void add_particle(float _mass, vec3d _velocity, vec3d _position, float _age)
	{
		particle p(_mass, _velocity, _position, _age);
		particles.push_back(p);
	}
	/*
	bool shoot_em_boi(int num, float dir_x, vec3d pos)
	{
		int i;
		for(i = 0; i < num && particles.length() < MAX_PARTICLES; i++)
		{
			Vec2f temp = getRandomVelocity(dir_x, 200, 30);
			particle p(8, vec3d(temp.y, XORRandom(200)-100, temp.x), pos, XORRandom(100)+100);
			//p.age = 1000;
			particles.push_back(p);
		}
		return (i >= num);
	}
*/
	//Function to delete particles(least is 0)
	bool delete_particles(int num)
	{
		int i;
		for(i = 0; i < num && particles.length() > 0; i++)
		{
			particles.pop_back();
		}
		return (i >= num);
	}
	
	void delete_particle(int num)
	{
		particles.removeAt(num);
	}

	//Function to draw a particle
	void draw(Vec2f player_pos, float[] model_mtrx, float head)
	{
		for(int it = 0; it < particles.length(); it++)
		{
			//particles[it].draw(player_pos);
			
			float[] temp = model_mtrx;
			
			//vec3d pos = particles[it].get_pos();
			
			vec3d pos = particles[it].old_position.lerp(particles[it].position, getRenderApproximateCorrectionFactor());
			particles[it].old_position = pos;
			
			Matrix::SetTranslation(temp, pos.x-player_pos.y, pos.y-head, pos.z-player_pos.x);
			Render::SetModelTransform(temp);
			
			
			Render::RawTriangles(particles[it].name, particles[it].Vertexes);
			
			// ye, later
			
			//float k = (gravity_point-pos).mag()/(1.5*LENGTH);
			//glColor4f(1, k, 0, 1);
			//glBegin(GL_POINTS);
			//	glVertex3f(pos.x, pos.y, pos.z);
			//glEnd();
		}
	}
}
/*
Vertex[] _Vertexes = {	Vertex(-0.02, 0.08, 0, 0,0,color_white),
						Vertex(0.06, 0.0, 0, 1,1,color_white),
						Vertex(-0.02, 0.0, 0, 0,1,color_white)};
*/
