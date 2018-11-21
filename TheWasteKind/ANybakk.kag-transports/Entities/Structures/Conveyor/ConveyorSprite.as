/* 
 * Conveyor sprite.
 * 
 * Author: ANybakk
 */

#include "StructureSprite.as"
#include "ConveyorBlobModeData.as"
#include "ConveyorBlobConnectionData.as"

namespace ANybakk {

  namespace ConveyorSprite {
  
  
  
    /**
     * Initialization event function
     */
    void onInit(CSprite@ this) {
      
      ANybakk::StructureSprite::onInit(this);
      
      CBlob@ blob = this.getBlob();
      
      blob.set_u32("ConveyorSprite::lastRunningSoundTime", getGameTime());
      
      //Finished
      return;
      
    }



    /**
     * Tick event function
     */
    void onTick(CSprite@ this) {
      
      ANybakk::StructureSprite::onTick(this);
      
      //Obtain a reference to the blob object
      CBlob@ blob = this.getBlob();
      
      //Retrieve time variable for when the running sound was last played
      u32 lastRunningSoundTime = blob.get_u32("ConveyorSprite::lastRunningSoundTime");
  
      //Retrieve current blob mode
      u8 blobMode = blob.get_u8("ConveyorBlobMode");
      
      //Create mode data handle
      const ANybakk::ConveyorBlobModeData@ blobModeData;
      
      //Iterate through modes
      for(u8 i=0; i<ANybakk::ConveyorVariables::MODE_DATA.length; i++) {
      
        @blobModeData = ANybakk::ConveyorVariables::MODE_DATA[i];
        
        //Check if current mode
        if(blobModeData.mMode == blobMode) {
        
          //Check if more than 0.68 seconds have passed
          if(getGameTime() - lastRunningSoundTime >= blobModeData.mSoundTime * getTicksASecond()) {
            
            //Check if sound file is set
            if(blobModeData.mSoundFile != "") {
            
              //Play sound
              this.PlaySound(blobModeData.mSoundFile);
              
              //Update time variable
              blob.set_u32("ConveyorSprite::lastRunningSoundTime", getGameTime());
              
            }
            
          }
          
          //End loop
          break;
          
        }
      
      }
      
      //Finished
      return;
      
    }



    /**
     * Rendering event function
     */
    void onRender(CSprite@ this) {

      //Check if debug mode
      if(g_debug > 0) {
      
        CBlob@ blob = this.getBlob();
        
        //Create a connection data handle
        const ANybakk::ConveyorBlobConnectionData@ connectionData;
        
        //Create a blob position vector
        Vec2f screenBlobPosition = getDriver().getScreenPosFromWorldPos(blob.getPosition());
        
        //Create a direction vector
        Vec2f screenDirectionPosition;
        
        //Iterate through all possible connections
        for(u8 i=0; i<ANybakk::ConveyorVariables::CONNECTION_DATA.length; i++) {
        
          //Keep connection data
          @connectionData = ANybakk::ConveyorVariables::CONNECTION_DATA[i];
          
          //Check if tagged with this connection name
          if(blob.hasTag(connectionData.mName)) {
          
            //Copy offset
            Vec2f offset = connectionData.mOffset;
            
            screenDirectionPosition = getDriver().getScreenPosFromWorldPos(blob.getPosition() + offset / 2);
            GUI::DrawLine2D(screenBlobPosition, screenDirectionPosition, SColor(0xff00ff00));
            
          }
          
        }
        
      }
      
      //Finished
      return;

    }
    
    
    
  }
  
}