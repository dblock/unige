/*

TP2.GenieLog - 30.10.97 - Daniel Doubrovkine - doubrov5@cuimail.unige.ch

 job: barycenter of a cloud
 
*/

import java.util.*;
import java.awt.*;

class Cloud extends Vector {
  public void addPoint (int x, int y) {
    Point newPoint = new Point();
    newPoint.setLocation(x, y);
    addPoint(newPoint);
  }
  public void addPoint (Point aPoint) { super.addElement(aPoint); }
  public Point getPoint (int Index) { return( (Point) super.elementAt(Index)); }
  public String getString() {
    String newString = new String();
    for (int i=0;i<size();i++) newString += getPoint(i).toString() + "\n";
    return(newString);
  }
  public Cloud(){
    super();
    randomize();
  }
  static int maxLocalInt = 256;
  public void randomize(){
    Random aRandom = new Random();
    int rInt = aRandom.nextInt() % maxLocalInt;
    if (rInt < 0) rInt = - rInt;
    if (rInt == 0) rInt = maxLocalInt;

    System.out.println("randomizing cloud of " + rInt + " points.");
    for (int i=0;i<rInt;i++) addPoint(aRandom.nextInt() % maxLocalInt, aRandom.nextInt() % maxLocalInt);
  }
  public Point Barycentre(){
    int xSum=0;
    int ySum=0;
    for (int i=0;i<size();i++) {
      Point iPoint = getPoint(i);
      xSum+=iPoint.x;
      ySum+=iPoint.y;
    }
    Point rPoint = new Point();
    rPoint.x = xSum / size();
    rPoint.y = ySum / size();
    return(rPoint);
  }
}

class tp2 {
  public static void main(String args[]){
    System.out.println("Java - TP2 - Daniel Doubrovkine - doubrov5@cuimail.unige.ch - 30.10.97");
    Cloud aCloud = new Cloud();
    System.out.println(aCloud.getString());
    Point aPoint = aCloud.Barycentre();
    System.out.println("barycentre: " + aPoint.toString());
  }
}
