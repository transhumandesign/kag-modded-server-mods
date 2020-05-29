
void PlayTreeDeeSound(string name, Vec2f position, float volume, float pitch)
{
	CPlayer@ p = getLocalPlayer();
	if(p !is null)
	{
		CBlob@ b = p.getBlob();
		if(b !is null)
		{
			Vec2f pos = b.getPosition();
			f32 dir_x = b.get_f32("dir_x");
			Vec2f newPos = (position-b.getPosition()).RotateByDegrees(-dir_x+90);
			newPos.x *= -1;
			if(newPos.Length() > 300) return;
			
			newPos *= 2.4;
			
			Sound::SetListenerPosition(Vec2f_zero);
			Sound::Play(name, newPos, volume, pitch);
		}
	}
}