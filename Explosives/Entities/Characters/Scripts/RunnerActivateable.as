// RunnerActivateable.as

void onInit(CBlob@ this)
{
    //these don't actually use it, they take the controls away
	this.push("names to activate", "lantern");
	this.push("names to activate", "stickynade");
	this.push("names to activate", "nade");

	this.getCurrentScript().runFlags |= Script::remove_after_this;
}