/* 
 * Pipe Funnel blob.
 *
 * NOTE: Must be bundled with PipeableVariables.as or a derived version
 * 
 * Author: ANybakk
 */

#include "StructureBlobOrientation.as";
#include "ConveyorBlob.as";
#include "ConveyorBlobMode";
#include "PipeBlob.as";
#include "PipeableVariables.as"; //Required for PipeableBlob.as
#include "PipeableBlob.as";
#include "PipeableSprite.as";



namespace ANybakk {

  namespace PipeFunnelBlob {



    void onInit(CBlob@ this) {
    
      ANybakk::PipeBlob::onInit(this);
      
      setTags(this);
      
      //Set blank ID of object
      //this.set_netid("isMovingID", 0);
      
    }
    
    
    
    void setTags(CBlob@ this) {
    
      this.Tag("isPipeFunnel");
      
      this.Untag("PipeFunnelBlob::wasEntered");
      
    }
    
    
    
    void onTick(CBlob@ this) {
    
      ANybakk::PipeBlob::onTick(this);
      
      //Retrieve current mode
      u8 currentMode = this.get_u8("ConveyorBlobMode");
      
      //Check if mode is not off
      if(currentMode != ANybakk::ConveyorBlobMode::MODE_OFF) {
      
        //Propel any overlapping blobs
        propelOverlapping(this);
        
      }
      
      //Finished
      return;
      
    }
    
    
    
    bool doesCollideWithBlob(CBlob@ this, CBlob@ otherBlob) {
    
      //Check if can't convey
      if(!ANybakk::PipeBlob::canConvey(this, otherBlob)) {
      
        //Obtain position
        Vec2f position = this.getPosition();
      
        //Obtain a reference to the shape object
        CShape@ shape = this.getShape();
        
        //Obtain width and height
        f32 width = shape.getWidth();
        f32 height = shape.getHeight();
        
        //Obtain a reference to the map object
        CMap@ map = this.getMap();
        
        //Determine relative displacement 
        Vec2f relativeDisplacement = otherBlob.getPosition() - position;
        
        //Retrieve current orientation
        u16 orientation = this.get_u16("StructureBlobOrientation");
        
        //Check if orientation is up
        if(orientation == ANybakk::StructureBlobOrientation::ORIENTATION_UP) {
          
          //Finished, return true if beyond segment and both adjacent tiles are solid
          return 
            relativeDisplacement.y < 0.0f - height 
            && map.isTileSolid(position - Vec2f(width, 0.0f)) 
            && map.isTileSolid(position + Vec2f(width, 0.0f));
          
        }
        
        //Check if orientation is right
        else if(orientation == ANybakk::StructureBlobOrientation::ORIENTATION_RIGHT) {
        
          //Finished, return true if beyond segment and both adjacent tiles are solid
          return 
            relativeDisplacement.x > 0.0f + width 
            && map.isTileSolid(position - Vec2f(0.0f, height)) 
            && map.isTileSolid(position + Vec2f(0.0f, height));
          
        }
        
        //Check if orientation is down
        else if(orientation == ANybakk::StructureBlobOrientation::ORIENTATION_DOWN) {
        
          //Finished, return true if beyond segment and both adjacent tiles are solid
          return 
            relativeDisplacement.y > 0.0f + height 
            && map.isTileSolid(position - Vec2f(width, 0.0f)) 
            && map.isTileSolid(position + Vec2f(width, 0.0f));
          
        }
        
        //Check if orientation is left
        else if(orientation == ANybakk::StructureBlobOrientation::ORIENTATION_LEFT) {
        
          //Finished, return true if beyond segment and both adjacent tiles are solid
          return 
            relativeDisplacement.x < 0.0f - width 
            && map.isTileSolid(position - Vec2f(0.0f, height)) 
            && map.isTileSolid(position + Vec2f(0.0f, height));
          
        }
      
      }
      
      //Finished, return false
      return false;
      
    }
    
    
    
    void onCollision(CBlob@ this, CBlob@ otherBlob, bool solid, Vec2f normal, Vec2f point1) {
      
      //Check if can convey and object not already in a pipe
      if(ANybakk::PipeBlob::canConvey(this, otherBlob) && !otherBlob.hasTag("PipeableBlob::isInPipe")) {
      
        //Retrieve current orientation
        u16 orientation = this.get_u16("StructureBlobOrientation");
        
        //Reverse normal vector so that what we get is relative to this
        normal.x *= -1;
        normal.y *= -1;
        
        //Check if not already entered this pipe (can happen when pipe turns back close enough) and collision from the right direction
        if(
          (orientation == ANybakk::StructureBlobOrientation::ORIENTATION_UP && normal.y < 0.0f)
          || (orientation == ANybakk::StructureBlobOrientation::ORIENTATION_RIGHT && normal.x > 0.0f)
          || (orientation == ANybakk::StructureBlobOrientation::ORIENTATION_DOWN && normal.y > 0.0f)
          || (orientation == ANybakk::StructureBlobOrientation::ORIENTATION_LEFT && normal.x < 0.0f)
        ) {
        
          absorb(this, otherBlob);
          
        }
        
      }
      
    }
    
    
    
    void onSetStatic(CBlob@ this, const bool isStatic) {
    
      ANybakk::PipeBlob::onSetStatic(this, isStatic);
      
    }
    
    
    
    /**
     * Propels any overlapping blobs that are in pipe
     */
    void propelOverlapping(CBlob@ this) {
      
      //Create an array of blobs
      CBlob@[] overlappingBlobs;
      
      //Check if any blobs are overlapping
      if(this.getOverlapping(@overlappingBlobs)) {
        
        //Retrieve current orientation
        u16 orientation = this.get_u16("StructureBlobOrientation");
        
        //Create a blob handle
        CBlob@ overlappingBlob;
        
        //Iterate through all overlapping blobs
        for(int i=0; i<overlappingBlobs.length; i++) {
        
          //Keep reference to this blob
          @overlappingBlob = overlappingBlobs[i];
          
          //Check if invalid blob or can't convey
          if(overlappingBlob is null || !ANybakk::PipeBlob::canConvey(this, overlappingBlob)) {
          
            //Skip to the next one
            continue;
            
          }
          
          //Get blob's position
          Vec2f overlappingPosition = overlappingBlob.getPosition();
          
          //Check if within and in pipe
          if(this.isPointInside(overlappingPosition) && overlappingBlob.hasTag("PipeableBlob::isInPipe")) {
          
            //Determine if this blob entered the pipe through this segment
            //bool enteredThis = (overlappingBlob.get_netid("PipeableBlob::enteredPipeID") == this.getNetworkID());
            
            propel(this, overlappingBlob);
            
          }
          
        }
        
      }
      
      //Finished
      return;
      
    }
    
    
    
    /**
     * Absorbs a blob
     */
    void absorb(CBlob@ this, CBlob@ otherBlob) {
    
      //Retrieve current orientation
      u16 orientation = this.get_u16("StructureBlobOrientation");
      
      //Check if orientation is up
      if(orientation == ANybakk::StructureBlobOrientation::ORIENTATION_UP) {
      
        //Absorb
        absorbTop(this, otherBlob);
        
      }
      
      //Check if orientation is right
      else if(orientation == ANybakk::StructureBlobOrientation::ORIENTATION_RIGHT) {
      
        //Absorb
        absorbRight(this, otherBlob);
        
      }
      
      //Check if orientation is down
      else if(orientation == ANybakk::StructureBlobOrientation::ORIENTATION_DOWN) {
      
        //Absorb
        absorbBottom(this, otherBlob);
        
      }
      
      //Check if orientation is left
      else if(orientation == ANybakk::StructureBlobOrientation::ORIENTATION_LEFT) {
      
        //Absorb
        absorbLeft(this, otherBlob);
        
      }
      
    }
    
    
    
    /**
     * Absorbs a blob, top-side
     */
    void absorbTop(CBlob@ this, CBlob@ otherBlob) {
    
      //Move other 1.0 inside
      otherBlob.setPosition(this.getPosition() + Vec2f(0.0f, -this.getShape().getHeight() / 2 + 1.0f));
      
      //Propel down
      ANybakk::PipeBlob::propelDown(this, otherBlob);
      
      //Call common handler
      onAbsorbed(this, otherBlob);
      
    }
    
    
    
    /**
     * Absorbs a blob, right-side
     */
    void absorbRight(CBlob@ this, CBlob@ otherBlob) {
    
      //Move other 1.0 inside
      otherBlob.setPosition(this.getPosition() + Vec2f(this.getShape().getWidth() / 2 - 1.0f, 0.0f));
      
      //Propel left
      ANybakk::PipeBlob::propelLeft(this, otherBlob);
      
      //Call common handler
      onAbsorbed(this, otherBlob);
      
    }
    
    
    
    /**
     * Absorbs a blob, bottom-side
     */
    void absorbBottom(CBlob@ this, CBlob@ otherBlob) {
    
      //Move other 1.0 inside
      otherBlob.setPosition(this.getPosition() + Vec2f(0.0f, this.getShape().getHeight() / 2 - 1.0f));
      
      //Propel up
      ANybakk::PipeBlob::propelUp(this, otherBlob);
      
      //Call common handler
      onAbsorbed(this, otherBlob);
      
    }
    
    
    
    /**
     * Absorbs a blob, left-side
     */
    void absorbLeft(CBlob@ this, CBlob@ otherBlob) {
    
      //Move other 1.0 inside
      otherBlob.setPosition(this.getPosition() + Vec2f(-this.getShape().getWidth() / 2 + 1.0f, 0.0f));
      
      //Propel right
      ANybakk::PipeBlob::propelRight(this, otherBlob);
      
      //Call common handler
      onAbsorbed(this, otherBlob);
      
    }
    
    
    
    /**
     * Handler for when a blob has been absorbed
     */
    void onAbsorbed(CBlob@ this, CBlob@ otherBlob) {
    
      //Tell pipeable to enter this pipe
      ANybakk::PipeableBlob::enterPipe(otherBlob, this);
      
      //Check if pipeable vanilla
      if(ANybakk::PipeableBlob::isConsideredPipeableVanilla(otherBlob)) {
      
        //Manually call sprite's onTick once (handler not associated with vanilla types)
        ANybakk::PipeableSprite::onTick(otherBlob.getSprite());
        
      }
      
      //Set entered pipe flag
      this.Tag("PipeFunnelBlob::wasEntered");
      
    }
    
    
    
    /**
     * Propels a blob
     */
    void propel(CBlob@ this, CBlob@ otherBlob) {
    
      //Retrieve current orientation
      u16 orientation = this.get_u16("StructureBlobOrientation");
    
      //Retrieve current velocity of object
      Vec2f currentVelocity = otherBlob.getVelocity();
      
      //Check if orientation is up or down
      if(orientation == ANybakk::StructureBlobOrientation::ORIENTATION_UP || orientation == ANybakk::StructureBlobOrientation::ORIENTATION_DOWN) {
      
        //Check if moving up
        if(currentVelocity.y < 0.0f) {
        
          //Propel up
          ANybakk::PipeBlob::propelUp(this, otherBlob);
          
        }
        
        //Otherwise, check if moving down
        else if(currentVelocity.y >= 0.0f) {
        
          //Propel down
          ANybakk::PipeBlob::propelDown(this, otherBlob);
          
        }
        
      }
      
      //Check if orientation is right or left
      else if(orientation == ANybakk::StructureBlobOrientation::ORIENTATION_RIGHT || orientation == ANybakk::StructureBlobOrientation::ORIENTATION_LEFT) {
      
        //Check if moving right
        if(currentVelocity.x > 0.0f) {
        
          //Propel right
          ANybakk::PipeBlob::propelRight(this, otherBlob);
          
        }
        
        //Otherwise, check if moving left
        else if(currentVelocity.x <= 0.0f) {
        
          //Propel left
          ANybakk::PipeBlob::propelLeft(this, otherBlob);
          
        }
        
      }
      
    }
    
    
    
  }
  
}