
int time;

void onInit( CRules@ this )
{
	time = 0;
}

void onRender( CRules@ this )
{
	time++;
    const int endTime1 = getTicksASecond() * 4;
	const int endTime2 = getTicksASecond() * 20;
	const int endTime3 = getTicksASecond() * 40;

	bool draw = false;
	Vec2f ul, lr;
	string text = "";

	ul = Vec2f( 30, 3*getScreenHeight()/4 );

    if (time < endTime1) {
        text = "Welcome to Shiprekt!";
        
		Vec2f size;
		GUI::GetTextDimensions(text, size);
		lr = ul + size;
		draw = true;
    }
	else if (time < endTime2) {
		text =  "How to Play:\n\n"+
				" *Your Core (spawn) provides random parts.\n"+
				" *Use these parts to build your ship.\n"+
				" *Protect your Core.\n"+
				" *Destroy all other ships Cores.\n"+
				" *All players on the final surviving team\n    get points - so play nice!)\n";
		Vec2f size;
		GUI::GetTextDimensions(text, size);
		lr = ul + size;
		lr.y -= 32.0f;
		draw = true;
	}
	else if (time < endTime3) {
		text =  "How to Play (continued):\n\n"+
				" *[ WASD ] to move around.\n"+
				" *[ E ] when close to use ship components.\n"+
				" *[ SPACE ] rotates blocks while building.\n"+
				" *[ LMB ] punch.\n"+
				" *[ RMB ] + mouse left/right - rotate freely.\n"+
				" *[ SPACE ] releases all couplings from a seat.\n"+
				" *[ SCROLL ] zoom in/out.\n"+
				"\n (these keys apply by default only)\n"+
				"\n              Have Fun!\n";
		Vec2f size;
		GUI::GetTextDimensions(text, size);
		lr = ul + size;
		lr.y -= 48.0f;
		draw = true;
	}
	
	if(draw)
	{
		f32 wave = Maths::Sin(getGameTime() / 10.0f) * 2.0f;
		ul.y += wave;
		lr.y += wave;
		GUI::DrawButtonPressed( ul - Vec2f(10,10), lr + Vec2f(10,10) );
		GUI::DrawText( text, ul, SColor(0xffffffff) );
	}
}
