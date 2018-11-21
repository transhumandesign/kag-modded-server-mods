/* 
 * Pipe Straight blob.
 * 
 * Author: ANybakk
 */

#include "PipeBlob.as";
#include "PipeFunnelBlob.as";



namespace ANybakk {

  namespace PipeStraightBlob {



    void onInit(CBlob@ this) {
    
      ANybakk::PipeBlob::onInit(this);
      
      setTags(this);
      
    }
    
    
    
    void setTags(CBlob@ this) {
    
      this.Tag("isPipeStraight");
      
    }
    
    
    
    void onTick(CBlob@ this) {
    
      ANybakk::PipeBlob::onTick(this);
      
      //Retrieve current mode
      u8 currentMode = this.get_u8("ConveyorBlobMode");
      
      //Check if mode is not off
      if(currentMode != ANybakk::ConveyorBlobMode::MODE_OFF) {
      
        //Propel any overlapping blobs
        ANybakk::PipeFunnelBlob::propelOverlapping(this);
        
      }
      
    }
    
    
    
    bool doesCollideWithBlob(CBlob@ this, CBlob@ other) {
      
      return ANybakk::PipeBlob::doesCollideWithBlob(this, other);;

    }
    
    
    
    void onSetStatic(CBlob@ this, const bool isStatic) {
    
      ANybakk::PipeBlob::onSetStatic(this, isStatic);
      
    }
    
    
    
  }
  
}