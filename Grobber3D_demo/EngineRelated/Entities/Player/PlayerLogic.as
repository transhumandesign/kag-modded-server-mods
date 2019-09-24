#include "PlayerCommon.as"
#include "IsLocalhost.as";

//#include "ParticleSystemClass.as"

void onInit(CBlob@ this)
{
	this.set_u8("prop_id", 1);
	
	this.Tag("player");
	this.set_f32("dir_x", 0.0f);
	this.set_f32("dir_y", 0.0f);
	this.getShape().SetRotationsAllowed(false);
	this.getShape().getConsts().net_threshold_multiplier = 0.5f;

	this.addCommandID(camera_sync_cmd);
	this.addCommandID(shooting_cmd);
	this.addCommandID("cycle");
	
	this.chatBubbleOffset = Vec2f(-20000, -50000);
	this.maxChatBubbleLines = -1;
	
	this.SetLight(false);
    //this.SetLightRadius(80.0f);
    //this.SetLightColor(SColor(255, 200, 140, 170));
	
	this.getCurrentScript().runFlags |= Script::tick_not_attached;
	this.getCurrentScript().removeIfTag = "dead";
}

void onTick(CBlob@ this)
{
	if(!this.isMyPlayer()) return;
	if(isServer() && !isLocalhost()) return;
	
	u8 delay = this.get_u8("shoot_delay");
	if(delay > 0)
		this.sub_u8("shoot_delay", 1);
	if(!getHUD().hasMenus())
	{
		ManageCamera(this);
		
		ManageShooting(this);
	}
}

void ManageShooting(CBlob@ this)
{
	const bool lmbClick	= this.isKeyJustPressed(key_action1);
	u8 delay = this.get_u8("shoot_delay");
	if(delay <= 0 && lmbClick && !(this.getSprite().isAnimation("shoot") && !this.getSprite().isAnimationEnded()) && !getRules().get_bool("stuck"))
	{
		this.set_u8("shoot_delay", 12);
		Shoot(this);
		//particle_system@ PS = getParticleSystem();
		//PS.shoot_em_boi(10, this.get_f32("dir_x")+180, vec3d(this.getPosition().y/16, 0.75, this.getPosition().x/16));
		//PS.sprout();
	}
}

void ManageCamera(CBlob@ this)
{
	CControls@ c = getControls();
	Driver@ d = getDriver();
	bool esc = c.isKeyJustPressed(KEY_ESCAPE);
	bool ctrl = c.isKeyJustPressed(KEY_RCONTROL);
	//if(ctrl){ this.set_bool("stuck", !this.get_bool("stuck")); this.Sync("stuck", true);}
	CRules@ rules = getRules();
	if(esc || ctrl) rules.set_bool("stuck", !rules.get_bool("stuck"));
	//if(ctrl) this.set_bool("stuck", !this.get_bool("stuck"));
	if(!rules.get_bool("stuck") && d !is null && c !is null)
	{
		Vec2f ScrMid = Vec2f(f32(d.getScreenWidth()) / 2, f32(d.getScreenHeight()) / 2);
		Vec2f dir = (c.getMouseScreenPos() - ScrMid)/10;
		f32 dirX = this.get_f32("dir_x");
		f32 dirY = this.get_f32("dir_y");
		dirX += dir.x;
		dirY = Maths::Clamp(dirY-dir.y,-90,90);
		this.set_f32("dir_x", dirX);
		this.set_f32("dir_y", dirY);
		c.setMousePosition(ScrMid);
	}
	if(getGameTime() % 3 == 0)
	{
		SyncCamera(this);
	}
}

bool canSend(CBlob@ this)
{
	return (this.isMyPlayer() || this.getPlayer() is null || this.getPlayer().isBot());
}

void onCommand(CBlob@ this, u8 cmd, CBitStream @params)
{
	if (cmd == this.getCommandID(camera_sync_cmd))
	{
		HandleCamera(this, params, !canSend(this));
	}
	
	else if (getNet().isServer() && cmd == this.getCommandID(shooting_cmd))
	{
		CreateBullet(this, params);
	}
}