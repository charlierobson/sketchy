class DFile
{
  int[] _dfile;
  Font _font;
  PGraphics _bg;

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
/*
GET_BLOCK:
  LD      A,$01        
        SRA     C              
        JR      NC,EVEN_Y

        LD      A,$04


EVEN_Y: SRA     B          
        JR      NC,EVEN_X  

        RLCA      ; 1 OR 4 BECOMES 2 OR 8                

EVEN_X:
  LD  B,A    ;SAVE the new pixwl block in b

  LD   A,(HL)    ;GET BYTE FROM SCREEN
  RLCA
  CP  16
  JR  NC,A_ZERO
  RRCA
  JR  NC,GOOD_CHAR
  XOR  $8F    ;ELSE INVERTED CHAR
  JR  GOOD_CHAR
A_ZERO:
  XOR  A
GOOD_CHAR:
  RET
  */
  void plot(int x, int y, int mode) {
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