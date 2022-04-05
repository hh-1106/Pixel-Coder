class PixelArtGenerator {

  int cols = 10;
  int rows = 10;
  int  scl = 20;

  boolean bStroke = false;

  PGraphics  _pg;
  PImage    _img;

  PixelArtGenerator() {
  }

  String getColsAndRows() {
    return "COLS : " + cols + "    " + "ROWS : " + rows + "    " + "TOTAL : " + cols*rows;
  }

  void pixelate(PGraphics pg, PImage img, int scl) {
    this._pg = pg;
    this._img = img;
    this.scl = scl;

    pixelate();
  }

  void pixelate() {
    if (_img == null) return;

    int w = _img.width;
    int h = _img.height;

    cols = floor(w / scl);
    rows = floor(h / scl);

    _img.loadPixels();
    _pg.beginDraw();
    _pg.clear();
    _pg.strokeWeight(1);

    if (bStroke) {
      _pg.stroke(0);
    } else {
      _pg.noStroke();
    }

    _pg.rectMode(CORNER);

    for (int j=0; j<h; j+=scl) {
      for (int i=0; i<w; i+=scl) {
        color col = _img.get(i, j);
        _pg.fill(col);
        _pg.rect(i, j, scl, scl);
      }
    }

    _pg.endDraw();
  }
}
