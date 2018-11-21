/* Trails.as
 * author: Chrispin, Aphelion
 */

#include "TeamColour.as";

class TrailData
{
	string path;
	int segments;
	int ticksPerSegUpdate;
	f32 width;
	f32 lightRadius;
	SColor lightColor;

	TrailData( string _path, int _segments, int _ticksPerSegUpdate, f32 _width, f32 _lightRadius, SColor _lightColor )
	{
		path = _path;
		segments = _segments;
		ticksPerSegUpdate = _ticksPerSegUpdate;
		width = _width;
		lightRadius = _lightRadius;
		lightColor = _lightColor;
	}
}

void SetupTrails( CBlob@ this, string path, int segments, int ticksPerSegUpdate, f32 width, f32 lightRadius, SColor lightColor )
{
	TrailData data(path, segments, ticksPerSegUpdate, width, lightRadius, lightColor);
	this.set("data", data);

	this.set_bool("segments updating", false);
	this.set_bool("initialized", false);
	this.set_u32("dead segment", 0);
}

void UpdateTrails( CBlob@ this )
{
	if(!getNet().isClient()) return;

	CSprite@ sprite = this.getSprite();
	Vec2f pos = this.getPosition();
	Vec2f vel = this.getVelocity();

	bool deathTriggered = this.hasTag("death triggered");
	bool isDead = this.hasTag("dead");

	TrailData@ data;
	if(!this.get("data", @data)) return;
	
	if(!this.get_bool("initialized") && this.getTickSinceCreated() > 1)
	{
		this.SetLight(true);
		this.SetLightRadius(data.lightRadius);
		this.SetLightColor(data.lightColor);
		sprite.SetZ(500.0f);
		
		array<Vec2f> trail_positions(data.segments, this.getPosition());
		this.set("trail positions", trail_positions);
		
		array<Vec2f> trail_vectors;
		for(int i = 0; i < data.segments - 1; i++)
		{
			trail_vectors.push_back(trail_positions[i + 1] - trail_positions[i]);
		}		
		this.set("trail vectors", trail_vectors);
		
		this.set_bool("initialized", true);
	}
	
	// trail effects
	if (this.getTickSinceCreated() > 1)	//delay to prevent rendering trails leading from map origin
	{
		Vec2f[]@ trail_positions;
		this.get("trail positions", @trail_positions);
		
		Vec2f[]@ trail_vectors;
		this.get("trail vectors",   @trail_vectors);
		
		if (trail_positions is null || trail_vectors is null)
		{
			return;
		}
		
		bool segmentsUpdating = this.get_bool("segments updating");

		f32 ticksTillUpdate = getGameTime() % data.ticksPerSegUpdate;
		if (ticksTillUpdate == 0)
		{
			this.set_bool("segments updating", true);
		}
		
		int lastPosArrayElement = trail_positions.length - 1;
		int lastVecArrayElement = trail_vectors.length - 1;
		
		if (segmentsUpdating)
		{				
			trail_positions.push_back(pos);
			trail_vectors.push_back(pos - trail_positions[lastPosArrayElement]);
			this.set_bool("segments updating", false);
		}
		
		for(int i = 0; i < trail_positions.length; i++)
		{
			sprite.RemoveSpriteLayer("trail" + i);
		}
		
		int deadSegment = this.get_u32("dead segment");
		
		if (!(isDead && lastPosArrayElement > deadSegment))
		{
			Vec2f currSegPos = trail_positions[lastPosArrayElement];
			Vec2f followVec = currSegPos - pos;
			Vec2f followNorm = followVec;
			followNorm.Normalize();
			
			f32 followDist = followVec.Length();
					
			CSpriteLayer@ trail = sprite.addSpriteLayer("trail" + (lastPosArrayElement), data.path, 16, 16); 
			if (trail !is null)
			{
				Animation@ anim = trail.addAnimation("default", 1, true);
				int[] frames = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15};
				anim.AddFrames(frames);				
				trail.SetFrameIndex(15 - (getGameTime() % 15));
				
				trail.SetVisible(true);
				
				f32 trailLength = (followDist + 1.0f) / 16.0f;				
				trail.ResetTransform();						
				trail.ScaleBy(Vec2f(trailLength,
					data.width * ((data.ticksPerSegUpdate - ticksTillUpdate * (1.0f / data.segments)) / data.ticksPerSegUpdate)));							
				trail.TranslateBy(Vec2f(trailLength * 8.0f, 0.0f));			
				trail.RotateBy(-followNorm.Angle(), Vec2f());
				trail.setRenderStyle(RenderStyle::light);
				trail.SetRelativeZ(-1);
			}
		}
		
		if (!(isDead && (lastPosArrayElement - 1) > deadSegment))
		{
			Vec2f currSegPos = trail_positions[lastPosArrayElement - 1];			
			Vec2f nextSegPos = trail_positions[lastPosArrayElement];
			Vec2f followVec = currSegPos - nextSegPos;
			Vec2f followNorm = followVec;
			followNorm.Normalize();
			
			f32 followDist = followVec.Length();
			
			Vec2f netTranslation = nextSegPos - pos;
					
			CSpriteLayer@ trail = sprite.addSpriteLayer("trail" + (lastPosArrayElement - 1), data.path, 16, 16);

			if (trail !is null)
			{
				Animation@ anim = trail.addAnimation("default", 1, true);
				int[] frames = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15};
				anim.AddFrames(frames);				
				trail.SetFrameIndex(15 - (getGameTime() % 15)); 
				
				trail.SetVisible(true);
				
				f32 trailLength = (followDist + 1.0f) / 16.0f;						
				trail.ResetTransform();							
				trail.ScaleBy( Vec2f(trailLength, data.width * ((data.segments-1.0f) / data.segments)
					* ((data.ticksPerSegUpdate - ticksTillUpdate*(1.0f / data.segments)) / data.ticksPerSegUpdate)));							
				trail.TranslateBy(Vec2f(trailLength * 8.0f, 0.0f));							
				trail.RotateBy(-followNorm.Angle(), Vec2f());
				trail.TranslateBy( netTranslation );
				trail.setRenderStyle(RenderStyle::light);
				trail.SetRelativeZ(-1);
			}
		}
		
		for(int i = trail_positions.length - data.segments; i < lastVecArrayElement; i++)
		{
			if (isDead && i > deadSegment)
				continue;
		
			Vec2f currSegPos = trail_positions[i];
			Vec2f prevSegPos = trail_positions[i + 1];
			Vec2f followVec = currSegPos - prevSegPos;
			Vec2f followNorm = followVec;
			followNorm.Normalize();
			
			f32 followDist = followVec.Length();
			
			Vec2f netTranslation = Vec2f(0, 0);

			for(int t = i + 1; t < lastVecArrayElement; t++)
			{	
				netTranslation = netTranslation - trail_vectors[t]; 
			}
			
			Vec2f movementOffset = trail_positions[lastPosArrayElement - 1] - pos;
					
			CSpriteLayer@ trail = sprite.addSpriteLayer("trail" + i, data.path, 16, 16);

			if (trail !is null)
			{
				Animation@ anim = trail.addAnimation("default", 1, true);
				int[] frames = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15};
				anim.AddFrames(frames);				
				trail.SetFrameIndex(15 - (getGameTime() % 15));
				
				trail.SetVisible(true);
				
				f32 trailLength = (followDist + 1.0f) / 16.0f;					
				trail.ResetTransform();			
				trail.ScaleBy( Vec2f(trailLength,
					data.width * ((i * 1.0f - (trail_positions.length - data.segments)) / data.segments)
					* ((data.ticksPerSegUpdate-ticksTillUpdate * (1.0f / data.segments)) / data.ticksPerSegUpdate)) );	
				trail.TranslateBy(Vec2f(trailLength * 8.0f, 0.0f));	
				trail.RotateBy(-followNorm.Angle(), Vec2f());	
				trail.TranslateBy(netTranslation + movementOffset);	
				trail.setRenderStyle(RenderStyle::light);
				trail.SetRelativeZ(-1);
			}
		}
	}
}
