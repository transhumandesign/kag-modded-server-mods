// Princess brain

#define SERVER_ONLY

#include "BrainCommon.as"

void onInit(CBrain@ this)
{
	InitBrain(this);

	this.server_SetActive(true);   // always running
	CBlob @blob = this.getBlob();
	blob.set_f32("gib health", -1.5f);

    if(blob.getTeamNum() != 1)
    {
        this.RemoveScript("GoGoNecro.as");
        this.getBlob().RemoveScript("GoGoNecro.as");

    }

    this.getBlob().set_s32("necrotimeout", getGameTime() + 40*30);

}

void onTick(CBrain@ this)
{
    if(this.getBlob().getTeamNum() != 1)
        return;

    bool istimeout = this.getBlob().get_s32("necrotimeout") < getGameTime();
    if(istimeout)
    {
        CBlob@ b =  getBlobByName("tradingpost");
        if(b !is null)
        {
            this.getBlob().setPosition(b.getPosition());

        }

    }

	if(this.getTarget() is null)
    {
        this.SetTarget(getBlobByName("tradingpost"));

    }

	CBlob @blob = this.getBlob();
	CBlob @target = this.getTarget();

	// logic for target

	this.getCurrentScript().tickFrequency = 29;
	if (target !is null)
	{
		this.getCurrentScript().tickFrequency = 1;
		DefaultChaseBlob(blob, target);
	}
	else
	{
		RandomTurn(blob);
	}

	FloatInWater(blob);
}

// BLOB

//physics logic
void onCollision(CBlob@ this, CBlob@ blob, bool solid)
{
    if(blob is this.getBrain().getTarget())
    {
        this.RemoveScript("GoGoNecro.as");
        this.getBrain().RemoveScript("GoGoNecro.as");

    }
}
