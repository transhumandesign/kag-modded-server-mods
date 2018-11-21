/* 
 * Generic blob
 * 
 * Author: ANybakk
 */



namespace ANybakk {

  namespace Blob {
  
  
  
    /**
     * Initializes this entity
     */
    void onInit(CBlob@ this) {
      
      setTags(this);
      
    }
  
    
    
    /**
     * Sets various tags for this entity type. Inheriting types should call this.
     * 
     * @param   this            a blob reference.
     */
    void setTags(CBlob@ this) {
    
      this.Tag("isBlob");
      
    }
    
    
    
    /**
     * Returns a vector representing the line between a blob and a position
     * 
     * @param   this            a blob reference.
     * @param   targetPosition  the target position.
     */
    Vec2f getVector(CBlob@ this, Vec2f targetPosition) {
      
      //Finished, return vector
      return (targetPosition - this.getPosition());
      
    }
    
    
    
    /**
     * Returns a vector representing the line between two blobs.
     * 
     * @param   this            a blob reference.
     * @param   target          the target blob.
     */
    Vec2f getVector(CBlob@ this, CBlob@ target) {
      
      //Finished, return result from other version of this method
      return getVector(this, target.getPosition());
      
    }
    
    
    
    /**
     * Returns the distance between a blob and a position.
     * 
     * @param   this            a blob reference.
     * @param   targetPosition  the target position.
     */
    f32 getDistance(CBlob@ this, Vec2f targetPosition) {
      
      //Finished, return distance
      return (targetPosition - this.getPosition()).getLength();
      
    }
    
    
    
    /**
     * Returns the distance between two blobs.
     * 
     * @param   this            a blob reference.
     * @param   target          the target blob.
     */
    f32 getDistance(CBlob@ this, CBlob@ target) {
      
      //Finished, return result from the other version of this method
      return getDistance(this, target.getPosition());
      
    }
    
    
    
  }
  
}