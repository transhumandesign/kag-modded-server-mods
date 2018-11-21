/*
 * Conveyor blob mode data.
 * 
 * Author: ANybakk
 */

#include "ConveyorBlobMode.as";

namespace ANybakk {

  class ConveyorBlobModeData {
    
    
    
    u8 mMode;
    Vec2f mTargetVelocity;
    string mSoundFile;
    f32 mSoundTime;
    
    
    
    ConveyorBlobModeData() {
    
      mMode = ANybakk::ConveyorBlobMode::MODE_OFF;  //Off mode
      mTargetVelocity = Vec2f(0.0f, 0.0f);          //No velocity
      mSoundFile = "";                              //No sound
      mSoundTime = 60.0f;                           //One minute
      
    }
    
    
    
    ConveyorBlobModeData(u8 mode, Vec2f targetVelocity, string soundFile, f32 soundTime) {
    
      mMode = mode;
      mTargetVelocity = targetVelocity;
      mSoundFile = soundFile;
      mSoundTime = soundTime;
      
    }
    
    
    
  }
  
}