void keyPressed() {

  if (key == ' ') {

    // toggles play head draw state
    if (phAct == false) {
      phAct = true;
      println("PLAY");
    } else {

      playStop();
    }
  }

  if (key == 'p' || key == 'P') { // for printing out stuff I'm testing

    println("drawMode = "+drawMode);
    println("newBar = "+newBar);
    println("startSeg = "+startSeg);
    println("endBar = "+endBar);
    println("numTar = "+numTar);
    println("haveTarget = "+haveTarget);
  }

  if (key == 'a' || key == 'A') { // further logic resets
    drawMode = false;
    startSeg = false;
    endBar = false;
    newBar = true;

    println("drawMode = "+drawMode);
    println("newBar = "+newBar);
    println("startSeg = "+startSeg);
    println("endBar = "+endBar);

    //println("key aA working");

    for (int i = 0; i < allSegs.size (); i++) {
      allSegs.get(i).segSelect = false;
    }

    for (int i = 0; i < allTrees.size (); i++) {
      allTrees.get(i).treeSel = false;
    }
  }

  if (key == 'v' || key == 'V') { // edit vibrato
    if (editVib == false) {
      editVib = true; // vibrato
      editTrem = false; // set others to false
      editFM = false;
      freeHand = false;
      drawMode = false;
    } else {
      editVib = false;
      drawMode = true;
    }
    println("editVib = "+editVib);
  }

  if (key == 't' || key == 'T') { // edit tremolo
    if (editTrem == false) {
      editTrem = true; // tremolo
      editVib = false; // set others to false
      editFM = false;
      freeHand = false;
      drawMode = false;
    } else {
      editTrem = false;
      drawMode = true;
    }
    println("editTrem = "+editTrem);
  }

  if (key == 'm' || key == 'M') { // edit synth parameters that render sideBand representations
    if (editFM == false) {
      editFM = true; // fm synth params
      editTrem = false; // set others to false
      editVib = false;
      freeHand = false;
      drawMode = false;
    } else {
      editFM = false;
      drawMode = true;
    }
    println("editFM = "+editFM);
  }

  if (key == 'f' || key == 'F') { // control whether we're in freeHand mode
    if (freeHand == false) {
      freeHand = true;
      editTrem = false; // set others to false
      editVib = false;
      editFM = false;
    } else {
      freeHand = false;
    }
    println("freeHand is "+freeHand);
  }

  if (key == 'd' || key == 'D') { // clears & resets everything
    resetAll();
    println("RESET");
  }

  if (key == 's' || key == 'S') { 
    if (drawMode == true) {// changes noteSeg from a line to a curve
      if (allSegs.get(actSeg).type == true) {
        allSegs.get(actSeg).type = false;
        allSegs.get(actSeg).plotPoints.clear();
        allSegs.get(actSeg).endX = mouseX;
        allSegs.get(actSeg).endY = mouseY;
        allSegs.get(actSeg).curveVars();
        allSegs.get(actSeg).plotCurve();
      } else {
        allSegs.get(actSeg).plotPoints.clear();
        allSegs.get(actSeg).type = true;
        allSegs.get(actSeg).endX = mouseX;
        allSegs.get(actSeg).endY = mouseY;
        allSegs.get(actSeg).plotLine();
      }
    } else { // this would mean that we're selecting things
      if (allSegs.get(numTar).type == true) {
        allSegs.get(numTar).type = false;
        allSegs.get(numTar).plotPoints.clear();
        allSegs.get(numTar).curveVars();
        allSegs.get(numTar).plotCurve();
      } else {
        allSegs.get(numTar).plotPoints.clear();
        allSegs.get(numTar).type = true;
        allSegs.get(numTar).plotLine();
      }
    }
  }

  if (keyCode == SHIFT) {

    endBar = true;
    println("endBar is "+endBar);
  }

  if (keyCode == CONTROL) {
    // use this to draw flat horizontal lines
    flatY = true;
    //println("CTRL - "+flatY);
  }
}



void keyReleased() {

  if (keyCode == SHIFT) { // hold SHIFT and click to end a noteBar

    endBar = false;
    println("endBar is "+endBar);
  }

  if (keyCode == CONTROL) {
    // use this to draw flat horizontal lines
    flatY = false;
    //println("CTRL - "+flatY);
  }

  if (keyCode == UP) { // increment noteTree

    notetreeInc();

    if (noteTree >= allTrees.size()) {
      allTrees.add(new Notetree()); // create a new Notetree
      allTrees.get(noteTree).start(noteTree);
    }
  }

  if (keyCode == DOWN) { // decrement noteTree

    notetreeDec();
  }
}

