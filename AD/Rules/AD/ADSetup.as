#include "GameplayEvents.as"
#include "ADCommon.as"

void onInit(CRules@ this)
{
    onRestart(this);
    this.addCommandID("SyncUI");

}

void onRestart(CRules@ this)
{
	SetupGameplayEvents(this);

	sv_gravity = 9.81f;
	particles_gravity.y = 0.25f;

    this.Tag("stupidthing");


}

void onCommand( CRules@ this, u8 cmd, CBitStream@ bt)
{
    if(cmd == this.getCommandID("SyncUI"))
    {
        if(getNet().isClient())
        {
            string username = bt.read_string();
            if(username == getLocalPlayer().getUsername())
            {
                s32 start = bt.read_s32();

                initWaves(this);

                Wave[]@ waves;
                this.get("waves", @waves);

                for(int i = 0; i < waves.size(); i++)
                {
                    waves[i].starttime += start;
                    if(i == 0)
                    {
                        waves[i].prevtime = start;

                    }
                    else
                    {
                        waves[i].prevtime = waves[i-1].starttime+1;

                    }

                }

            }

        }

    }

}

void onNewPlayerJoin( CRules@ this, CPlayer@ player)
{
    if(getNet().isServer() && !player.isBot())
    {
        if(this.isWarmup() || this.isMatchRunning())
        {
            Wave[]@ waves;
            this.get("waves", @waves);

            if(waves is null) return;

            CBitStream bt;
            bt.write_string(player.getUsername());
            bt.write_s32(waves[0].prevtime - getGameTime());

            this.SendCommand(this.getCommandID("SyncUI"), bt);

        }

    }

}

void onTick(CRules@ this)
{
    if(this.isWarmup() && this.hasTag("stupidthing"))
    {
        this.Untag("stupidthing");

        initWaves(this);

        Wave[]@ waves;
        this.get("waves", @waves);

        for(int i = 0; i < waves.size(); i++)
        {
            if(i == 0)
            {
                waves[i].prevtime = getGameTime();

            }
            else
            {
                waves[i].prevtime = waves[i-1].starttime+1;

            }

        }

    }

}

void initWaves(CRules@ this)
{
    Wave[] waves;
    int basetime = getGameTime() + 150*30;
    int t = 60*30; //1 minute between waves


    //TODO: change up these items so they aren't so retarded

    Wave wave_1(basetime, "$mat_firearrows$", true);

    {
        Crate crate(0, 14);
        crate.addItem("mat_firearrows", 2);
        crate.addItem("bomb_satchel", 1);
        wave_1.addCrate(crate);

    }

    wave_1.knightitems.push_back("mat_bombs");

    //give everyone food instead of spamming crates
    wave_1.archeritems.push_back("food");
    wave_1.knightitems.push_back("food");
    waves.push_back(wave_1);

    Wave wave_2(basetime + t, "$catapult$");

    {
        Crate crate(0, 17);
        crate.addItem("mat_bombarrows", 2);
        crate.addItem("mat_stone", 1);
        wave_2.addCrate(crate);

    }

	wave_2.addSiegeDrop("catapult", 4, 25*30);
    waves.push_back(wave_2);

    Wave wave_3(basetime + t*2, "$keg$", true);

    {
        Crate crate(6*30, 13);
        crate.addItem("mat_firearrows", 3);
        crate.addItem("keg", 1);
        wave_3.addCrate(crate);

    }

    wave_3.knightitems.push_back("mat_bombs");

    //give everyone food instead of spamming crates
    wave_3.archeritems.push_back("food");
    wave_3.knightitems.push_back("food");

    waves.push_back(wave_3);

    Wave wave_4(basetime + t*3, "$ballista$");
	wave_4.addSiegeDrop("ballista", 5, 0);

    {
        Crate crate(25*30, 14);
        crate.addItem("mine", 4);
        crate.addItem("mat_firearrows", 3);
        wave_4.addCrate(crate);

    }
    waves.push_back(wave_4);

    Wave wave_5(basetime + t*4, "$bomb_satchel$");
	wave_5.archeritems.push_back("bomb_satchel");
	wave_5.knightitems.push_back("bomb_satchel");

	//wave_5.addSiegeDrop("mat_bolts", 0, 25*50); nobody used this either
    waves.push_back(wave_5);

    Wave wave_6(basetime + t*5, "$catapult$");
	wave_6.addSiegeDrop("catapult", 4, 0);

    //do this so we don't have to unpack it
    {
        Crate crate(15*30, 13);
        crate.addItem("bomb_satchel", 1);
        crate.addItem("mat_bombarrows", 1);
        crate.addItem("mine", 1);
        crate.addItem("food", 3);
        wave_6.addCrate(crate);

    }

    {
        Crate crate(30*30, 13);
        crate.addItem("keg", 1);
        wave_6.addCrate(crate);

    }

    //give everyone food instead of spamming crates
    wave_3.archeritems.push_back("food");
    wave_3.knightitems.push_back("food");

    waves.push_back(wave_6);

    Wave wave_7(basetime + t*6, "$keg$", true);
    
    {
        Crate crate(0, 14);
        crate.addItem("bomb_satchel", 2);
        crate.addItem("mat_firearrows", 3);
        wave_7.addCrate(crate);

    }

    {
        Crate crate(15*30, 13);
        crate.addItem("keg", 1);
        wave_7.addCrate(crate);

    }
    
	wave_7.unlockBombTech = true;
    waves.push_back(wave_7);

    Wave wave_8(basetime + t*7, "$bomb_satchel$", true);
	wave_8.addSiegeDrop("ballista", 5, 0);

	wave_8.knightitems.push_back("mat_bombs");

    {
        Crate crate(30*30, 0);
        crate.addItem("bomb_satchel", 3);
        wave_8.addCrate(crate);

    }

    waves.push_back(wave_8);

    Wave wave_9(basetime + t*8, "$mat_bombs$", true);

    {
        Crate crate(0, 0);
        crate.addItem("bomb_satchel", 2);
        wave_9.addCrate(crate);

    }

	wave_9.addSiegeDrop("catapult", 4, 15*30);

    {
        Crate crate(30*30, 13);
        crate.addItem("keg", 1);
        crate.addItem("mat_bombarrows", 2);
        wave_9.addCrate(crate);

    }

    waves.push_back(wave_9);

    Wave wave_10(basetime + t*9, "$mine$", true);
	wave_10.archeritems.push_back("bomb_satchel");
    wave_10.archeritems.push_back("mat_firearrows");

	wave_10.knightitems.push_back("bomb_satchel");
    wave_10.knightitems.push_back("mat_bombs");

    {
        Crate crate(0, 13);
        crate.addItem("chicken", 1); //10/10 trolling >:)
        crate.addItem("bomb_satchel", 1);
        wave_10.addCrate(crate);

    }

    waves.push_back(wave_10);

    /*Wave wave_11(basetime + t*10, "$ballista$");
	wave_11.addSiegeDrop("catapult", 4, 0);
	wave_11.addSiegeDrop("ballista", 5, 15*30);
	wave_11.addSiegeDrop("mat_stone", 16, 30*30);
	wave_11.addSiegeDrop("mat_bolts", 0, 50*30);
    waves.push_back(wave_11);

    Wave wave_12(basetime + t*11, "$bomb_satchel$");
	wave_12.addSiegeDrop("bomb_satchel", 0, 0, 3);
	wave_12.addSiegeDrop("mat_bombs", 12, 1*30, 5);
	wave_12.addSiegeDrop("mat_bombarrows", 17, 2*30, 2);
	wave_12.addSiegeDrop("keg", 13, 3*30);
    waves.push_back(wave_12);*/

    //cuz index out of bounds
    Wave wave_fake(basetime + t*12, "$ALERT$");
    waves.push_back(wave_fake);

    //double protection against out of bounds lel >:)
    Wave wave_fake2(basetime + t*13, "$ALERT$");
    waves.push_back(wave_fake2);

    this.set("waves", waves);

    if(getNet().isServer())
    {
        this.set_s32("wave", -1);
        this.Sync("wave", true);

    }

}
