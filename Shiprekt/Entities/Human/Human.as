#include "HumanCommon.as"
#include "EmotesCommon.as"
#include "MakeBlock.as"
#include "WaterEffects.as"
#include "IslandsCommon.as"

int useClickTime = 0;
f32 zoom = 1.0f;
const f32 ZOOM_SPEED = 0.1f;

void onInit( CBlob@ this )
{
	this.Tag("player");	 
	this.SetMinimapVars("GUI/Minimap/MinimapIcons.png", 8, Vec2f(8,8));
	this.addCommandID("get out");
	this.addCommandID("punch");
	this.set_f32("cam rotation", 0.0f);
	this.set_f32("health", 5.0f );
	const u16 shipID = this.get_u16( "shipID" );
	CBlob@ ship = getBlobByNetworkID(shipID);
	if (ship !is null) {
		this.setPosition( ship.getPosition() );
		this.set_s8( "stay count", 3 );
	}
	this.SetMapEdgeFlags( u8(CBlob::map_collide_none) | u8(CBlob::map_collide_nodeath) );
}

void onTick( CBlob@ this )
{				
	Move( this );

	// my player stuff

	if (this.isMyPlayer())	{
		PlayerControls( this );
	}
}

void onSetPlayer( CBlob@ this, CPlayer@ player )
{	
	if (player !is null && player.isMyPlayer()) // setup camera to follow
	{
		CCamera@ camera = getCamera();
		camera.mousecamstyle = 1; // follow
		camera.targetDistance = 1.0f; // zoom factor
		camera.posLag = 5; // lag/smoothen the movement of the camera

		this.SetMinimapVars("GUI/Minimap/MinimapIcons.png", 0, Vec2f(8,8));
		client_AddToChat( "You are part of team " + this.getTeamNum() + " now." );
	}
}

void Move( CBlob@ this )
{
	const bool myPlayer = this.isMyPlayer();
	const f32 camRotation = myPlayer ? getCamera().getRotation() : this.get_f32("cam rotation");
	const bool attached = this.isAttached();
	Vec2f pos = this.getPosition();	
	Vec2f aimpos = this.getAimPos();
	Vec2f forward = aimpos - pos;	

	if (myPlayer)
	{
		this.set_f32("cam rotation", camRotation);
		this.Sync("cam rotation", false);
	}	
	
	if (!attached)
	{	
		const bool up = this.isKeyPressed( key_up );
		const bool down = this.isKeyPressed( key_down );
		const bool left = this.isKeyPressed( key_left);
		const bool right = this.isKeyPressed( key_right );	
		const bool punch = this.isKeyJustPressed( key_action1 );
		const u32 time = getGameTime();
		const f32 vellen = this.getShape().vellen;
		CBlob@ islandBlob = getIslandBlob( this );
		const bool solidGround = this.getShape().getVars().onground = (attached || islandBlob !is null);

		// move

		Vec2f moveVel;

		if (up)	{
			moveVel.y -= Human::walkSpeed;
		} 
		else if (down)	{
			moveVel.y += Human::walkSpeed;
		} 
		
		if (left)	{
			moveVel.x -= Human::walkSpeed;
		} 
		else if (right)	{
			moveVel.x += Human::walkSpeed;
		} 

		if (!solidGround)
		{
			moveVel *= Human::swimSlow;

			if( (getGameTime() + this.getNetworkID()) % 3 == 0)
				MakeWaterParticle(pos, Vec2f()); 

			if (this.wasOnGround())
				this.getSprite().PlaySound("SplashFast");
		}
		else
		{
			// punch
			if (punch && !Human::isHoldingBlocks(this))
			{
				Punch( this );
			}
		}

		moveVel.RotateBy( camRotation );
		this.setVelocity( moveVel );

		// face

		f32 angle = camRotation;
		forward.Normalize();
		if (up && left) angle += 225;
		else if (up && right) angle += 315;
		else if (down && left) angle += 135;
		else if (down && right) angle += 45;
		else if (up) angle += 270;
		else if (down) angle += 90;
		else if (left) angle += 180;
		else if (right) angle += 0;
		else angle = -forward.Angle();
		
		while(angle > 360)
			angle -= 360;
		while(angle < 0)
			angle += 360;

		this.getShape().SetAngleDegrees( angle );	

		// artificial stay on ship

		if (islandBlob !is null)
		{
			this.set_u16( "shipID", islandBlob.getNetworkID() );	
			this.set_s8( "stay count", 3 );
		}
		else
		{
			CBlob@ shipBlob = getBlobByNetworkID( this.get_u16( "shipID" ) );
			if (shipBlob !is null)
			{
				s8 count = this.get_s8( "stay count" );		
				count--;
				if (count <= 0){
					this.set_u16( "shipID", 0 );	
				}
				else if (!up && !left && !right && !down)
				{
					this.setPosition( shipBlob.getPosition() );
				}
				this.set_s8( "stay count", count );		
			}
		}
	}
	else
	{
		this.getShape().getVars().onground = true;
		this.getShape().SetAngleDegrees( -forward.Angle() );
	}
}



void PlayerControls( CBlob@ this )
{
	CHUD@ hud = getHUD();

	// bubble menu
	if (this.isKeyJustPressed(key_bubbles))
	{
		this.CreateBubbleMenu();
	}

	if (this.isAttached())
	{
	    // get out of seat
		if (this.isKeyJustPressed(key_use))
		{
			CBitStream params;
			this.SendCommand( this.getCommandID("get out"), params );
		} 

		// aim cursor
		hud.SetCursorImage("ArcherCursor.png", Vec2f(32,32));
		hud.SetCursorOffset( Vec2f(-32, -32) );		
	}
	else
	{		
		// use menu
	    if (this.isKeyJustPressed(key_use))
	    {
	        this.ClearMenus();
	        this.ShowInteractButtons();
	        useClickTime = getGameTime();
	    }
	    else if (this.isKeyJustReleased(key_use))
	    {
	    	bool tapped = (getGameTime() - useClickTime) < 10; 
	    	this.ClickClosestInteractButton( tapped ? this.getPosition() : this.getAimPos(), this.getRadius()*2 );
	        this.ClearButtons();
	    }	

	    // click action1 to click buttons

		if (hud.hasButtons() && this.isKeyJustPressed(key_action1) && !this.ClickClosestInteractButton( this.getAimPos(), this.getRadius()*3 ))
	    {
	    }

	    // default cursor
	    hud.SetDefaultCursor();
	}

	// click grid menus

    if (hud.hasButtons())
    {
        if (this.isKeyJustPressed(key_action1))
        {
		    CGridMenu @gmenu;
		    CGridButton @gbutton;
		    this.ClickGridMenu(0, gmenu, gbutton); 
	    }	
	}

	// zoom
	
	CCamera@ camera = getCamera();
	CControls@ controls = getControls();
	if (controls !is null)
	{
		const int key_zoomout = 0x100;
		const int key_zoomin = 0xFF;

		if (zoom == 2.0f)	
		{
			if (controls.isKeyJustPressed(key_zoomout)){
	  			zoom = 1.0f;
	  		}
			else if (camera.targetDistance < zoom)
				camera.targetDistance += ZOOM_SPEED;		
		}
		else if (zoom == 1.0f)	
		{
			if (controls.isKeyJustPressed(key_zoomout)){
	  			zoom = 0.5f;
	  		}
	  		else if (controls.isKeyJustPressed(key_zoomin)){
	  			zoom = 2.0f;
	  		} 
	  		else if (camera.targetDistance < zoom)
				camera.targetDistance += ZOOM_SPEED;	
			else if (camera.targetDistance > zoom)
				camera.targetDistance -= ZOOM_SPEED;	
		}
		else if (zoom == 0.5f)
		{
			if (controls.isKeyJustPressed(key_zoomin)){
	  			zoom = 1.0f;
	  		} 
			else if (camera.targetDistance > zoom)	
				camera.targetDistance -= ZOOM_SPEED;
		}
	}
}

void onAttached( CBlob@ this, CBlob@ attached, AttachmentPoint @attachedPoint )
{  
	this.ClearMenus();
}

void onDetach( CBlob@ this, CBlob@ detached, AttachmentPoint @attachedPoint )
{  
	this.set_u16( "shipID", detached.getNetworkID() );
	this.set_s8( "stay count", 3 );
}

void onDie( CBlob@ this )
{
	CSprite@ sprite = this.getSprite();
	sprite.Gib();
	sprite.PlaySound("ManScream");
	ParticleBloodSplat( this.getPosition(), true );
	sprite.PlaySound("BodyGibFall");

	if(this.isMyPlayer())
	{
		CCamera@ camera = getCamera();
		if (camera !is null)
		{
			camera.setRotation(0.0f);
			camera.targetDistance = 1.0f;
		}
	}

	// destroy blocks

    CBlob@[]@ blocks;
    if (this.get( "blocks", @blocks ))                 
    {
        for (uint i = 0; i < blocks.length; ++i)
        {
            CBlob@ b = blocks[i];
            b.server_Die();
        }
        blocks.clear();
    } 
}

void Punch( CBlob@ this )
{
	Vec2f pos = this.getPosition();
	Vec2f aimvector = this.getAimPos() - pos;
	const f32 aimdist = aimvector.Normalize();

	CBlob@[] blobsInRadius;
	if (this.getMap().getBlobsInRadius( pos, this.getRadius()*3.0f, @blobsInRadius ))
	{
		for (uint i = 0; i < blobsInRadius.length; i++)
		{
			CBlob @b = blobsInRadius[i];
			if (b !is this && b.getTeamNum() != this.getTeamNum() && b.getName() == "human")
			{
				Vec2f vector = b.getPosition() - pos;
				if (vector * aimvector > 0.0f)
				{
					if (this.isMyPlayer())
					{
						CBitStream params;
						params.write_netid( b.getNetworkID() );
						this.SendCommand( this.getCommandID("punch"), params );
					}
					return;
				}
			}
		}
	}

	// miss
	this.getSprite().PlaySound("throw");
}

void onCommand( CBlob@ this, u8 cmd, CBitStream @params )
{
	if (this.getCommandID("get out") == cmd){
		this.server_DetachFromAll();
	}
	else if (this.getCommandID("punch") == cmd){
		CBlob@ b = getBlobByNetworkID( params.read_netid() );
		if (b !is null)
		{
			f32 health = b.get_f32("health");
			health -= 1.0f;
			b.set_f32("health", health);
			if (health < 0.0f)
			{
				b.server_Die();
			}
			else
			{
				ParticleBloodSplat( b.getPosition(), false );
				b.getSprite().PlaySound("Kick.ogg");			
			}
		}
	}
}
