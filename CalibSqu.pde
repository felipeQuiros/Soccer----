public class CalibSqu {

  float [][] dots;
  PApplet parent;
  int dotSens = 10;
  int current = 5;

  //top-left, top-right, down-left, down-right, width and height of the screen image position
  PVector o1, o2, o3, o4; // are vectors cause we can put coordinates on 'em.
  PVector t1, t2, t3, t4;
  float ow, oh; // just floats cuase are scalar data.

  //variable for yDistortion exponent
  float exp = 1.0;

  public CalibSqu(PApplet p, float ox, float oy, float ow, float oh) {

    //receive the parent of applet, just in case...
    parent = p;

    //init the dots matrix
    dots = new float[4][2];

    //base position for the square
    dots[0][0] = 50;
    dots[0][1] = 50;

    dots[1][0] = 100;
    dots[1][1] = 50;

    dots[2][0] = 100;
    dots[2][1] = 100;

    dots[3][0] = 50;
    dots[3][1] = 100;

    //set vectors and constants
    this.ow = ow;
    this.oh = oh;

    this.o1 = new PVector(ox, oy);
    this.o2 = new PVector(ox+ow, oy);
    this.o3 = new PVector(ox, oy+oh);
    this.o4 = new PVector(ox+ow, oy+oh);

    setTargetVectors();
  }

  public void put(boolean cal) {
    //set Color to the stroke
    stroke(80, 80, 250);
    strokeWeight(2);

    //draw the square shape
    //draw points on verts
    beginShape();
    for (int i=0 ; i<dots.length ; i++) {
      vertex(dots[i][0], dots[i][1]);
      fill(80, 80, 250);
      if (cal)
        ellipse(dots[i][0], dots[i][1], dotSens, dotSens);
    }
    noFill();
    endShape(CLOSE);

    //yDistortion Graphics
    for (int i=0 ; i<=10 ; i++) {
      float res = pow(i, exp);//current Dot

      if (i!=5)stroke(240);//white color for all dots
      else
        stroke(200, 50, 50);//except the middle one

      //show dots, maped by the exp on the left side of target square.
      float yDist = dots[2][1]-map(res, 0, pow(10, exp), dots[2][1]-dots[0][1],0);
      point(map(yDist, dots[3][1], dots[0][1], dots[3][0], dots[0][0]), yDist);

//      if (i>0)
//        println("la diferencia entre "+i+" y "+(i-1)+" da: "+(res-pow(i-1, exp)));
    }

    this.movePoint();
  }

  public float[] showHit(float xx, float yy) {
    
    float relX = xx-o1.x;
    float relY = yy-o1.y;
    float yNorm = map(relY, 0, oh, 0, 10);
    float yMapped = map(pow(yNorm,exp), 0, pow(10, exp), 0, t3.y-t1.y);
    
    float xOffLeft = t1.x-t3.x;
    float xOffRight = t2.x-t4.x;
    float xLeft = t1.x-map(yMapped, 0, (t3.y-t1.y), 0, xOffLeft);
    float xRight = t2.x-map(yMapped, 0, (t3.y-t1.y), 0, xOffRight);
    float currentWidth = xRight-xLeft;
    float xMapped = map(relX,0,ow,0, currentWidth);
    float xResult = xLeft + xMapped;
    
    strokeWeight(2);
    ellipse(xLeft, yMapped+t1.y, 5, 5);
    ellipse(xRight, yMapped+t1.y, 5, 5);

    float [] result = new float[2];
    
    result[0] = xResult;
    result[1] = yMapped+t1.y;
    return result;
  }

  public void calibDots(float xx, float yy) {
    for (int i=0 ; i<dots.length ; i++) {
      if (abs(dist(xx, yy, dots[i][0], dots[i][1]))< dotSens) {
        current = i; 
        println("Moving Dot index: "+i);
      }
    }
  }

  public void setTargetVectors() {
    t1 = new PVector(dots[0][0], dots[0][1]);
    t2 = new PVector(dots[1][0], dots[1][1]);
    t3 = new PVector(dots[3][0], dots[3][1]);
    t4 = new PVector(dots[2][0], dots[2][1]);
    println("target vector calibrated");
  }

  public void rels () {
    setTargetVectors();
    current = 5;
  }

  public void movePoint() {
    if (current != 5) {
      dots[current][0] = mouseX;

      if (current == 0 || current == 1) {
        dots[0][1] = mouseY;
        dots[1][1] = mouseY;
      }

      if (current == 2 || current == 3) {
        dots[2][1] = mouseY;
        dots[3][1] = mouseY;
      }
    }
  }

  public float [][] get() {
    return dots;
  }

  public double logOfBase(int base, int num) {
    return Math.log(num) / Math.log(base);
  }

  public float convertY(float inY) {
    
//    println("inY: "+inY);
    float numBase = inY-t1.y;
//    println("numBase: "+numBase);
    float unMap = map(numBase, 0, dots[2][1]-dots[0][1], 0, pow(10, exp));
//    println("unMap: "+unMap);
    float unPowered = pow(unMap,(1/exp));
//    println("unPowered: "+unPowered);
    float reMap = map(unPowered,0,10,o1.y,o3.y);
//    println("reMap: "+reMap);
    return  reMap-o1.y;
  }

  public void keyPressed() {
    if (key == CODED) {
      if (keyCode == UP) {
        exp+=.01;
      } 
      if (keyCode == DOWN) {
        exp-=.01;
      }
    }
  }
  
  public float getUpper(){
   return t1.y; 
  }
}
