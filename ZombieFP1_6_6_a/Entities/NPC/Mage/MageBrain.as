// Mage brain

#define SERVER_ONLY

#include "BotBrainCommon.as"

namespace AttackType
{
	enum type
	{
	attack_fire = 0,
	attack_manical,
	attack_rest
	};
};

void onInit( CBrain@ this )
{
	InitBrain( this );

	this.server_SetActive( true ); // always running
	CBlob @blob = this.getBlob();
	blob.set_f32("gib health", 0.0f);
	blob.Tag("migrant");
	blob.Tag("flesh");

	blob.set_u8("attack stage", AttackType::attack_fire);
	blob.set_u8("attack counter", 0);
}

void onTick( CBrain@ this )
{
	SearchTarget( this, false, true );
	
	CBlob @blob = this.getBlob();
	
	bool sawYou = blob.hasTag("saw you");
	SearchTarget( this, sawYou, true );

	CBlob @target = this.getTarget();

	// logic for target

	this.getCurrentScript().tickFrequency = 29;
	if(target !is null)
	{	
		this.getCurrentScript().tickFrequency = 1;

		u8 strategy = blob.get_u8("strategy");
		bool standground = blob.get_bool("standground");
		const f32 distance = (target.getPosition() - blob.getPosition()).getLength();
		f32 visibleDistance;
		const bool visibleTarget = isVisible( blob, target, visibleDistance);
		if(visibleTarget && visibleDistance < 70.0f) 
		{
			DefaultRetreatBlob( blob, target );
			strategy = Strategy::retreating;
		}	

		if(distance < 150.0f)
		{
			if(!sawYou)
			{
				blob.getSprite().PlaySound("/EvilNotice.ogg");
				blob.setAimPos( target.getPosition() );
				blob.Tag("saw you");
				strategy = Strategy::attacking; 
			}

			u8 stage = blob.get_u8("attack stage");

			const u32 gametime = getGameTime();
			if(stage == AttackType::attack_manical || (stage == AttackType::attack_fire && gametime % 50 == 0)) 
			{
				blob.setKeyPressed( key_action1, true );
				f32 vellen = target.getShape().vellen;
				Vec2f randomness = Vec2f( -5+XORRandom(100)*0.1f, -5+XORRandom(100)*0.1f );
				blob.setAimPos( target.getPosition() + target.getVelocity()*vellen*vellen + randomness  );
			}

			int x = gametime % 300;
			if(x < 140) {
				stage = AttackType::attack_fire;
			}
			else if(x < 190) {
				stage = visibleTarget ? AttackType::attack_manical :  AttackType::attack_fire;
			}

			blob.set_u8("attack stage", stage);

		}

		LoseTarget( this, target );
	}
	else
	{
		RandomTurn( blob );
	}

	FloatInWater( blob ); 
} 

