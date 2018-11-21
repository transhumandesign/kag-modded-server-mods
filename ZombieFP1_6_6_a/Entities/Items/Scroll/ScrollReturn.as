void onInit( CBlob@ this )
{
	this.addCommandID( "teleport" );
}

void GetButtonsFor( CBlob@ this, CBlob@ caller )
{
	CBitStream params;
	params.write_u16(caller.getNetworkID());
	u8 kek = caller.getTeamNum();	
	if (kek == 0)
	{	
		caller.CreateGenericButton( 11, Vec2f_zero, this, this.getCommandID("teleport"), "Teleport to a Dormitory.", params );
	}
}

void onCommand( CBlob@ this, u8 cmd, CBitStream @params )
{
	if (cmd == this.getCommandID("teleport"))
	{
		CBlob@ caller = getBlobByNetworkID( params.read_u16() );
		ParticleZombieLightning( this.getPosition() );
		ParticleZombieLightning( caller.getPosition() );
		
		CBlob@[] tents;
		getBlobsByName("dorm", @tents);
		for (int n = 0; n < tents.length; n++)
		{
			if (tents[n] !is null && tents[n].getTeamNum() == caller.getTeamNum())
			{
				caller.setPosition(tents[n].getPosition());
				ParticleZombieLightning( caller.getPosition() ); 
			}
		}
		this.server_Die();
	}
}