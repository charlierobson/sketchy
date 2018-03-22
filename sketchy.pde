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
  background(200);
  image(dfile.render(), 0, 0, 256 * sf, 192 * sf);
  
  fill(0);
  text(ctrl ? "Draw mode: PLOT" : "Draw mode: CHAR", 8, 400);
}


void updateBit(int mode) {
  int scx = Math.max(Math.min(mouseX / sf / 4, 63), 0);
  int scy = Math.max(Math.min(mouseY / sf / 4, 47), 0);
  dfile.plot(scx, scy, mode);
}


int mode;
boolean ctrl;

void mousePressed() {
  int scx = Math.max(Math.min(mouseX / sf / 4, 63), 0);
  int scy = Math.max(Math.min(mouseY / sf / 4, 47), 0);
  mode = dfile.pleek(scx, scy) ? DFile.RESET : DFile.SET;
}

void mouseDragged() {
  if (ctrl) updateBit(mode);
}

void mouseClicked() {
  if (ctrl) {
    updateBit(DFile.XOR);
  }
}

void keyPressed() {
  ctrl = key==CODED && keyCode == CONTROL;
}

void keyReleased() {
  ctrl = !(key==CODED && keyCode == CONTROL);
}