void endbarTrue () {

  // endBar is set to true when you hold down SHIFT, so to end a 
  // noteBar, hold down SHIFT and click
  if (endBar == true && newBar == false) {
    
    if (mouseX > allSegs.get(actSeg).startX) {
      
      if (flatY == false) {
        if (nodeMatchS == true || nodeMatchE == true) { // // if there is 
          // a node in range...
          checkNodeD("NEWBAR & FLATY FALSE, ENDBAR TRUE - co-ords match found");
        } else {        
          allSegs.get(actSeg).endX = mouseX; // sets the end points of 
          // the last segment to mouse x and y values
          allSegs.get(actSeg).endY = mouseY;
        }
      } else {
        if (nodeMatchS == true || nodeMatchE == true) { // // if there is 
          // a node in range...
          checkNodeD("NEWBAR FALSE, FLATY & ENDBAR TRUE - co-ords match found");
        } else {

          allSegs.get(actSeg).endX = mouseX;
          allSegs.get(actSeg).endY = allSegs.get(actSeg).startY;
        }
      }
      actSeg++;
      allSegs.get(actSeg-1).calcSelection();
      if (allSegs.get(actSeg-1).type == true) {
        allSegs.get(actSeg-1).plotLine();
      }
      startSeg = false; // stop drawing lines on mousemoved
      newBar = true;    // next click will start new noteBar


      noteBars.add(new IntList(whichSegs));
      for (int i=0; i<=actBar; i++) {
        println("noteBars "+i+" is "+noteBars.get(i));
      }
      //notetreeInc(); // comment this out if you want to control noteTree increment manually
      actBar++;
      whichSegs.clear(); // clears the whichSegs IntList so it can 
      // receive a new list of noteSegs for the next notBar
      drawMode = false;
      endBar = false;
      allTrees.get(noteTree).sidebandData(); // this will have to be added to anything that changes a noteTrees positions
    } else {
    println("Try that just a wee bit further right...");
    }
    println("---------------------");
  }
}

