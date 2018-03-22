class DFile
{
  int[] _dfile;
  Font _font;
  PGraphics _bg;

  public static final int RESET = 0;
  public static final int SET = 1;
  public static final int XOR = 2;

  DFile(Font font) {
    _font = font;
    cls();
    _bg = createGraphics(256, 192);
  }

  void cls() {
    _dfile = new int[32*24];
  }

  int get(int x, int y) {
    return _dfile[x + 32 * y];
  }

  void set(int x, int y, int c) {
    _dfile[x + 32 * y] = c;
  }

  void plot(int x, int y, int mode) {
    int b = (y & 1) == 0 ? 1 : 4;
    if ((x & 1) != 0) {
      b *= 2;
    }

    int c = _dfile[x / 2 + (y / 2) * 32];
    if ((c & 127) > 8) {
      c = 0;
    }
    if (c > 127) {
      c ^= 0x8f;
    }

    if (mode == 0) {
      c = (~b) & c;
    } else if (mode == 1) {
      c |= b;
    } else {
      c = c ^ b;
    }
    if (c > 7) {
      c ^= 0x8f;
    }
    _dfile[x / 2 + (y / 2) * 32] = c;
  }

  boolean pleek(int x, int y) {
    int b = (y & 1) == 0 ? 1 : 4;
    if ((x & 1) != 0) {
      b *= 2;
    }

    int c = _dfile[x / 2 + (y / 2) * 32];
    if ((c & 127) > 8) {
      c = 0;
    }
    if (c > 127) {
      c ^= 0x8f;
    }

    return (c & b) != 0;
  }

  PImage render() {
    _bg.beginDraw();
    _bg.background(240);
    _bg.fill(225);
    _bg.noStroke();
    for (int y = 0; y < 24; ++y) {
      boolean b = (y & 1) != 0;
      for (int x = 0; x < 32; ++x) {
        if (_dfile[x + (32 * y)] != 0) {
          _bg.image(_font.character(_dfile[x + (32 * y)]), x * 8, y * 8);
        } else if (b) {
          _bg.rect(x * 8, y * 8, 8, 8);
        }
        b = !b;
      }
    }
    _bg.endDraw();

    return _bg;
  }
}