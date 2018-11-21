/*
 * Belt Conveyor sections.
 * 
 * Author: ANybakk
 */



namespace ANybakk {

  namespace BeltConveyorSpriteSection {
  
  
  
    /**
     * Enumeration for different sections of a Belt Conveyor. Indexes 
     * corresponds to frame numbers (x-axis) in the sprite texture file.
     */
    enum Section {
    
      SECTION_STANDALONE = 0,   //Standalone part
      SECTION_LEFT = 1,         //Left edge part
      SECTION_MIDDLE = 2,       //Middle part
      SECTION_RIGHT = 3,        //Right edge part
      SECTION_NONE = 4          //End reference (not used)
      
    }
    
    
    
  }
  
}