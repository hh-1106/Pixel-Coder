import java.io.FileWriter;
import java.util.Iterator;
import java.util.Map;


class AutoCoder {
  String filePath = sketchPath("sketch");
  String fileName = "sketch.pde";
  File       file;
  PImage     _img;

  int   pixelSize = 20;
  boolean bUseBackground = true;
  boolean bUseForLoop = true;
  boolean bFillR = true;

  AutoCoder() {
    File path = new File(filePath);
    if (!path.exists()) {
      path.mkdirs();
    }

    file = new File(filePath + "\\" + fileName);
    try {
      if (!file.exists()) {
        file.createNewFile();
      }
    }
    catch (Exception e) {
      e.printStackTrace();
    }
  }

  void generateCode(PImage img) {
    this._img = img;

    if (bUseForLoop) {
      generateCodeUseForLoop( pixelSize );
    } else if (bUseBackground) {
      generateCodeUseBackground( pixelSize );
    } else {
      generateCode( pixelSize );
    }
  }

  void generateCodeUseForLoop(int a) {
    if (_img == null) return;

    int w = PAG.cols * a;
    int h = PAG.rows * a;
    _img.loadPixels();
    color bgCol   = getBackCol();
    int br = (bgCol >> 16) & 0xFF;
    int bg = (bgCol >> 8) & 0xFF;
    int bb = bgCol & 0xFF;

    try {
      FileWriter out = new FileWriter(file);

      String strokeLine = PAG.bStroke ?"" :"\n  noStroke();";
      String setup = "void setup() {"
        + String.format("\n  size(%d, %d);", w, h)
        + String.format("\n  background(%d, %d, %d);", br, bg, bb)
        + strokeLine
        + "\n"
        ;
      out.write( setup );

      for (int j=0; j<PAG.rows; j++) {
        int y = j * a;
        boolean skip = false;

        int forStart = 0;
        int forEnd   = 0;
        boolean bInForloop = false;
        String forloopCode = "";

        color nextCol = _img.get(0, j*PAG.scl);
        for (int i=0; i<PAG.cols; i++) {
          int x = i * a;
          color col = nextCol;

          if (i == PAG.cols-1)
            nextCol = -1;
          else
            nextCol = _img.get((i+1)*PAG.scl, j*PAG.scl);

          if ( col == bgCol ) {
            forStart = i+1;

            if (PAG.bStroke) {
              String fillColor = getFillColor(col);
              out.write( "\n  " );
              out.write( fillColor );
              String drawRect  = String.format("rect(%d, %d, %d, %d);", x, y, a, a);
              out.write( "\n  " );
              out.write( drawRect );
            }
            continue;
          } else skip = true;

          if ( nextCol == col ) {
            forEnd = i;
            bInForloop = true;
          } else {
            String fillColor = getFillColor(col);
            out.write( "\n  " );
            out.write( fillColor );

            // for loop rects
            if (bInForloop) {
              forEnd = i+1;
              forloopCode = String.format(
                "for (int x = %d; x < %d; x += %d) {\n" +
                "    rect(x, %d, %d, %d);\n" +
                "  }"
                , forStart*a, forEnd*a, a, y, a, a);

              out.write( "\n  " );
              out.write( forloopCode );
            }
            // single rect
            else {
              String drawRect  = String.format("rect(%d, %d, %d, %d);", x, y, a, a);
              out.write( "\n  " );
              out.write( drawRect );
            }
            forStart = i+1;
            bInForloop = false;
            forloopCode = "";
          }
        }

        if (skip) {
          out.write( "\n" );
        }
      }

      out.write( "\n}" );
      out.close();
    }
    catch(Exception e) {
      e.printStackTrace();
    }
  }

  void generateCodeUseBackground(int a) {
    if (_img == null) return;

    int w = PAG.cols * a;
    int h = PAG.rows * a;

    _img.loadPixels();

    color bgCol   = getBackCol();
    color lastCol = -1;
    int br = (bgCol >> 16) & 0xFF;
    int bg = (bgCol >> 8) & 0xFF;
    int bb = bgCol & 0xFF;

    try {
      FileWriter out = new FileWriter(file);

      String strokeLine = PAG.bStroke ?"" :"\n  noStroke();";

      String setup = "void setup() {"
        + String.format("\n  size(%d, %d);", w, h)
        + String.format("\n  background(%d, %d, %d);", br, bg, bb)
        + strokeLine
        + "\n"
        ;
      out.write( setup );

      for (int j=0; j<PAG.rows; j++) {
        int y = j * a;
        boolean skip = false;
        for (int i=0; i<PAG.cols; i++) {
          int x = i * a;
          color col = _img.get(i*PAG.scl, j*PAG.scl);

          if ( col == bgCol ) {
            continue;
          } else {
            skip = true;
          }

          String fillColor = getFillColor(col);
          String drawRect  = String.format("rect(%d, %d, %d, %d);", x, y, a, a);

          if ( lastCol != col ) {
            out.write( "\n  " );
            out.write( fillColor );
          }
          out.write( "\n  " );
          out.write( drawRect );

          lastCol = col;
        }
        if (skip) out.write( "\n" );
      }

      out.write( "\n}" );
      out.close();
    }
    catch(Exception e) {
      e.printStackTrace();
    }
  }

  void generateCode(int a) {
    if (_img == null) return;

    int w = PAG.cols * a;
    int h = PAG.rows * a;

    _img.loadPixels();
    color lastCol = -1;

    try {
      FileWriter out = new FileWriter(file);

      String strokeLine = PAG.bStroke ?"" :"\n  noStroke();";

      String setup = "void setup() {"
        + String.format("\n  size(%d, %d);", w, h)
        + strokeLine
        + "\n"
        ;
      out.write( setup );

      for (int j=0; j<PAG.rows; j++) {
        int y = j * a;
        for (int i=0; i<PAG.cols; i++) {
          int x = i * a;
          color col = _img.get(i*PAG.scl, j*PAG.scl);

          String fillColor = getFillColor(col);
          String drawRect  = String.format("rect(%d, %d, %d, %d);", x, y, a, a);

          if ( lastCol != col ) {
            out.write( "\n  " );
            out.write( fillColor );
          }
          out.write( "\n  " );
          out.write( drawRect );

          lastCol = col;
        }
      }

      out.write( "\n}" );
      out.close();
    }
    catch(Exception e) {
      e.printStackTrace();
    }
  }

  color getBackCol() {
    PImage src = _img.copy();

    HashMap<Integer, Integer> colors = new HashMap<Integer, Integer>();

    src.loadPixels();

    for (int j=0; j<PAG.rows; j++) {
      for (int i=0; i<PAG.cols; i++) {
        color col = src.get(i*PAG.scl, j*PAG.scl);

        if (colors.containsKey( col )) {
          int count = colors.get( col );
          count++;
          colors.remove(col);
          colors.put(col, count);
        } else {
          colors.put(col, 1);
        }
      }
    }

    Iterator iter = colors.entrySet().iterator();
    int count = 0;
    int bcol = 0;
    while (iter.hasNext()) {
      Map.Entry entry = (Map.Entry) iter.next();
      int value = (int) entry.getValue();
      if (count < value) {
        count = value;
        bcol = (int)entry.getKey();
      }
    }

    int r = (bcol >> 16) & 0xFF;
    int g = (bcol >> 8) & 0xFF;
    int b = bcol & 0xFF;

    return color(r, g, b);
  }

  String getFillColor(color col) {
    int r = (col >> 16) & 0xFF;
    int g = (col >> 8) & 0xFF;
    int b = col & 0xFF;
    String fillColor = "";

    if (bFillR && r==g && r==b)
      fillColor = String.format("fill(%d);", r);
    else
      fillColor = String.format("fill(%d, %d, %d);", r, g, b);
    return fillColor;
  }
}
