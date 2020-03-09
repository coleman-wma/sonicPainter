void selectStuff () { 
  if (drawMode == false) { 

    for (int i = 0; i < allSegs.size (); i++) {

      allSegs.get(i).segSelect = false;
    }

    for (int i = 0; i < allTrees.size (); i++) {

      allTrees.get(i).treeSel = false; // resetting all tree select values to false
    }

    /*
      SELECTING USING PLOTPOINTS
     first we run a loop that looks for all plotPoints
     If plotpoints are in range, select that seg
     */

    for (int j=0; j<allSegs.size (); j++) {
      for (int k=0; k<allSegs.get (j).plotPoints.size(); k++) {
        if (mouseX > (allSegs.get(j).plotPoints.get(k).xPt-lineRange) && mouseX < (allSegs.get(j).plotPoints.get(k).xPt+lineRange) && 
          mouseY > (allSegs.get(j).plotPoints.get(k).yPt-lineRange) && mouseY < (allSegs.get(j).plotPoints.get(k).yPt+lineRange)) {
          haveTarget = true;
          numTar = j;
          allSegs.get(j).segSelect = true;
          allTrees.get(allSegs.get(j).treeNo).treeSel = true;
          allTrees.get(allSegs.get(j).treeNo).sidebandData(); // run the data for sideband representation
          break;
        } else {
          allSegs.get(j).segSelect = false;
          haveTarget = false;
          numTar = 500;
        }
      }
      if (allSegs.get(j).segSelect == true) {
        break;
      }
    }

    /*
    SELECTING USING TIMBRE VISUALISATIONS
     Run loops that check the timbre visualisations of the vibrato and fm
     Clicking and draggin on these representations should edit those representations
     */

    /* VIBRATO */

    if (haveTarget == false) {

      for (int i = 0; i < allSegs.size (); i++) { // Check all vibrato points, select the tree clicked on

        for (int e = 0; e < allSegs.get (i).vibPoints.size(); e++) {

          if (mouseX > (allSegs.get(i).vibPoints.get(e).xPt-lineRange) && mouseX < (allSegs.get(i).vibPoints.get(e).xPt+lineRange) && 
            mouseY > (allSegs.get(i).vibPoints.get(e).yPt-lineRange) && mouseY < (allSegs.get(i).vibPoints.get(e).yPt+lineRange)) {
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
    }

    /* FM SYNTH */

    if (haveTarget == false) {

      for (int i = 0; i < allTrees.size (); i++) {

        for (int e = 0; e < allTrees.get (i).sidebandPts0.size(); e++) {

          if ((mouseX > (allTrees.get(i).sidebandPts0.get(e).xPt-lineRange) && mouseX < (allTrees.get(i).sidebandPts0.get(e).xPt+lineRange) && 
            mouseY > (allTrees.get(i).sidebandPts0.get(e).yPt-lineRange) && mouseY < (allTrees.get(i).sidebandPts0.get(e).yPt+lineRange)) ||
            (mouseX > (allTrees.get(i).sidebandPts1.get(e).xPt-lineRange) && mouseX < (allTrees.get(i).sidebandPts1.get(e).xPt+lineRange) && 
            mouseY > (allTrees.get(i).sidebandPts1.get(e).yPt-lineRange) && mouseY < (allTrees.get(i).sidebandPts1.get(e).yPt+lineRange)) ||
            (mouseX > (allTrees.get(i).sidebandPts2.get(e).xPt-lineRange) && mouseX < (allTrees.get(i).sidebandPts2.get(e).xPt+lineRange) && 
            mouseY > (allTrees.get(i).sidebandPts2.get(e).yPt-lineRange) && mouseY < (allTrees.get(i).sidebandPts2.get(e).yPt+lineRange)) ||
            (mouseX > (allTrees.get(i).sidebandPts3.get(e).xPt-lineRange) && mouseX < (allTrees.get(i).sidebandPts3.get(e).xPt+lineRange) && 
            mouseY > (allTrees.get(i).sidebandPts3.get(e).yPt-lineRange) && mouseY < (allTrees.get(i).sidebandPts3.get(e).yPt+lineRange))) {

            haveTarget = true;
            editFM = true;
            editVib = false;
            editTrem = false;

            for (int s = 0; s < allSegs.size (); s++) { // Clear all vibPoints arrays

              allSegs.get(s).vibPoints.clear();
            }
            
            numTar = allSegs.get(noteBars.get(i).get(0)).notesegID;  // target seg is first seg of this noteTree
            allSegs.get(noteBars.get(i).get(0)).segSelect = true;    // select the first noteSeg of this noteTree
            allTrees.get(i).treeSel = true;
            break;
          } else {
          }
        }
        if (allTrees.get(i).treeSel == true) {
          break;
        }
      }
    }
  }
}

void selectforDrag () {

  if (drawMode == false) { 

    for (int i = 0; i < allSegs.size (); i++) {

      allSegs.get(i).segSelect = false;
    }

    for (int i = 0; i < allTrees.size (); i++) {

      allTrees.get(i).treeSel = false; // resetting all tree select values to false
    }

    for (int j=0; j<allSegs.size (); j++) {
      for (int k=0; k<allSegs.get (j).plotPoints.size(); k++) {
        if (mouseX > (allSegs.get(j).plotPoints.get(k).xPt-lineRange) && mouseX < (allSegs.get(j).plotPoints.get(k).xPt+lineRange) && 
          mouseY > (allSegs.get(j).plotPoints.get(k).yPt-lineRange) && mouseY < (allSegs.get(j).plotPoints.get(k).yPt+lineRange)) {
          haveTarget = true;
          numTar = j;
          allSegs.get(j).segSelect = true;
          allTrees.get(allSegs.get(j).treeNo).treeSel = true;
          //println("allSegs.get("+j+").segSelect is "+allSegs.get(j).segSelect);
          //println("allTrees.get("+allSegs.get(j).treeNo+").treeSel is "+allTrees.get(allSegs.get(j).treeNo).treeSel);            
          break;
        }
      }
    }
  } else {
    println("You havenae clicked on anything you silly cabbage!!!");
  }
}
