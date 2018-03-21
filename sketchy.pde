  import java.util.Map;

PImage[] glyphs;

color B = color(0);
color W = color(255);
PGraphics bg;

int sf = 2;
int[] dfile;

int ascii2zeddy(char ascii) {
  String zeddycs = " ??????????\"£$:?()><=+-*/;,.0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  String s = new String();
  s += ascii;
  s = s.toUpperCase();
  return zeddycs.indexOf(s);
}

void setup() {
  size(512, 384);
  noSmooth();

  dfile = new int[32*24];

  bg = createGraphics(256, 192);
  bg.beginDraw();
  bg.background(255);
  bg.fill(240);
  bg.noStroke();
  for (int y = 0; y < 24; ++y) {
    boolean b = (y & 1) != 0;
    for (int x = 0; x < 32; ++x) {
      if (b) {
        bg.rect(x * 8, y * 8, 8, 8);
      }
      b = !b;
    }
  }
  bg.endDraw();

  byte[] font = loadBytes("data/zx81.fnt");

  glyphs = new PImage[256];

  for (int bo = 0, i = 0; i < 64; ++i) {
    PImage glyph = new PImage(8, 8);
    PImage iglyph = new PImage(8, 8);
    glyph.loadPixels();
    iglyph.loadPixels();
    for (int n = 0, j = 0; j < 8; j ++) {
      byte b = font[bo++];
      glyph.pixels[n] = (b & 0x80) != 0 ? B : W;
      iglyph.pixels[n++] = (b & 0x80) != 0 ? W : B;
      glyph.pixels[n] = (b & 0x40) != 0 ? B : W;
      iglyph.pixels[n++] = (b & 0x40) != 0 ? W : B;
      glyph.pixels[n] = (b & 0x20) != 0 ? B : W;
      iglyph.pixels[n++] = (b & 0x20) != 0 ? W : B;
      glyph.pixels[n] = (b & 0x10) != 0 ? B : W;
      iglyph.pixels[n++] = (b & 0x10) != 0 ? W : B;
      glyph.pixels[n] = (b & 0x08) != 0 ? B : W;
      iglyph.pixels[n++] = (b & 0x08) != 0 ? W : B;
      glyph.pixels[n] = (b & 0x04) != 0 ? B : W;
      iglyph.pixels[n++] = (b & 0x04) != 0 ? W : B;
      glyph.pixels[n] = (b & 0x02) != 0 ? B : W;
      iglyph.pixels[n++] = (b & 0x02) != 0 ? W : B;
      glyph.pixels[n] = (b & 0x01) != 0 ? B : W;
      iglyph.pixels[n++] = (b & 0x01) != 0 ? W : B;
    }
    glyph.updatePixels();
    glyphs[i] = glyph;

    iglyph.updatePixels();
    glyphs[i+128] = iglyph;
  }
}


void draw() {
  image(bg, 0, 0, width, height);
  for (int i = 0; i < dfile.length; ++i) {
    if (dfile[i] != 0) {
      image(glyphs[dfile[i]], 8 * (i % 32) * sf, 8 * (i / 32) * sf, 8 * sf, 8 * sf);
    }
  }
}


void mouseClicked() {
  int[] bits = {1,2,4};

  int cx = mouseX / sf / 8;
  int cy = mouseY / sf / 8;
  int scx = (mouseX / sf / 4) & 1;
  int scy = (mouseY / sf / 4) & 1;
  println(cx, cy, scx, scy);
  if (scx == 1 && scy == 1) {
    dfile[cx + 32 * cy] = 7 - dfile[cx + 32 * cy] + 128;
  }
  else {
    dfile[cx + 32 * cy] ^= bits[scx + 2 * scy];
  }
}