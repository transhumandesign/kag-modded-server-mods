/* 
 * Conveyor blob.
 * 
 * Author: ANybakk
 */

#include "StructureBlob.as";
#include "ConveyorBlobMode.as";
#include "ConveyorBlobDirection.as";
#include "ConveyorBlobConnectionData.as";



namespace ANybakk {

  namespace ConveyorBlob {



    void onInit(CBlob@ this) {
    
      ANybakk::StructureBlob::onInit(this);
      
      setTags(this);
      
    }
    
    
    
    void setTags(CBlob@ this) {
    
      this.Tag("isConveyor");
      
      //Set sync flag (propagates connection update to adjacent segments, on placement)
      this.Tag("ConveyorBlob::isSynchronized");
      
      //Set animation sync flag (propagates connection animation update to adjacent segments, on placement)
      this.Tag("ConveyorBlob::isAnimationSynchronized");
      
      //Set sound sync flag (propagates connection sound update to adjacent segments, on placement)
      this.Tag("ConveyorBlob::isSoundSynchronized");
      
      //Set initial mode to OFF
      this.set_u8("ConveyorBlobMode", ANybakk::ConveyorVariables::DEFAULT_MODE);
      
      //Set direction counter-clockwise
      this.set_u8("ConveyorBlobDirection", ANybakk::ConveyorVariables::DEFAULT_DIRECTION);
      
      //Store connection data (necessary for connecting segments with different connection rules)
      this.set("ConveyorBlobConnectionData", @ANybakk::ConveyorVariables::CONNECTION_DATA);
      
      //Store the time of last time connections were updated (used to avoid circular loops)
      this.set_u32("ConveyorBlob::lastUpdateConnectionsTime", getGameTime());
      
      //Create an empty ID array
      u32[] connectionIDs = {};
      
      //Store the time of last time connections were updated (used to avoid circular loops)
      this.set("ConveyorBlob::connectionIDs", @connectionIDs);
      
      //Set flag so that blob cannot be rotated when built (for BlobPlacement.as)
      this.Tag("place norotate");

      //Unset flag so that blob is flipped depending on direction faced (for BlobPlacement.as)
      this.Untag("place ignore facing");
      
      //Set flag so that builder always hit (for BuilderHittable.as)
      this.Tag("builder always hit");

      //Unset flag so that swords hit (for KnightLogic.as)
      //TODO: Sword won't do damage anyway
      this.set_bool("ignore sword", !ANybakk::ConveyorVariables::TAKE_DAMAGE_FROM_SWORD);
      
    }
    
    
    
    void onTick(CBlob@ this) {
      
      //Update connections
      updateConnections(this, null, null, false, false, false);
      
    }
    
    
    
    bool doesCollideWithBlob(CBlob@ this, CBlob@ other) {
      
      //Finished, return true always
      return true;

    }
    
    
    
    void onSetStatic(CBlob@ this, const bool isStatic) {
    
      ANybakk::StructureBlob::onSetStatic(this, isStatic);
      
      if(this.hasTag("StructureBlob::isPlaced")) {
      
        //Set mode to default
        this.set_u8("ConveyorBlobMode", ANybakk::ConveyorVariables::DEFAULT_ON_MODE);
        
        //Update connections
        updateConnections(this, null, null, this.hasTag("ConveyorBlob::isSynchronized"), this.hasTag("ConveyorBlob::isAnimationSynchronized"), this.hasTag("ConveyorBlob::isSoundSynchronized"));
      
      }
      
    }
    
    
    
    bool canBePickedUp(CBlob@ this, CBlob@ byBlob) {

      return ANybakk::StructureBlob::canBePickedUp(this, byBlob);

    }
    
    
    
    /**
     * Updates connection statuses for the blob (and any others of the same type in the same direction)
     * 
     * @param   previousBlob    the previous segment in the chain (used for recursive calls)
     * @param   doPropagate     whether to propagate linearly or not
     * @param   doAnimationSync whether to synchronize animations when propagating
     * @param   doSoundSync     whether to synchronize sound when propagating
     */
    void updateConnections(CBlob@ this, CBlob@ previousBlob=null, ANybakk::ConveyorBlobConnectionData@ previousData=null, bool doPropagate=false, bool doAnimationSync=false, bool doSoundSync=false) {
      
      //Check if placed
      if(this.hasTag("StructureBlob::isPlaced")) {
      
        //Update time variable
        this.set_u32("ConveyorBlob::lastUpdateConnectionsTime", getGameTime());
        
        //Check if previous is valid and animation propagate flag
        if(previousBlob !is null && doAnimationSync) {
        
          //Set animation frame number
          this.getSprite().animation.frame = previousBlob.getSprite().animation.frame;
          
        }
        
        //Check if previous is valid and sound propagate flag
        if(previousBlob !is null && doSoundSync) {
        
          this.set_u32("ConveyorSprite::lastRunningSoundTime", previousBlob.get_u32("ConveyorSprite::lastRunningSoundTime"));
          
        }
        
        //Create an array of connection data object references
        ANybakk::ConveyorBlobConnectionData[]@ connectionData;
        
        //Check if connection data could be retrieved
        if(this.get("ConveyorBlobConnectionData", @connectionData)) {
        
          //Obtain a reference to the map
          CMap@ map = this.getMap();
        
          //Retrieve current orientation
          u16 orientation = this.get_u16("StructureBlobOrientation");
        
          //Iterate through possible connections
          for(int i=0; i<connectionData.length; i++) {
            
            //Iterate through valid orientations
            for(int j=0; j<connectionData[i].mOrientations.length; j++) {
            
              //Check if orientation matches
              if(connectionData[i].mOrientations[j] == orientation) {
                
                //Retrieve the next segment
                CBlob@ nextBlob = map.getBlobAtPosition(this.getPosition() + connectionData[i].mOffset);
                
                //Check if valid, tagged as conveyor, is placed, not recently destroyed, and same direction
                if(
                    nextBlob !is null
                    //nextBlob.getName() == currentBlob.getName() 
                    && nextBlob.hasTag("isConveyor") 
                    && nextBlob.hasTag("StructureBlob::isPlaced") 
                    && !nextBlob.hasTag("StructureBlob::wasDestroyed")
                    && nextBlob.get_u8("ConveyorBlobDirection") == this.get_u8("ConveyorBlobDirection")
                    && isCompatible(this, nextBlob)
                    //And nextBlob has correct orientation
                  ) {
                  
                  //Check if previous is valid and next is the same as previous
                  if(previousBlob !is null && nextBlob.getNetworkID() == previousBlob.getNetworkID()) {
                  
                    //Set tag on previous
                    previousBlob.Tag(previousData.mName);
                    
                    //Create an ID array variables
                    u32[]@ previousConnectionIDs;
                    
                    //Retrieve previous segment's IDs
                    if(previousBlob.get("ConveyorBlob::connectionIDs", @previousConnectionIDs)) {
                    
                      //Retrieve index of this segment's ID
                      int a = previousConnectionIDs.find(this.getNetworkID());
                      
                      //Check if not present
                      if(a < 0) {
                      
                        //Store ID
                        previousConnectionIDs.push_back(this.getNetworkID());
                        
                      }
                    
                    }
                    
                    //Set tag on this
                    this.Tag(connectionData[i].mName);
                    
                    //Create an ID array variables
                    u32[]@ thisConnectionIDs;
                    
                    //Retrieve previous segment's IDs
                    if(this.get("ConveyorBlob::connectionIDs", @thisConnectionIDs)) {
                    
                      //Retrieve index of previous segment's ID
                      int a = thisConnectionIDs.find(previousBlob.getNetworkID());
                      
                      //Check if not present
                      if(a < 0) {
                      
                        //Store ID
                        thisConnectionIDs.push_back(previousBlob.getNetworkID());
                        
                      }
                      
                    }
                    
                  }
                  
                  //Check if previous is not valid (first segment), or propagating while next not the same as previous and next hasn't already been updated
                  if(previousBlob is null || (doPropagate && nextBlob.getNetworkID() != previousBlob.getNetworkID() && nextBlob.get_u32("ConveyorBlob::lastUpdateConnectionsTime") != getGameTime())) {
                  
                    //Recursively handle the next segment
                    updateConnections(nextBlob, this, connectionData[i], doPropagate, doAnimationSync, doSoundSync);
                    
                  }
                  
                }
                
              }
              
            }
            
          }
          
        }
        
      }
      
      //Finished
      return;
      
    }
    
    
    
    /**
     * Checks whether this is connected to another blob
     */
    bool isConnected(CBlob@ this, CBlob@ other) {
    
      //Check if either is invalid, not conveyor or not same type
      if(this is null || other is null || !this.hasTag("isConveyor") || !other.hasTag("isConveyor")) {
      
        //Finished, return false (could not check)
        return false;
        
      }
      
      //Create a couple of reference arrays
      u32[]@ thisConnectionIDs;
      u32[]@ otherConnectionIDs;
      
      //Check if connection IDs could be retrieved
      if(this.get("ConveyorBlob::connectionIDs", @thisConnectionIDs) && other.get("ConveyorBlob::connectionIDs", @otherConnectionIDs)) {
      
        //Iterate through this segment's IDs
        for(int i=0; i<thisConnectionIDs.length; i++) {
        
          //Iterate through other segment's IDs
          for(int j=0; j<otherConnectionIDs.length; j++) {
          
            //Check if IDs match
            if(thisConnectionIDs[i] == other.getNetworkID() && otherConnectionIDs[j] == this.getNetworkID()) {
            
              //Finished, match was found
              return true;
            
            }
            
          }
          
        }
        
      }
      
      //Finished, return false (no match found)
      return false;
      
    }
    
    
    
    void onDie(CBlob@ this) {
    
      ANybakk::StructureBlob::onDie(this);
    
      //Check if valid and placed
      if(this !is null && this.hasTag("StructureBlob::wasDestroyed")) {
      
        //Create a reference array
        u32[]@ thisConnectionIDs;
        
        //Check if connection IDs could be retrieved
        if(this.get("ConveyorBlob::connectionIDs", @thisConnectionIDs)) {
        
          //Create a blob reference handle
          CBlob@ otherBlob;
          
          //Iterate through IDs
          for(int i=0; i<thisConnectionIDs.length; i++) {
          
            //Keep a reference
            @otherBlob = getBlobByNetworkID(thisConnectionIDs[i]);
            
            //Create another reference array
            u32[]@ otherConnectionIDs;
            
            //Check if other is valid and connection IDs could be retrieved
            if(otherBlob !is null && otherBlob.get("ConveyorBlob::connectionIDs", @otherConnectionIDs)) {
            
              //Iterate through other segment's IDs
              for(int j=0; j<otherConnectionIDs.length; j++) {
              
                //Check if match
                if(otherConnectionIDs[j] == this.getNetworkID()) {
                
                  //Remove this segment's ID
                  otherConnectionIDs.removeAt(j);
                  
                  //Create an array of connection data object references
                  ANybakk::ConveyorBlobConnectionData[]@ connectionData;
                  
                  //Check if connection data could be retrieved
                  if(otherBlob.get("ConveyorBlobConnectionData", @connectionData)) {
                  
                    //Iterate through connections
                    for(int k=0; k<connectionData.length; k++) {
                    
                      //Check if offset matches displacement
                      if(connectionData[k].mOffset == this.getPosition() - otherBlob.getPosition()) {
                      
                        //Untag
                        otherBlob.Untag(connectionData[k].mName);
                        
                        break;
                        
                      }
                      
                    }
                    
                    //Update connections for other segment (lightweight, only immediate neighbours)
                    updateConnections(otherBlob, null, null, false, this.hasTag("ConveyorBlob::isAnimationSynchronized"), this.hasTag("ConveyorBlob::isSoundSynchronized"));
                    
                  }
                  
                }
                
              }
              
            }
            
          }
          
        }
        
      }
      
    }
    
    
    
    bool isCompatible(CBlob@ this, CBlob@ other) {
    
      bool thisIsCompatible = false;
      bool otherIsCompatible = false;
      
      //Create an arrays of connection data object references
      ANybakk::ConveyorBlobConnectionData[]@ thisConnectionData;
      
      //Check if connection data could be retrieved for this
      if(this.get("ConveyorBlobConnectionData", @thisConnectionData)) {
        
        //Iterate through connections
        for(int i=0; i<thisConnectionData.length; i++) {
        
          //Iterate through compatibilities
          for(int j=0; j<thisConnectionData[i].mCompatibilities.length; j++) {
          
            //Remember if tagged
            otherIsCompatible = otherIsCompatible || other.hasTag(thisConnectionData[i].mCompatibilities[j]);
            
          }
          
        }
        
      }
      
      //Otherwise, could not retrieve connection data for this
      else {
      
        //Remember that other is compatible (out of kindness)
        otherIsCompatible = true;
        
      }
      
      //Create an arrays of connection data object references
      ANybakk::ConveyorBlobConnectionData[]@ otherConnectionData;
      
      //Check if connection data could be retrieved for other
      if(other.get("ConveyorBlobConnectionData", @otherConnectionData)) {
        
        //Iterate through connections
        for(int i=0; i<otherConnectionData.length; i++) {
        
          //Iterate through compatibilities
          for(int j=0; j<otherConnectionData[i].mCompatibilities.length; j++) {
          
            //Remember if tagged
            thisIsCompatible = thisIsCompatible || this.hasTag(otherConnectionData[i].mCompatibilities[j]);
            
          }
          
        }
        
      }
      
      //Otherwise, could not retrieve connection data for other
      else {
      
        //Remember that this is compatible (out of kindness)
        thisIsCompatible = true;
        
      }
      
      //Finished, return true if both are compatible
      return otherIsCompatible && thisIsCompatible;
      
    }
    
    
    
    /**
     * Returns the mode data object depending on whatever mode is currently active
     */
    ConveyorBlobModeData getModeData(CBlob@ this) {
    
      //Create variable
      ConveyorBlobModeData result;
    
      //Retrieve current mode
      u8 currentMode = this.get_u8("ConveyorBlobMode");
      
      //Iterate through modes
      for(u8 i=0; i<ANybakk::ConveyorVariables::MODE_DATA.length; i++) {
      
        //Check if current mode
        if(ANybakk::ConveyorVariables::MODE_DATA[i].mMode == currentMode) {
        
          //Keep target velocity vector
          result = ANybakk::ConveyorVariables::MODE_DATA[i];
          
          //End loop
          break;
          
        }
      
      }
      
      return result;
      
    }
    
    
    
  }
  
}