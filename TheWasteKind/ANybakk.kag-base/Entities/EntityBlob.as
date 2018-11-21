/* 
 * Generic Entity blob
 * 
 * Author: ANybakk
 */

#include "Blob.as";


namespace ANybakk {

  namespace EntityBlob {
  
  
  
    /**
     * Initializes this entity
     */
    void onInit(CBlob@ this) {
      
      ANybakk::Blob::onInit(this);
      
      setTags(this);
      
    }
  
    
    
    /**
     * Sets various tags for this entity type. Inheriting types should call this.
     * 
     * @param   this            a blob reference.
     */
    void setTags(CBlob@ this) {
    
      this.Tag("isEntity");
      
    }
    
    
    
  }
  
}