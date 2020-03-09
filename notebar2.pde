void midnoteBar () { 
  if (endBar == false && newBar == false) {
    // When in single click - if endBar is false && newBar is false && drawmode = true
    // not ending a noteBar and we're not stating a new noteBar, then
    // we're not acting on the 1st noteSeg of a noteBar

    if (mouseX > allSegs.get(actSeg).startX) {

      allSegs.add(new NoteSeg()); // so we create a new segment

      actSeg++; // increment actSeg, and fill the new segment variables
                // with mouse co-ords
      allSegs.get(actSeg-1).calcSelection();
      if (allSegs.get(actSeg-1).type == true) {
        allSegs.get(actSeg-1).plotLine();
      }
      //
      if (flatY == false) {// (flatY is controlled by the CTRL key, 
        // when flatY is true, draws straight horizontal lines)

        if (nodeMatchS == true || nodeMatchE == true) { // if there is 
          // a node in range...
          checkNodeB("NEWBAR, ENDBAR & FLATY FALSE - co-ords match found");
        } else {

          allSegs.get(actSeg).start(actSeg, mouseX, mouseY, mouseX, mouseY, true, actBar, barCol, false, noteTree, 
          0, 0);  
        }
      } else { // if we want to draw a straight line then the start Y
        // value of the new noteSeg must be the end Y value of the
        // previous noteSeg
        if (nodeMatchS == true || nodeMatchE == true) { // // if there is 
          // a node in range...
          checkNodeB("NEWBAR & ENDBAR FALSE, FLATY TRUE - co-ords match found");
        } else {
          allSegs.get(actSeg).start(actSeg, mouseX, allSegs.get(actSeg-1).endY, 
          mouseX, mouseY, true, actBar, 
          barCol, false, noteTree, 
          0, 0);  
        }
      }
      whichSegs.append(actSeg); // adding this segment to the list of 
      // segs that will be associated with this noteBar
    } else {
    println("Ye cannae gae back in TIME lad!!!!");
    }
  }
}

