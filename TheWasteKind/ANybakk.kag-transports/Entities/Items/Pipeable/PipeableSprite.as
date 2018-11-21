/* 
 * Pipe sprite ("abstract" type). Can also be used with vanilla types by 
 * calling functions directly. Keep in mind that some default post-event 
 * behaviour may reside in onTick handlers, so you might have to manually call 
 * them once.
 * 
 * Author: ANybakk
 */

#include "PipeableBlob.as";
#include "EntityVariables.as";
#include "EntitySprite.as";



namespace ANybakk {

  namespace PipeableSprite {
  
  
  
    /**
     * Initialization event function
     */
    void onInit(CSprite@ this) {
      
      //Finished
      return;
      
    }



    /**
     * Tick event function
     */
    void onTick(CSprite@ this) {
    
      //Obtain blob object reference
      CBlob@ blob = this.getBlob();
      
      //Check if recently entered
      if(blob.hasTag("PipeableBlob::wasEnteredPipe")) {
        
        //Call on entered handler
        onEnteredPipe(this);
        
      }
      
      //Check if recently exited
      if(blob.hasTag("PipeableBlob::wasExitedPipe")) {
        
        //Call on exited handler
        onExitedPipe(this);
        
      }
      
      //Check if recently propelled
      if(blob.hasTag("PipeableBlob::wasPropelled")) {
        
        //Call on propelled handler
        onPropelled(this);
        
      }
      
      //Finished
      return;
      
    }



    /**
     * Rendering event function
     */
    void onRender(CSprite@ this) {
      
      //Finished
      return;
      
    }
    
    
    
    /**
     * On entered pipe handler
     */
    void onEnteredPipe(CSprite@ this) {
    
      //Obtain blob object reference
      CBlob@ blob = this.getBlob();
      
      //Put in the background layer
      ANybakk::EntitySprite::setLayer(this, ANybakk::EntitySpriteLayer::LAYER_ABYSS);
      
      //Check if shrinking is enabled
      if(ANybakk::PipeableVariables::SHRINK_ON_ENTERED_PIPE) {
      
        //Create vector
        Vec2f originalSize;
        
        //check if original size is not already stored
        if(!blob.exists("PipeableSprite::originalSize")) {
        
          //Store original size
          blob.set("PipeableSprite::originalSize", Vec2f(this.getFrameWidth(), this.getFrameHeight()));
          
        }
        
        //Shrink
        ANybakk::EntitySprite::scale(this, ANybakk::PipeableVariables::SHRINK_TO_SIZE);
        
        //Check if pipeable vanilla
        if(ANybakk::PipeableBlob::isConsideredPipeableVanilla(blob)) {
          
          //Manually call onTick once (handler not associated with vanilla types)
          ANybakk::EntitySprite::onTick(this);
          
        }
        
      }
      
      //Check if invisibility is enabled
      if(ANybakk::PipeableVariables::MAKE_INVISIBLE_ON_ENTERED_PIPE) {
      
        //Set invisible
        this.SetVisible(false);
        
      }
      
      //Untag
      blob.Untag("PipeableBlob::wasEnteredPipe");
      
      //Finished
      return;
      
    }
    
    
    
    /**
     * On exited pipe handler
     */
    void onExitedPipe(CSprite@ this) {
    
      //Obtain blob object reference
      CBlob@ blob = this.getBlob();
    
      //Put in the default layer
      ANybakk::EntitySprite::setLayer(this, ANybakk::EntitySpriteLayer::LAYER_DEFAULT);
      
      //Check if shrinking is enabled and has been shrunk
      if(ANybakk::PipeableVariables::SHRINK_ON_ENTERED_PIPE && blob.exists("PipeableSprite::originalSize")) {
      
        Vec2f originalSize;
        
        //Check if could retrieve original size variable
        if(blob.get("PipeableSprite::originalSize", originalSize)) {
        
          //Grow back to original size
          ANybakk::EntitySprite::scale(this, originalSize);
        
          //Check if pipeable vanilla
          if(ANybakk::PipeableBlob::isConsideredPipeableVanilla(blob)) {
            
            //Manually call onTick once (handler not associated with vanilla types)
            ANybakk::EntitySprite::onTick(this);
            
          }
          
        }
        
      }
      
      //Check if invisibility is enabled
      if(ANybakk::PipeableVariables::MAKE_INVISIBLE_ON_ENTERED_PIPE) {
      
        //Set visible
        this.SetVisible(true);
        
      }
      
      //Untag
      blob.Untag("PipeableBlob::wasExitedPipe");
      
      //Finished
      return;
      
    }
    
    
    
    /**
     * On propelled handler
     */
    void onPropelled(CSprite@ this) {
    
      //Obtain blob object reference
      CBlob@ blob = this.getBlob();
      
      //Untag
      blob.Untag("PipeableBlob::wasPropelled");
      
      //Finished
      return;
    
    }
    
    
    
  }
  
}