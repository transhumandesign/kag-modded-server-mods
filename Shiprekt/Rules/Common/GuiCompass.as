
class CompassVars {
    s32[] core_teams;
    f32[] core_angles;
    f32[] core_distances;

    f32 north_angle;

    CompassVars() {
        Reset();
    }

    void Reset() {
        north_angle = 0.0f;
        core_angles.clear();
        core_teams.clear();
        core_distances.clear();
    }
};

CompassVars _vars;

void onTick( CRules@ this )
{
    _vars.Reset();

    CPlayer@ p = getLocalPlayer();
    if (p is null || !p.isMyPlayer()) { return; }

    CBlob@ b = p.getBlob();
    if(b is null) return;

    Vec2f pos = b.getPosition();

    CBlob@[] cores;
    getBlobsByTag( "mothership", cores );
    for (uint i = 0; i < cores.length; i++)
    {
        CBlob@ core = cores[i];
        _vars.core_teams.push_back(core.getTeamNum());

        Vec2f offset = (core.getPosition() - pos);

        _vars.core_angles.push_back(offset.Angle() * -1.0f); 
        _vars.core_distances.push_back(offset.Length());
    }

}

void onInit( CRules@ this )
{
    onRestart(this);
}

void onRestart( CRules@ this )
{
    _vars.Reset();
}

void onRender( CRules@ this )
{
    const string gui_image_fname = "GUI/compass.png";

    CCamera@ c = getCamera();
    f32 camangle = c.getRotation();

    Vec2f topLeft = Vec2f(8,8);
    Vec2f framesize = Vec2f(64,64);
    Vec2f center = Vec2f(32,32);

    GUI::DrawIcon(gui_image_fname, 0, framesize, topLeft, 1.0f, 0);

    //north
    {
        Vec2f pos(8,0);

        Vec2f thisframesize = Vec2f(16,16);

        pos.RotateBy(-90 - camangle);

        GUI::DrawIcon(gui_image_fname, 13, thisframesize, topLeft + (center + pos)*2.0f - thisframesize, 1.0f, 0);
    }

    //core icons
    for (uint i = 0; i < _vars.core_teams.length; i++)
    {
        Vec2f pos( Maths::Max(4.0f,Maths::Min(18.0f, _vars.core_distances[i] / 48.0f )), 0.0f);

        Vec2f thisframesize = Vec2f(8,8);

        pos.RotateBy(_vars.core_angles[i] - camangle);

        GUI::DrawIcon(gui_image_fname, 24, thisframesize, topLeft + (center + pos)*2.0f - thisframesize, 1.0f, _vars.core_teams[i]);
    }
}
