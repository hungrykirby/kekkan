import ddf.minim.analysis.*;
import ddf.minim.*;
 
Minim minim;
AudioPlayer player;
FFT fft;

PImage base, kekkan, cell, al1, al2, al3, le1, le2, pla;
int cellCount = 30;
int al1Count = 4;
int al2Count = 3;
int al3Count = 4;
int le1Count = 2;
int le2Count = 2;
int plaCount = 3;
final int cellN = 7 + cellCount + al1Count + al2Count + al3Count + le1Count + le2Count + plaCount;
Content[] contents = new Content[cellN];

boolean isImage;
boolean isUp, preUp;
int upCount;
int cellSize;
 
void setup()
{
  frameRate(50);
  
  kekkan = loadImage("kekkan.png");
  cell = loadImage("red_blood_cell.png");
  al1 = loadImage("albumin.png");
  al2 = loadImage("albumin2.png");
  al3 = loadImage("albumin3.png");
  le1 = loadImage("leukocyte.png");
  le2 = loadImage("leukocyte2.png");
  pla = loadImage("platelet.png");
  cellSize = 300;
  contents[0] = new Content(cell, cellSize + 150); //赤血球
  contents[1] = new Content(al1, cellSize); //アルブミン
  contents[2] = new Content(al2, cellSize);
  contents[3] = new Content(al3, cellSize);
  contents[4] = new Content(le1, cellSize/5.0); //白血球
  contents[5] = new Content(le2, cellSize/5.0); //白血球
  contents[6] = new Content(pla, cellSize); //血小板
  
  int randomRange = 20;
  for(int i = 0; i < cellCount; i++) contents[7 + i] = new Content(cell, cellSize + 150 + random(-randomRange, randomRange));
  for(int i = 0; i < al1Count; i++) contents[7 + cellCount + i] = new Content(al1, cellSize + random(-randomRange, randomRange));
  for(int i = 0; i < al2Count; i++) contents[7 + cellCount + al1Count + i] = new Content(al1, cellSize + random(-randomRange, randomRange));
  for(int i = 0; i < al3Count; i++) contents[7 + cellCount + al1Count + al2Count + i] = new Content(al1, cellSize + random(-randomRange, randomRange));
  for(int i = 0; i < le1Count; i++) contents[7 + cellCount + al1Count + al2Count + al3Count + i] = new Content(al1, cellSize/5.0 + random(-randomRange/5.0, randomRange/5.0));
  for(int i = 0; i < le2Count; i++) contents[7 + cellCount + al1Count + al2Count + al3Count + le1Count + i] = new Content(al1, cellSize/5.0 + random(-randomRange/5.0, randomRange/5.0));
  for(int i = 0; i < plaCount; i++) contents[7 + cellCount + al1Count + al2Count + al3Count + le1Count + le2Count + i] = new Content(al1, cellSize + random(-randomRange, randomRange));
  
  for(int i = 0; i < cellN; i++){
    contents[i].setup(random(-200, 200),random(-200, 200));
  }
  
  size(960, 540);
  background(255);
  image(kekkan, 0, 0);
  base = get();
  isImage = false;
  isUp = false;
  preUp = false;
  upCount = 0;
 
  minim = new Minim(this);
  player = minim.loadFile("se_maoudamashii_se_heartbeat01.mp3", 1024);
  player.play();
  fft = new FFT(player.bufferSize(), player.sampleRate());
}
 
void draw()
{
  if(player.isPlaying() == false){
    frameCount = 0;
    for(int i = 0; i < cellN; i++){
      contents[i].setup(random(-200, 200),random(-200, 200));
    }
    isImage = false;
    isUp = false;
    preUp = false;
    upCount = 0;
    player.rewind();
    player.play();
  }
 
  background(255);
  imageMode(CORNER);
  image(kekkan, 0, 0);
 
  fft.forward(player.mix);
 
  float max = 0.0;
  for(int i = 0; i < fft.specSize() - 1; i++)
  {
    max += fft.getBand(i);
  }
  if(max/fft.specSize() > 0.075){
    isUp = true;
  }else{
    isUp = false;
  }
  if(isUp == true && preUp == false){
    upCount++;
  }
  if(upCount == 1){
    isImage = true;
  }
  if(isImage == true){
    for(int i = 0; i < cellN; i++){
      contents[i].draw(frameCount/50.0);
    }
  }
  preUp = isUp;
}
 
void stop()
{
  player.close();
  minim.stop();
  super.stop();
}