
#include "StructureBlobOrientation.as";
#include "ConveyorBlobMode.as";
#include "ConveyorBlobModeData.as";
#include "ConveyorBlobConnectionData.as";
#include "ConveyorBlobDirection.as";

namespace ANybakk {

  namespace StructureVariables {
  
    //Define a stone background tile type 
    const int BACKGROUND_TILE_TYPE = CMap::tile_castle_back;
    
    //Define a "build_door.ogg" placement sound
    const string PLACEMENT_SOUND = "/build_wall2.ogg";
  
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
    
      //Define an off mode with a target velocity of 0.0, 0.0
      ANybakk::ConveyorBlobModeData(ANybakk::ConveyorBlobMode::MODE_OFF, Vec2f(0.0f, 0.0f), "", 60.0f),
    
      //Define a slow mode with a target velocity of 1.0, 1.0
      ANybakk::ConveyorBlobModeData(ANybakk::ConveyorBlobMode::MODE_SLOW, Vec2f(1.0f, 1.0f), "", 60.0f)
      
    };
  
    //Define a default direction to be clockwise
    const u8 DEFAULT_DIRECTION = ANybakk::ConveyorBlobDirection::DIRECTION_CLOCKWISE;
    
    //Define vertical connections for up and down orientations
    const int[] CONNECTION_DATA_VERTICAL_ORIENTATIONS = { 
    
      ANybakk::StructureBlobOrientation::ORIENTATION_UP, 
      ANybakk::StructureBlobOrientation::ORIENTATION_DOWN 
      
    };
    
    //Define horizontal connections for left and right orientations
    const int[] CONNECTION_DATA_HORIZONTAL_ORIENTATIONS = { 
      
      ANybakk::StructureBlobOrientation::ORIENTATION_LEFT, 
      ANybakk::StructureBlobOrientation::ORIENTATION_RIGHT 
      
    };
    
    //Define compatibility with all pipe segments
    const string[] CONNECTION_DATA_COMPATIBILITIES = {
    
      "isPipe"
      
    };
    
    //Define an array of supported connections
    const ANybakk::ConveyorBlobConnectionData[] CONNECTION_DATA = { 
    
      //Define an up connection with an offset of 0.0, -8.0
      ANybakk::ConveyorBlobConnectionData("ConveyorVariables::isConnectedUp", Vec2f(0.0f, -8.0f), CONNECTION_DATA_VERTICAL_ORIENTATIONS, CONNECTION_DATA_COMPATIBILITIES),
    
      //Define a right connection with an offset of 8.0, 0.0
      ANybakk::ConveyorBlobConnectionData("ConveyorVariables::isConnectedRight", Vec2f(8.0f, 0.0f), CONNECTION_DATA_HORIZONTAL_ORIENTATIONS, CONNECTION_DATA_COMPATIBILITIES),
    
      //Define a down connection with an offset of 0.0, 8.0
      ANybakk::ConveyorBlobConnectionData("ConveyorVariables::isConnectedDown", Vec2f(0.0f, 8.0f), CONNECTION_DATA_VERTICAL_ORIENTATIONS, CONNECTION_DATA_COMPATIBILITIES),
    
      //Define a left connection with an offset of -8.0, 0.0
      ANybakk::ConveyorBlobConnectionData("ConveyorVariables::isConnectedLeft", Vec2f(-8.0f, 0.0f), CONNECTION_DATA_HORIZONTAL_ORIENTATIONS, CONNECTION_DATA_COMPATIBILITIES)
      
    };
    
    //Define a sword damage flag as false
    const bool TAKE_DAMAGE_FROM_SWORD = false;
    
  }

  namespace PipeVariables {
    
  }

  namespace PipeStraightVariables {
    
  }
  
}