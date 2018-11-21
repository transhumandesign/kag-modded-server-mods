#include "CTF_Structs.as";
#include "ScoreboardCommon.as";

#include "Utils.as";

/*
void onTick( CRules@ this )
{
    //see the logic script for this
}
*/


void onInit(CRules@ this)
{
    onRestart(this);

}

void onRestart( CRules@ this )
{
    UIData ui;

    CBlob@[] flags;
    if(getBlobsByName("ctf_flag", flags))
    {
        for(int i = 0; i < flags.size(); i++)
        {
            CBlob@ blob = flags[i];

            ui.flagIds.push_back(blob.getNetworkID());
            ui.flagStates.push_back("f");
            ui.flagTeams.push_back(blob.getTeamNum());
            ui.addTeam(blob.getTeamNum());


        }

    }

    this.set("uidata", @ui);

    CBitStream bt = ui.serialize();

	this.set_CBitStream("ctf_serialised_team_hud", bt);
	this.Sync("ctf_serialised_team_hud", true);

}

//only for after the fact if you spawn a flag
void onBlobCreated( CRules@ this, CBlob@ blob )
{
    if(!getNet().isServer())
        return;

    if(blob.getName() == "ctf_flag")
    {
        UIData@ ui;
        this.get("uidata", @ui);

        if(ui is null) return;

        ui.flagIds.push_back(blob.getNetworkID());
        ui.flagStates.push_back("f");
        ui.flagTeams.push_back(blob.getTeamNum());
        ui.addTeam(blob.getTeamNum());

        CBitStream bt = ui.serialize();

		this.set_CBitStream("ctf_serialised_team_hud", bt);
		this.Sync("ctf_serialised_team_hud", true);

    }

}

void onBlobDie( CRules@ this, CBlob@ blob )
{
    if(!getNet().isServer())
        return;

    if(blob.getName() == "ctf_flag")
    {
        UIData@ ui;
        this.get("uidata", @ui);

        if(ui is null) return;

        int id = blob.getNetworkID();

        for(int i = 0; i < ui.flagIds.size(); i++)
        {
            if(ui.flagIds[i] == id)
            {
                ui.flagStates[i] = "c";

            }

        }

        CBitStream bt = ui.serialize();

		this.set_CBitStream("ctf_serialised_team_hud", bt);
		this.Sync("ctf_serialised_team_hud", true);

    }

}

void onRender(CRules@ this)
{
	CPlayer@ p = getLocalPlayer();

	if (p is null || !p.isMyPlayer()) { return; }

	CBitStream serialised_team_hud;
	this.get_CBitStream("ctf_serialised_team_hud", serialised_team_hud);

	if (serialised_team_hud.getBytesUsed() > 8)
	{
		serialised_team_hud.Reset();
		u16 check;

		if (serialised_team_hud.saferead_u16(check) && check == 0x5afe)
		{
			const string gui_image_fname = "Rules/CTF/CTFGui.png";

			while (!serialised_team_hud.isBufferEnd())
			{
				CTF_HUD hud(serialised_team_hud);
				Vec2f topLeft = Vec2f(8, 8 + 64 * hud.team_num);

				int step = 0;
				Vec2f startFlags = Vec2f(0, 8);

				string pattern = hud.flag_pattern;
				string flag_char = "";
				int size = int(pattern.size());

				GUI::DrawRectangle(topLeft + Vec2f(4, 4), topLeft + Vec2f(size * 32 + 26, 60));

				while (step < size)
				{
					flag_char = pattern.substr(step, 1);

					int frame = 0;
					//c captured
					if (flag_char == "c")
					{
						frame = 2;
					}
					//m missing
					else if (flag_char == "m")
					{
						frame = getGameTime() % 20 > 10 ? 1 : 2;
					}
					//f fine
					else if (flag_char == "f")
					{
						frame = 0;
					}

					GUI::DrawIcon(gui_image_fname, frame , Vec2f(16, 24), topLeft + startFlags + Vec2f(14 + step * 32, 0) , 1.0f, hud.team_num);

					step++;
				}
			}
		}

		serialised_team_hud.Reset();
	}

	string propname = "ctf spawn time " + p.getUsername();
	if (p.getBlob() is null && this.exists(propname))
	{
		u8 spawn = this.get_u8(propname);

		if (spawn != 255)
		{
			string spawn_message = "Respawn in: " + spawn;
			if (spawn >= 250)
			{
				spawn_message = "Respawn in: (approximately never)";
			}

			GUI::DrawText(spawn_message , Vec2f(getScreenWidth() / 2 - 70, getScreenHeight() / 3 + Maths::Sin(getGameTime() / 3.0f) * 5.0f), SColor(255, 255, 255, 55));
		}
	}
}

CPlayer@ hoveredPlayer;
Vec2f hoveredPos;

//returns the bottom
float drawScoreboard(CPlayer@[] players, Vec2f topleft, int backColor, Vec2f emblem)
{
    if(players.size() <= 0)
        return topleft.y;
    Vec2f orig = topleft; //save for later

	f32 stepheight = 16;
	Vec2f bottomright(getScreenWidth() - 100, topleft.y + (players.length + 3.5) * stepheight);
	GUI::DrawPane(topleft, bottomright, SColor(backColor));

	//offset border
	topleft.x += stepheight;
	bottomright.x -= stepheight;
	topleft.y += stepheight;

	GUI::SetFont("menu");

	//draw player table header

    GUI::DrawText("Player", Vec2f(topleft.x, topleft.y), SColor(0xffffffff));
    GUI::DrawText("Username", Vec2f(bottomright.x - 600, topleft.y), SColor(0xffffffff));
    GUI::DrawText("Ping", Vec2f(bottomright.x - 450, topleft.y), SColor(0xffffffff));
    GUI::DrawText("Total Kills", Vec2f(bottomright.x - 350, topleft.y), SColor(0xffffffff));
    GUI::DrawText("Total Deaths", Vec2f(bottomright.x - 250, topleft.y), SColor(0xffffffff));
    GUI::DrawText("Kills", Vec2f(bottomright.x - 150, topleft.y), SColor(0xffffffff));
    GUI::DrawText("Deaths", Vec2f(bottomright.x - 50, topleft.y), SColor(0xffffffff));

    topleft.y += stepheight * 0.5f;

	CControls@ controls = getControls();
	Vec2f mousePos = controls.getMouseScreenPos();

	//draw players
	for (u32 i = 0; i < players.length; i++)
	{
		CPlayer@ p = players[i];

		topleft.y += stepheight;
		bottomright.y = topleft.y + stepheight;

        bool playerHover = mousePos.y > topleft.y && mousePos.y < topleft.y + 15;

        if(playerHover && controls.mousePressed1)
        {
            setSpectatePlayer(p.getUsername());

        }

		Vec2f lineoffset = Vec2f(0, -2);

		u32 playercolour = (p.getBlob() is null || p.getBlob().hasTag("dead")) ? 0xffaaaaaa : 0xffc0c0c0;
        if(playerHover)
        {
            playercolour = 0xffffffff;
            @hoveredPlayer = p;
            hoveredPos = topleft;
            hoveredPos.x = bottomright.x - 150;

        }

		GUI::DrawLine2D(Vec2f(topleft.x, bottomright.y + 1) + lineoffset, Vec2f(bottomright.x, bottomright.y + 1) + lineoffset, SColor(0xff404040));
		GUI::DrawLine2D(Vec2f(topleft.x, bottomright.y) + lineoffset, bottomright + lineoffset, SColor(playercolour));

		string tex = "";
		u16 frame = 0;
		Vec2f framesize;
		if (p.isMyPlayer())
		{
			tex = "ScoreboardIcons.png";
			frame = 4;
			framesize.Set(16, 16);
		}
		else
		{
			tex = p.getScoreboardTexture();
			frame = p.getScoreboardFrame();
			framesize = p.getScoreboardFrameSize();
		}
		if (tex != "")
		{
			GUI::DrawIcon(tex, frame, framesize, topleft, 0.5f, p.getTeamNum());
		}

        string username = p.getUsername();

		string playername = p.getCharacterName();
		string clantag = p.getClantag();
		if (clantag.length > 0)
		{
			playername = clantag + " " + playername;
		}

		//have to calc this from ticks
		s32 ping_in_ms = s32(p.getPing() * 1000.0f / 30.0f);


		//render the player + stats
		CRules@ rules = getRules();

		s32 total_kills = rules.get_u32(username + " k");
		s32 total_deaths = rules.get_u32(username + " d");

		SColor namecolour = getNameColour(p);
		GUI::DrawText(playername, topleft + Vec2f(20, 0), namecolour);

		GUI::DrawText("" + username, Vec2f(bottomright.x - 600, topleft.y), namecolour);
		GUI::DrawText("" + ping_in_ms, Vec2f(bottomright.x - 450, topleft.y), SColor(0xffffffff));
		GUI::DrawText("" + total_kills, Vec2f(bottomright.x - 350, topleft.y), SColor(0xffffffff));
		GUI::DrawText("" + total_deaths, Vec2f(bottomright.x - 250, topleft.y), SColor(0xffffffff));
		GUI::DrawText("" + p.getKills(), Vec2f(bottomright.x - 150, topleft.y), SColor(0xffffffff));
		GUI::DrawText("" + p.getDeaths(), Vec2f(bottomright.x - 50, topleft.y), SColor(0xffffffff));

	}

    /*orig.x -= stepheight*3;
    orig.y -= stepheight*3;
    GUI::DrawIconDirect("emblem.png", orig, emblem, Vec2f(32, 32), 1.5, 0, SColor(0xffffffff));*/

    return topleft.y;

}

void onRenderScoreboard(CRules@ this)
{
	//sort players
    CPlayer@[] blueplayers;
	CPlayer@[] redplayers;
	CPlayer@[] spectators;
	for (u32 i = 0; i < getPlayersCount(); i++)
	{
		CPlayer@ p = getPlayer(i);
		f32 kdr = getKDR(p);
		bool inserted = false;
		if (p.getTeamNum() == this.getSpectatorTeamNum())
		{
			spectators.push_back(p);
			continue;
		}

        int teamNum = p.getTeamNum();
        if(teamNum == 0) //blue team
        {
		    for (u32 j = 0; j < blueplayers.length; j++)
		    {
			    if (getKDR(blueplayers[j]) < kdr)
			    {
				    blueplayers.insert(j, p);
				    inserted = true;
				    break;
			    }
		    }

		    if (!inserted)
			    blueplayers.push_back(p);

        }
        else
        {
		    for (u32 j = 0; j < redplayers.length; j++)
		    {
			    if (getKDR(redplayers[j]) < kdr)
			    {
				    redplayers.insert(j, p);
				    inserted = true;
				    break;
			    }
		    }

		    if (!inserted)
			    redplayers.push_back(p);

        }

	}

	//draw board

    int localTeam = getLocalPlayer().getTeamNum();
    if(localTeam != 0 && localTeam != 1)
        localTeam = 0;

    @hoveredPlayer = null;

	Vec2f topleft(100, 150);
    if(blueplayers.size() + redplayers.size() > 18)
    {
        topleft.y = drawServerInfo(10);

    }
    else
    {
        drawServerInfo(40);

    }

    if(localTeam == 0)
	    topleft.y = drawScoreboard(blueplayers, topleft, 0xff195e9d, Vec2f(0, 0));
    else
        topleft.y = drawScoreboard(redplayers, topleft, 0xffc02424, Vec2f(32, 0));
    topleft.y += 52;
    if(localTeam == 1)
        topleft.y = drawScoreboard(blueplayers, topleft, 0xff195e9d, Vec2f(0, 0));
    else
        topleft.y = drawScoreboard(redplayers, topleft, 0xffc02424, Vec2f(32, 0));
    topleft.y += 52;

	if (spectators.length > 0)
	{
        //draw spectators
        f32 stepheight = 16;
	    Vec2f bottomright(getScreenWidth() - 100, topleft.y + stepheight*2);
        f32 specy = topleft.y + stepheight*0.5;
	    GUI::DrawPane(topleft, bottomright, SColor(0xffc0c0c0));

		Vec2f textdim;
		string s = "Spectators:";
		GUI::GetTextDimensions(s, textdim);

		GUI::DrawText(s, Vec2f(topleft.x+5, specy), SColor(0xffaaaaaa));

		f32 specx = topleft.x + textdim.x + 15;
		for (u32 i = 0; i < spectators.length; i++)
		{
			CPlayer@ p = spectators[i];
			if (specx < bottomright.x - 100)
			{
				string name = p.getCharacterName();
				if (i != spectators.length - 1)
					name += ",";
				GUI::GetTextDimensions(name, textdim);
				SColor namecolour = getNameColour(p);
				GUI::DrawText(name, Vec2f(specx, specy), namecolour);
				specx += textdim.x + 10;
			}
			else
			{
				GUI::DrawText("and more ...", Vec2f(specx, specy), SColor(0xffaaaaaa));
				break;
			}
		}
	}

    drawPlayerCard(hoveredPlayer, hoveredPos);


}

