final int PREV_PG_MAX_WIDTH  = 1000;
final int PREV_PG_MAX_HEIGHT =  600;

PGraphics previewPG;
PImage       srcImg;


PixelArtGenerator PAG;
UIManager         UIM;

void setup() {
  size(1280, 720, P2D);

  imageMode(CENTER);

  srcImg = loadImage("wallhaven-4753j3.jpg");
  previewPG = createGraphics(srcImg.width, srcImg.height, P2D);

  PAG = new PixelArtGenerator();

  UIM = new UIManager(this);

  UIM.onPixelateChange( PAG.scl );
}

void draw() {
  background(27);

  renderPrevPG();
}

void renderPrevPG() {
  float prevW = PREV_PG_MAX_WIDTH;
  float prevH = prevW * previewPG.height / (float)previewPG.width;
  if (prevH > PREV_PG_MAX_HEIGHT) {
    prevH = PREV_PG_MAX_HEIGHT;
    prevW = prevH * previewPG.width / (float)previewPG.height;
  }

  push();
  rectMode(CENTER);
  translate(740, 360);
  noFill();
  stroke(38, 128, 235);
  strokeWeight(3);
  rect(0, 0, prevW, prevH);

  image(previewPG, 0, 0, prevW, prevH);

  pop();
}
