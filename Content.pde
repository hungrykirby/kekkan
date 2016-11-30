class Content{
  PImage p;
  float x, y;
  float yokoSize;
  float ratio;
  float vX, vY;
  float angle;
  float tateSize;
  
  Content(PImage _p, float _size){
    p = _p;
    //x = _x;
    //y = _y;
    yokoSize = _size;
    //vX = x - width/2.0;
    //vY = y - height/2.0;
    //vX *= 0.01;
  }
  
  void setup(float xPos, float yPos){
    x = xPos + width/2;
    y = yPos + height/2;
    vX = xPos;
    vY = yPos;
    angle = random(0, 2*PI);
    tateSize = yokoSize*p.height/p.width;
  }
  
  void draw(float ratio){
    pushMatrix();
    translate(x + 100.0*(noise(x, y, ratio*5) - 0.5), y + 100.0*(noise(y, x, ratio*5) - 0.5));
    //println(x);
    translate(2*ratio*vX, 2*ratio*vY);
    scale(ratio);
    rotate(angle + 2 * noise(ratio*3.0, width/2 - x, height/2 - y));
    imageMode(CENTER);
    image(p, 0, 0, yokoSize, tateSize);
    popMatrix();
  }
}