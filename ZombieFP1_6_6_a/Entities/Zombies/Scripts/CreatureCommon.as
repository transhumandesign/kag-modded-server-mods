// Aphelion \\

const string chomp_tag = "chomping";

const string delay_property = "brain_delay";
const string target_searchrad_property = "brain_target_rad";
const string destination_property = "brain_destination";
const string obstruction_threshold = "brain_obstruction_threshold";

/*
class ZombieInfo
{
    u8 attack_frequency;
    f32 attack_damage;
    string attack_sound;
    string death_sound;
    string spawn_sound;
    string hurt_sound;
    int coins;

    TargetInfo[] targets;
}
*/

shared class TargetInfo
{
    string identifier;
    f32 priority;
    bool tag;
    bool seeThroughWalls;

    TargetInfo( string _identifier, f32 _priority = 0.5f, bool _tag = false, bool _seeThroughWalls = false )
    {
        identifier = _identifier;
        priority = _priority;
        tag = _tag;
        seeThroughWalls = _seeThroughWalls;
    }

    bool isTarget( CBlob@ target )
    {
        return tag ? target.hasTag(identifier) : target.getName() == identifier;
    }
}

shared class CreatureMoveVars
{
    //walking vars
    f32 walkSpeed;  //target vel
    f32 walkFactor;
    Vec2f walkLadderSpeed;
	
	//climbing vars
	bool climbingEnabled;
	
    //jumping vars
    f32 jumpMaxVel;
    f32 jumpStart;
    f32 jumpMid;
    f32 jumpEnd;
    f32 jumpFactor;
    s32 jumpCount; //internal counter
	
    //force applied while... stopping
    f32 stoppingForce;
    f32 stoppingForceAir;
    f32 stoppingFactor;

    //flying vars
    f32 flySpeed;
    f32 flyFactor;
};

void RemoveTarget( CBrain@ this )
{
    CBlob@ blob = this.getBlob();
    CBlob@ carried = blob.getCarriedBlob();

    if (carried !is null && carried is this.getTarget())
    {
        carried.server_DetachFrom(blob);
    }

    // remove
    this.SetTarget(null);
}

void ResetDestination( CBlob@ blob )
{
    blob.set_Vec2f(destination_property, Vec2f_zero);
}

bool isTarget( CBlob@ this, CBlob@ target )
{
    if (target !is null)
    {
        TargetInfo[]@ infos;
        this.get("target infos", @infos);

        for(uint i = 0; i < infos.length; i++)
        {
            TargetInfo info = infos[i];

            if (info.isTarget(target))
            {
                return true;
            }
        }
    }
    return false;
}

f32 getTargetPriority( CBlob@ this, CBlob@ target )
{
    if (target !is null)
    {
        TargetInfo[]@ infos;
        this.get("target infos", @infos);

        for(uint i = 0; i < infos.length; i++)
        {
            TargetInfo info = infos[i];

            if (info.isTarget(target))
            {
                return info.priority;
            }
        }
    }
    return 0.0f;
}

bool seeTargetThroughWalls( CBlob@ this, CBlob@ target )
{
    if (target !is null)
    {
        TargetInfo[]@ infos;
        this.get("target infos", @infos);

        for(uint i = 0; i < infos.length; i++)
        {
            TargetInfo info = infos[i];

            if (info.isTarget(target))
            {
                return info.seeThroughWalls;
            }
        }
    }
    return false;
}

bool isTargetVisible( CBlob@ this, CBlob@ target )
{
    Vec2f col;

    if (getMap().rayCastSolid(this.getPosition(), target.getPosition(), col))
    {
        // fix for doors not being considered visible
        CBlob@ obstruction = getMap().getBlobAtPosition(col);

        if (obstruction is null || obstruction !is target)
            return false;
    }
    return true;
}

bool isTargetVisible( CBlob@ this, CBlob@ target, f32 &out distance )
{
    distance = (target.getPosition() - this.getPosition()).getLength();
    return isTargetVisible(this, target);
}

f32 getDistanceBetween( Vec2f point1, Vec2f point2 )
{
    return (point1 - point2).getLength();
}

f32 getXBetween( Vec2f point1, Vec2f point2 )
{
    return Maths::Abs(point1.x - point2.x);
}

f32 getYBetween( Vec2f point1, Vec2f point2 )
{
    return Maths::Abs(point1.y - point2.y);
}
