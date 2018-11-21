#define SERVER_ONLY

const f32 probability = 0.7f; //between 0 and 1

void dropArm(CBlob@ this)
{
	if (!this.hasTag("dropped arm")) //double check
	{
		this.Tag("dropped arm");

		if ((XORRandom(1024) / 1024.0f) < probability)
		{
			CBlob@ zombiearm = server_CreateBlob("zombiearm", -1, this.getPosition());

			if (zombiearm !is null)
			{
				Vec2f vel(XORRandom(2) == 0 ? -2.0 : 2.0f, -5.0f);
				zombiearm.setVelocity(vel);
			}
		}
	}
}

void onDie(CBlob@ this)
{
	dropArm(this);
	this.getCurrentScript().runFlags |= Script::remove_after_this;
}
