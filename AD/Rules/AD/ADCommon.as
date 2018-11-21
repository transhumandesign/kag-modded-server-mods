#include "MakeCrate.as"

shared bool SetMaterials(CBlob@ blob,  const string &in name, const int quantity)
{
	CBlob@ mat = server_CreateBlob(name);
	if (mat !is null)
	{
		mat.Tag("do not set materials");
		mat.server_SetQuantity(quantity);
		if (!blob.server_PutInInventory(mat))
		{
			mat.setPosition(blob.getPosition());
		}
	}

	return true;
}

shared class RespawnPlayer
{
    RespawnPlayer(string name, int time)
    {
        this.name = name;
        this.time = time;

    }

    string name;
    int time;

};

shared class RespawnList
{
    RespawnList(){}

    RespawnPlayer[] attackers;
    RespawnPlayer[] defenders;
    string[] matsgiven;
    string[] ignorenext;

};

shared class Crate
{
    Crate(s32 offsetTime, int frame)
    {
        name = "party box";
        this.offsetTime = offsetTime;
        this.frame = frame;
        this.name = name;

    }

    void addItem(string name, int amount)
    {
        blobs.push_back(name);
        amounts.push_back(amount);
    
    }

    void makeCrate()
    {
        Vec2f drop = getDropPosition(getBlobByName("tradingpost").getPosition());
        CBlob@ crate = server_MakeCrateOnParachute("", name, frame, 1, drop);

        for(int i = 0; i < blobs.size(); i++)
        {
            string blobname = blobs[i];
            int amount = amounts[i];
            for(int j = 0; j < amount; j++)
            {
                CBlob@ blob = server_CreateBlob(blobname, 1, Vec2f(0, 0));
                crate.server_PutInInventory(blob);

            }

        }

    }

    s32 offsetTime;
    int frame;
    string name;
    string[] blobs;
    int[] amounts;

};

shared class Wave
{
    bool smallIcon;
    Wave(s32 respawntime, string icon = "$catapult$", bool iconSmall = false)
    {
        smallIcon = iconSmall;
        this.icon = icon;
        starttime = respawntime;

        unlockBombTech = true;

        index = 0;
        crateIndex = 0;

    }

    void addSiegeDrop(string blob, int frame, int offsetTime)
    {
        addSiegeDrop(blob, frame, offsetTime, 1);

    }

    void addSiegeDrop(string blob, int frame, int offsetTime, int quantity)
    {
        siegedrops.push_back(blob);
        frames.push_back(frame);
        siegetimes.push_back(offsetTime);
        siegequantity.push_back(quantity);

    }

    void addCrate(Crate crate)
    {
        crates.push_back(crate);

    }

    bool isSiegeDrop()
    {
        if(!(index < siegetimes.size()))
            return false;
        return (starttime + siegetimes[index]) < getGameTime();

    }

    bool isCrateDrop()
    {
        if(!(crateIndex < crates.size()))
            return false;
        return (starttime + crates[crateIndex].offsetTime) < getGameTime();

    }

    void dropCrate()
    {
        crates[crateIndex].makeCrate();
        crateIndex++;

    }

    void drop()
    {
        Vec2f drop = getDropPosition(getBlobByName("tradingpost").getPosition());

        if(siegequantity[index] > 1)
        {
            CBlob@ crate = server_MakeCrateOnParachute("", "party box", frames[index], 1, drop);

            for(int i = 0; i < siegequantity[index]; i++)
            {
                CBlob@ blob = server_CreateBlob(siegedrops[index], 1, Vec2f(0, 0));
                crate.server_PutInInventory(blob);

            }

        }
        else
        {
            server_MakeCrateOnParachute(siegedrops[index], "party box", frames[index], 1, drop);

        }

        index++;
    }

    void giveSpawnMats(CBlob@ blob)
    {
        if(blob.getName() == "knight")
        {
            for(int i = 0; i < knightitems.size(); i++)
            {
                SetMaterials(blob, knightitems[i], 1);

            }

        }
        else if(blob.getName() == "archer")
        {
            for(int i = 0; i < archeritems.size(); i++)
            {
                SetMaterials(blob, archeritems[i], 1);

            }

        }

    }

    string icon;
    s32 prevtime;
    s32 starttime;

    string[] knightitems;
    string[] archeritems;
    
    string[] siegedrops;
    int[] frames;
    int[] siegetimes;
    int[] siegequantity;

    bool unlockBombTech;

    Crate[] crates;

    int crateIndex;
    int index;

};

int getTimeToRespawn(RespawnList@ list, CPlayer@ player)
{
    string username = player.getUsername();
    for(int i = 0; i < list.defenders.size(); i++)
    {
        if(list.defenders[i].name == username)
        {
            return list.defenders[i].time - getGameTime();

        }

    }

    for(int i = 0; i < list.attackers.size(); i++)
    {
        if(list.attackers[i].name == username)
        {
            return list.attackers[i].time - getGameTime();

        }

    }

    return -1;

}

bool gotMats(RespawnList@ list, CPlayer@ player)
{
    string username = player.getUsername();
    for(int i = 0; i < list.matsgiven.size(); i++)
    {
        if(list.matsgiven[i] == username)
        {
            return true;

        }

    }

    return false;

}


bool inDefenderQueue(RespawnList@ respawns, string username)
{
    for(int i = 0; i < respawns.defenders.size(); i++)
    {
        if(respawns.defenders[i].name == username)
            return true;

    }

    return false;

}

bool inAttackerQueue(RespawnList@ respawns, string username)
{
    for(int i = 0; i < respawns.attackers.size(); i++)
    {
        if(respawns.attackers[i].name == username)
            return true;

    }

    return false;

}

bool inRespawnQueue(RespawnList@ respawns, string username)
{
    for(int i = 0; i < respawns.ignorenext.size(); i++)
    {
        if(respawns.ignorenext[i] == username)
        {
            respawns.ignorenext.erase(i);
            return true;

        }

    }
      
    return inDefenderQueue(respawns, username) || inAttackerQueue(respawns, username);

}

