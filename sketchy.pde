import java.util.Map;

Font zx81font;
DFile dfile;
int sf = 2;

void setup() {
  size(800, 600);
  noSmooth();

  zx81font = new Font("data/zx81.fnt");
  dfile = new DFile(zx81font);
}


void draw() {
  image(dfile.render(), 0, 0, 256 * sf, 192 * sf);
}


void updateBit(int mode) {
  int scx = mouseX / sf / 4;
  int scy = mouseY / sf / 4;
  dfile.plot(scx, scy, mode);
}

void mouseDragged() {
  updateBit(1); // set
}

void mouseClicked() {
  updateBit(2); // xor
}