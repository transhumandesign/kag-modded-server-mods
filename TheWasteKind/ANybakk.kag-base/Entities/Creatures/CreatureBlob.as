/* 
 * Creature blob.
 * 
 * Author: ANybakk
 */

#include "Blob.as";
#include "EntityBlob.as";



namespace ANybakk {

  namespace CreatureBlob {
  
  
  
    /**
     * Initializes this entity
     */
    void onInit(CBlob@ this) {
      
      ANybakk::EntityBlob::onInit(this);
      
      setTags(this);
      
    }
  
    
    
    /**
     * Sets various tags for this entity type. Inheriting types should call this.
     * 
     * @param   this            a blob reference.
     */
    void setTags(CBlob@ this) {
    
      this.Tag("isCreature");
      this.Tag("CreatureBlob::isMadeOfFlesh");
      this.Tag("flesh"); //Vanilla tag that allows being targeted by a bison for instance
      
    }
    
    
    
    /**
     * Checks if a target is within range (based on the radius of two blobs).
     * 
     * @param   this            a blob reference.
     * @param   target          the target blob.
     */
    bool isWithinMeleeRange(CBlob@ this, CBlob@ target) {
      
      //Finished, return true if distance is within the combined radius
      return ANybakk::Blob::getDistance(this, target) <= this.getRadius() + target.getRadius();
      
    }
    
    
    
  }
  
}