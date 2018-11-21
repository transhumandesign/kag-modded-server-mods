bool doesCollideWithBlob( CBlob@ this, CBlob@ blob )
{
    // when dead, collide only if its moving and some time has passed after death
	if (this.hasTag("dead"))
	{
        CShape@ oShape = blob.getShape();
		bool slow = (this.getShape().vellen < 1.5f);
        //static && collidable should be doors/platform etc             fast vel + static and !player = other entities for a little bit (land on the top of ballistas).
		return (oShape.isStatic() && oShape.getConsts().collidable) || (!slow && oShape.isStatic() && !blob.hasTag("player"));
	}
	return this.getTeamNum() != blob.getTeamNum() && !blob.hasTag("undeadplayer") || blob.hasTag("zombie") || blob.hasTag ("door") || blob.hasTag ("undeaddoor") || blob.getName() == "wooden_platform"; //collides with blobs from other teams or blobs with the zombie tag
}