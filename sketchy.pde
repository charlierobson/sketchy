import java.util.Map;

Font zx81font;
DFile dfile;
int sf = 2;
int scnx = 4;
int scny = 4;
int cursorx = 0;
int cursory = 0;
boolean cursoron = true;

void setup() {
  size(800, 600);
  noSmooth();

  zx81font = new Font("data/zx81.fnt");
  dfile = new DFile(zx81font);
}


void draw() {
  background(200);
  image(dfile.render(), scnx, scny, 256 * sf, 192 * sf);
  
  fill(0);
  text(ctrl ? "Draw mode: PLOT" : "Draw mode: CHAR", 8, 400);
  if (cursoron) {
    noFill();
    stroke((millis() & 512) == 512 ? color(128,0,0) : color(0,128,0));
    
    rect((cursorx * 8 * sf) + scnx-1, (cursory * 8 * sf) + scny-1, 8 * sf + 1, 8 * sf + 1);
  }
}


void updateBit(int mode) {
  int scx = Math.max(Math.min(mx(), 63), 0);
  int scy = Math.max(Math.min(my(), 47), 0);
  dfile.plot(scx, scy, mode);
}


int mode;
boolean ctrl;

void mousePressed() {
  int scx = Math.max(Math.min(mx(), 63), 0);
  int scy = Math.max(Math.min(my(), 47), 0);
  mode = dfile.pleek(scx, scy) ? DFile.RESET : DFile.SET;
}

void mouseDragged() {
  if (ctrl) updateBit(mode);
}

int mx() {
  int mx = (mouseX - scnx) / sf / 8;
  return Math.max(Math.min(mx, 31), 0);
}

int my() {
  int my = (mouseY - scny) / sf / 8;
  return Math.max(Math.min(my, 23), 0);
}

void mouseClicked() {
  if (ctrl) {
    updateBit(DFile.XOR);
  } else {
    cursorx = mx();
    cursory = my();
  }
}


  int ascii2zeddy(char ascii) {
    String zeddycs = " ??????????\"£$:?()><=+-*/;,.0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    String s = new String();
    s += ascii;
    s = s.toUpperCase();
    return zeddycs.indexOf(s);
  }
  

void keyPressed() {
  ctrl = key==CODED && keyCode == CONTROL;
  if (ctrl) return;

  if (key == CODED) return;

  dfile.set(cursorx, cursory, ascii2zeddy(key));
  cursorx++;
  if (cursorx == 32) {
    cursorx = 0;
    cursory ++;
    if (cursory == 24) {
      cursory = 0;
    }
  }
}

void keyReleased() {
  if(key==CODED && keyCode == CONTROL) {
    ctrl = false;
  }
}