void playHead() {

  // Draw the playHead
  strokeWeight(5);
  stroke(100);
  line(phXpos, 0, phXpos, height);
}

void setSpeed() { // to implement ffwding or rwding 

  pixperSec = width/phDur; // work out speed of playhead

  phSpeed = pixperSec*0.04; // need to calc speed at split second 
                            // rate
}

void resetAll () {

  // playHead variables
  phAct = false; // playHead Active state
  //phDur = 10; // Duration value for playHead
  phSpeed = 0; // speed of playHead
  phXpos = 0; // x position of playHead 
  pixperSec = 0; // no. of pixels the playHead moves per second

  // holding variables for node matching
  ptX = 0;
  ptY = 0;
  nodeMatchS = false;
  nodeMatchE = false;
  checkNodes = 0; // to control the size of the loop that checks nodes

  pixperSec = width/phDur; // work out speed of playhead
  phSpeed = pixperSec*0.04;

  // clear all ArrayLists and IntLists
  noteBars.clear();
  whichSegs.clear();
  allSegs.clear();
  allTrees.clear();

  noteTree = 0; // reset noteTree
  actTree = true; // boolean to control initiation of handle
  nonoteTrees = 0;

  // variable to iterate through allSegs instances
  actSeg = 0; //which noteSeg is currently active?

  // variable to iterate through noteBars
  actBar = 0;
  newBar = true;

  // number of target seg
  haveTarget = false;
  numTar = 0;

  // boolean values to control if we're drawing segs under mouseMoved
  startSeg = false;

  // using this with keyPressed & keyReleased to set up a toggle
  // to control the ending of a noteBar
  endBar = false;

  //variable to toggle on/off the drawing of straight horizontal lines
  flatY = false;

  // colour variable
  colF = 100;
  barCol = 100; // controls colour of noteBar

  // boolean to stop running of the tremolo opacity array if the array values are being recalculated
  tremCalc = false;

  // boolean to control freeHand drawing
  freeHand = false;

  //booleans for direct control of synth parameters
  editFM = false; // fm synth params
  editVib = false; // vibrato
  editTrem = false; // tremolo
  drawingVib = false; // flipping between drawing sideband and vibrato

  allTrees.add(new Notetree()); // need to create the first noteTree
  allTrees.get(noteTree).start(noteTree);
}


// method for the drawing of a dotted line between two points
void dottedLine(float x1, float y1, float x2, float y2, float steps) {

  for (int i=0; i<=steps; i++) {

    float x = lerp(x1, x2, i/steps);
    float y = lerp(y1, y2, i/steps);
    // could set up an array here to hold x y points then draw lines between them

    point(x, y);
  }
}

// variation on a dotted line

void dottedLine2(float x1, float y1, float x2, float y2, float steps) {
  float lstX = 0;
  float lstY = 0;

  for (int i=0; i<=steps; i++) {

    float x = lerp(x1, x2, i/steps);
    float y = lerp(y1, y2, i/steps);

    if (i>0 && i%2 == 0) {

      line(x, y, lstX, lstY);
    }
    lstX = x;
    lstY = y;
  }
}

// method for the drawing of target boxes around selected items
void targetBoxes () {

  strokeWeight(1);
  if (haveTarget == true) {
    if (allSegs.get(numTar).segFill == 100) {
      stroke(100);
    } else {
      stroke(allSegs.get(numTar).segFill, 100, 100);
    }
  } else {
    stroke(0, 100, 100);
  }
  fill(50, 10); // fill for range box
  rectMode(CENTER);
  rect(mouseX, mouseY, range*2, range*2); // range box

  noStroke();
  fill(50, 50);
  rect(mouseX, mouseY, width*2, range);
  rect(mouseX, mouseY, range, height*2);
}

// method to increment noteTree number
void notetreeInc () {

  noteTree++;
  if (noteTree >= allTrees.size()) {
    barCol = colInc*noteTree;
    actTree = true;
  }
}

// to decrement noteTree
void notetreeDec () {

  if (noteTree > 0) {
    noteTree--;
    barCol = colInc*noteTree;
    println("noteTree = "+noteTree);
  } else { // if user tries to decrement below 0
    println("You've gone as low as you can go noteTree-wise, partner");
  }
}

// method to stop playback
void playStop() {

  phAct = false;
  println("STOP");
  phXpos = 0;
  for (int m=0; m<allSegs.size (); m++) { // also reset all noteSegs sendMsg to false
    allSegs.get(m).sendMsg = false;
  }

  // When we stop playback we need to
  // send 0 values to all active noteSegs to stop Max 
  // making noise

    // Send a message we can look for in Max
  OscMessage myMessage1 = new OscMessage("PLAYSTOP");                             
  // start ramp point
  myMessage1.add(0);               
  // end ramp point
  myMessage1.add(0);                 
  // over duration 10 ms
  myMessage1.add(10);                                     
  // Send the message
  oscP5.send(myMessage1, myRemoteLocation);
}

// method to draw synthesis parameter values to the score space
void drawInfo () {
  textSize(16);
  fill(100);

  if (freeHand == true) {
    text("freeHand", 10, height-15);
  }

  if (editVib == true) {
    float treeMIval, treeHRval;

    if (allSegs.size() == 0) {
      treeMIval = 0;
      treeHRval = 0;
    } else if (numTar != 500) {
      treeMIval = allTrees.get(allSegs.get(numTar).treeNo).treeMI;
      treeHRval = allTrees.get(allSegs.get(numTar).treeNo).treeHR;
    } else {
      treeMIval = 0;
      treeHRval = 0;
    }

    text("Vibrato", 10, height-15);
    String vd = nf(treeMIval, 2, 2);
    text("VibDpth = "+vd, 240, height-15);
    String vr = nf(treeHRval, 2, 2);
    text("VibRate = "+vr, 80, height-15);
  }

  if (editFM == true) {
    float treeMIval, treeHRval;

    if (allSegs.size() == 0) {
      treeMIval = 0;
      treeHRval = 0;
    } else if (numTar != 500) {
      treeMIval = allTrees.get(allSegs.get(numTar).treeNo).treeMI;
      treeHRval = allTrees.get(allSegs.get(numTar).treeNo).treeHR;
    } else {
      treeMIval = 0;
      treeHRval = 0;
    }

    text("fmSynth", 10, height-15);
    String vd = nf(treeMIval, 2, 2);
    text("M.I. = "+vd, 240, height-15);
    String vr = nf(treeHRval, 2, 2);
    text("H.R. = "+vr, 80, height-15);
  }

  if (editTrem == true) {
    float treeTDval, treeTRval;

    if (allSegs.size() == 0) {
      treeTDval = 0;
      treeTRval = 0;
    } else if (numTar != 500) {
      treeTDval = allTrees.get(allSegs.get(numTar).treeNo).treeTD;
      treeTRval = allTrees.get(allSegs.get(numTar).treeNo).treeTR;
    } else {
      treeTDval = 0;
      treeTRval = 0;
    }

    text("Tremolo", 10, height-15);
    String vd = nf(treeTDval, 2, 2);
    text("TremDpth = "+vd, 240, height-15);
    String vr = nf(treeTRval, 2, 2);
    text("TremRate = "+vr, 80, height-15);
  }

  text(noteTree, width-40, height-15);
}

// implemented to push osc to Max if Max drops the connection
void refreshOsc () {

  oscP5 = new OscP5(this, 7400); // initialising oscP5 variable  
  myRemoteLocation = new NetAddress("127.0.0.1", 7400); 


}

