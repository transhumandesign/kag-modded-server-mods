/* PlayerProfiles.as
 * author: Aphelion
 */

#include "PlayerProfilesCommon.as";

void Reset( CRules@ this )
{
	if(!getNet().isServer()) return;

	PlayerProfile[]@ profiles = server_getProfiles();

	if (profiles !is null)
	{
		for(uint i = 0; i < profiles.length; i++)
		{
			PlayerProfile@ profile = profiles[i];

			if (profile !is null)
			{
				profile.SaveToFile();
			}
		}
	}

	PlayerProfile[] empty;
	this.set(PlayerProfiles::PROFILE_ARRAY_PROPERTY, empty);
}

void onRestart( CRules@ this )
{
	Reset(this);
}

void onInit( CRules@ this )
{
	Reset(this);

	this.addCommandID(PlayerProfiles::SYNC_PROFILE);
}

void onNewPlayerJoin( CRules@ this, CPlayer@ player )
{
	if(!getNet().isServer()) return;

	if (player !is null)
	{
		PlayerProfile@ profile = getProfile(player);

		if (profile !is null)
		{
			server_SyncProfile(profile, player);
		}
	}
}

void onCommand( CRules@ this, u8 cmd, CBitStream@ params )
{
	if (cmd == this.getCommandID(PlayerProfiles::SYNC_PROFILE))
	{
	    PlayerProfile@ profile = PlayerProfile();
	    
	    if (profile.Unserialise(params))
	    {
		    CPlayer@ localPlayer = getLocalPlayer();
		    if      (localPlayer !is null)
		    {
		    	string username = localPlayer.getUsername();
		    	if    (username == profile.username)
		    	{
		    		this.set(PlayerProfiles::PROFILE_PROPERTY, profile);

		    		printf("[PlayerProfiles]: onCommand() - Received profile sync");
		    	}
		    }
	    }
	    else
	    {
	    	warn("[PlayerProfiles]: onCommand() - Failed to read profile stream sync!");
	    }
	}
}