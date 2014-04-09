public class Target {
  int posX;
  int posY;
  float posZ;
  float ancho;
  float alto;
  float contador=75;
  float aumento=5;
  float desaceleracion = 0.01;
  boolean toca;

  boolean empiezaContar = false;
  boolean terminarContar = false;

  Target(int pPosX, int pPosY, float an, float alt, float dist) {
    posX=pPosX;
    posY=pPosY;
    ancho=an;
    alto=alt;
    toca=false;
    posZ = dist;
  }

  void dibujoPrueba() {
    noFill();
    strokeWeight(2);
    if (toca==true) {
      //      fill(255, 0, 0);
      stroke(255, 0, 0);
    } 
    else {
      //      fill(34, 166, 255);
      stroke(34, 166, 255);
    }
    ellipse(posX, posY, ancho, ancho);
    toca=false;

    point(posX, posY);
  }

  void adorno() {
    noFill();
    stroke(34, 166, 255);
    ellipse(posX, posY, contador, contador);

    contador +=208 * desaceleracion;  

    if (contador>128) {
      contador=75;
    }
  }

  void puntaje() {
  }

  public boolean validar(float x, float y, float z, float umbral) {
    float yOff = (posY-y)/10;
    if (abs(dist(x, y, posX, posY))<ancho && z>(posZ-umbral+yOff) && z<(posZ+yOff)) {
      toca = true;
    }

    return toca;
  }

  public void setZ(float z, float umbr, float offset) {
    println("zNeto: "+z);
    posZ = z-umbr-offset;
    println("zSet: "+posZ);
  }

  public float getPosX() {
    return posX;
  }

  public float getPosY() {
    return posY;
  }
  public float [] getPoses (){
    float [] rt = new float[2];
    rt[0] = posX;
    rt[1] = posY;
   return rt; 
  }
}
