void resetNodebooleans () {
  nodeMatchS = false; // booleans to check if any new point is   
  nodeMatchE = false; // within range of an old one
}

void checkingNodes () {

  if (allSegs.size() == 0) { // This controls the size of the loop 
    // that checks nodes
    checkNodes = 0; // if there's nothing in allSegs it's = 0
  } else { // if there's anything in allSegs it's = one less
    // than the size of allSegs
    checkNodes = allSegs.size();
  }
  
  // Checks all node points, if the new node point is within
  // a certain range of an old one, boolean nodeMatchS or E is true
    for (int i=0; i<checkNodes; i++) { // checks start values of noteSegs

    if (i < checkNodes-1) { // 
      if ((mouseX<=allSegs.get(i).startX+range && mouseX>=allSegs.get(i).startX-range) &&
        (mouseY<=allSegs.get(i).startY+range && mouseY>=allSegs.get(i).startY-range)) {
        if (nodeMatchS == false) { // use this to access the correct noteSeg when
          segID = i;               // accessing the coordinates
          nodeMatchS = true;
        }
      } else if ((mouseX<=allSegs.get(i).endX+range && mouseX>=allSegs.get(i).endX-range) &&
        (mouseY<=allSegs.get(i).endY+range && mouseY>=allSegs.get(i).endY-range)) {
        if (nodeMatchS == false && nodeMatchE == false) {
          segID = i;
          nodeMatchE = true;
        }
      }
    }

    if (newBar == true) { // this checks if I've just ended a noteBar
      // if the click is in range of a node, I can edit the node
      // but not begin a new noteBar
      if ((mouseX<=allSegs.get(i).startX+range && mouseX>=allSegs.get(i).startX-range) &&
        (mouseY<=allSegs.get(i).startY+range && mouseY>=allSegs.get(i).startY-range)) {

        allSegs.get(i).startNode = true;
        moveNodes = true;
      } else if ((mouseX<=allSegs.get(i).endX+range && mouseX>=allSegs.get(i).endX-range) &&
        (mouseY<=allSegs.get(i).endY+range && mouseY>=allSegs.get(i).endY-range)) {

        allSegs.get(i).endNode = true;
        moveNodes = true;
      }
    }
  }
}

/*
These methods look at node Match booleans and instantiate instances
 of the noteSeg class based on these.
 */



void checkNodeA(String Msg) {

  if (nodeMatchS == true) { // if new click matches the coordinates
                            // of the start point of a noteSeg

    // run the .start method of the noteSeg class
    // using the start coordinates of the target noteseg (segID)
    // as the start coordinates of the new node

      allSegs.get(actSeg).start(actSeg, allSegs.get(segID).startX, 
    allSegs.get(segID).startY, mouseX, mouseY, true, actBar, barCol, false, noteTree, 
    0, 0);
  } else if (nodeMatchE == true) { // if new click matches the 
    // coordinates of the end point of a noteSeg
    //
    // run the .start method of the noteSeg class
    // using the end coordinates of the target noteseg (segID)
    // as the start coordinates of the new node
    
    allSegs.get(actSeg).start(actSeg, allSegs.get(segID).endX, 
    allSegs.get(segID).endY, mouseX, mouseY, true, actBar, barCol, false, noteTree, 
    0, 0);
  } 
}

void checkNodeB(String Msg) {

  if (nodeMatchS == true) { // if new click matches the coordinates
    // of the start point of a noteSeg
    //
    // run the .start method of the noteSeg class
    // using the start coordinates of the target noteseg (segID)
    // as the start coordinates of the new node
    //
    allSegs.get(actSeg).start(actSeg, allSegs.get(segID).startX, 
    allSegs.get(segID).startY, mouseX, mouseY, true, actBar, barCol, false, noteTree, 
    0, 0);

    allSegs.get(actSeg-1).endX = allSegs.get(segID).startX;
    allSegs.get(actSeg-1).endY = allSegs.get(segID).startY;
    
        if (allSegs.get(actSeg-1).type == false) {
      allSegs.get(actSeg-1).plotPoints.clear();
      allSegs.get(actSeg-1).curveVars();
      allSegs.get(actSeg-1).plotCurve();
      allSegs.get(actSeg-1).display();
    }
  } else if (nodeMatchE == true) { // if new click matches the 
    // coordinates of the end point of 
    // a noteSeg
    //
    // run the .start method of the noteSeg class
    // using the end coordinates of the target noteseg (segID)
    // as the start coordinates of the new node
    //
    allSegs.get(actSeg).start(actSeg, allSegs.get(segID).endX, 
    allSegs.get(segID).endY, mouseX, mouseY, true, actBar, barCol, false, noteTree, 
    0, 0);
    //
    // ALSO
    //
    // Set the end points of the previous noteSeg need to be
    // set to the same coordinates as the end of the target noteSeg
    //
    allSegs.get(actSeg-1).endX = allSegs.get(segID).endX;
    allSegs.get(actSeg-1).endY = allSegs.get(segID).endY;

    if (allSegs.get(actSeg-1).type == false) {
      allSegs.get(actSeg-1).plotPoints.clear();
      allSegs.get(actSeg-1).curveVars();
      allSegs.get(actSeg-1).plotCurve();
      allSegs.get(actSeg-1).display();
    }
  } 
}

void checkNodeD(String Msg) {

  if (nodeMatchS == true) {
    //
    // sets the end points of the last segment to the target node 
    // startX and Y points
    allSegs.get(actSeg).endX = allSegs.get(segID).startX;
    allSegs.get(actSeg).endY = allSegs.get(segID).startY;
    //
    if (allSegs.get(actSeg).type == false) {
      allSegs.get(actSeg).plotPoints.clear();
      allSegs.get(actSeg).curveVars();
      allSegs.get(actSeg).plotCurve();
      allSegs.get(actSeg).display();
    }
  } else if (nodeMatchE == true) {
    //
    // sets the end points of the last segment to the target node 
    // endX and Y points
    allSegs.get(actSeg).endX = allSegs.get(segID).endX;
    allSegs.get(actSeg).endY = allSegs.get(segID).endY;
    //
    if (allSegs.get(actSeg).type == false) {
      allSegs.get(actSeg).plotPoints.clear();
      allSegs.get(actSeg).curveVars();
      allSegs.get(actSeg).plotCurve();
      allSegs.get(actSeg).display();
    }
  }
}

