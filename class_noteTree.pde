class Notetree {

  int treeID;
  ArrayList<Tremvals> tremOpac; // holds opacity values
  ArrayList<Plotpts> sidebandPts0; // to hold points for the drawing of the fm rep
  ArrayList<Plotpts> sidebandPts1;
  ArrayList<Plotpts> sidebandPts2;
  ArrayList<Plotpts> sidebandPts3;
  int treehandID;
  boolean treeSel; // toggle this on/off if selected/not
  float treeOpac; // opacity value for noteTree
  int treeCol; // colour of tree

  // mod index and harm ratio values for noteTree
  float treeMI = 0;
  float treeHR = 0;

  // Vibrato values for noteTree - these values sent to treeHR & treeMI, though they are mapped to different values
  //float treeVR = 0;
  //float treeVD = 0;

  // Tremolo values for noteTree
  float treeTR = 1;
  float treeTD = 1;

  // values for opacity representation of tremolo
  float treeTRms = treeTR*1000;
  int treeCount = 0;
  float treeTime;
  float tremAng = 0;
  float tremY;

  float treeminX = 999, treeminY = 999; 
  float treemaxX = 0, treemaxY = 0; // boundary of noteTree
  float treecenterX, treecenterY = 0; // center points of boundary, where we'll orient the representation from
  float noise0val = 0.2;

  void start (int _treeID) {

    treeID = _treeID;
    tremOpac = new ArrayList<Tremvals>();
    sidebandPts0 = new ArrayList<Plotpts>();
    sidebandPts1 = new ArrayList<Plotpts>();
    sidebandPts2 = new ArrayList<Plotpts>();
    sidebandPts3 = new ArrayList<Plotpts>();
    treeSel = false; // boolean
    tremData();
  }

  // works out noteTree max and mins - housekeeping stuff for drawing sidebands
  void sidebandData () {

    for (int j = 0; j < noteBars.size (); j++) { // step through every entry in noteBars (lists of segs in each noteTree)

      for (int i = 0; i < noteBars.get (j).size(); i++) { // figuring out the max and min x and y values for the noteTree

        if (treeminX > allSegs.get(noteBars.get(j).get(i)).startX) {
          treeminX = allSegs.get(noteBars.get(j).get(i)).startX; // first X value of noteTree
        }
        if (treemaxX < allSegs.get(noteBars.get(j).get(i)).startX) {
          treemaxX = allSegs.get(noteBars.get(j).get(i)).startX; // first X value of noteTree
        }
        if (treeminY > allSegs.get(noteBars.get(j).get(i)).startY) {
          treeminY = allSegs.get(noteBars.get(j).get(i)).startY; //
        }
        if (treemaxY < allSegs.get(noteBars.get(j).get(i)).startY) {
          treemaxY = allSegs.get(noteBars.get(j).get(i)).startY; //
        }

        if (treeminX > allSegs.get(noteBars.get(j).size()-1).endX) {
          treeminX = allSegs.get(noteBars.get(j).size()-1).endX; // first X value of noteTree
        }
        if (treemaxX < allSegs.get(noteBars.get(j).size()-1).endX) {
          treemaxX = allSegs.get(noteBars.get(j).size()-1).endX; // first X value of noteTree
        }
        if (treeminY > allSegs.get(noteBars.get(j).size()-1).endY) {
          treeminY = allSegs.get(noteBars.get(j).size()-1).endY; //
        }
        if (treemaxY < allSegs.get(noteBars.get(j).size()-1).endY) {
          treemaxY = allSegs.get(noteBars.get(j).size()-1).endY; //
        }
      }
    }
    treecenterX = (((treemaxX - treeminX)*0.5)+treeminX); // working out the center points between tree max and mins
    treecenterY = (((treemaxY - treeminY)*0.5)+treeminY); // the minX and Y have to be added so the center is in the 
    // middle of the max and mins and not counted from the top and left of the window

    plotSideband();
  }

  // plots points used in the fm representation
  void plotSideband () {

    sidebandPts0.clear();
    sidebandPts1.clear();
    sidebandPts2.clear();
    sidebandPts3.clear();

    int q = 0;
    int loopInc = int(map(treeHR, 0, 200, 40, 5)); // mapping this to treeHR
    int randomNess = int(map(treeHR, 0, 200, -30, 30)); // this also

    // map mod depth to sideband width
    // sidebands get wider when MI gets deeper
    // do this by changing the length of the loop that plots sideband points
    
    float loopSt = int(treeminX); // loop start
    float loopEnd = int(treemaxX); // loop end
    float loopLen1 = loopEnd - loopSt; // biggest loop length
    
    // remapping the loop length so it gets narrower as MI gets smaller
    float loopLength = map(treeMI, 0, 1000, loopLen1*0.2, loopLen1); 
    float loopOffset = ((loopLen1-loopLength)*0.5);

    // redrawing the sideband coordinate points as loop size changes
    for (float i = (loopSt+loopOffset); i < (loopLength+loopSt+loopOffset); i+=loopInc) {

      sidebandPts0.add(new Plotpts()); // creating coordinate points
      sidebandPts1.add(new Plotpts());
      sidebandPts2.add(new Plotpts());
      sidebandPts3.add(new Plotpts());

      sidebandPts0.get(q).start(i, treecenterY+map(random(treeMI), 0, 1000, randomNess*-1, randomNess));
      sidebandPts1.get(q).start(i, 15+treecenterY+map(random(treeMI), 0, 1000, randomNess*-1, randomNess));
      sidebandPts2.get(q).start(i, 30+treecenterY+map(random(treeMI), 0, 1000, randomNess*-1, randomNess));
      sidebandPts3.get(q).start(i, 45+treecenterY+map(random(treeMI), 0, 1000, randomNess*-1, randomNess));
      q++;
    }
  }

  // draws sidebands
  void drawSideband () {

    if (treeMI > 0 || treeHR > 0) {
      
      float strokeAdj = map(treeHR, 10, 200, 7, 0.5); // treeHR adjusts rep thickness

      strokeWeight(allSegs.get(numTar).segstrWt*treeTD*0.5*strokeAdj);

      for (int i = 0; i < allSegs.size (); i++) {    
        if (allSegs.get(i).segSelect == true) {
          treeCol = allSegs.get(i).segFill;
        }
      }

      treeOpac = tremOpac.get(treeCount).yAmp; // writes opacity value to sideband
      treeOpac = int(map(treeOpac, -10, 10, 0, 100)); // maps it to appropriate values

      if (treeCol == 100) {
        stroke(treeCol, treeOpac);
      } else {
        stroke(treeCol, 100, 100, treeOpac);
      }
      
      // maps treeHR to 'dottedness' of line
      int noSteps = int(map(treeHR, 0, 200, 15, 1));

      for (int j = 0; j < sidebandPts0.size (); j++) {

        if (j > 2) {

          // draws curves
          
          if (treeHR <= 75) {

            beginShape();
            curveVertex(sidebandPts0.get(j-3).xPt, sidebandPts0.get(j-3).yPt); // control point
            curveVertex(sidebandPts0.get(j-2).xPt, sidebandPts0.get(j-2).yPt); // start point
            curveVertex(sidebandPts0.get(j-1).xPt, sidebandPts0.get(j-1).yPt); // end point
            curveVertex(sidebandPts0.get(j).xPt, sidebandPts0.get(j).yPt); // control point
            endShape();

            if (treeMI > 250) {
              beginShape();
              curveVertex(sidebandPts1.get(j-3).xPt, sidebandPts1.get(j-3).yPt); // control point
              curveVertex(sidebandPts1.get(j-2).xPt, sidebandPts1.get(j-2).yPt); // start point
              curveVertex(sidebandPts1.get(j-1).xPt, sidebandPts1.get(j-1).yPt); // end point
              curveVertex(sidebandPts1.get(j).xPt, sidebandPts1.get(j).yPt); // control point
              endShape();
            }

            if (treeMI > 500) {
              beginShape();
              curveVertex(sidebandPts2.get(j-3).xPt, sidebandPts2.get(j-3).yPt); // control point
              curveVertex(sidebandPts2.get(j-2).xPt, sidebandPts2.get(j-2).yPt); // start point
              curveVertex(sidebandPts2.get(j-1).xPt, sidebandPts2.get(j-1).yPt); // end point
              curveVertex(sidebandPts2.get(j).xPt, sidebandPts2.get(j).yPt); // control point
              endShape();
            }

            if (treeMI > 750) {
              beginShape();
              curveVertex(sidebandPts3.get(j-3).xPt, sidebandPts3.get(j-3).yPt); // control point
              curveVertex(sidebandPts3.get(j-2).xPt, sidebandPts3.get(j-2).yPt); // start point
              curveVertex(sidebandPts3.get(j-1).xPt, sidebandPts3.get(j-1).yPt); // end point
              curveVertex(sidebandPts3.get(j).xPt, sidebandPts3.get(j).yPt); // control point
              endShape();
            }
          }
          
          // draws lines

          if (treeHR > 75 && treeHR < 125) {
            line(sidebandPts0.get(j-1).xPt, sidebandPts0.get(j-1).yPt, sidebandPts0.get(j).xPt, sidebandPts0.get(j).yPt);

            if (treeMI > 250) {
              line(sidebandPts1.get(j-1).xPt, sidebandPts1.get(j-1).yPt, sidebandPts1.get(j).xPt, sidebandPts1.get(j).yPt);
            }

            if (treeMI > 500) {
              line(sidebandPts2.get(j-1).xPt, sidebandPts2.get(j-1).yPt, sidebandPts2.get(j).xPt, sidebandPts2.get(j).yPt);
            }

            if (treeMI > 750) {
              line(sidebandPts3.get(j-1).xPt, sidebandPts3.get(j-1).yPt, sidebandPts3.get(j).xPt, sidebandPts3.get(j).yPt);
            }
          }
          
          // draws dottedlines

          if (treeHR >= 125) {
            dottedLine(sidebandPts0.get(j-1).xPt, sidebandPts0.get(j-1).yPt, sidebandPts0.get(j).xPt, sidebandPts0.get(j).yPt, noSteps);

            if (treeMI > 250) {
              dottedLine(sidebandPts1.get(j-1).xPt, sidebandPts1.get(j-1).yPt, sidebandPts1.get(j).xPt, sidebandPts1.get(j).yPt, noSteps);
            }

            if (treeMI > 500) {
              dottedLine(sidebandPts2.get(j-1).xPt, sidebandPts2.get(j-1).yPt, sidebandPts2.get(j).xPt, sidebandPts2.get(j).yPt, noSteps);
            }

            if (treeMI > 750) {
              dottedLine(sidebandPts3.get(j-1).xPt, sidebandPts3.get(j-1).yPt, sidebandPts3.get(j).xPt, sidebandPts3.get(j).yPt, noSteps);
            }
          }
        }
      }
    }
  }

// writes tremolo data based on tremolo values to array so it can be accessed for representation
  void tremData () {

    tremOpac.clear();
    tremAng = 0;

    int slotNo = 0;

    for (int xTrem = 0; xTrem < treeTRms; xTrem +=10) { // increment was 10 - this value should be 
                                                        // matched with the logic check in treeTimer();

      if (tremAng < 360) {

        float tremRad = radians(tremAng); // every time angle hits 360 that's a full cycle
        tremY = sin(tremRad)*treeTD;

        tremOpac.add(new Tremvals()); // this is writing values to the array to control 
                                       // variance of tremolo opacity
        tremOpac.get(slotNo).start(xTrem, tremY);

        // TUNING TREMOLO VISUAL
        tremAng += 18*treeTR; // alter this numeral here to make tremolo vis faster or slower
        slotNo++;
      } else {
        break;
      }
    }
  }

  // a timer to control opacity change over time
  void treeTimer () {

    if ((millis() - treeTime) > 10) { // match the'10' value here with whatever increment is decided on for calculating the tremolo sine wave

      treeTime = millis();
      treeCount++;

      if (editTrem == false) {

        if (treeCount == tremOpac.size()) { // This controls loop point of tremolo - don't write another 0 value to the last slot of this ArrayList, stop at 350deg
          treeCount = 0;
        }
      } else {

        if (treeCount >= tremOpac.size()*0.75) { // When the handle was being moved I was getting mismatches in the length of this array
          // When the handle moved to a new position and the increment changed such that there were more slots in the array
          // I got an index read error when trying to read an opacity value from a slot that didn't exist
          // This resets the loop through the opacity values so it doesn't overflow
          treeCount = 0;
        }
      }
    }
  }
}






// class for tremolo values
class Tremvals {


  float xTime;
  float yAmp;

  void start (float _xTime, float _yAmp) {

    xTime = _xTime;
    yAmp = _yAmp;
  }
}

