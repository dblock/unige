import java.util.*;
import java.awt.*;
import java.applet.*;

public class Cloud extends Vector {
  Random aRandom;
  Cloud(){
     aRandom = new Random();
  }
  public void addPoint (Point aPoint) { super.addElement(aPoint); }
  public Point getPoint (int Index) { return( (Point) super.elementAt(Index)); }
  public String getString() {
    String newString = new String();
    for (int i=0;i<size();i++) newString += getPoint(i).toString() + "\n";
    return(newString);
  }
  static int maxLocalInt = 256;
  static Applet parent;
  public void randomize(int width, int height, Applet _parent){
    parent = _parent;
    int rInt;
    try {
      rInt = Integer.valueOf(_parent.getParameter("COUNT")).intValue();
    } catch (Exception e) {
      rInt = Math.abs(aRandom.nextInt() % maxLocalInt);
    }
    if (rInt <= 0) rInt = maxLocalInt;
    removeAllElements();
    //System.out.println("randomizing cloud of " + rInt + " points.");
    for (int i=0;i<rInt;i++) addPoint(new Point(Math.abs(aRandom.nextInt() % width), Math.abs(aRandom.nextInt() % height)));
  }
  private void LDrawPoint(Point z, Graphics g){
    g.drawOval(z.x, z.y, 1, 1);
  }
  public void Paint(Graphics g){
    g.setFont(new Font("Times", Font.PLAIN, 12));
    String oul = "doubrov5@ - Plotting "  + size() + " points.";
    g.drawString(oul, 
	(parent.size().width - g.getFontMetrics(g.getFont()).stringWidth(oul)) / 2, 
	 parent.size().height - g.getFontMetrics(g.getFont()).getDescent());
    for (int i=0;i<size();i++) {
      LDrawPoint(getPoint(i), g);
    }
    paintBaryCentre(g);
  }
  public void paintBaryCentre(Graphics g){
    Point bary = Barycentre();
    int dz = 2;
    g.setColor(Color.red);
    g.fillOval(bary.x - dz, bary.y - dz, dz * 2, dz * 2); 
  }
  public Point Barycentre(){
    if (size() == 0) return(new Point(0, 0));
    int xSum=0;
    int ySum=0;
    for (int i=0;i<size();i++) {
      Point iPoint = getPoint(i);
      xSum+=iPoint.x;
      ySum+=iPoint.y;
    }
    return(new Point(xSum / size(), ySum / size()));
  }
}

