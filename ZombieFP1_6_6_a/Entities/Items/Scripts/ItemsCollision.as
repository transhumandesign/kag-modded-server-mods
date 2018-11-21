bool doesCollideWithBlob( CBlob@ this, CBlob@ blob )
{	
	if (blob.hasTag("blocks water"))
	{
		return true;
	}
	else return false;
}