// implement freeHand drawing

void freeHand() {

  if (newBar == true) {
    newBar = false;

    allSegs.add(new NoteSeg()); // create a new noteSeg and fill 
    // variables with mouse co-ords etc.

    allSegs.get(actSeg).start(actSeg, mouseX, mouseY, mouseX, mouseY, 
    true, actBar, barCol, false, noteTree, 0, 0); // slot values into noteSeg

    whichSegs.append(actSeg); // adding this segment to the list of 
    // segs that will be associated with this noteBar
  }

  if (endBar == false && newBar == false) {

    if (mouseX > allSegs.get(actSeg).startX) {

      allSegs.add(new NoteSeg()); // so we create a new segment

      actSeg++; // increment actSeg, and fill the new segment variables
      // with mouse co-ords
      allSegs.get(actSeg-1).calcSelection();
      if (allSegs.get(actSeg-1).type == true) {
        allSegs.get(actSeg-1).plotLine();
      }

      allSegs.get(actSeg).start(actSeg, mouseX, mouseY, 
      mouseX, mouseY, true, actBar, barCol, false, noteTree, 0, 0);

      allSegs.get(actSeg-1).endX = allSegs.get(actSeg).startX;
      allSegs.get(actSeg-1).endY = allSegs.get(actSeg).startY;

      whichSegs.append(actSeg);
    }
  }
}

void endfreeHand () {

  if (mouseX >= allSegs.get(actSeg).startX) {

    allSegs.get(actSeg).endX = mouseX; // sets the end points of 
    // the last segment to mouse x and y values
    allSegs.get(actSeg).endY = mouseY;

    actSeg++;

    allSegs.get(actSeg-1).calcSelection();

    startSeg = false; // stop drawing lines on mousemoved
    newBar = true;    // next click will start new noteBar

    noteBars.add(new IntList(whichSegs));
    for (int i=0; i<=actBar; i++) {
      println("noteBars "+i+" is "+noteBars.get(i));
    }
    actBar++;
    whichSegs.clear(); // clears the whichSegs IntList so it can 
    // receive a new list of noteSegs for the next noteBar
    drawMode = false;
    endBar = false;
    allTrees.get(noteTree).sidebandData();
  }
}

