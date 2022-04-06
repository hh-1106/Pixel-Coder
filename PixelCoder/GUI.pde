import controlP5.*;

class UIManager {

  ControlP5               cp5;
  Textlabel  labelColsAndRows;
  Slider      sliderPixelSize;
  Toggle        toggleUseBack;

  UIManager(PApplet app) {
    cp5 = new ControlP5(app);

    cp5.setColor( new CColor(
      color(95)             // fg
      , color(50)           // bg
      , color(255, 154, 0)  // active
      , color(220)          // label
      , color(255)          // vl
      ));

    Group g1 = cp5.addGroup("settings");
    {
      g1.setHeight(16).setSize(190, 250).setPosition(10, 30)
        .setBackgroundColor(color(38))
        .getCaptionLabel().align(CENTER, CENTER)
        ;

      float py = 5;

      cp5.addToggle("stroke").setGroup(g1)
        .setPosition(10, py+=10)
        .setSize(75, 25)
        .plugTo(this, "onToggleStroke")
        .getCaptionLabel().align(CENTER, CENTER)
        ;

      cp5.addToggle("fill r").setGroup(g1)
        .setPosition(105, py)
        .setSize(75, 25)
        .setValue(AC.bFillR)
        .plugTo(this, "onToggleFillR")
        .getCaptionLabel().align(CENTER, CENTER)
        ;

      toggleUseBack = cp5.addToggle("use back").setGroup(g1);
      toggleUseBack.setPosition(10, py+=35)
        .setSize(75, 25)
        .setValue(AC.bUseBackground)
        .plugTo(this, "onToggleUseBack")
        .getCaptionLabel().align(CENTER, CENTER)
        ;

      cp5.addToggle("use for").setGroup(g1)
        .setPosition(105, py)
        .setSize(75, 25)
        .setValue(AC.bUseForLoop)
        .plugTo(this, "onToggleUseFor")
        .getCaptionLabel().align(CENTER, CENTER)
        ;


      cp5.addSlider("pixelate").setGroup(g1)
        .setPosition(10, py+=45)
        .setSize(120, 14)
        .setRange(8, 128).setValue(PAG.scl)
        .plugTo(this, "onPixelateChange")
        ;

      labelColsAndRows = cp5.addTextlabel("label").setGroup(g1)
        .setPosition(8, py+=20)
        .setText("COLS : --" + "    " + "ROWS : --")
        .setColor(color(20, 115, 230))
        ;


      sliderPixelSize = cp5.addSlider("pixel size").setGroup(g1)
        .setPosition(10, py+=30)
        .setSize(120, 14)
        .setRange(5, 100).setValue(AC.pixelSize)
        .plugTo(this, "onPixelSizeChange")
        ;


      cp5.addButton("generate code").setGroup(g1)
        .setSize(170, 35)
        .setPosition(10, py+=40)
        .setColorLabel(color(255, 154, 0))
        .plugTo(this, "onGenerateCodeButton");
    }
  }

  void onPixelateChange(int val) {
    PAG.pixelate( previewPG, srcImg, val );
    labelColsAndRows.setValueLabel( PAG.getColsAndRows() );
  }

  void onPixelSizeChange(int val) {
    int maxSize = floor(MAX_GENERATE_WIDTH / (float)PAG.cols);
    if (val > maxSize) {
      val = maxSize;
      sliderPixelSize.setValue(val);
    }

    AC.pixelSize = val;
  }

  void onGenerateCodeButton() {
    AC.generateCode( srcImg );
  }

  void onToggleStroke(boolean val) {
    PAG.bStroke = val;
    PAG.pixelate();
  }

  void onToggleUseBack(boolean val) {
    AC.bUseBackground = val;

    // TODO:
    // useBack should not be off while useFor on
  }

  void onToggleUseFor(boolean val) {
    AC.bUseForLoop = val;

    if (val) {
      toggleUseBack.setValue(true);
      AC.bUseBackground = true;
    }
  }

  void onToggleFillR(boolean val) {
    AC.bFillR = val;
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

    image(previewPG, 0, 0, prevW, prevH);
    rect(0, 0, prevW+2, prevH+2);

    pop();
  }
}
