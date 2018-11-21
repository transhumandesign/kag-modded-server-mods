/* 
 * Entity sprite.
 * 
 * Author: ANybakk
 */

#include "EntitySpriteLayer.as";


namespace ANybakk {

  namespace EntitySprite {
  
  
  
    /**
     * Initialization event function
     */
    void onInit(CSprite@ this) {
      
      //Set default animation state (conveyor is not placed yet)
      this.SetAnimation("default");
      
      //Set default frame to 0
      this.animation.frame = 0;
      
      //Retrieve a reference to the blob object
      CBlob@ blob = this.getBlob();
      
      //Disable recently scaled flag
      blob.Untag("EntitySprite::wasScaled");
      
      //Finished
      return;
      
    }



    /**
     * Tick event function
     */
    void onTick(CSprite@ this) {
    
      CBlob@ blob = this.getBlob();
      
      if(blob !is null && blob.hasTag("EntitySprite::wasScaled")) {
      
        //Disable flag
        blob.Untag("EntitySprite::wasScaled");
        
      }
      
      //Finished
      return;
      
    }
    
    
    
    /**
     * Sets layer
     * 
     * @param   layer     what layer (Z-index) to put this sprite in.
     */
    void setLayer(CSprite@ this, int layer = ANybakk::EntitySpriteLayer::LAYER_DEFAULT) {
    
      //Set layer
      this.SetZ(layer);
      
      //Finished
      return;
      
    }
    
    
    
    void scale(CSprite@ this, Vec2f newSize=ANybakk::EntityVariables::DEFAULT_SCALE_TO_SIZE) {
    
      //Obtain a reference to the blob object
      CBlob@ blob = this.getBlob();
      
      //Create a size vector
      Vec2f currentSize;
      
      //Check if current size is stored
      if(blob.exists("EntitySprite::currentSize")) {
      
        //Retrieve current size
        blob.get("EntitySprite::currentSize", currentSize);
        
      }
      
      //Otherwise
      else {
      
        //Set current size based on frame width and height (configuration values)
        currentSize = Vec2f(this.getFrameWidth(), this.getFrameHeight());
        
      }
      
      //Retrieve current offset
      Vec2f offset = this.getOffset();
      
      //Determine scaling factors
      f32 scaleWidth = newSize.x * ((currentSize.x > newSize.x && offset.x >= 0) ? -1.0f : 1.0f) / currentSize.x;
      f32 scaleHeight = newSize.y * ((currentSize.y > newSize.y && offset.y >= 0) ? -1.0f : 1.0f) / currentSize.y;
      
      //Scale
      this.ScaleBy(Vec2f(scaleWidth, scaleHeight));
      
      //Store new size
      blob.set("EntitySprite::currentSize", Vec2f(Maths::Abs(currentSize.x * scaleWidth), Maths::Abs(currentSize.y * scaleHeight)));
      
      //Tag as recently scaled
      this.getBlob().Tag("EntitySprite::wasScaled");
      
    }
    
    
    
  }
  
}