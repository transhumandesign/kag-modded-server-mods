/*
 * Conveyor blob connection data.
 * 
 * Author: ANybakk
 */

#include "StructureBlobOrientation.as";

namespace ANybakk {

  /**
   * Represents data about a connection type for conveyors.
   */
  class ConveyorBlobConnectionData {
    
    
    
    string mName;               //Name, used as a tag on blob
    Vec2f mOffset;              //An offset pointing to where a connected blob might be located
    int[] mOrientations;        //An array of orientations this connection requires (StructureBlob)
    string[] mCompatibilities;  //An array of types this connection is compatible with (StructureBlob)
    
    
    
    ConveyorBlobConnectionData() {
    
      mName = "ConveyorBlobConnectionData::isConnectedSelf";
      mOffset = Vec2f(0.0f, 0.0f);
      mOrientations.push_back(ANybakk::StructureVariables::DEFAULT_ORIENTATION);
      mCompatibilities.push_back("isConveyor");
      
    }
    
    
    
    ConveyorBlobConnectionData(string name, Vec2f offset, int[] orientations, string[] compatibilities) {
    
      mName = name;
      mOffset = offset;
      mOrientations = orientations;
      mCompatibilities = compatibilities;
      
    }
    
    
    
  }
  
}