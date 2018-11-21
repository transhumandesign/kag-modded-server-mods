/* 
 * Pipeable blob ("abstract" type). Can also be used with vanilla types by 
 * calling functions directly. Keep in mind that some default post-event 
 * behaviour may reside in onTick handlers, so you might have to manually call 
 * them once.
 * 
 * Author: ANybakk
 */



namespace ANybakk {

  namespace PipeableBlob {



    void onInit(CBlob@ this) {
    
      //No hierarchy call
      
      setTags(this);
      
      //Store pipe ID
      this.set_netid("PipeableBlob::enteredPipeID", 0);
      
      //Store last pipe ID
      this.set_netid("PipeableBlob::lastPipeID", 0);
      
    }
    
    
    
    void setTags(CBlob@ this) {
    
      this.Tag("isPipeable");
      
      //Untag recently propelled
      this.Untag("PipeableBlob::wasPropelled");
      
    }
    
    
    
    void onTick(CBlob@ this) {
    
      //No hierarchy call
      return;
      
    }
    
    
    
    bool canBePickedUp(CBlob@ this, CBlob@ byBlob) {
    
      //Return true if not in pipe
      return !this.hasTag("PipeableBlob::isInPipe");
      
    }
    
    
    
    /**
     * Make a pipeable enter a pipe segment
     * 
     * @param   otherBlob   the pipe segment (other blobs will be ignored)
     */
    void enterPipe(CBlob@ this, CBlob@ otherBlob) {
      
      //Check if other is valid and tagged as pipe
      if(otherBlob !is null && otherBlob.hasTag("isPipe")) {
      
        //Store pipe ID
        this.set_netid("PipeableBlob::enteredPipeID", otherBlob.getNetworkID());
        
        //Obtain a reference to the shape object
        CShape@ shape = this.getShape();
        
        //Disable map collisions
        shape.getConsts().mapCollisions = false;
        
        //Disable blob collisions
        shape.getConsts().collidable = false;
        
        //Disable gravity
        shape.SetGravityScale(0.0f);
        
        //Update flags
        this.Tag("PipeableBlob::isInPipe");
        this.Tag("PipeableBlob::wasEnteredPipe"); //For sprite
      
      }
      
    }
    
    
    
    /**
     * Make a pipeable exit a pipe network. Ignored if not actually in a pipe.
     */
    void exitPipe(CBlob@ this) {
      
      if(this.hasTag("PipeableBlob::isInPipe")) {
      
        //Store pipe ID
        this.set_netid("PipeableBlob::enteredPipeID", 0);
        
        //Obtain a reference to the shape object
        CShape@ shape = this.getShape();
        
        //Enable map collisions
        shape.getConsts().mapCollisions = true;
        
        //Enable blob collisions
        shape.getConsts().collidable = true;
        
        //Enable gravity
        shape.SetGravityScale(1.0f);
        
        //Set visible
        //this.getSprite().SetVisible(false);
        
        //Update flags
        this.Untag("PipeableBlob::isInPipe");
        this.Tag("PipeableBlob::wasExitedPipe"); //For sprite
        
      }
      
    }
    
    
    
    /**
     * Checks if a blob is to be considered pipeable, either if it's tagged 
     * like one, or is a valid vanilla type.
     */
    bool isConsideredPipeable(CBlob@ this) {
    
      //Check if pipeable
      if(this.hasTag("isPipeable")) {
      
        //Finished, return true
        return true;
        
      }
      
      //Lastly, return if valid vanilla
      return isConsideredPipeableVanilla(this);
      
    }
    
    
    
    /**
     * Checks if a blob is to be considered a pipeable vanilla type.
     */
    bool isConsideredPipeableVanilla(CBlob@ this) {
      
      //Iterate through vanilla group name array
      for(int i=0; i<ANybakk::PipeableVariables::VANILLA_PIPEABLE_GROUP_NAMES.length; i++) {
      
        //Check if tagged
        if(this.hasTag(ANybakk::PipeableVariables::VANILLA_PIPEABLE_GROUP_NAMES[i])) {
        
          //Finished, return true
          return true;
          
        }
        
      }
      
      //Lastly, return true if name matches some entry in vanilla name array
      return ANybakk::PipeableVariables::VANILLA_PIPEABLE_NAMES.find(this.getName()) >= 0;
    
    }
    
    
    
    void propel(CBlob@ this, Vec2f velocity, CBlob@ pipeBlob) {
    
      //Set velocity upwards
      this.setVelocity(velocity);
      
      //Store segment ID as last pipe ID
      this.set_netid("PipeableBlob::lastPipeID", pipeBlob.getNetworkID());
      
      //Tag as recently propelled
      this.Tag("PipeableBlob::wasPropelled");
      
    }
    
    
    
  }
  
}