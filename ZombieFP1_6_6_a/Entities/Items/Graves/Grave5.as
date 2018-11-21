#include "Grave5Common.as";
void onInit(CBlob@ this)
{
    InitLoot(this);
    this.addCommandID("open");
}
f32 onHit( CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData )
{
    if (!button)
    {
        f32 health = this.getHealth();
        if (health <= openHealth && !this.hasTag("opened"))
            Open(this);
    }
    return damage;
}

void GetButtonsFor( CBlob@ this, CBlob@ caller )
{
    if (!this.hasTag("opened") && button)
        caller.CreateGenericButton( 20, Vec2f(0,0), this, this.getCommandID("open"), "Open");
}

void onCommand( CBlob@ this, u8 cmd, CBitStream @params )
{
    if (cmd == this.getCommandID("open"))
        Open(this);
}

void onDie(CBlob@ this)
{
    if (!this.hasTag("opened"))
        Open(this);
}

void Open(CBlob@ this)
{
    this.Tag("opened");

    Loot[]@ loot;
    this.get( "loot", @loot );

    for (int i = 0 ; i < loot.length; i++)
    {
        Loot @l = loot[i];
        print(l.name);
        const ::int rarernd = XORRandom(l.rarity) + 1;
        if (getNet().isServer() && (rarernd == l.rarity || l.rarity == 0))
        {
            if (l.name == "coins")
            {
                server_DropCoins(this.getPosition(), l.quantity);
            }
            else
            {
                CBlob@ item = server_CreateBlob( l.name, this.getTeamNum(), this.getPosition());
                if (item !is null)
                {
                    item.server_SetQuantity(l.quantity);
                    item.setVelocity(Vec2f(XORRandom(8) + itemVelocity, XORRandom(8) + itemVelocity));
                }
            }
        }
    }
    CSprite@ sprite = this.getSprite();
    sprite.SetAnimation("open");
}