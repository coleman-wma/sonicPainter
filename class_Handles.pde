/*
Much of the implementation of this class has been removed from the rest of the
code to clean it up.
*/



//class Handle {
//  //GLOBAL VARIABLES
//  // first, x & y co-ords for drawing handles
//  int handX = 0; // x and y position of handle - these need to be worked out based on the start values of HR 
//  int handY = 0; // and MI
//  int vibhX, vibhY, tremhX = 0;
//  int tremhY = int(height*0.1);
//  int anchX = 0; // to draw guide line from handle to start point of first noteSeg of noteTree
//  int anchY = 0;
//
//  // colouring of Handle - to associate it with the noteTree/noteSegs it controls
//  int handCol = barCol;
//
//  // which noteTree this handle controls parameters for
//  int handTree;
//
//  // synth params
//  float modInd = 2;
//  float harmRat = 2;
//  float vibRate = 0;
//  float vibDepth = 0;
//  float tremRate = 0;
//  float tremDepth = 1;
//
//  //CONSTRUCTOR
//  // declaring variables for the class to hold x & y co-ords etc
//
//  void start(int _handX, int _handY, int _handCol, float _modInd, float _harmRat, int _anchX, int _anchY, int _handTree) {
//
//    handX = _handX;
//    handY = _handY;
//    handCol = _handCol;
//    modInd = _modInd;
//    harmRat = _harmRat;
//    anchX = _anchX;
//    anchY = _anchY;
//    handTree = _handTree;
//  }
//
//
//
//  //FUNCTIONS
//
//  void display () {
//    strokeWeight(1);
//    textSize(12);
//
//    if (handCol == 100) {
//
//      // MI & HR
//      stroke(handCol);
//      fill(handCol, 20);
//      ellipse(handX, handY, range, range);
//      fill(handCol);
//      String mi = nf(modInd, 2, 2);
//      text("M.I. = "+mi, handX+range*0.75, handY+10);
//      String hr = nf(harmRat, 2, 2);
//      text("H.R. = "+hr, handX+range*0.75, handY-5);
//      dottedLine(handX, handY, anchX, anchY, 20);
//
//      // VIBRATO
//      stroke(handCol);
//      fill(handCol, 20);
//      ellipse(vibhX, vibhY, range, range);
//      fill(handCol);
//      String vr = nf(vibRate, 2, 2);
//      text("vRate = "+vr, vibhX+range*0.75, vibhY-5);
//      String vd = nf(vibDepth, 2, 2);
//      text("vDpth = "+vd, vibhX+range*0.75, vibhY+10);
//      dottedLine(vibhX, vibhY, anchX, anchY, 20);            
//
//      // TREMOLO
//      stroke(handCol);
//      fill(handCol, 20);
//      ellipse(tremhX, tremhY, range, range);
//      fill(handCol);
//      String tr = nf(tremRate, 2, 2);
//      text("tRate = "+tr, tremhX+range*0.75, tremhY-5);
//      String td = nf(tremDepth, 2, 2);
//      text("tDpth = "+td, tremhX+range*0.75, tremhY+10);
//      dottedLine(tremhX, tremhY, anchX, anchY, 20);      
//
//
//      textSize(32);
//      text(noteTree, 960, 485);
//    } else {
//
//      // MI & HR
//      stroke(handCol, 100, 100); // stroke for noteSeg
//      fill(handCol, 100, 100, 20);
//      ellipse(handX, handY, range, range);
//      fill(handCol, 100, 100);
//       String mi = nf(modInd, 2, 2);
//      text("M.I. = "+mi, handX+range*0.75, handY+10);
//      String hr = nf(harmRat, 2, 2);
//      text("H.R. = "+hr, handX+range*0.75, handY-5);
//      dottedLine(handX, handY, anchX, anchY, 20);
//
//      // VIBRATO
//      stroke(handCol, 100, 100); // stroke for noteSeg
//      fill(handCol, 100, 100, 20);
//      ellipse(vibhX, vibhY, range, range);
//      fill(handCol, 100, 100);
//      String vr = nf(vibRate, 2, 2);
//      text("vRate = "+vr, vibhX+range*0.75, vibhY-5);
//      String vd = nf(vibDepth, 2, 2);
//      text("vDpth = "+vd, vibhX+range*0.75, vibhY+10);
//      dottedLine(vibhX, vibhY, anchX, anchY, 20);            
//
//      // TREMOLO
//      stroke(handCol, 100, 100); // stroke for noteSeg
//      fill(handCol, 100, 100, 20);
//      ellipse(tremhX, tremhY, range, range);
//      fill(handCol, 100, 100);
//      String tr = nf(tremRate, 2, 2);
//      text("tRate = "+tr, tremhX+range*0.75, tremhY-5);
//      String td = nf(tremDepth, 2, 2);
//      text("tDpth = "+td, tremhX+range*0.75, tremhY+10);
//      dottedLine(tremhX, tremhY, anchX, anchY, 20);  
//
//      textSize(32);
//      text(noteTree, 960, 485);
//    }
//  }
//}

