/* 
 * Pipe Funnel sprite.
 * 
 * Author: ANybakk
 */

#include "StructureBlobOrientation.as";
#include "StructureSprite.as";
#include "PipeSprite.as";



namespace ANybakk {

  namespace PipeFunnelSprite {
  
  
  
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
      
      //Obtain a reference to the blob object
      CBlob@ blob = this.getBlob();
      
      if(blob.hasTag("PipeFunnelBlob::wasEntered")) {
      
        if(ANybakk::PipeFunnelVariables::SOUND_ON_ENTERED != "") {
        
          this.PlaySound(ANybakk::PipeFunnelVariables::SOUND_ON_ENTERED);
          
        }
        
        blob.Untag("PipeFunnelBlob::wasEntered");
        
      }
    
      ANybakk::PipeSprite::onTick(this);
      
      //Finished
      return;
      
    }
    
    
    
  }
  
}