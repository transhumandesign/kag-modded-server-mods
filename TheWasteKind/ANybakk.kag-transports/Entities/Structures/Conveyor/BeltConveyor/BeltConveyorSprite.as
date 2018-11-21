/* 
 * Belt Conveyor sprite.
 * 
 * Author: ANybakk
 */

#include "ConveyorBlobMode.as";
#include "ConveyorBlobDirection.as";
#include "ConveyorSprite.as";
#include "BeltConveyorSpriteSection.as";



namespace ANybakk {

  namespace BeltConveyorSprite {
  
  
  
    /**
     * Initialization event function
     */
    void onInit(CSprite@ this) {
    
      ANybakk::ConveyorSprite::onInit(this);
      
      CBlob@ blob = this.getBlob();
      
      //Set default animation state (conveyor is not placed yet)
      this.SetAnimation("default");
      
      //Set default frame to left end
      this.animation.frame = ANybakk::BeltConveyorSpriteSection::SECTION_STANDALONE;
      
      //Store mode
      blob.set_u8("BeltConveyorSpriteSection", ANybakk::BeltConveyorSpriteSection::SECTION_STANDALONE);
      
      //Finished
      return;
      
    }



    /**
     * Tick event function
     */
    void onTick(CSprite@ this) {
    
      ANybakk::ConveyorSprite::onTick(this);
      
      //Update section
      updateSection(this);
      
      //Update animation
      updateAnimation(this);
      
    }
    
    
    
    /**
     * Updates animation
     */
    void updateAnimation(CSprite@ this) {
    
      //Obtain a reference to the blob object
      CBlob@ blob = this.getBlob();
  
      //Retrieve current blob mode
      u8 blobMode = blob.get_u8("ConveyorBlobMode");
      
      //Retrieve current section
      u8 section = blob.get_u8("BeltConveyorSpriteSection");
      
      //Retrieve direction
      u8 direction = blob.get_u8("ConveyorBlobDirection");
      
      //Check if sprite section is standalone
      if(section == ANybakk::BeltConveyorSpriteSection::SECTION_STANDALONE) {
      
        //Check if blob mode is slow and animation not active
        if(blobMode == ANybakk::ConveyorBlobMode::MODE_SLOW && !this.isAnimation("slow_standalone")) {
        
          //Start slow left animation
          this.SetAnimation("slow_standalone");
        
        }
        
        //Otherwise, check if mode is off and animation is not active
        else if(blobMode == ANybakk::ConveyorBlobMode::MODE_OFF && !this.isAnimation("default")) {
      
          //Set default animation state
          this.SetAnimation("default");
      
          //Set default frame to left end
          this.animation.frame = ANybakk::BeltConveyorSpriteSection::SECTION_STANDALONE;
          
        }
        
      }
      
      //Otherwise, check if section is left edge
      else if(section == ANybakk::BeltConveyorSpriteSection::SECTION_LEFT) {
      
        //Check if blob mode is slow
        if(blobMode == ANybakk::ConveyorBlobMode::MODE_SLOW) {
        
          //Check if direction is clockwise and left animation not active
          if(direction == ANybakk::ConveyorBlobDirection::DIRECTION_CLOCKWISE && !this.isAnimation("slow_left")) {
        
            //Start slow left animation
            this.SetAnimation("slow_left");
            
          }
          
          //Otherwise, check if direction is counter-clockwise and right animation not active (sprite is flipped)
          else if(direction == ANybakk::ConveyorBlobDirection::DIRECTION_COUNTERCLOCKWISE && !this.isAnimation("slow_right")) {
        
            //Start slow right animation
            this.SetAnimation("slow_right");
            
          }
        
        }
        
        //Otherwise, check if mode is off and animation is not active
        else if(blobMode == ANybakk::ConveyorBlobMode::MODE_OFF && !this.isAnimation("default")) {
      
          //Set default animation state
          this.SetAnimation("default");
          
          //Check if direction is clockwise
          if(direction == ANybakk::ConveyorBlobDirection::DIRECTION_CLOCKWISE) {
      
            //Set default frame to left end
            this.animation.frame = ANybakk::BeltConveyorSpriteSection::SECTION_LEFT;
            
          }
          
          //Otherwise, check if direction is counter-clockwise
          else if(direction == ANybakk::ConveyorBlobDirection::DIRECTION_COUNTERCLOCKWISE) {
      
            //Set default frame to right end (sprite is flipped)
            this.animation.frame = ANybakk::BeltConveyorSpriteSection::SECTION_RIGHT;
          
          }
          
        }
        
      }
      
      //Otherwise, check if section is right edge
      else if(section == ANybakk::BeltConveyorSpriteSection::SECTION_RIGHT) {
      
        //Check if blob mode is slow
        if(blobMode == ANybakk::ConveyorBlobMode::MODE_SLOW) {
        
          //Check if direction is clockwise and right animation not active
          if(direction == ANybakk::ConveyorBlobDirection::DIRECTION_CLOCKWISE && !this.isAnimation("slow_right")) {
        
            //Start slow right animation
            this.SetAnimation("slow_right");
            
          }
          
          //Otherwise, check if direction is counter-clockwise and left animation not active (sprite is flipped)
          else if(direction == ANybakk::ConveyorBlobDirection::DIRECTION_COUNTERCLOCKWISE && !this.isAnimation("slow_left")) {
        
            //Start slow left animation
            this.SetAnimation("slow_left");
            
          }
        
        }
        
        //Otherwise, check if mode is off and animation is not active
        else if(blobMode == ANybakk::ConveyorBlobMode::MODE_OFF && !this.isAnimation("default")) {
      
          //Set default animation state
          this.SetAnimation("default");
          
          //Check if direction is clockwise
          if(direction == ANybakk::ConveyorBlobDirection::DIRECTION_CLOCKWISE) {
      
            //Set default frame to right end
            this.animation.frame = ANybakk::BeltConveyorSpriteSection::SECTION_RIGHT;
            
          }
          
          //Otherwise, check if direction is counter-clockwise
          else if(direction == ANybakk::ConveyorBlobDirection::DIRECTION_COUNTERCLOCKWISE) {
      
            //Set default frame to left end (sprite is flipped)
            this.animation.frame = ANybakk::BeltConveyorSpriteSection::SECTION_LEFT;
          
          }
          
        }
        
      }
      
      //Check if sprite section is middle
      else if(section == ANybakk::BeltConveyorSpriteSection::SECTION_MIDDLE) {
      
        //Check if blob mode is slow and animation not active
        if(blobMode == ANybakk::ConveyorBlobMode::MODE_SLOW && !this.isAnimation("slow_middle")) {
        
          //Start slow middle animation
          this.SetAnimation("slow_middle");
        
        }
        
        //Otherwise, check if mode is off and animation is not active
        else if(blobMode == ANybakk::ConveyorBlobMode::MODE_OFF && !this.isAnimation("default")) {
      
          //Set default animation state
          this.SetAnimation("default");
      
          //Set default frame to left end
          this.animation.frame = ANybakk::BeltConveyorSpriteSection::SECTION_MIDDLE;
          
        }
        
      }
      
      //Finished
      return;
      
    }
    
    
    
    /**
     * Updates section variable based on connections
     */
    void updateSection(CSprite@ this) {
    
      //Obtain a reference to the blob object
      CBlob@ blob = this.getBlob();
      
      //Check if connected both to the left and to the right
      if(blob.hasTag("ConveyorVariables::isConnectedLeft") && blob.hasTag("ConveyorVariables::isConnectedRight")) {
      
        //Set section to middle
        blob.set_u8("BeltConveyorSpriteSection", ANybakk::BeltConveyorSpriteSection::SECTION_MIDDLE);
        
      }
      
      //Otherwise, check if connected to the right
      else if(blob.hasTag("ConveyorVariables::isConnectedRight")) {
      
        blob.set_u8("BeltConveyorSpriteSection", ANybakk::BeltConveyorSpriteSection::SECTION_LEFT);
        
      }
      
      //Otherwise, check if connected to the left
      else if(blob.hasTag("ConveyorVariables::isConnectedLeft")) {
      
        //Set section to right
        blob.set_u8("BeltConveyorSpriteSection", ANybakk::BeltConveyorSpriteSection::SECTION_RIGHT);
        
      }
      
      //Otherwise
      else {
      
        //Set section to standalone
        blob.set_u8("BeltConveyorSpriteSection", ANybakk::BeltConveyorSpriteSection::SECTION_STANDALONE);
        
      }
      
      //Finished
      return;
      
    }
    
    
    
  }
  
}