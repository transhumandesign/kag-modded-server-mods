// Priest logic
//by Diprog (edited by Frikman)

#include "Knocked.as"
#include "Help.as";
#include "Hitters2.as";
#include "PriestCommon.as";

void onInit( CBlob@ this )
{
	WizardInfo wizard;	  
	this.set("wizardInfo", @wizard);
	this.set_bool( "has_blob", false );
	this.set_Vec2f("inventory offset", Vec2f(0.0f, 122.0f));
	
    this.set_f32("gib health", -3.0f);
    this.Tag("player");
    this.Tag("flesh");
    this.set_u8("custom_hitter", Hitters2::wizexplosion);
	
	for (uint i = 0; i < orbTypeNames.length; i++) {
        this.addCommandID( "pick " + orbTypeNames[i]);
    }
	AddIconToken( "$Orb0$", "GUI/jitem.png", Vec2f(16,16), 27, 0);
	AddIconToken( "$Orb1$", "GUI/jitem.png", Vec2f(16,16), 27, 1);
	AddIconToken( "$Blink$", "wSpellIcons.png", Vec2f(16,16), 1 );
	AddIconToken( "$HealSpell$", "wSpellIcons.png", Vec2f(16,16), 0 );
	AddIconToken( "$Orb$", "OrbIcons", Vec2f(16,16), 0 );
	AddIconToken( "$FireOrb$", "OrbIcons", Vec2f(16,16), 1 );
	AddIconToken( "$BombOrb$", "OrbIcons", Vec2f(16,16), 2 );
	AddIconToken( "$WaterOrb$", "OrbIcons", Vec2f(16,16), 3 );
	 
	SetHelp( this, "help self action", "wizard", "$Orb$ Shoot orbs    $LMB$", "", 5 );
	SetHelp( this, "help self action2", "wizard", "$HealSpell$ Heal    $RMB$", "" ); 
	//SetHelp( this, "help show", "wizard", "$Blink$ Blink using V", "" );
	
	this.getCurrentScript().runFlags |= Script::tick_not_attached;
	this.getCurrentScript().removeIfTag = "dead";
}

void onSetPlayer( CBlob@ this, CPlayer@ player )
{
	if (player !is null){
		player.SetScoreboardVars("ScoreboardIcons.png", 6, Vec2f(16,16));
	}
}
void onCreateInventoryMenu( CBlob@ this, CBlob@ forBlob, CGridMenu @gridmenu )
{
    if (orbTypeNames.length == 0) {
        return;
    }

    this.ClearGridMenusExceptInventory();
    Vec2f pos( gridmenu.getUpperLeftPosition().x + 0.5f*(gridmenu.getLowerRightPosition().x - gridmenu.getUpperLeftPosition().x),
               (gridmenu.getUpperLeftPosition().y - 16 * 1 - 2*24));
    CGridMenu@ menu = CreateGridMenu( pos, this, Vec2f( orbTypeNames.length, 1 ), "Current orb" );

	WizardInfo@ wizard;
	if (!this.get( "wizardInfo", @wizard )) {
		return;
	}
	const u8 orbSel = wizard.orb_type;

    if (menu !is null)
    {
		menu.deleteAfterClick = false;
        for (uint i = 0; i < orbTypeNames.length; i++)
        {
            string matname = orbTypeNames[i];
            CGridButton @button = menu.AddButton( orbIcons[i], orbNames[i], this.getCommandID( "pick " + matname) );

            if (button !is null)
            {
				bool enabled = this.getBlobCount(orbTypeNames[i] ) > 0;
                button.SetEnabled( enabled );
				button.selectOneOnClick = true;

                if (orbSel == i) {
                    button.SetSelected(1);
                }
			}
        }
    }
}

void onAddToInventory( CBlob@ this, CBlob@ blob )
{
	string itemname = blob.getName();

	CInventory@ inv = this.getInventory();
	if (inv.getItemsCount() == 0)
	{
		WizardInfo@ wizard;
		if (!this.get( "wizardInfo", @wizard )) {
			return;
		}

		for (uint i = 0; i < orbTypeNames.length; i++)
		{
			if (itemname == orbTypeNames[i]) {
				wizard.orb_type = i;
			}
		}
	}
}
void onCommand( CBlob@ this, u8 cmd, CBitStream @params )
{
	WizardInfo@ wizard;
	if (!this.get( "wizardInfo", @wizard )) {
		return;
	}
    for (uint i = 0; i < orbTypeNames.length; i++)
    {
        if (cmd == this.getCommandID( "pick " + orbTypeNames[i]))
        {
            wizard.orb_type = i;
            break;
        }
    }
}
void onTick( CBlob@ this )
{
	AttachmentPoint@ hands = this.getAttachments().getAttachmentPointByName("PICKUP");
	hands.offset.Set(0, -1);
}

f32 onHit( CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitBlob, u8 customData ){
	if (customData == Hitters2::wizexplosion){
		return 0.0f;
	}
	if (hitBlob.getName() == "wizard_orb" && hitBlob.getDamageOwnerPlayer() is this.getPlayer()){
		return 0.0f;
	}
	return damage;
}