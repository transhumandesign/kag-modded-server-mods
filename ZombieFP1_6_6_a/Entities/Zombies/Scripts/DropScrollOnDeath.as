#define SERVER_ONLY

const f32 probability = 1.0f; //between 0 and 1

void dropScroll(CBlob@ this)
{
	if (!this.hasTag("dropped scroll")) //double check
	{
		this.Tag("dropped scroll");

		if ((XORRandom(1024) / 1024.0f) < probability)
		{
			CBlob@ scrollundead = server_CreateBlob("scrollundead", -1, this.getPosition());
			server_CreateBlob("scrollundead", -1, this.getPosition());
			server_CreateBlob("scrollundead", -1, this.getPosition());

			if (scrollundead !is null)
			{
				Vec2f vel(XORRandom(2) == 0 ? -2.0 : 2.0f, -5.0f);
				scrollundead.setVelocity(vel);
			}
		}
	}
}

void onDie(CBlob@ this)
{
	dropScroll(this);
	this.getCurrentScript().runFlags |= Script::remove_after_this;
}
