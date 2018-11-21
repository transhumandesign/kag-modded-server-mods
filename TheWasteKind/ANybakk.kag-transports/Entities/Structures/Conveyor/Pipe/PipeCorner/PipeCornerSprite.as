/* 
 * Pipe Funnel sprite.
 * 
 * Author: ANybakk
 */

#include "StructureBlobOrientation.as";
#include "StructureSprite.as";
#include "PipeSprite.as";



namespace ANybakk {

  namespace PipeCornerSprite {
  
  
  
    /**
     * Initialization event function
     */
    void onInit(CSprite@ this) {
    
      ANybakk::PipeSprite::onInit(this);
      
      //Finished
      return;
      
    }



    /**
     * Tick event function
     */
    void onTick(CSprite@ this) {
    
      //Update frame depending on orientation (4 variants)
      ANybakk::StructureSprite::updateFrameFromOrientation(this, 4);
    
      ANybakk::PipeSprite::onTick(this);
      
      return;
      
    }
    
    
    
  }
  
}