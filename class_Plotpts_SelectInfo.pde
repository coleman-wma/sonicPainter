class Plotpts {
  
  /*
  This class contains x y points to plot curves
  
  These are used to plot curves, the fm representation and points for direct line selection
  */

  float xPt;
  float yPt;

  void start(float _xPt, float _yPt) {

    xPt = _xPt;
    yPt = _yPt;
  }
}

class SelectInfo {

int thisSeg;
int clickDist;

}
