// Item Spawner from Diprog
// modified by 8x for The Waste Kind

#include "ItemsSpawnerCommon.as";

void onInit( CBlob@ this )
{
	this.SetLight( true );
    this.SetLightRadius( 10.0f );
    if (this.getTeamNum() == 1)
		this.SetLightColor( SColor(255, 200, 0, 50 ) );
	else
		this.SetLightColor( SColor(255, 72, 72, 252 ) );

	//this.getCurrentScript().tickFrequency = 30;


}

void onTick(CBlob@ this)
{
	CRules@ rules = getRules();
	bool spawn = false;
	if (rules !is null)
		spawn = rules.get_bool("itemspawner_spawn");

	if (spawn)
	{
		if (getNet().isServer())
		{
			string name = names[XORRandom(names.length)];
			Vec2f pos = this.getPosition();
			CBlob@ item = server_CreateBlob( name, this.getTeamNum(), Vec2f(pos.x, pos.y - 16));
			if (name == "bomb")
			{
				item.server_setTeamNum(-1);
				CBlob@ bomb = server_CreateBlob( "bomb", -2, Vec2f(pos.x - 8, pos.y - 16));
			}
			if (name == "fire")
			{
				CreateFire(this);
			}
		}
	}

}

void CreateFire(CBlob@ this)
{
    CMap@ map = getMap();
    if (map is null)   return;
    for (int doFire = 0; doFire <= 2 * 8; doFire += 1 * 8) //8 - tile size in pixels
    {
        map.server_setFireWorldspace(Vec2f(this.getPosition().x, this.getPosition().y + doFire), true);
        map.server_setFireWorldspace(Vec2f(this.getPosition().x, this.getPosition().y - doFire), true);
        map.server_setFireWorldspace(Vec2f(this.getPosition().x + doFire, this.getPosition().y), true);
        map.server_setFireWorldspace(Vec2f(this.getPosition().x - doFire, this.getPosition().y), true);
        map.server_setFireWorldspace(Vec2f(this.getPosition().x + doFire, this.getPosition().y + doFire), true);
        map.server_setFireWorldspace(Vec2f(this.getPosition().x - doFire, this.getPosition().y - doFire), true);
        map.server_setFireWorldspace(Vec2f(this.getPosition().x + doFire, this.getPosition().y - doFire), true);
        map.server_setFireWorldspace(Vec2f(this.getPosition().x - doFire, this.getPosition().y + doFire), true);
    }
}

bool canBePickedUp(CBlob@ this, CBlob@ byBlob)
{
	return false;
}