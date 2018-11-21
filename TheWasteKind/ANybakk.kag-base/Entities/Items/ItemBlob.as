/* 
 * Item blob.
 * 
 * Author: ANybakk
 */

#include "EntityBlob.as";



namespace ANybakk {

  namespace ItemBlob {



    void onInit(CBlob@ this) {
    
      ANybakk::EntityBlob::onInit(this);
      
      setTags(this);
      
    }
    
    
    
    void setTags(CBlob@ this) {
    
      this.Tag("isItem");
      
    }
    
    
    
    void onTick(CBlob@ this) {
    
      ANybakk::EntityBlob::onTick(this);
      
    }
    
    
    
  }
  
}