#include "WaterEffects.as"

const f32 SHARK_SPEED = 0.75f;
f32 zoom = 1.0f;
const f32 ZOOM_SPEED = 0.2f;

void onInit( CBlob@ this )
{
	//find target to swim towards
	this.set_Vec2f("target", getTargetVel( this ) * 0.5f);

	CSprite@ sprite = this.getSprite();
	sprite.SetZ(-10.0f);
	sprite.ReloadSprites(0,0); //always blue
	sprite.SetAnimation("out");
}

void onTick( CBlob@ this )
{	
	if (this.getPlayer() is null)
	{
		u32 ticktime = (getGameTime() + this.getNetworkID());

		if(ticktime % 5 == 0 && //check each 5 ticks
			this.hasTag("vanish") && //read tag
			getGameTime() > this.get_u32("vanishtime")) //compare time
		{
			this.Tag("no gib");
			this.server_Die();
			return;
		}
		if( ticktime % 40 == 0 )
		{
			this.set_Vec2f("target", getTargetVel( this ));
		}

		MoveTo( this, this.get_Vec2f("target") );
	}
	else
	{
		// player
		const f32 speed = SHARK_SPEED * 0.75f;
		Vec2f vel = this.getVelocity();
		if (this.isKeyPressed(key_up)){
			vel.y -= speed;
		}
		if (this.isKeyPressed(key_down)){
			vel.y += speed;
		}
		if (this.isKeyPressed(key_left)){
			vel.x -= speed;
		}
		if (this.isKeyPressed(key_right)){
			vel.x += speed;
		}
		MoveTo( this, vel );

		if (this.isMyPlayer())
		{
			HandleZoom( this );


		    if (getHUD().hasButtons())
		    {
		        if (this.isKeyJustPressed(key_action1))
		        {
				    CGridMenu @gmenu;
				    CGridButton @gbutton;
				    this.ClickGridMenu(0, gmenu, gbutton); 
			    }	
			}
		}
		this.getSprite().SetAnimation("default");
	}
	
}

//sprite update
void onTick( CSprite@ this )
{
	CBlob@ blob = this.getBlob();

	if(this.isAnimation("out") && this.isAnimationEnded())
		this.SetAnimation("default");


	if(blob.hasTag("vanish"))
		this.SetAnimation("in");
}

Random _anglerandom(0x9090); //clientside

void MoveTo( CBlob@ this, Vec2f vel )
{
	Vec2f pos = this.getPosition();	

	// move

	Vec2f moveVel = vel;
	const f32 angle = moveVel.Angle();
	moveVel *= SHARK_SPEED;

	this.setVelocity( moveVel );	
	this.setAngleDegrees( -angle );	

	// water effect

	if( (getGameTime() + this.getNetworkID()) % 9 == 0){
		MakeWaterWave(pos, Vec2f_zero, -angle + (_anglerandom.NextRanged(100) > 50 ? 180 : 0)); 
	}
}

Vec2f getTargetVel( CBlob@ this )
{
	CBlob@[] blobsInRadius;
	Vec2f pos = this.getPosition();
	Vec2f target = this.getVelocity();
	int humansInWater = 0;
	if (getMap().getBlobsInRadius( pos, 150.0f, @blobsInRadius ))
	{		
		f32 maxDistance = 9999999.9f;
		for (uint i = 0; i < blobsInRadius.length; i++)
		{
			CBlob @b = blobsInRadius[i];
			if (!b.isOnGround() && b.getName() == "human")
			{
				humansInWater++;
				f32 dist = (pos - b.getPosition()).getLength();
				if (dist < maxDistance)
				{
					target = b.getPosition() - pos;
					maxDistance = dist;
				}
			}
		}
	}

	if (humansInWater == 0)
	{
		this.Tag("vanish");
		this.set_u32("vanishtime", getGameTime() + 15);
	}

	target.Normalize();
	return target;
}

void onDie( CBlob@ this )
{
	MakeWaterParticle(this.getPosition(), Vec2f_zero); 
}

void onCollision( CBlob@ this, CBlob@ blob, bool solid, Vec2f normal, Vec2f point1 )
{
	if (blob is null) {
		return;
	}

	if (blob.getName() == "human" && !blob.isOnGround())
	{
		MakeWaterParticle(this.getPosition(), Vec2f_zero); 		
		this.getSprite().PlaySound("ZombieBite");
		blob.server_Die();
		this.server_Die();
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
		client_AddToChat( "You are a shark now." );
	}
}

void HandleZoom( CBlob@ this )
{
	CControls@ controls = getControls();
	if (controls !is null)
	{
		const int key_zoomout = 0x100;
		const int key_zoomin = 0xFF;
	  	if (controls.isKeyJustPressed(key_zoomout)){
	  		zoom = 0.5f;
	  	}
	  	else if (controls.isKeyJustPressed(key_zoomin)){
	  		zoom = 1.0f;
	  	}

		CCamera@ camera = getCamera();
		if (zoom == 1.0f)	{
			if (camera.targetDistance < zoom)
				camera.targetDistance += ZOOM_SPEED;		
		}
		else if (camera.targetDistance > zoom)	
			camera.targetDistance -= ZOOM_SPEED;	
	}
}