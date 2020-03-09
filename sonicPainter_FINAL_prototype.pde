/*
///////  sonicPainter: Improvements to the traditional piano roll inspired ///////
///////  by legacy graphic synthesis systems and visual music.             ///////
///////                                                                    ///////
///////                                                                    ///////
///////                          by                                        ///////
///////                      Bill Coleman                                  ///////
<<~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~>>
<<~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~>> 
 */

// Libraries for Serial Communication
import oscP5.*;
import netP5.*;

OscP5 oscP5; // Declare an object of the OscP5 class to handle 
             // messaging
NetAddress myRemoteLocation; //Where we send/receive messages to/from

// playHead variables
boolean phAct = false; // playHead Active state
int phDur = 25; // Duration value for playHead
float phSpeed = 0; // speed of playHead - it's important that these values are floats 
                   // because converting them back to ints to increment the playhead leads 
                   // to accumulative innaccuracies
float phXpos = 0; // x position of playHead 
float pixperSec = 0; // no. of pixels the playHead moves per second

// holding variables for node matching
int ptX = 0;
int ptY = 0;
boolean nodeMatchS = false;
boolean nodeMatchE = false;
int segID; // used to pick noteSeg coords out of array
int checkNodes = 0; // to control the size of the loop that checks 
// nodes

// range for node matching
int range = 20;

// range for seg selecting
int lineRange = 10;

// declaring an ArrayList of IntLists to hold noteBar information
// this way I can keep track of which noteSeg's belong
// in which noteBar
// noteBar in slot 3, for instance, might contain noteSegs 9, 10 & 11
ArrayList<IntList> noteBars = new ArrayList<IntList>();

// variable for targeting
boolean haveTarget = false;
int numTar; // variable for which seg is the target

// using an intlist to build a list of segments which belong to the 
// same noteBar. As each noteBar is built, the segments created are 
// appended to this IntList and when the noteBar is finished, this 
// list is loaded into the noteBars ArrayList and then cleared so it 
// can collect info for the next noteBar
IntList whichSegs = new IntList();

// Another ArrayList to hold all noteSeg information
// this way we can easily access one particular noteSeg if so desired
ArrayList<NoteSeg> allSegs = new ArrayList<NoteSeg>();

// variable to iterate through allSegs instances
int actSeg = 0; //which noteSeg is currently active?

// variable to iterate through noteBars
int actBar = 0;
boolean newBar = true;

// variable to identify note 'trees'
// controlled by UP and DOWN arrows
// used in the drawing of handles
// NOT ADDED TO RESET

// Arraylist for Notetrees
ArrayList<Notetree> allTrees = new ArrayList<Notetree>();

int noteTree = 0; // what noteTree am I acting on?
boolean actTree = true; // boolean to control initiation of handle
int nonoteTrees = 0; // to keep track of how many noteTrees there are
// I want a seperate value for this because I want to be able to
// increment and decrement noteTree and add to previously
// instantiated noteTrees 
int colInc = 10; // used to control the colour of noteTrees

// boolean to implement a drawing mode so we can have a selecting mode
boolean drawMode = false;

// boolean values to control if we're drawing segs under mouseMoved
boolean startSeg = false;

// boolean to control if we're moving a node and redrawing all the noteSegs connected to it
boolean moveNodes = false;

// using this with keyPressed & keyReleased to set up a toggle
// to control the ending of a noteBar
boolean endBar = false;

//variable to toggle on/off the drawing of straight horizontal lines
boolean flatY = false;

// colour variable
int colF = 100;
int barCol = 100; // controls colour of noteBar

// synth mapping parameters
int maxHR = 200; // maximum possible harmonicity ratio
float startHR = 10;
int maxMI = 1000; // maximum possible modulation index
int maxvibRate = 10; // max poss vib rate
int maxvibDpth = 100; // max poss vib depth
int maxtremRate = 10;
int maxtremDpth = 10;

// click/doubleclick management
int clickTime = 0;
int clickSpeed = 200; // shortening this causes issues with ending noteBars (makes extra segs)
                // it would be desirable to reduce it if possible as this makes handle editing
                // smoother
boolean clicked = false;

// boolean to stop running of the tremolo opacity array if the array values are being recalculated
boolean tremCalc = false;

// boolean to control freeHand drawing
boolean freeHand = false;

//booleans for direct control of synth parameters
boolean editFM = false; // fm synth params
boolean editVib = false; // vibrato
boolean editTrem = false; // tremolo
boolean drawingVib = false; // flipping between drawing sideband and vibrato

// variables for parameter editing without handles
int baseX, baseY, initX, initY, nowX, nowY;



void setup() {

  size (1000, 500);
  fill(100);
  frameRate(25);
  rectMode(CENTER);

  pixperSec = width/phDur; // work out speed of playhead

  phSpeed = pixperSec*0.04; // need to calc speed at split second rate

  colorMode(HSB, 100); // for colour identifying noteBars

  // This is here because I want to control it with UP and DOWN, 
  // and need to make the first one to get things rolling
  allTrees.add(new Notetree()); // create a new Notetree
  allTrees.get(noteTree).start(noteTree);

  oscP5 = new OscP5(this, 7400); // initialising oscP5 variable  

  // use 127.0.0.1 for local machine
  // use 192.168.0.4 for this machine when operating Processing on another machine
  myRemoteLocation = new NetAddress("127.0.0.1", 7400); //Location is 
  // local machine, port 7400. The application we are sending to 
  // (e.g.Max) needs to listen at the above port.
}

void draw() {

  background(0);

  targetBoxes(); // draws crosshairs and target box

  if (phAct == true) { // if play is toggled on
    phXpos = phXpos+phSpeed; // increment x position
    playHead(); // draw playHead
  }

  if (phXpos >= width) { // if playHead reaches RHS then reset to 0
    phXpos = 0;
    for (int i=0; i<allSegs.size (); i++) { // also reset all noteSegs sendMsg to false
      allSegs.get(i).sendMsg = false;
    }
  }

  for (int k = 0; k < allTrees.size (); k++) {

    if (allTrees.get(k).treeSel == true) {

      allTrees.get(k).treeTimer();
      
      if (drawingVib == false) {
      allTrees.get(k).plotSideband();
      allTrees.get(k).drawSideband();
      }
    }
  }


  for (int i=0; i<allSegs.size (); i++) { // draw all noteSegs
    NoteSeg nS = allSegs.get(i);
    nS.display();

    if (allSegs.get(i).segSelect == true) {
      allSegs.get(i).drawselectionBox();
      // put drawing of effects parameters in here
    }
  }
  
  drawInfo(); // display info about synth parameters and noteTrees

  for (int j = 0; j < noteBars.size (); j++) { // step through every entry in noteBars (lists 
                                               // of segs in each noteTree)


    // if playhead passes the start of a noteSeg that is the first noteSeg of a noteTree, 
    // and that noteSegs sendMsg state is false...
    // 
    if (phXpos >= allSegs.get(noteBars.get(j).get(0)).startX && 
      allSegs.get(noteBars.get(j).get(0)).sendMsg == false) { // 
      // then send the coordinate points for all segs of that noteTree in the following message
      // ...
      OscMessage myMessage1 = new OscMessage("NOTESEG");

      float treeFstX = allSegs.get(noteBars.get(j).get(0)).startX; // first X value of noteTree
      float treeLstX = allSegs.get(noteBars.get(j).get(noteBars.get(j).size()-1)).endX; // last X value of noteTree

      float treeDur = treeLstX - treeFstX;
      treeDur = (treeDur/pixperSec)*1000; // total duration of noteTree in millisecs

      myMessage1.add(treeFstX); // first x point of tree

      myMessage1.add(treeLstX); // last x point of tree

      myMessage1.add(treeDur); // duration of tree

      myMessage1.add(allSegs.get(noteBars.get(j).get(noteBars.get(j).size()-1)).segMI); // mod index value

      myMessage1.add(allSegs.get(noteBars.get(j).get(noteBars.get(j).size()-1)).segHR); // harm rat value

      myMessage1.add(allSegs.get(noteBars.get(j).get(noteBars.get(j).size()-1)).treeNo); // tree identifier

      myMessage1.add(allSegs.get(noteBars.get(j).get(noteBars.get(j).size()-1)).segTR); // tremolo rate

      myMessage1.add(allSegs.get(noteBars.get(j).get(noteBars.get(j).size()-1)).segTD); // tremolo depth

      for (int i = 0; i < noteBars.get (j).size(); i++) { // we're going to look at every seg in this noteBar and send all plotpoints to Max
        if (allSegs.get(noteBars.get(j).get(i)).type == true) { // then this seg is a line

            // Start x point of Seg
          myMessage1.add(allSegs.get(noteBars.get(j).get(i)).startX);
          // start Y point of noteSeg
          myMessage1.add(height-allSegs.get(noteBars.get(j).get(i)).startY);
          // End x point of Seg
          myMessage1.add(allSegs.get(noteBars.get(j).get(i)).endX);          
          // end Y point of noteSeg
          myMessage1.add(height-allSegs.get(noteBars.get(j).get(i)).endY);                          
          // change sendMsg to true
          allSegs.get(noteBars.get(j).get(i)).sendMsg = true;
        } else { // then this noteSeg is a curve

          // so we need to step through plotPoints array writing x and y points
          for (int b = 0; b < allSegs.get (noteBars.get (j).get(i)).plotPoints.size (); b++) {
            myMessage1.add(allSegs.get (noteBars.get(j).get(i)).plotPoints.get(b).xPt); //                    
         
            myMessage1.add(height-allSegs.get (noteBars.get(j).get(i)).plotPoints.get(b).yPt);
          }      
          // change sendMsg to true
          allSegs.get(noteBars.get(j).get(i)).sendMsg = true;
        }
      }
      // Send the message
      oscP5.send(myMessage1, myRemoteLocation);
    }
  }

  stroke(100);
  strokeWeight(5);
  line(0, height*0.9, width, height*0.9);// draws a line to seperate 
  // transport buttons from canvas
}

