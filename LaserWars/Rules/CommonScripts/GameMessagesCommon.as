/* GameMessagesCommon.as
 * author: Aphelion
 */

const string cmd_sendmessage = "rules send message";

const SColor MESSAGE_BLACK = SColor(255, 0, 0, 0);
const SColor MESSAGE_RED = SColor(255, 255, 0, 0);

void cmdSendMessage( string player, string message, bool red )
{
	CBitStream params;
	params.write_string(player);
	params.write_string(message);
	params.write_bool(red);
	
	getRules().SendCommand(getRules().getCommandID(cmd_sendmessage), params);
}

void sendMessage( CPlayer@ player, SColor color, string message )
{
    if (getNet().isClient() && player !is null && getLocalPlayer() is player)
	{
	    client_AddToChat(message, color);
	}
}

void sendMessage( CPlayer@ player, string message )
{
    if (getNet().isClient() && player !is null && getLocalPlayer() is player)
	{
	    client_AddToChat(message, MESSAGE_BLACK);
	}
}

void sendMessage( string message )
{
    if (getNet().isClient())
	{
	    client_AddToChat(message, MESSAGE_BLACK);
	}
}
