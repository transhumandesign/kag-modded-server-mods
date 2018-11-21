/* 
 * Structure blob.
 * 
 * Author: ANybakk
 */

#include "EntityBlob.as";


namespace ANybakk {

  namespace StructureBlob {



    void onInit(CBlob@ this) {
      
      ANybakk::EntityBlob::onInit(this);
      
      setTags(this);
      
      //Set background tile type (for TileBackground.as)
      this.set_TileType("background tile", ANybakk::StructureVariables::BACKGROUND_TILE_TYPE);
      
      //Set default orientation
      this.set_u16("StructureBlobOrientation", ANybakk::StructureVariables::DEFAULT_ORIENTATION);
      
    }
    
    
    
    void setTags(CBlob@ this) {
    
      this.Tag("isStructure");
      this.Untag("StructureBlob::isPlaced");
      this.Untag("StructureBlob::wasPlaced");
      
    }
    
    
    
    void onSetStatic(CBlob@ this, const bool isStatic) {

      //Check if not static
      if(!isStatic) {
        
        //Finished, entity not yet static
        return;
        
      }
      
      //Tag as placed (used by sprite/sound)
      this.Tag("StructureBlob::wasPlaced");
      
      //Tag as placed
      this.Tag("StructureBlob::isPlaced");
      
      //Store orientation using segment's angle
      this.set_u16("StructureBlobOrientation", this.getShape().getAngleDegrees());
      
    }
    
    
    
    bool canBePickedUp(CBlob@ this, CBlob@ byBlob) {

      return false;

    }
    
    
    
    void onDie(CBlob@ this) {
    
      //Check if valid and placed
      if(this !is null && this.hasTag("StructureBlob::isPlaced")) {
      
        //Tag as recently destroyed
        this.Tag("StructureBlob::wasDestroyed");
        
      }
      
    }
    
    
    
  }
  
}