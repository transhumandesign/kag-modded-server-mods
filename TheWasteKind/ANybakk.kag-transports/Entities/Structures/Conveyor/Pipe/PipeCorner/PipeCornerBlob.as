/* 
 * Pipe Funnel blob.
 * 
 * Author: ANybakk
 */

#include "StructureBlobOrientation.as";
#include "ConveyorBlobConnectionData.as";
#include "PipeBlob.as";



namespace ANybakk {

  namespace PipeCornerBlob {



    void onInit(CBlob@ this) {
    
      ANybakk::PipeBlob::onInit(this);
      
      setTags(this);
      
    }
    
    
    
    void setTags(CBlob@ this) {
    
      this.Tag("isPipeCorner");
      
    }
    
    
    
    void onTick(CBlob@ this) {
    
      ANybakk::PipeBlob::onTick(this);
      
      //Propel overlapping blobs
      propelOverlapping(this);
    
      return;
      
    }
    
    
    
    bool doesCollideWithBlob(CBlob@ this, CBlob@ other) {
      
      return ANybakk::PipeBlob::doesCollideWithBlob(this, other);

    }
    
    
    
    void onSetStatic(CBlob@ this, const bool isStatic) {
      
      ANybakk::PipeBlob::onSetStatic(this, isStatic);
      
      //Check if placed
      if(this.hasTag("StructureBlob::isPlaced")) {
      
        //Retrieve current orientation
        u16 orientation = this.get_u16("StructureBlobOrientation");
        
        //Create a connection data object
        ANybakk::ConveyorBlobConnectionData connectionData;
        
        //Iterate through all possible connections (we need to un-tag connection types that aren't valid any longer)
        for(u8 i=0; i<ANybakk::ConveyorVariables::CONNECTION_DATA.length; i++) {
        
          //Keep connection data
          connectionData = ANybakk::ConveyorVariables::CONNECTION_DATA[i];
          
          //Check if orientation is up (up-right)
          if(orientation == ANybakk::StructureBlobOrientation::ORIENTATION_UP) {
          
            //Check if offset is not up or right
            if(!(connectionData.mOffset.y < 0.0f || connectionData.mOffset.x > 0.0f)) {
            
              //Remove tag
              this.Untag(connectionData.mName);
              
            }
            
          }
          
          //Check if orientation is right (right-down)
          else if(orientation == ANybakk::StructureBlobOrientation::ORIENTATION_RIGHT) {
          
            //Check if offset is not right or down
            if(!(connectionData.mOffset.x > 0.0f || connectionData.mOffset.y > 0.0f)) {
            
              //Remove tag
              this.Untag(connectionData.mName);
              
            }
            
          }
          
          //Check if orientation is down (down-left)
          else if(orientation == ANybakk::StructureBlobOrientation::ORIENTATION_DOWN) {
          
            //Check if offset is not down or left
            if(!(connectionData.mOffset.y > 0.0f || connectionData.mOffset.x < 0.0f)) {
            
              //Remove tag
              this.Untag(connectionData.mName);
              
            }
            
          }
          
          //Check if orientation is left (left-up)
          else if(orientation == ANybakk::StructureBlobOrientation::ORIENTATION_LEFT) {
          
            //Check if offset is not left or up
            if(!(connectionData.mOffset.x < 0.0f || connectionData.mOffset.y < 0.0f)) {
            
              //Remove tag
              this.Untag(connectionData.mName);
              
            }
            
          }
          
        }
        
      }
      
      //Finished
      return;
      
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
          
          //Check if valid, is within and in pipe
          if(overlappingBlob !is null && this.isPointInside(overlappingBlob.getPosition()) && overlappingBlob.hasTag("PipeableBlob::isInPipe")) {
            
            propel(this, overlappingBlob);
            
          }
          
        }
        
      }
      
    }
    
    
    
    /**
     * Propels a blob
     */
    void propel(CBlob@ this, CBlob@ otherBlob) {
    
      //Retrieve current orientation
      u16 orientation = this.get_u16("StructureBlobOrientation");
    
      //Retrieve current velocity of object
      Vec2f currentVelocity = otherBlob.getVelocity();
      
      //Obtain position of object
      Vec2f objectPosition = otherBlob.getPosition();
      
      //Obtain position of segment
      Vec2f segmentPosition = this.getPosition();
      
      //Check if orientation is up (up-right)
      if(orientation == ANybakk::StructureBlobOrientation::ORIENTATION_UP) {
      
        //Check if moving up
        if(currentVelocity.y < 0.0f) {
        
          //Propel up
          ANybakk::PipeBlob::propelUp(this, otherBlob);
          
        }
        
        //Otherwise, check if moving right
        else if(currentVelocity.x > 0.0f) {
        
          //Propel right
          ANybakk::PipeBlob::propelRight(this, otherBlob);
        
        }
        
        //Otherwise, check if moving down
        else if(currentVelocity.y > 0.0f) {
        
          //Check if reached the bend (center)
          if((objectPosition.y >= segmentPosition.y)) {
            
            //Propel right
            ANybakk::PipeBlob::propelRight(this, otherBlob);
          
          } else {
            
            //Propel down
            ANybakk::PipeBlob::propelDown(this, otherBlob);
          
          }
        
        }
        
        //Otherwise, check if moving left
        else if(currentVelocity.x < 0.0f) {
        
          //Check if reached the bend (center)
          if((objectPosition.x <= segmentPosition.x)) {
        
            //Propel up
            ANybakk::PipeBlob::propelUp(this, otherBlob);
          
          } else {
        
            //Propel left
            ANybakk::PipeBlob::propelLeft(this, otherBlob);
          
          }
        
        }
        
      }
      
      //Check if orientation is right (right-down)
      else if(orientation == ANybakk::StructureBlobOrientation::ORIENTATION_RIGHT) {
      
        //Check if moving up
        if(currentVelocity.y < 0.0f) {
        
          //Check if reached the bend (center)
          if((objectPosition.y <= segmentPosition.y)) {
            
            //Propel right
            ANybakk::PipeBlob::propelRight(this, otherBlob);
          
          } else {
            
            //Propel up
            ANybakk::PipeBlob::propelUp(this, otherBlob);
          
          }
          
        }
        
        //Otherwise, check if moving right
        else if(currentVelocity.x > 0.0f) {
        
          //Propel right
          ANybakk::PipeBlob::propelRight(this, otherBlob);
        
        }
        
        //Otherwise, check if moving down
        else if(currentVelocity.y > 0.0f) {
        
          //Propel down
          ANybakk::PipeBlob::propelDown(this, otherBlob);
        
        }
        
        //Otherwise, check if moving left
        else if(currentVelocity.x < 0.0f) {
        
          //Check if reached the bend (center)
          if((objectPosition.x <= segmentPosition.x)) {
        
            //Propel down
            ANybakk::PipeBlob::propelDown(this, otherBlob);
          
          } else {
        
            //Propel left
            ANybakk::PipeBlob::propelLeft(this, otherBlob);
          
          }
        
        }
        
      }
      
      //Check if orientation is down (down-left)
      else if(orientation == ANybakk::StructureBlobOrientation::ORIENTATION_DOWN) {
      
        //Check if moving up
        if(currentVelocity.y < 0.0f) {
        
          //Check if reached the bend (center)
          if((objectPosition.y <= segmentPosition.y)) {
            
            //Propel left
            ANybakk::PipeBlob::propelLeft(this, otherBlob);
          
          } else {
            
            //Propel up
            ANybakk::PipeBlob::propelUp(this, otherBlob);
          
          }
          
        }
        
        //Otherwise, check if moving right
        else if(currentVelocity.x > 0.0f) {
        
          //Check if reached the bend (center)
          if((objectPosition.x >= segmentPosition.x)) {
            
            //Propel down
            ANybakk::PipeBlob::propelDown(this, otherBlob);
          
          } else {
            
            //Propel right
            ANybakk::PipeBlob::propelRight(this, otherBlob);
          
          }
        
        }
        
        //Otherwise, check if moving down
        else if(currentVelocity.y > 0.0f) {
        
          //Propel down
          ANybakk::PipeBlob::propelDown(this, otherBlob);
        
        }
        
        //Otherwise, check if moving left
        else if(currentVelocity.x < 0.0f) {
        
          //Propel left
          ANybakk::PipeBlob::propelLeft(this, otherBlob);
        
        }
        
      }
      
      //Check if orientation is left (left-up)
      else if(orientation == ANybakk::StructureBlobOrientation::ORIENTATION_LEFT) {
      
        //Check if moving up
        if(currentVelocity.y < 0.0f) {
        
          //Propel up
          ANybakk::PipeBlob::propelUp(this, otherBlob);
          
        }
        
        //Otherwise, check if moving right
        else if(currentVelocity.x > 0.0f) {
        
          //Check if reached the bend (center)
          if((objectPosition.x >= segmentPosition.x)) {
            
            //Propel up
            ANybakk::PipeBlob::propelUp(this, otherBlob);
          
          } else {
            
            //Propel right
            ANybakk::PipeBlob::propelRight(this, otherBlob);
          
          }
        
        }
        
        //Otherwise, check if moving down
        else if(currentVelocity.y > 0.0f) {
        
          //Check if reached the bend (center)
          if((objectPosition.y >= segmentPosition.y)) {
            
            //Propel left
            ANybakk::PipeBlob::propelLeft(this, otherBlob);
          
          } else {
            
            //Propel down
            ANybakk::PipeBlob::propelDown(this, otherBlob);
          
          }
        
          
        
        }
        
        //Otherwise, check if moving left
        else if(currentVelocity.x < 0.0f) {
        
          //Propel left
          ANybakk::PipeBlob::propelLeft(this, otherBlob);
        
        }
        
      }
    
    }
    
    
    
  }
  
}