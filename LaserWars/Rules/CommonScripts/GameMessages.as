/* GameMessages.as
 * author: Aphelion
 */

#include "GameMessagesCommon.as";

void onInit( CRules@ this )
{
    this.addCommandID(cmd_sendmessage);
}

void onCommand( CRules@ this, u8 cmd, CBitStream@ params )
{
	if (cmd == this.getCommandID(cmd_sendmessage))
	{
	    string user, msg;
		bool red;
		
		if (!params.saferead_string(user) || !params.saferead_string(msg) || !params.saferead_bool(red))
		    return;
		
		CPlayer@ localPlayer = getLocalPlayer();
		if      (localPlayer !is null && localPlayer.getUsername() == user && getNet().isClient())
		{
	        client_AddToChat(msg, red ? MESSAGE_RED : MESSAGE_BLACK);
		}
	}
}
