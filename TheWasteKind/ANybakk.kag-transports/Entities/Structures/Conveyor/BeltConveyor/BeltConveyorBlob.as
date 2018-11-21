/* 
 * Belt Conveyor blob.
 * 
 * Author: ANybakk
 */

#include "ConveyorBlob.as";
#include "ConveyorBlobMode.as";



namespace ANybakk {

  namespace BeltConveyorBlob {



    void onInit(CBlob@ this) {
    
      ANybakk::ConveyorBlob::onInit(this);
      
      setTags(this);
      
    }
    
    
    
    void setTags(CBlob@ this) {
    
      this.Tag("isBeltConveyor");
      
    }
    
    
    
    void onTick(CBlob@ this) {
    
      ANybakk::ConveyorBlob::onTick(this);
      
      //Update direction
      updateDirection(this);
      
      //Retrieve current mode
      u8 currentMode = this.get_u8("ConveyorBlobMode");
      
      //Check if mode is not off
      if(currentMode != ANybakk::ConveyorBlobMode::MODE_OFF) {
      
        //Obtain a reference to the map object
        CMap@ map = this.getMap();
      
        //Create an array of blob object references
        CBlob@[] nearbyBlobs;
        
        //Check if any blobs are within radius
        if(map.getBlobsInRadius(this.getPosition(), map.tilesize, @nearbyBlobs)) {
        
          //Create a handle for a blob object
          CBlob@ nearbyBlob;
          
          //Create a vector representing the relative displacement
          f32 relativeAngle;
        
          //Determine if facing left
          bool isFacingLeft = this.isFacingLeft();
          
          //Iterate through blob objects
          for(u8 i = 0; i<nearbyBlobs.length; i++) {
          
            //Keep a reference to this blob object
            @nearbyBlob = nearbyBlobs[i];
            
            //Keep relative angle
            relativeAngle = (nearbyBlob.getPosition() - this.getPosition()).Angle();
            
            //Check if blob is not this blob, not tagged as conveyor and is above (within a 120 degree angle, which seems enough for most objects)
            //TODO: Maybe also exclude any static blobs in general
            if(nearbyBlob !is this && !nearbyBlob.hasTag("isConveyor") && (relativeAngle >= 30.0f && relativeAngle <= 150.0f)) {
            
              //If blob is tagged as touching, and touching this belt conveyor
              if(/*nearbyBlob.hasTag("isTouchingBeltConveyor") && */nearbyBlob.get_netid("isTouchingID") == this.getNetworkID()) {
                
                //Obtain a vector for the blob's current velocity
                Vec2f currentVelocity = nearbyBlob.getVelocity();
                
                //Create a vector for target velocity
                Vec2f targetVelocity = Vec2f(0.0f, 0.0f);
                
                //Iterate through modes
                for(u8 i=0; i<ANybakk::ConveyorVariables::MODE_DATA.length; i++) {
                
                  //Check if current mode
                  if(ANybakk::ConveyorVariables::MODE_DATA[i].mMode == currentMode) {
                  
                    //Keep target velocity vector
                    targetVelocity = ANybakk::ConveyorVariables::MODE_DATA[i].mTargetVelocity;
                    
                    //End loop
                    break;
                    
                  }
                
                }
                
                //Check if conveyor is facing left
                if(isFacingLeft) {
                
                  //Set horizontal velocity in left direction
                  targetVelocity.x *= -1.0f;
                  
                  //Set target velocity or current, whichever is higher (to the left)
                  nearbyBlob.setVelocity(Vec2f(Maths::Min(targetVelocity.x, currentVelocity.x), currentVelocity.y));
                
                }
                
                //Otherwise, facing right
                else {
                
                  //Set target velocity or current, whichever is higher (to the right)
                  nearbyBlob.setVelocity(Vec2f(Maths::Max(targetVelocity.x, currentVelocity.x), currentVelocity.y));
                  
                }
                
              }
              
            }
            
          }
          
        }
        
      }
      
      //Finished
      return;
      
    }
    
    
    
    void onCollision(CBlob@ this, CBlob@ otherBlob, bool solid, Vec2f normal, Vec2f point1) {
    
      //If this is tagged as placed while other is a valid blob, not a conveyor, and above
      if(this.hasTag("StructureBlob::isPlaced") && otherBlob !is null && !otherBlob.hasTag("isConveyor") && normal.y > 0.0f) {
        
        //Store ID of segment
        otherBlob.set_netid("isTouchingID", this.getNetworkID());
        
      }
      
      //Finished
      return;
      
    }
    
    
    
    void onEndCollision(CBlob@ this, CBlob@ otherBlob) {
      
      //Finished
      return;

    }
    
    
    
    void onSetStatic(CBlob@ this, const bool isStatic) {
    
      ANybakk::ConveyorBlob::onSetStatic(this, isStatic);
      
      //Update direction
      updateDirection(this);
        
      //Check if recently placed
      if(this.hasTag("StructureBlob::wasPlaced")) {
      
        //Obtain a reference to the map object
        CMap@ map = this.getMap();
        
        //Set tile type to 256 (just to get proper collision)
        map.server_SetTile(this.getPosition(), 256);
        
        //Obtain a reference to the sprite object
        CSprite@ sprite = this.getSprite();
        
        //Check if sprite is valid
        if(sprite !is null) {
        
          //Set z-index to 500 (overlapping tile)
          sprite.SetZ(500);
          
        }
        
        //Retrieve tile space position
        Vec2f tileSpacePosition = map.getTileSpacePosition(this.getPosition());
        
        //Retrieve the offset index for this tile
        int tileOffset = map.getTileOffsetFromTileSpace(tileSpacePosition);
        
        //Set solid and collision flags for this tile
        map.AddTileFlag(tileOffset, Tile::SOLID | Tile::COLLISION);
      
      }
      
    }
    
    
    
    void onDie(CBlob@ this) {
    
      ANybakk::ConveyorBlob::onDie(this);
    
      //Check if placed
      if(this.hasTag("StructureBlob::isPlaced")) {
      
        //Obtain a reference to the map object
        CMap@ map = this.getMap();
        
        //Set empty tile
        map.server_SetTile(this.getPosition(), CMap::tile_empty);
        
      }
      
    }
    
    
    
    /**
     * Updates direction based on blob facing direction
     */
    void updateDirection(CBlob@ this) {
    
      //Check if facing left
      if(this.isFacingLeft()) {
      
        //Set direction counter-clockwise
        this.set_u8("ConveyorBlobDirection", ANybakk::ConveyorBlobDirection::DIRECTION_COUNTERCLOCKWISE);
        
      }
      
      //Otherwise, is facing right
      else {
      
        //Set direction clockwise
        this.set_u8("ConveyorBlobDirection", ANybakk::ConveyorBlobDirection::DIRECTION_CLOCKWISE);
        
      }
      
      //Finished
      return;
      
    }
    
    
    
  }
  
}