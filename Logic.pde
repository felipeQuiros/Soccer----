public class App {
  /* calib square variables */
  //create the calibSqu Var
  CalibSqu squ;

  //Data for targetsquare
  Float xGoal, yGoal, wGoal, hGoal;

  //TargetLines
  float [] hit;


  /* images and graphic stuff */
  PImage testBG;


  SimpleOpenNI kinect;

  /*Variables de medicion*/
  int[] depthValues;
  int clickPosition; //Para hacer pruebas con la posicion del mouse;
  int milimetros;
  float pulgadas; //por si algun gringo quiere revisar el codigo
  float centimetros;
  float distancia;
  float umbral;
  float distanciaMax;
  float distanciaMin;
  boolean sumarPuntos;
  int puntaje;        
  float proporcionX;
  float proporcionY;

  /*Variables de control de juego y calibración*/
  boolean onCalib;
  boolean rgbOnOff;
  boolean dibujarUmbral;
  float offsetZ;
  float xArco, yArco, wArco, hArco;
  ArrayList <Punto>losPuntos = new ArrayList<Punto>();
  int YkinectOff = 0;

  /*Creacion de targets"*/
  ArrayList <Target> losTargets = new ArrayList<Target>();
  Target targetPequeno1;
  Target targetPequeno2;
  Target targetPequeno3;
  Target targetPequeno4;

  /*Variables para el control de los targets*/
  int anchoPequeno = 80;
  int altoPequeno = 40;

  /*Definir clases para pintar*/


  //Prueba con rangos
  int posX, posY, ancho, alto;

  PApplet parent;

  public App(PApplet parent) {//----------------------------------------------------CONSTRUCT
    this.parent = parent;

    kinect = new SimpleOpenNI(this.parent);
    smooth();

    kinect.enableDepth();
    kinect.enableRGB(); 
    ancho=50;
    alto=ancho;
    posX= 0;
    posY= 0;
    distancia=208;
    offsetZ = 0.5;

    //rect(135, 92, 1046-135, 802);
    xArco = 135;
    yArco = 92;
    wArco = 1046-135;
    hArco = 802;

    /*La distancia mide un punto, si se le suma y resta el umbral, se puede generar un rango en donde el balon entra. Cuestion de calibracion: entre mas preciso, menos datos se procesan,
     sin embargo, si se es muy puntual, puede no cogerlo el sensor.*/
    umbral=10; 

    distanciaMax=distancia+umbral;
    distanciaMin=distancia-umbral;

    targetPequeno1= new Target( (width/4)-(anchoPequeno/2), (height/4)-(anchoPequeno/2), anchoPequeno, altoPequeno, distancia);
    targetPequeno2= new Target( ((width/4)*3)-(anchoPequeno/2), (height/4)-(anchoPequeno/2), anchoPequeno, altoPequeno, distancia);
    targetPequeno3= new Target( ((width/4)*3)-(anchoPequeno/2), ((height/4)*3)-(anchoPequeno/2), anchoPequeno, altoPequeno, distancia);
    targetPequeno4= new Target( (width/4)-(anchoPequeno/2), ((height/4)*3)-(anchoPequeno/2), anchoPequeno, altoPequeno, distancia);

    losTargets.add(targetPequeno1);
    losTargets.add(targetPequeno2);
    losTargets.add(targetPequeno3);
    losTargets.add(targetPequeno4);

    onCalib=true;
    rgbOnOff=false;
    sumarPuntos=false;
    puntaje=0;
    dibujarUmbral=true;

    /*Proporcion de variables*/
    proporcionX = 640.0/1280f;
    proporcionY = 480.0/980f;

    println(proporcionX);

    testBG = loadImage("1.jpg");

    /*vaiables de calibracion kinect+videoBeam */
    xGoal = 60.0;
    yGoal = 145.0;
    wGoal = 1170.0;
    hGoal = 450.0;

    hit = new float[2];
    hit[0] = xGoal+(wGoal*.5);
    hit[1] = yGoal+(hGoal*.5);

    squ = new CalibSqu(parent, xGoal, yGoal, wGoal, hGoal);
  }

  public void draw() {
    kinect.update();
    //println("frameRate: "+frameRate);

    PImage depthImage = kinect.depthImage();
    PImage rgbImage = kinect.rgbImage();
    float constP = 640f/480f;

    background(0);
    //image(depthImage, 0, 0, width, width/constP);


    if (rgbOnOff==true) {
      image(rgbImage, 0, 0);
    }

    if (onCalib==false) {
      // fill(255, 10);
      // rect(0, 0, width, height);
      //image(testBG, 0, 0, width, height);
    }

    //Se genera el arreglo de valores de cada pixel
    depthValues = kinect.depthMap();
    //Se calcula la posicion del mouse, convirtiendo la coordenada en valores de un arreglo, para mapearlo al arreglo anterior

    /*formula es posX + (posY*anchoLienzo)*/

    clickPosition = posX + (posY * width);


    fill(255);
    stroke(0, 255, 0);

    fill(34, 166, 255);

    //    for (int i=0;i<depthValues.length;i++) {
    //
    //      float valorTemporal=depthValues[i]/10; //Se divide por 10 para manejarlo en centimetros
    //
    //      int pPosY=i/640; //Se calcula la posicion en Y del punto
    //      int pPosX=i-(pPosY*640); //se calcula para X
    //      float mappedX= pPosX/proporcionX;
    //      float mappedY= pPosY/proporcionY;
    //
    //      //comenzar for para validar los targets
    //      for (int j=0 ; j<losTargets.size() ; j++) {
    //        // ellipse(mappedX, mappedY, 2, 2);
    //        if (losTargets.get(j).validar(mappedX, mappedY, valorTemporal, umbral)) {
    //        }
    //      }
    //    }

    targetPequeno1.dibujoPrueba();
    targetPequeno2.dibujoPrueba();
    targetPequeno3.dibujoPrueba();
    targetPequeno4.dibujoPrueba();


    noFill();
    stroke(240);
    line(width/2, 0, width/2, height);

    calibationStuff();
  }

  public void mousePressed() {
    if (onCalib)
      squ.calibDots(mouseX, mouseY);

    println(mouseX);
    println(mouseY);
  }

  public void mouseReleased () {
    if (onCalib)
      squ.rels();
  }

  public void keyPressed() {
    if (key == CODED) {
      if (keyCode == RIGHT) {
        offsetZ += 0.5;
        println("offset MODIFICADo :::: "+ offsetZ);
      }
      else
        if (keyCode == LEFT) {
          offsetZ -= 0.5;
          println("offset MODIFICADo :::: "+ offsetZ);
        }/*
        else
         if (keyCode == RIGHT) {
         println("UMBRAL MODIFICADO ::::  +1");
         umbral+=1;
         
         println("Umbral calibrado final: "+umbral);
         println("------------------------------------");
         }
         else
         if (keyCode == LEFT) {
         println("UMBRAL MODIFICADO ::::  -1");
         umbral-=1;
         
         println("Umbral calibrado final: "+umbral);
         println("------------------------------------");
         }*/
    }

    if ((key == 'c' || key == 'C') && !mousePressed) { 
      onCalib = !onCalib;
      println("toggle calib: "+((onCalib==true)?"On":"Off"));
    }
    else if (mousePressed) {
      println("- release the mouse to toggle calib Please");
    }
    if (onCalib)
      squ.keyPressed();
    if (key == 'd' || key == 'D') {
      rgbOnOff=!rgbOnOff;
    }
    if (key == 'p' || key == 'P') {
      dibujarUmbral=!dibujarUmbral;
    }

    if (key == 't' || key == 'T') {
      for (int i = 0 ; i<losTargets.size() ; i++) {
        //se calcula el index en la matriz de profundidades, con base en la posicion de uno de los targets
        float targPosition = losTargets.get(i).getPosX()*proporcionX + (((losTargets.get(i).getPosY())*proporcionY)*640);
        println(losTargets.get(i).getPosY()*proporcionY);
        //se obtiene el valor de la matriz para la ubicacion del target
        int zTarget=depthValues[(int)targPosition]/10;
        //se entrega al target su ubicacion en z y el umbral para tenerlo en cuenta
        losTargets.get(i).setZ(zTarget, umbral, offsetZ);
      }
    }
  }

  public void calibationStuff() {

    fill(255);
    text(((onCalib==true)?"--On Calibration":"**Calibrated* ^^"), width-200, 50);
    noFill();

    //draw lines
    drawResult();

    strokeWeight(3);
    stroke(255, 255, 255);
    noFill();
    rect(xGoal, yGoal, wGoal, hGoal);
    //put the CalibSquare
    squ.put(onCalib);


    if (mousePressed && !onCalib) {
      hit = squ.showHit(mouseX, mouseY);
    }
  }

  public void drawResult() {
    strokeWeight(1);
    fill(200, 10, 10);
    noStroke();
    ellipse(hit[0], hit[1], 5, 5);
  }
}
