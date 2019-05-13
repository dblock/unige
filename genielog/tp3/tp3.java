/*

TP3.GenieLog - 03.11.97 - Daniel Doubrovkine - doubrov5@cuimail.unige.ch

 job: barycenter of a cloud, applet version
 
*/

import java.util.*;
import java.awt.*;

public class tp3 extends java.applet.Applet {
  static int randomized = 0;
  public synchronized void reshape(int x, int y, int w, int h) {
    super.reshape(x, y, w, h);
    if (appletCloud != null) appletCloud.randomize(w, h, this);
  }
  public void init(){
    appletCloud = new Cloud();
    appletCloud.randomize(size().width, size().height, this);	  
  }
  private Cloud appletCloud;
  public void paint(Graphics g){
    appletCloud.Paint(g);
  }
  
}


