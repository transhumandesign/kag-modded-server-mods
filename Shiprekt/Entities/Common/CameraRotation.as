#include "IslandsCommon.as"

int angle = 0;
Vec2f old_mousepos2d;
u16 last_island = 0;

void onInit( CBlob@ this )
{
	this.getCurrentScript().runFlags |= Script::tick_myplayer;	
}

void onTick( CBlob@ this )
{	
	//island based rotation
	Island@ island = getIsland( this );
	if (island !is null)
	{     	
		CCamera@ camera = getCamera();
		if (camera !is null)
		{
			f32 camAngle = camera.getRotation();
			
			f32 nearest_angle = island.angle;
			
			while(nearest_angle > camAngle + 45)
				nearest_angle -= 90.0f;

			while(nearest_angle < camAngle - 45)
				nearest_angle += 90.0f;

			angle = nearest_angle;
		}

	}

	//seat facing direction
	if (this.isAttached())
	{
		CBlob@ seat = this.getAttachmentPoint(0).getOccupied();
		
		if(seat !is null && seat.hasTag("seat"))
		{
			const f32 seat_angle = seat.getAngleDegrees() + 90.0f;
			angle = seat_angle;
		}
	}

	CameraRotation( angle );
}

void CameraRotation( f32 angle )
{
	CCamera@ camera = getCamera();
	if (camera !is null)
	{
		f32 camAngle = camera.getRotation();
		f32 rotdelta = angle - camAngle;
		if (rotdelta > 180) {
			rotdelta -= 360;
		}
		if (rotdelta < -180) {
			rotdelta += 360;
		}

		const f32 rotate_max = 15.0f;

		rotdelta = Maths::Max(Maths::Min(rotate_max, rotdelta), -rotate_max);

		const f32 rot = rotdelta / 2.0f;
		camAngle += rot;

		while(camAngle < -180.0f){
			camAngle += 360.0f;
		}
		while(camAngle > 180.0f){
			camAngle -= 360.0f;
		}
		
		camera.setRotation( camAngle );
	}	
}