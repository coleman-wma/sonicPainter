void mousePressed() {

  resetNodebooleans(); // resets node booleans that signify if they've been clicked or not

  if (allSegs.size() > 0) { // if there's something drawn
    if (editVib == true || editTrem == true || editFM == true) { // and you're editing any of these effects...
      selectforDrag(); // selects tree at initial point and keeps it selected as drag continues

      initX = mouseX;
      initY = mouseY;
    }
  }

  if (editVib == false && editTrem == false && editFM == false && freeHand == false) {
    selectStuff(); // have you clicked on a noteSeg?
    checkingNodes(); // have you clicked on a node between two noteSegs?

    // If you haven't clicked on anything, then you must have clicked on open space, so you want to start a noteTree
    if (haveTarget == false && drawMode == false) { // this is set to false when you tie off a noteTree
      drawMode = true; // so set this to true
      newbarTrue(); // and run this
    } else if (drawMode == true && endBar == false) { // if this is true then you've drawn the first part of the noteTree
      midnoteBar();         // so you're continuing to draw the noteTree
    } else if (drawMode == true && endBar == true) { // if you're holding SHIFT down you want to end the noteTree
      endbarTrue();         // so you run this
    }
  }
}

void mouseMoved() {
  if (startSeg == true && mouseX > allSegs.get(actSeg).startX) {
    if (allSegs.get(actSeg).type == true) {
      allSegs.get(actSeg).plotLine();
      if (flatY == false) {
        allSegs.get(actSeg).endX = mouseX;
        allSegs.get(actSeg).endY = mouseY;
      } else {
        allSegs.get(actSeg).endX = mouseX;
        allSegs.get(actSeg).endY = allSegs.get(actSeg).startY;
      }
    } else {
      allSegs.get(actSeg).plotPoints.clear();
      allSegs.get(actSeg).endX = mouseX;
      allSegs.get(actSeg).endY = mouseY;
      allSegs.get(actSeg).curveVars();
      allSegs.get(actSeg).plotCurve();
    }
  }
}

void mouseDragged() {

  if (freeHand == true) {

    freeHand();
  }

  int thisTar = numTar;

  // below contains mappings for changing synth parameters
  // use the keys 'v', 't' and 'm' to select which parameter set you want to change
  // then click on a noteSeg to edit its parameters.

  if (editVib == true) {

    for (int i = 0; i < allSegs.size (); i++) { // Check all vibrato points, select the tree clicked on

      for (int e = 0; e < allSegs.get (i).vibPoints.size(); e++) {

        if (initX > (allSegs.get(i).vibPoints.get(e).xPt-lineRange) && initX < (allSegs.get(i).vibPoints.get(e).xPt+lineRange) && 
          initY > (allSegs.get(i).vibPoints.get(e).yPt-lineRange) && initY < (allSegs.get(i).vibPoints.get(e).yPt+lineRange)) {
          haveTarget = true;
          editVib = true;
          editFM = false;
          editTrem = false;
          numTar = i;
          allSegs.get(i).segSelect = true;
          allTrees.get(allSegs.get(i).treeNo).treeSel = true;
          break;
        }
      }
      if (allSegs.get(i).segSelect == true) {
        break;
      }
    }

    if (numTar != 500 && editVib == true && allTrees.get(allSegs.get(thisTar).treeNo).treeSel == true) {

      for (int i = 0; i < allSegs.size (); i++) { 
        if (allTrees.get(allSegs.get(thisTar).treeNo).treeID == allSegs.get(i).treeNo) { // reset all the plotted vibPoints for the noteTree being edited
          allSegs.get(i).vibPoints.clear();
          allSegs.get(i).plotVib();
        }
      }

      float vibratePlus = map(mouseX, 0, width, 0, maxvibRate); // the amount to increment the parameter is...


      allTrees.get(allSegs.get(numTar).treeNo).treeHR = vibratePlus;

      for (int i = 0; i < allSegs.size (); i++) { // check segs, if they're part of the same noteTree as the numTar seg, change their values
        if (allSegs.get(i).treeNo == allSegs.get(numTar).treeNo) {

          allSegs.get(i).segHR = allTrees.get(allSegs.get(numTar).treeNo).treeHR;
        }
      }

      if (phAct == true) { // any changes, send a msg to Max
        OscMessage myMessage2 = new OscMessage("SYNTHMSG");
        myMessage2.add(allSegs.get(numTar).treeNo);
        myMessage2.add(allSegs.get(numTar).segHR);
        myMessage2.add(allSegs.get(numTar).segMI);
        oscP5.send(myMessage2, myRemoteLocation);
      }



      float vibdpthPlus = map(mouseY, 0, height, 0, maxvibDpth); // the amount to increment the parameter is...

      allTrees.get(allSegs.get(numTar).treeNo).treeMI = vibdpthPlus;

      for (int i = 0; i < allSegs.size (); i++) { // check segs, if they're part of the same noteTree as the numTar seg, change their values
        if (allSegs.get(i).treeNo == allSegs.get(numTar).treeNo) {

          allSegs.get(i).segMI = allTrees.get(allSegs.get(numTar).treeNo).treeMI;
        }
      }

      if (phAct == true) { // any changes, send a msg to Max
        OscMessage myMessage2 = new OscMessage("SYNTHMSG");
        myMessage2.add(allSegs.get(numTar).treeNo);
        myMessage2.add(allSegs.get(numTar).segHR);
        myMessage2.add(allSegs.get(numTar).segMI);
        oscP5.send(myMessage2, myRemoteLocation);
      }
    } else {
      println("You MISSED, ye pleic!!!");
    }
  }

  if (editTrem == true) {

    for (int j=0; j<allSegs.size (); j++) {
      for (int k=0; k<allSegs.get (j).plotPoints.size(); k++) {
        if (initX > (allSegs.get(j).plotPoints.get(k).xPt-lineRange) && initX < (allSegs.get(j).plotPoints.get(k).xPt+lineRange) && 
          initY > (allSegs.get(j).plotPoints.get(k).yPt-lineRange) && initY < (allSegs.get(j).plotPoints.get(k).yPt+lineRange)) {
          haveTarget = true;
          numTar = j;
          editVib = false;
          editFM = false;
          allSegs.get(j).segSelect = true;
          allTrees.get(allSegs.get(j).treeNo).treeSel = true;         
          break;
        }
      }
    }

    if (numTar != 500 && editTrem == true && allTrees.get(allSegs.get(thisTar).treeNo).treeSel == true) {

      float tremratePlus = map(mouseX, 0, width, 0, maxtremRate); // the amount to increment the parameter is...

      allTrees.get(allSegs.get(numTar).treeNo).treeTR = tremratePlus; // write the mapped value to the synth parameter

      for (int i = 0; i < allSegs.size (); i++) { // check segs, if they belong to this noteTree, change values
        if (allSegs.get(i).treeNo == allSegs.get(numTar).treeNo) {
          allSegs.get(i).segTR = allTrees.get(allSegs.get(numTar).treeNo).treeTR;
        }
      }

      float tremdpthPlus = map(mouseY, 0, height, 0, maxtremDpth); // the amount to increment the parameter is...

      allTrees.get(allSegs.get(numTar).treeNo).treeTD = tremdpthPlus; // write the mapped value to the synth parameter

      for (int i = 0; i < allSegs.size (); i++) {  // check segs, if they belong to this noteTree, change values
        if (allSegs.get(i).treeNo == allSegs.get(numTar).treeNo) {

          allSegs.get(i).segTD = allTrees.get(allSegs.get(numTar).treeNo).treeTD;
        }
      }

      allTrees.get(allSegs.get(numTar).treeNo).tremData();

      if (phAct == true) { // any changes, send a msg to Max
        OscMessage myMessage2 = new OscMessage("TREM");
        myMessage2.add(allSegs.get(numTar).treeNo);
        myMessage2.add(allSegs.get(numTar).segTR);
        myMessage2.add(allSegs.get(numTar).segTD);
        oscP5.send(myMessage2, myRemoteLocation);
      }
    } else {
      println("Ye clicked on NOTHING laddie!");
    }
  }


  if (editFM == true) {

    for (int s = 0; s < allSegs.size (); s++) { // Clear all vibPoints arrays

      allSegs.get(s).vibPoints.clear();
    }

    editVib = false;
    editTrem = false;

    if (numTar != 500 && editFM == true && allTrees.get(allSegs.get(thisTar).treeNo).treeSel == true) {

      float harmratePlus = map(mouseX, 0, width, 0, maxHR); // the amount to increment the parameter is...

      allTrees.get(allSegs.get(numTar).treeNo).treeHR = harmratePlus;

      for (int i = 0; i < allSegs.size (); i++) { // check segs, if they belong to this noteTree, select them
        if (allSegs.get(i).treeNo == allSegs.get(numTar).treeNo) {

          allSegs.get(i).segHR = allTrees.get(allSegs.get(numTar).treeNo).treeHR; // write parameter to noteTree
        }
      }

      float modindPlus = map(mouseY, 0, height, 0, maxMI); // the amount to increment the parameter is...

      allTrees.get(allSegs.get(numTar).treeNo).treeMI = modindPlus;

      for (int i = 0; i < allSegs.size (); i++) { // check segs, if they belong to this noteTree, select them
        if (allSegs.get(i).treeNo == allSegs.get(numTar).treeNo) {

          allSegs.get(i).segMI = allTrees.get(allSegs.get(numTar).treeNo).treeMI; // write parameter to noteTree
        }
      }

      if (phAct == true) { // any changes, send a msg to Max
        OscMessage myMessage2 = new OscMessage("SYNTHMSG");
        myMessage2.add(allSegs.get(numTar).treeNo);
        myMessage2.add(allSegs.get(numTar).segHR);
        myMessage2.add(allSegs.get(numTar).segMI);
        oscP5.send(myMessage2, myRemoteLocation);
      }
    } else {
      println("Your aim is SHITE man!!");
    }
  }



  if (moveNodes == true) {

    editVib = false;
    editTrem = false;
    editFM = false;

    for (int k=0; k<allSegs.size (); k++) {

      // Also check for true startNode and endNode values
      if (allSegs.get(k).startNode == true) {
        allSegs.get(k).startX = mouseX;
        allSegs.get(k).startY = mouseY;
        allSegs.get(k).calcSelection();
        if (allSegs.get(k).type == false) {
          allSegs.get(k).calcSelection(); // need these?
          allSegs.get(k).curveVars();
          allSegs.get(k).plotCurve();
          allSegs.get(k).display();
          // then send msg to Max
        } else {
          allSegs.get(k).calcSelection(); // need these?
          allSegs.get(k).plotLine();
          allSegs.get(k).display();
          // then send msg to Max
        }
      } 

      if (allSegs.get(k).endNode == true) {
        allSegs.get(k).endX = mouseX;
        allSegs.get(k).endY = mouseY;
        allSegs.get(k).calcSelection();
        if (allSegs.get(k).type == false) {
          allSegs.get(k).calcSelection(); // need these?
          allSegs.get(k).curveVars();
          allSegs.get(k).plotCurve();
          allSegs.get(k).display();
          // then send msg to Max
        } else {
          allSegs.get(k).calcSelection(); // need these?
          allSegs.get(k).plotLine();
          allSegs.get(k).display();
          // then send msg to Max
        }
      }
    }
  }
}

void mouseReleased() {

  if (moveNodes == true) {
    for (int i = 0; i < allSegs.size (); i++) {
      allSegs.get(i).startNode = false;
      allSegs.get(i).endNode = false;
    }
    moveNodes = false;
  }

  if (freeHand == true) {
    endfreeHand();
  }

  if (editVib == true) {
    editVib = false;
  }

  if (editFM == true) {
    editFM = false;
  }

  if (editTrem == true) {
    editTrem = false;
  }

  if (haveTarget == true) {
    haveTarget = false;
  }

  initX = 0;
  initY = 0;
  nowX = 0;
  nowY = 0;
}

