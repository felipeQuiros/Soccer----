import SimpleOpenNI.*;

App app;

void setup()
{
  size(1280, 720);
  app = new App(this);
}

void draw()
{
  app.draw();
}


void mouseDragged() {

//  /*posX= mouseX;
//   posY=mouseY;*/
//  calibrarDistancia();
} 
void mousePressed() {
  
  app.mousePressed();

//  posX = mouseX;
//  posY = mouseY;
//  println(mouseX+", "+mouseY);
} 

void mouseReleased(){
 app.mouseReleased(); 
}

void calibrarDistancia() {
//  distancia= map(mouseX, 50, width-50, 50, 400);
//  distanciaMax=distancia+umbral;
//  distanciaMin=distancia-umbral;
//  fill(255, 50);
//  // rect(50, 50, width-100, height-100);
//  println("Calibrando distancia a: "+distancia+" cm");
}

void keyPressed() {
  app.keyPressed();
}
