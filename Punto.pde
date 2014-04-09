class Punto {
  float posX, posY, radio;

  public Punto(int X, int Y) {
    posX=X;
    posY=Y;
    radio=20;
  }

  void dibujar () {
    ellipse(posX, posY, radio, radio);
  }

  public boolean validar(float x, float y) {
    return x>posX-radio && x<posX+radio && y>posY-radio && y<posY+radio;
  }

  public void setPos(float x, float y) {
    posX = x;
    posY = y;
  }
  
  public float getPosX() {
    return posX;
  }

  public float getPosY() {
    return posY;
  }
}
