final int PREV_PG_MAX_WIDTH  = 1000;
final int PREV_PG_MAX_HEIGHT =  600;
final int DROP_IMG_DELAY     =  500;

PGraphics   previewPG;
PImage         srcImg;

PixelArtGenerator PAG;
UIManager         UIM;
SDrop            drop;

void setup() {
  size(1280, 720);
  imageMode(CENTER);
  previewPG = createGraphics(PREV_PG_MAX_WIDTH, PREV_PG_MAX_HEIGHT);

  drop = new SDrop(this);

  PAG = new PixelArtGenerator();

  UIM = new UIManager(this);
}

void draw() {
  background(27);

  UIM.renderPrevPG();
}
