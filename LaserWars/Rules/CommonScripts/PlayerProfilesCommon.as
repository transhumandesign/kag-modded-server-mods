/* PlayerProfilesCommon.as
 * author: Aphelion
 */

#ifndef INCLUDED_PLAYERPROFILES
#define INCLUDED_PLAYERPROFILES

namespace PlayerProfiles
{
	const string SYNC_PROFILE = "sync profile";
	const string SYNC_STATS = "sync stats";
	const string SYNC_STAT = "sync stat";

	const string PROFILE_PROPERTY = "profile"; // client
	const string PROFILE_ARRAY_PROPERTY = "profile array"; // server
}

shared class PlayerProfile
{
    string profiles_path = "Profiles/";

	string username;

	string[] loadout_items; // purchased items
	string loadout_exosuit;
	string loadout_primary;
	string loadout_sidearm;

	// Stats
	int kills;
	int deaths;

	PlayerProfile() { Setup("", "", "", ""); }

	PlayerProfile( string username ) { Setup(username, "logistics", "gauss_rifle", "omni_tool"); }

	void Setup( string _username, string _loadout_exosuit, string _loadout_primary, string _loadout_sidearm )
	{
		username = _username;

		loadout_exosuit = _loadout_exosuit;
		loadout_primary = _loadout_primary;
		loadout_sidearm = _loadout_sidearm;
	}

	void LoadFromFile()
	{
		ConfigFile profile = ConfigFile();
		profile.loadFile("../Cache/" + profiles_path + "Profile-" + username + ".cfg");

		kills = profile.read_s32("kills", 0);
		deaths = profile.read_s32("deaths", 0);
	}

	void SaveToFile()
	{
		ConfigFile profile = ConfigFile();

		profile.add_s32("kills", kills);
		profile.add_s32("deaths", deaths);
	    profile.saveFile(profiles_path + "Profile-" + username + ".cfg");
	}

	void AddItem( string item )
	{
		loadout_items.push_back(item);
	}

	bool HasItem( string item )
	{
		for(uint i = 0; i < loadout_items.length; i++)
		{
			if (loadout_items[i] == item)
			{
				return true;
			}
		}
		return false;
	}

	CBitStream@ Serialise()
	{
		CBitStream stream;

		stream.write_string(username);
		stream.write_string(loadout_exosuit);
		stream.write_string(loadout_primary);
		stream.write_string(loadout_sidearm);
		stream.write_s32(kills);
		stream.write_s32(deaths);
		stream.write_u16(loadout_items.length);

		for(uint i = 0; i < loadout_items.length; i++)
		{
			stream.write_string(loadout_items[i]);
		}
		return stream;
	}

	bool Unserialise( CBitStream@ stream )
	{
		if (!stream.saferead_string(username)) return false;
		if (!stream.saferead_string(loadout_exosuit)) return false;
		if (!stream.saferead_string(loadout_primary)) return false;
		if (!stream.saferead_string(loadout_sidearm)) return false;
		if (!stream.saferead_s32(kills)) return false;
		if (!stream.saferead_s32(deaths))  return false;

		u16 length;
	    if (!stream.saferead_u16(length)) return false;

		for(uint i = 0; i < length; i++)
		{
			string item;
			if (!stream.saferead_string(item)) return false;

			AddItem(item);
		}
		return true;
	}

	bool opEquals(const PlayerProfile &in other) const
	{
		return this is other;
	}

	int opCmp(const PlayerProfile &in other) const
	{
		return username.opCmp(other.username);
	}
}

shared PlayerProfile@ getProfile( CPlayer@ player )
{
	if (player is null)
	{
		warn("[PlayerProfilesCommon]: getProfile() - Attempted to retrieve profile of non-existant player!");
		return null;
	}

	PlayerProfile@ profile;

	if (getNet().isServer())
	{
		@profile = server_getProfileFromName(player.getUsername());
	}
	else
	{
		getRules().get("profile", @profile);
	}
	return profile;
}

shared PlayerProfile[]@ server_getProfiles()
{
	PlayerProfile[]@ profiles;

	getRules().get("profile array", @profiles);
	return profiles;
}

shared PlayerProfile@ server_getProfileFromName( string username )
{
	PlayerProfile[]@ profiles = server_getProfiles();

	for(uint i = 0; i < profiles.length; i++)
	{
		if (profiles[i].username == username)
		{
			return profiles[i];
		}
	}
	return null;
}

PlayerProfile@ server_GetOrCreateProfile( CPlayer@ player, bool sync = false )
{
	if (player is null)
	{
		warn("[PlayerProfilesCommon]: server_GetOrCreate() - Attempted to get or create profile for non-existant player");

		return PlayerProfile("null profile");
	}
	
	PlayerProfile@ profile = getProfile(player);

	if (profile is null)
	{
		@profile = PlayerProfile(player.getUsername());
		profile.LoadFromFile();

	    server_SetProfile(player, profile);
	    sync = true;
	}

	if (sync)
	{
	    server_SyncProfile(profile, player);
	}

	return profile;
}

void server_SetProfile( CPlayer@ player, PlayerProfile@ profile )
{
	if (getNet().isClient()) return;

	if (player is null)
	{
		warn("[PlayerProfilesCommon]: SetProfile() - Attempted to set the profile of a non-existant player!");
		return;
	}

	if (server_getProfileFromName(player.getUsername()) !is null)
	{
		warn("[PlayerProfilesCommon]: SetProfile() - Profile already exists for player " + player.getUsername());
		return;
	}

	PlayerProfile[]@ profiles = server_getProfiles();
	profiles.push_back(profile);
}

void server_SyncProfile( PlayerProfile@ profile, CPlayer@ player )
{
	if (profile is null)
	{
		warn("[PlayerProfilesCommon]: server_SyncProfile() - Attempted to sync non-existant profile!");
		return;
	}

	if (player is null)
	{
		warn("[PlayerProfilesCommon]: server_SyncProfile() - Attempted to sync profile with non-existant player!");
		return;
	}

	CRules@ rules = getRules();

	rules.set_u32(player.getUsername() + " k", profile.kills);
	rules.set_u32(player.getUsername() + " d", profile.deaths);
	rules.Sync(player.getUsername() + " k", true);
	rules.Sync(player.getUsername() + " d", true);

	if(!player.isBot()) // avoid crash
	{
		rules.SendCommand(rules.getCommandID(PlayerProfiles::SYNC_PROFILE), profile.Serialise(), player);

		printf("[PlayerProfilesCommon]: server_SyncProfile() - Sent profile sync to player " + player.getUsername());
	}
}

#endif