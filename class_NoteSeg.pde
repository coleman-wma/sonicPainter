class NoteSeg {
  
  // GLOBAL VARIABLES //

  // first, x & y co-ords for start and end points
  int startX = 0;
  int startY = 0;
  int endX = 0;
  int endY = 0;

  float y; // for drawing fx representations
  float lastX, lastY = -999;
  float opac; // opacity

  // selection bounding box testing
  int minX, maxX, minY, maxY;

  // noteSeg selection
  boolean inRange = false;
  boolean segSelect = false;

  // parameters for drawing curves
  ArrayList<Plotpts> plotPoints; // Array to hold point which can be used for direct selection
  ArrayList<Plotpts> vibPoints; // Array for points that plot the vibrato rep sine curve
  float amp; // variance about zero point
  float offAdj; // offAdj = amp - startY
  float inc; // inc = PI/xDiff
  float a; // either PI or 0 depending on whether we have a rising or falling wave
  // this then gets incremented in the loop that plots the curve points - a = a + inc;
  int yDiff; // difference between start and end y points of noteSeg
  int xDiff; // difference between start and end x points of wave
  int startL, endL; // loop to draw curve start and end points

  // draw a line or a curve?
  boolean type = true; // if true then line, if false then curve
  int nonoteBar = actBar; // what noteBar is this seg a part of?
  int segFill = barCol; // colour of noteSeg
  boolean sendMsg = false; // used to control messaging
  int treeNo = noteTree; // what noteTree is this seg a part of?
  int notesegID; // number to identify the noteSeg
  //float segDur; // duration of seg, calculated when sending messages to Max

  // mod index and harm ratio values for noteSeg
  float segMI = 0;
  float segHR = 0;

  // Tremolo values for noteSeg
  float segTR = 1;
  float segTD = 1;

  // strokeWeight value to represent change in volume
  float segstrWt = 3;

  // node detection
  boolean startNode = false;
  boolean endNode = false;




  // CONSTRUCTOR //
  
  // declaring variables for the class to hold x & y co-ords and 
  // control points for beziers
  void start(int _notesegID, int _startX, int _startY, int _endX, int _endY, 
  boolean _type, int _nonoteBar, int _segFill, boolean _sendMsg, 
  int _treeNo, float _segMI, float _segHR) {

    notesegID = _notesegID;
    startX = _startX;
    startY = _startY;
    endX = _endX;
    endY = _endY;
    plotPoints = new ArrayList<Plotpts>();
    vibPoints = new ArrayList<Plotpts>();
    type = _type;
    nonoteBar = _nonoteBar;
    segFill = _segFill;
    sendMsg = _sendMsg;
    treeNo = _treeNo;
    segMI = _segMI;
    segHR = _segHR;

    if (type == true) { // if this seg is a line
      allSegs.get(actSeg).plotLine(); // calculate plots of line for selection purposes
    } else {
      allSegs.get(actSeg).curveVars(); // calculate curve variables
      allSegs.get(actSeg).plotCurve(); // plot points of curve
    }
  }



  // FUNCTIONS //

  void display () {
    strokeWeight(segstrWt*segTD*0.5);
    noFill();

    // getting the opacity value of the noteTrees current count
    opac = allTrees.get(treeNo).tremOpac.get(allTrees.get(treeNo).treeCount).yAmp; 
    // this controls the opacity
    opac = int(map(opac, -10, 10, 0, 100)); // mapping appropriate opacity values from effect params
    // opacity works for the whole noteTree

    if (segFill == 100) { // colour of seg stroke
      stroke(segFill, opac);
    } else {
      stroke(segFill, 100, 100, opac);
    }

    if (type == true) { // if this is true then draw a line
      line(startX, startY, endX, endY);
    } else { // if not then draw a curve
      drawCurve();
    }
    strokeWeight(1);

    stroke(100, 100, 100); // stroke for node circle - red
    noFill();
    ellipse(startX, startY, 10, 10); // draws circles at node start
    ellipse(endX, endY, 10, 10); // and end points

    // toggles drawing of vibrato representation
    if (numTar != 500 && segHR < 10 && segHR > 0 && segMI < 200 && segMI > 0 && allTrees.get(allSegs.get(numTar).treeNo).treeSel == true) {
      drawVib();
      drawingVib = true;
    } else {
      drawingVib = false;
    }
  }

  // plots points along a noteSeg line, stores them in an array
  void plotLine () {

    plotPoints.clear();

    yDiff = endY-startY; // difference between y points
    xDiff = endX-startX; // difference between x points

    float slope = (float(yDiff)/float(xDiff))*-1;

    if (xDiff < 0) { // if this is negative

      startL = endX; // plot curve for loop needs to start at the lower number
      endL = startX; // and end at the higher
    } else { // means xDiff > 0

      startL = startX; // plot curve for loop needs to start at the lower number
      endL = endX; // and end at the higher
    }

    // line formula: y - y1 = slope(x - x1)
    // where (x1, y1) are the starting coordinate points
    // so, y = slope(x - x1) + y1
    // or, endY = slope(endX - startX) + startY
    /*
    endY = slope*endX - slope*startX + startY
     */
    // solve this for various increments of x

    if (dist(startX, startY, endX, endY) > 30) { // if the distance between the start and the 
                                                 // end of the line is > 30 pixels
                                                 // plots lots of waypoints - this is so freehand 
                                                 // mode doesn't waste time drawing needless 
                                                 // points
                                                 
      int n = 0; // to index slot points in array

      for (int j = startL; j < endL; j+=10) {

        plotPoints.add(new Plotpts());

        plotPoints.get(n).start(float(j), ((slope*(endX - j)) + startY + yDiff));

        n++;
      }
    } else { // if the distance between start and end is less than 30 pixels, 
             // just use the start and end points as plotpoints

      plotPoints.add(new Plotpts());

      plotPoints.get(0).start(startX, startY);

      plotPoints.add(new Plotpts());

      plotPoints.get(1).start(endX, endY);
    }
  }

  // steps through the plotted vibrato rep points and connects them with lines
  void drawVib () {

    strokeWeight(segstrWt*segTD*0.25);

    if (segFill == 100) {
      stroke(segFill, opac); // colour & opacity of FX object
    } else {
      stroke(segFill, 100, 100, opac);
    }

    for (int j = 0; j < vibPoints.size (); j++) {

      if (j > 0) {

        line(vibPoints.get(j-1).xPt, vibPoints.get(j-1).yPt, vibPoints.get(j).xPt, vibPoints.get(j).yPt);
      }
    }
  }

  // plotting vibrato rep points and slotting them in an array
  void plotVib () {

    yDiff = endY-startY; // difference between y points
    xDiff = endX-startX; // difference between x points

    // calculating the slope of a line - this will be used to adjust the
    // plotted y value should the line be sloped 
    float slopeFX = (float(yDiff)/float(xDiff))*-1; 
                                                                    
    float vibDepthmap = segMI; // value for amplitude of vibrato sine wave
    float vibRatemap = segHR; // using this as a variable angle increment means the
                              // rate of the vibrato sine wave will increase and
                              // decrease with harmonicity ratio

    float angle = 180; // to fix start of sine wave so amplitude is increasing from 0

    if (xDiff < 0) { // if this is negative
      startL = endX; // plot curve for loop needs to start at the lower number
      endL = int(startX); // and end at the higher
    } else { // means xDiff > 0
      startL = int(startX); // plot curve for loop needs to start at the lower number
      endL = endX; // and end at the higher
    }

    int w = 0; // to index vibPoints array

    for (int x = startL; x <= endL; x+=2) {

      float rad = radians(angle);
      
      // the vibDepthmap here is amplitude of the sine curve
      y = startY + (sin(rad)*vibDepthmap); 

      vibPoints.add(new Plotpts()); // create a new vibPoint coordinate

      y = y + ((slopeFX*(endX - x)) + yDiff); // adjust y position for line slope

      vibPoints.get(w).start(x, y); // drop x and y values into vibPoints array

      angle+=vibRatemap; // increment the angle variable
      w++; // increment index point
    }
  }

  // this was for testing pointPlotting when implementing it first
  void drawLineplots () {
    for (int f = 0; f < plotPoints.size (); f++) {
      ellipse(plotPoints.get(f).xPt, plotPoints.get(f).yPt, 5, 5);
    }
  }

  void curveVars () {

    /*-------CURVE STUFF--------*/
    /* The curves are cosine curves drawn from position of max
     amplitude to min amplitude.
     
     startL and endL are values for the start and end 
     points of the loop that will draw the curve
     
     THAT LOOP is equal to the distance between x points
     
     xDiff is the difference between the x values of start
     and end points
     
     yDiff is the difference between y values of start and
     end points.
     */

    amp = (endY-startY)*0.5; // variance about zero point

    if (amp < 0) { // if amp is negative, * by -1
      amp = amp*-1;
    }

    yDiff = endY-startY; // difference between y points

    offAdj = amp - startY; // need this variable to correctly plot the curve

    xDiff = endX-startX; // difference between x points

    /*
    Why am I multiplying xDiff by 0.1? (see below)
     
     This is for computation efficiency.
     
     The plot loop steps through the distance between the start and end x points, 
     calculating a y point for each x point. If the increment here is 1, then it 
     means that for every pixel, we're plotting a y point, then we eventually draw 
     a line between each point.
     
     Much more efficient to use an increment in that loop of 10, but that means 
     that we must alter the value we use to calculate the y point (a) correspondingly.
     
     The increment used over each instance of the loop is inc, which is calculated from:
     
     PI/xDiff
     
     So if the step in x (the i value for the loop) is larger, then the step in y (inc)
     must also be larger by the same degree, hence we make xDiff a tenth of its 
     original value, which will result in a larger step for inc.
     */

    if (xDiff < 0) { // if this is negative
      xDiff = int((xDiff*-1)*0.1); // make it positive
      startL = endX; // plot curve for loop needs to start at the lower number
      endL = startX; // and end at the higher
      a = 0; // as startX > endX this curve needs to fall, therefore a = 0
    } else { // means xDiff > 0
      xDiff = int(xDiff*0.1);
      startL = startX; // plot curve for loop needs to start at the lower number
      endL = endX; // and end at the higher
      a = PI; // as startX < endX this curve needs to rise, therefore a = PI
    }

    inc = PI/xDiff; // this is the increment amount for each instance of the plot loop
    // effectively it corresponds to the distance we've moved x by, which we are 
    // then using to plot the corresponding y point

    /*
In terms of the project, the amplitude would be equal
     to the positive value of the difference between the y
     start and end points.
     
     endY - startY
     if result is negative, * by -1
     */
  }

  // drawing the pitch curve between two nodes if required 
  void drawCurve () {

    strokeWeight(segstrWt*segTD*0.5);

    // Steps through all the plotted points for the curve and draws a line between them

    for (int k = 0; k < plotPoints.size (); k++) {
      if (k > 0) {
        line(plotPoints.get(k-1).xPt, plotPoints.get(k-1).yPt, 
        plotPoints.get(k).xPt, plotPoints.get(k).yPt);
      }
    }
  }

  // plots points for the cosine curve 
  void plotCurve () {

    plotPoints.clear();

    int j = 0;
     
     // yDiff is the difference between y values of start and end points
     // yDiff = endY-startY

    if (yDiff > 0) { // then endY is below startY    

      for (int i = startL; i <= endL; i+=10) {

        plotPoints.add(new Plotpts());

        plotPoints.get(j).start(float(i), yDiff-offAdj+cos(a)*amp);

        a = a + inc;
        j++;
      }
    } else { // then endY is above startY
    
      for (int i = startL; i <= endL; i+=10) {

        plotPoints.add(new Plotpts());

        plotPoints.get(j).start(float(i), 0-offAdj-cos(a)*amp);

        a = a + inc;
        j++;
      }
    }
  }


    // work out min and max X Y values for drawing selection box
  void calcSelection () {

    if (startX < endX) {
      minX = startX;
      maxX = endX;
    } else {
      minX = endX;
      maxX = startX;
    }
    if (startY < endY) {
      minY = startY;
      maxY = endY;
    } else {
      minY = endY;
      maxY = startY;
    }
  }

  // does wot it sez on the tin, innit.
  void drawselectionBox () {
    rectMode(CORNER);
    strokeWeight(1);

    if (segFill == 100) {
      stroke(0, 100, 100); // was segFill - colour is now red
    } else {
      stroke(0, 100, 100);
    }

    rect(minX, minY, maxX-minX, maxY-minY);
  }

  // for testing
  void printSeg () {
    println("minX = "+minX+", maxX = "+maxX+", minY = "+minY+", maxY = "+maxY);
  }
}

