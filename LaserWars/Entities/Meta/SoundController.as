/* SoundController.as
 * author: Aphelion
 */

#define CLIENT_ONLY

const int AMBIENCE_INTERVAL = 1 * getTicksASecond(); // Ambience update interval
const int MUSIC_INTERVAL = 15 * getTicksASecond(); // Music update interval

bool ambience_enabled = true;
bool music_enabled = true;

enum SoundTags
{
    ambience_start = 0,
	ambience_space,
	ambience_end,

	music_start,
	music_peace,
	music_war,
	music_end
};

void onInit(CBlob@ this)
{
    CMixer@ mixer = getMixer();
    if     (mixer is null) { return; }

    mixer.ResetMixer();
    this.set_bool("initialized sounds", false);
}

void onTick(CBlob@ this)
{
    CMixer@ mixer = getMixer();
    if     (mixer is null) { return; }

    if (s_soundon != 0 && s_musicvolume > 0.0f)
    {
        if (!this.get_bool("initialized sounds"))
		{
            AddSounds(this, mixer);
        }

        SoundLogic(this, mixer);
    }
    else
    {
        mixer.FadeOutAll(0.0f, 3.0f);
    }
}

void AddSounds(CBlob@ this, CMixer@ mixer)
{
    this.set_bool("initialized sounds", true);

	// -- AMBIENCE
	//mixer.AddTrack("../Mods/LaserWars/Sounds/Ambient/Space.ogg", ambience_space);
	// --

	// -- MUSIC
	mixer.AddTrack("../Mods/LaserWars/Sounds/Music/Peace3.ogg", music_peace); // bloopy synth riff
	mixer.AddTrack("../Mods/LaserWars/Sounds/Music/Combat3.ogg", music_war); //guitar brooding? into synths
	// --
}

// LOGIC

void SoundLogic(CBlob@ this, CMixer@ mixer)
{
	CRules@ rules = getRules();

    const u32 time = getGameTime();

	// AMBIENCE
	//if (ambience_enabled && time % AMBIENCE_INTERVAL == 0)
	//{
	//    changeAmbience(mixer, ambience_space, 3.0f, 3.0f);
	//}

	// MUSIC
	if (music_enabled && time % MUSIC_INTERVAL == 0)
	{
		if (rules.isGameOver())
		{
			fadeoutMusic(mixer, 0.5f);
			return;
		}

		if (rules.isWarmup())
		{
		    changeMusic(mixer, music_peace, 3.0f, 3.0f);
		}
		else if (rules.isMatchRunning())
		{
		    changeMusic(mixer, music_war, 3.0f, 3.0f);
		}
	}
}

void changeAmbience(CMixer@ mixer, int nextTrack, f32 fadeoutTime, f32 fadeinTime)
{
    if (!mixer.isPlaying(nextTrack))
	{
        fadeoutAmbience(mixer, fadeoutTime);

		mixer.FadeInRandom(nextTrack, fadeinTime);
	}
}

void changeMusic(CMixer@ mixer, int nextTrack, f32 fadeoutTime, f32 fadeinTime)
{
    if (!mixer.isPlaying(nextTrack))
	{
        fadeoutMusic(mixer, fadeoutTime);

		mixer.FadeInRandom(nextTrack, fadeinTime);
	}
}

void fadeoutAmbience(CMixer@ mixer, f32 fadeoutTime)
{
    for(u32 i = ambience_start + 1; i < ambience_end; i++)
        mixer.FadeOut(i, fadeoutTime);
}

void fadeoutMusic(CMixer@ mixer, f32 fadeoutTime)
{
    for(u32 i = music_start + 1; i < music_end; i++)
        mixer.FadeOut(i, fadeoutTime);
}

void toggleAmbience(CMixer@ mixer, bool enable, f32 fadeoutTime = 3.0f)
{
    ambience_enabled = enable;

	if(!enable)
	{
	    fadeoutAmbience(mixer, fadeoutTime);
	}
}

void toggleMusic(CMixer@ mixer, bool enable, f32 fadeoutTime = 3.0f)
{
    music_enabled = enable;

	if(!enable)
	{
	    fadeoutMusic(mixer, fadeoutTime);
	}
}
