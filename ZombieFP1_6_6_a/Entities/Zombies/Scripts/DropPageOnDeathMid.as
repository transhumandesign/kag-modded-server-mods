#define SERVER_ONLY

const f32 probability = 0.25f; //between 0 and 1

void dropPage(CBlob@ this)
{
	if (!this.hasTag("dropped page")) //double check
	{
		this.Tag("dropped page");

		if ((XORRandom(1024) / 1024.0f) < probability)
		{
			CBlob@ page = server_CreateBlob("whitepage", -1, this.getPosition());

			if (page !is null)
			{
				Vec2f vel(XORRandom(2) == 0 ? -2.0 : 2.0f, -5.0f);
				page.setVelocity(vel);
			}
		}
	}
}

void onDie(CBlob@ this)
{
	dropPage(this);
	this.getCurrentScript().runFlags |= Script::remove_after_this;
}
