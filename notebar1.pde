void newbarTrue () {

  if (drawMode == true) {
    
    if (newBar == true) { // if newBar = true it means we're acting on 
      // the first noteSeg of a noteBar
      startSeg = true;    // use this to control if mouseMoved draws
      newBar = false;

      allSegs.add(new NoteSeg()); // create a new noteSeg and fill 
      // variables with mouse co-ords etc.

      if (nodeMatchS == true || nodeMatchE == true) { // if there is 
        // a node in range...
        checkNodeA("NEWBAR TRUE - co-ords match found"); // run this
        // method
      } else { // if there's no matching nodes then
        // make a new one where you've clicked
        allSegs.get(actSeg).start(actSeg, mouseX, mouseY, mouseX, mouseY, 
        true, actBar, barCol, false, noteTree, 0, 0);
      }

      whichSegs.append(actSeg); // adding this segment to the list of
    }
  }
}

