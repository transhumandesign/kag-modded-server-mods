
#include "StructureBlobOrientation.as";
#include "ConveyorBlobMode.as";
#include "ConveyorBlobModeData.as";
#include "ConveyorBlobConnectionData.as";
#include "ConveyorBlobDirection.as";

namespace ANybakk {

  namespace StructureVariables {
  
    //Define a wooden background tile type 
    const int BACKGROUND_TILE_TYPE = CMap::tile_wood_back;
    
    //Define a "build_door.ogg" placement sound
    const string PLACEMENT_SOUND = "/build_door.ogg";
  
    //Define an orientation of up (typically first sprite frame)
    const u16 DEFAULT_ORIENTATION = ANybakk::StructureBlobOrientation::ORIENTATION_UP;
    
  }

  namespace ConveyorVariables {
  
    //Define a default mode to be off
    const u8 DEFAULT_MODE = ANybakk::ConveyorBlobMode::MODE_OFF;
  
    //Define a default mode when turned on to be slow
    const u8 DEFAULT_ON_MODE = ANybakk::ConveyorBlobMode::MODE_SLOW;
    
    //Define an array of supported modes
    const ANybakk::ConveyorBlobModeData[] MODE_DATA = { 
    
      //Define an off mode with a target velocity of 0.0, 0.0 and no sound
      ANybakk::ConveyorBlobModeData(ANybakk::ConveyorBlobMode::MODE_OFF, Vec2f(0.0f, 0.0f), "", 60.0f),
    
      //Define a slow mode with a target velocity of 1.0, 0.0 and no sound
      ANybakk::ConveyorBlobModeData(ANybakk::ConveyorBlobMode::MODE_SLOW, Vec2f(1.0f, 0.0f), "", 60.0f)
      
    };
  
    //Define a default direction to be clockwise
    const u8 DEFAULT_DIRECTION = ANybakk::ConveyorBlobDirection::DIRECTION_CLOCKWISE;
    
    //Define horizontal connections for up orientation (belt conveyor always has up orientation)
    const int[] CONNECTION_DATA_HORIZONTAL_ORIENTATIONS = { 
      
      ANybakk::StructureBlobOrientation::ORIENTATION_UP 
      
    };
    
    //Define compatibility with belt conveyor segments
    const string[] CONNECTION_DATA_COMPATIBILITIES = {
    
      "isBeltConveyor"
      
    };
    
    //Define an array of supported connections
    const ANybakk::ConveyorBlobConnectionData[] CONNECTION_DATA = { 
    
      //Define a right connection with an offset of 8.0, 0.0
      ANybakk::ConveyorBlobConnectionData("ConveyorVariables::isConnectedRight", Vec2f(8.0f, 0.0f), CONNECTION_DATA_HORIZONTAL_ORIENTATIONS, CONNECTION_DATA_COMPATIBILITIES),
    
      //Define a left connection with an offset of -8.0, 0.0
      ANybakk::ConveyorBlobConnectionData("ConveyorVariables::isConnectedLeft", Vec2f(-8.0f, 0.0f), CONNECTION_DATA_HORIZONTAL_ORIENTATIONS, CONNECTION_DATA_COMPATIBILITIES)
      
    };
    
    //Define a sword damage flag as true
    const bool TAKE_DAMAGE_FROM_SWORD = true;
    
  }

  namespace BeltConveyorVariables {
    
  }
  
}