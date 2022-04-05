import java.io.FileWriter;
import java.util.Iterator;
import java.util.Map;


class AutoCoder {
  String filePath = sketchPath("sketch");
  String fileName = "sketch.pde";
  File       file;
  PImage     _img;

  int   pixelSize = 10;
  boolean bUseBackground = true;

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

    if (bUseBackground) {
      generateCodeUseBackground( pixelSize );
    } else {
      generateCode( pixelSize );
    }
  }

  void generateCodeUseBackground(int a) {
    if (_img == null) return;

    int w = PAG.cols * a;
    int h = PAG.rows * a;

    _img.loadPixels();

    color bgCol   = getBackCol(_img, a);
    color lastCol = -1;
    int br = (bgCol >> 16) & 0xFF;
    int bg = (bgCol >> 8) & 0xFF;
    int bb = bgCol & 0xFF;

    try {
      FileWriter out = new FileWriter(file);

      String setup = "void setup() {"
        + String.format("\n  size(%d, %d);", w, h)
        + String.format("\n  background(%d, %d, %d);", br, bg, bb)
        + "\n  noStroke();"
        + "\n"
        ;
      out.write( setup );

      for (int j=0; j<h; j+=a) {
        boolean skip = false;
        for (int i=0; i<w; i+=a) {
          color col = _img.get(i, j);

          if ( col == bgCol ) {
            continue;
          } else {
            skip = true;
          }

          int r = (col >> 16) & 0xFF;
          int g = (col >> 8) & 0xFF;
          int b = col & 0xFF;

          String fillColor = String.format("fill(%d, %d, %d);", r, g, b);
          String drawRect  = String.format("rect(%d, %d, %d, %d);", i, j, a, a);

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

      String setup = "void setup() {"
        + String.format("\n  size(%d, %d);", w, h)
        + "\n  noStroke();"
        + "\n"
        ;
      out.write( setup );

      for (int j=0; j<h; j+=a) {
        boolean skip = false;
        for (int i=0; i<w; i+=a) {
          color col = _img.get(i, j);

          int r = (col >> 16) & 0xFF;
          int g = (col >> 8) & 0xFF;
          int b = col & 0xFF;

          String fillColor = String.format("fill(%d, %d, %d);", r, g, b);
          String drawRect  = String.format("rect(%d, %d, %d, %d);", i, j, a, a);

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

  color getBackCol(PImage img, int a) {
    PImage src = img.copy();
    int w = src.width;
    int h = src.height;

    HashMap<Integer, Integer> colors = new HashMap<Integer, Integer>();

    src.loadPixels();
    float off = a*0.5;

    for (int j=0; j<h; j+=a) {
      int y = round(j + off);
      for (int i=0; i<w; i+=a) {
        int x = round(i + off);

        color col = src.get(x, y);

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
}
