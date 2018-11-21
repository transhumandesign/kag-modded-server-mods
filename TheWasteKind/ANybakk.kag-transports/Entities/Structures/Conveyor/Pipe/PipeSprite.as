/* 
 * Pipe sprite.
 * 
 * Author: ANybakk
 */

#include "EntitySprite.as";
#include "EntitySpriteLayer.as";
#include "ConveyorSprite.as";



namespace ANybakk {

  namespace PipeSprite {
  
  
  
    /**
     * Initialization event function
     */
    void onInit(CSprite@ this) {
    
      ANybakk::ConveyorSprite::onInit(this);
      
      //Finished
      return;
      
    }



    /**
     * Tick event function
     */
    void onTick(CSprite@ this) {
      
      //Check if recently placed
      if(this.getBlob().hasTag("StructureBlob::wasPlaced")) {
      
        //Put in the background layer
        ANybakk::EntitySprite::setLayer(this, ANybakk::EntitySpriteLayer::LAYER_BACKGROUND);
        
      }
    
      ANybakk::ConveyorSprite::onTick(this);
      
      //Finished
      return;
      
    }



    /**
     * Rendering event function
     */
    void onRender(CSprite@ this) {
    
      ANybakk::ConveyorSprite::onRender(this);
      
      //Finished
      return;
      
    }
    
    
    
  }
  
}