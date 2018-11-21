#include "ADCommon.as"

void onInit(CRules@ this)
{
    onRestart(this);

}

void onRestart(CRules@ this)
{
}

void onRender(CRules@ this)
{
	CPlayer@ p = getLocalPlayer();

	if (p is null || !p.isMyPlayer()) { return; }
   
    int team = p.getTeamNum();

	if (team == 0 && p.getBlob() is null)
	{
		int time = this.get_s32(p.getUsername() + "_respawn") - getGameTime();
		string spawn_message = "Respawn in: " + ((time/30) + 1);
		GUI::DrawText(spawn_message , Vec2f(getScreenWidth() / 2 - 70, getScreenHeight() / 2.5 + Maths::Sin(getGameTime() / 3.0f) * 5.0f), SColor(255, 255, 255, 55));

	}

    GUI::SetFont("menu");
    
    if(this.isWarmup() || this.isMatchRunning())
    {
        Wave[]@ waves;
        this.get("waves", @waves);

        if(waves !is null)
        {
            Vec2f topLeft = Vec2f(8, 8 + 32);
            GUI::DrawIcon("waveui.png", 0, Vec2f(126, 32), topLeft, 1.0f, 1);
            int wavenum = this.get_s32("wave");
            GUI::DrawText("Wave " + (wavenum+1) + "/10", topLeft - Vec2f(0, 4), SColor(0xffffffff));

            Wave nextwave = waves[wavenum+1];
            Vec2f off;
            if(nextwave.smallIcon)
                off = Vec2f(16, 16);
            GUI::DrawIconByName(nextwave.icon, topLeft + Vec2f(190, 0) + off);

            f32 t = nextwave.starttime;
            f32 len = nextwave.prevtime;
            f32 ratio = float(getGameTime()-len)/(t-len);
            //print("t: " + t + " tick: " + getGameTime() + " rat: " + ratio);
            if(ratio > 1)
                ratio = 1;
            int timesize = ratio*86.0f*2.0f;
            Vec2f ul = topLeft;
            ul.x += 10;
            ul.y += 14;
            Vec2f lr = ul;
            lr.x += timesize;
            //lr.y += 36;

	        GUI::DrawRectangle(ul, lr + Vec2f(0, 36), SColor(0xff941B1B));
            GUI::DrawRectangle(ul, lr + Vec2f(0, 4), SColor(0xff3B1406));
            GUI::DrawRectangle(ul + Vec2f(0, 32), lr + Vec2f(0, 32+4), SColor(0xffB73333));


            string text = "Next Wave in ";
            if(nextwave.icon == "$ALERT$")
            {
                text = "Defenders win in ";

            }

            GUI::DrawText(text + (int((t-getGameTime())/30)+1) + " secs", topLeft + Vec2f(16, 24), SColor(0xffffffff));

        }

    }

    if(team == 0 && (this.isWarmup() || this.isMatchRunning()))
    {
        Vec2f topLeft = Vec2f(getScreenWidth() - 8 - 126*2, 8 + 32);
        GUI::DrawIcon("resupplyui.png", 0, Vec2f(126, 32), topLeft, 1.0f, 1);

        f32 time = this.get_s32("resupply time") - getGameTime();
        f32 ratio = (time / 1350.0f);
        if(ratio > 1)
            ratio = 1;

        int timesize = ratio*87.0f*2.0f;
        Vec2f ul = topLeft;
        ul.x += 52 + timesize;
        ul.y += 22;
        Vec2f lr = ul;
        lr.x = topLeft.x + 52 + 87.0f*2.0f;

        GUI::DrawRectangle(ul, lr + Vec2f(0, 22), SColor(0xff316511));
        GUI::DrawRectangle(ul, lr + Vec2f(0, 4), SColor(0xff0C280D));
        GUI::DrawRectangle(ul + Vec2f(0, 18), lr + Vec2f(0, 18+4), SColor(0xff9BC92A));

        time /= 30;
        time += 1;

        GUI::DrawText("Resupply in " + int(time) + " secs", topLeft + Vec2f(52+16, 24), SColor(0xffffffff));

    }

}

SColor getNameColour(CPlayer@ p)
{
	CSecurity@ security = getSecurity();
	string devs = "geti;mm;flieslikeabrick;furai;jrgp;";
	string admins = "admin;superadmin;rcon;";
	string seclev = security.getPlayerSeclev(p).getName().toLower();
	u32[] namecolours = {0xffb400ff, 0xffa0ffa0, 0xfffa5a00, 0xffffEE44, 0xffffffff};
	u32 namecolour = devs.find(p.getUsername().toLower() + ";") != -1 ? namecolours[0] :
	                 seclev == "guard" ? namecolours[1] :
	                 admins.toLower().find(seclev + ";") != -1 ? namecolours[2] :
	                 p.isMyPlayer() ? namecolours[3] : namecolours[4];

    SColor c(namecolour);

    if(p.getBlob() is null)
    {
        uint b = c.getBlue();
        uint g = c.getGreen();
        uint r = c.getRed();

        b -= 75;
        g -= 75;
        r -= 75;

        b = Maths::Max(b, 25);
        g = Maths::Max(g, 25);
        r = Maths::Max(r, 25);

        c.setBlue(b);
        c.setGreen(g);
        c.setRed(r);

    }

	return c;

}

void drawBoard(Vec2f tl, string name, CPlayer@[] players, float height, int color = 0xffcccccc)
{
    GUI::SetFont("menu");

    Vec2f br(tl.x + 500, tl.y + height);
    GUI::DrawPane(tl, br, SColor(color));

    Vec2f ttl = Vec2f(tl.x + 250 - 75, tl.y - 40);
    Vec2f tbr = Vec2f(tl.x + 250 + 75, tl.y + 10);
    GUI::DrawWindow(ttl,tbr);
    Vec2f tmid = ttl + tbr;
    tmid.x /= 2;
    tmid.y /= 2;
    GUI::DrawTextCentered(name, tmid, SColor(0xff000000));

    f32 stepheight = 16;
    
    tl.x += stepheight;
    tl.y += stepheight;
    br.x -= stepheight;

    Vec2f otl = tl;

    GUI::DrawText("Player", tl, SColor(0xffffffff));
    GUI::DrawText("Username", Vec2f(tl.x + 225, tl.y), SColor(0xffffffff));
    GUI::DrawText("Ping", Vec2f(tl.x + 400, tl.y), SColor(0xffffffff));

    tl.y += stepheight * 0.5f;

    CControls@ controls = getControls();
    Vec2f mousePos = controls.getMouseScreenPos();

    for(int i = 0; i < players.size(); i++)
    {
        CPlayer@ p = players[i];

	    tl.y += stepheight;
	    br.y = tl.y + stepheight;

        bool playerHover = mousePos.y > tl.y && mousePos.y < tl.y + 15;
            
	    Vec2f lineoffset = Vec2f(0, -2);

	    u32 playercolour = (p.getBlob() is null || p.getBlob().hasTag("dead")) ? 0xffaaaaaa : 0xffc0c0c0;
        if(playerHover)
        {
            playercolour = 0xffffffff;

        }

	    GUI::DrawLine2D(Vec2f(tl.x, br.y + 1) + lineoffset, Vec2f(br.x, br.y + 1) + lineoffset, SColor(0xff404040));
	    GUI::DrawLine2D(Vec2f(tl.x, br.y) + lineoffset, br + lineoffset, SColor(playercolour));

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
		    GUI::DrawIcon(tex, frame, framesize, Vec2f(tl.x - 14, tl.y), 0.5f, p.getTeamNum());
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
	    SColor namecolour = getNameColour(p);
	    GUI::DrawText(playername, Vec2f(otl.x, tl.y), namecolour);
	    GUI::DrawText("" + username, Vec2f(otl.x + 225, tl.y), namecolour);
	    GUI::DrawText("" + ping_in_ms, Vec2f(otl.x + 400, tl.y), SColor(0xffffffff));

    }

}

void onRenderScoreboard(CRules@ this)
{
    f32 stepheight = 16;

    if(this.isWarmup() || this.isIntermission())
    {
        CPlayer@[] players;
        int count = getPlayersCount();
        for(int i = 0; i < count; i++)
        {
            CPlayer@ player = getPlayer(i);
            if(player !is null && player.getTeamNum() == 0)
            {
                players.push_back(player);

            }

        }

        float height = (players.length + 3.5) * stepheight;
        //float y = getScreenHeight()/2-(height/2);
        float y = 150;

        drawBoard(Vec2f(getScreenWidth()/2-250, y), "Defenders", players, height, 0xff195e9d);

    }
    else
    {
        CPlayer@[] b;
        CPlayer@[] d;

        int count = getPlayersCount();
        for(int i = 0; i < count; i++)
        {
            CPlayer@ player = getPlayer(i);
            if(player !is null)
            {
                if(player.getTeamNum() == 0)
                    d.push_back(player);
                else if(player.getTeamNum() == 1)
                    b.push_back(player);

            }

        }

        float height = (b.length + 3.5) * stepheight;
        height = Maths::Max(height, (d.length + 3.5) * stepheight);
       // float y = getScreenHeight()/2-(height/2);
        float y = 150;

        float mid = getScreenWidth()/2;

        drawBoard(Vec2f(mid - 550, y), "Barbarians", b, height, 0xffc02424);
        drawBoard(Vec2f(mid + 50, y), "Defenders", d, height, 0xff195e9d);

    }

}

/*
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
    GUI::DrawText("Username", Vec2f(bottomright.x - 400, topleft.y), SColor(0xffffffff));
    GUI::DrawText("Ping", Vec2f(bottomright.x - 250, topleft.y), SColor(0xffffffff));
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
		u32 namecolour = getNameColour(p);
		GUI::DrawText(playername, topleft + Vec2f(20, 0), SColor(namecolour));

		GUI::DrawText("" + username, Vec2f(bottomright.x - 400, topleft.y), SColor(namecolour));
		GUI::DrawText("" + ping_in_ms, Vec2f(bottomright.x - 250, topleft.y), SColor(0xffffffff));
		GUI::DrawText("" + p.getKills(), Vec2f(bottomright.x - 150, topleft.y), SColor(0xffffffff));
		GUI::DrawText("" + p.getDeaths(), Vec2f(bottomright.x - 50, topleft.y), SColor(0xffffffff));

	}

    orig.x -= stepheight*3;
    orig.y -= stepheight*3;
    GUI::DrawIconDirect("emblem.png", orig, emblem, Vec2f(32, 32), 1.5, 0, SColor(0xffffffff));

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
				u32 namecolour = getNameColour(p);
				GUI::DrawText(name, Vec2f(specx, specy), SColor(namecolour));
				specx += textdim.x + 10;
			}
			else
			{
				GUI::DrawText("and more ...", Vec2f(specx, specy), SColor(0xffaaaaaa));
				break;
			}
		}
	}

    //drawPlayerCard(hoveredPlayer, hoveredPos);


}
*/
