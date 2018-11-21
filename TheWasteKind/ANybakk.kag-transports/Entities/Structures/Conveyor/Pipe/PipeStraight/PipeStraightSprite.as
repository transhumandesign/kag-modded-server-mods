/* 
 * Pipe Straight sprite.
 * 
 * Author: ANybakk
 */

#include "StructureBlobOrientation.as";
#include "StructureSprite.as";
#include "PipeSprite.as";



namespace ANybakk {

  namespace PipeStraightSprite {
  
  
  
    /**
     * Initialization event function
     */
    void onInit(CSprite@ this) {
    
      ANybakk::PipeSprite::onInit(this);
      
      /* For transparent pipe
      CSpriteLayer@ layer = this.addSpriteLayer("background", "PipeStraightBackground.png", 8, 8);
      
      if(layer !is null) {
      
        layer.SetVisible(true);
        layer.SetRelativeZ(-499.0f);
        Animation@ anim = layer.addAnimation("default", 0, false);
        int[] frames = {0, 1};
        anim.AddFrames(frames);
        
      }
      */

      //Finished
      return;
      
    }



    /**
     * Tick event function
     */
    void onTick(CSprite@ this) {
    
      //Update frame depending on orientation (2 variants)
      ANybakk::StructureSprite::updateFrameFromOrientation(this, 2);
      
      ANybakk::PipeSprite::onTick(this);
      
      //Finished
      return;
      
    }



    /**
     * Rendering event function
     */
    void onRender(CSprite@ this) {
    
      ANybakk::PipeSprite::onRender(this);
      
    }
    
    
    
  }
  
}