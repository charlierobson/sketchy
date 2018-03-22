import controlP5.*;
ControlP5 cp5;

DFileZX81 dfile;

int mode;
boolean ctrl;

int sf = 2;
int scnx = 4;
int scny = 4;


int mx() {
  int mx = (mouseX - scnx) / sf / 8;
  return Math.max(Math.min(mx, 31), 0);
}

int my() {
  int my = (mouseY - scny) / sf / 8;
  return Math.max(Math.min(my, 23), 0);
}

int mxhr() {
  int mx = (mouseX - scnx) / sf / 4;
  return Math.max(Math.min(mx, 63), 0);
}

int myhr() {
  int my = (mouseY - scny) / sf / 4;
  return Math.max(Math.min(my, 47), 0);
}



void setup() {
  size(800, 600);
  noSmooth();

  cp5 = new ControlP5(this);

  dfile = new DFileZX81();

  cp5.addButton("load").setPosition(10, 450).setSize(100, 20);
  cp5.addButton("save").setPosition(150, 450).setSize(100, 20);
}

public void load() {
  selectInput("Select a file to load from:", "fileSelectedLoad");
}

void fileSelectedLoad(File selection) {
  if (selection != null) {
    dfile.load(selection.getAbsolutePath());
  }
}

public void save() {
  selectOutput("Select a file to write to:", "fileSelectedSave");
}

void fileSelectedSave(File selection) {
  if (selection != null) {
    dfile.save(selection.getAbsolutePath());
  }
}


void draw() {
  background(200);
  image(dfile.render(), scnx, scny, 256 * sf, 192 * sf);

  fill(0);
  text(ctrl ? "Draw mode: PLOT" : "Draw mode: CHAR", 8, 400);
  if (!ctrl) {
    noFill();
    stroke((millis() & 512) == 512 ? color(128, 0, 0) : color(0, 128, 0));

    rect((dfile.cursorx() * 8 * sf) + scnx-1, (dfile.cursory() * 8 * sf) + scny-1, 8 * sf + 1, 8 * sf + 1);
  }
}


void updateBit(int mode) {
  dfile.plot(mxhr(), myhr(), mode);
}

boolean mouseInZeddyScreen() {
  return mouseX >= scnx &&
    mouseX < scnx + 512 &&
    mouseY >= scny &&
    mouseY < scny + 384;
}

void mousePressed() {
  if (mouseInZeddyScreen()) {
    mode = dfile.pleek(mxhr(), myhr()) ? DFileZX81.RESET : DFileZX81.SET;
  }
}

int selrectx, selrecty, selrectw, selrecth;

void mouseDragged() {
  if (ctrl) { 
    updateBit(mode);
  } else {
    selrectw = Math.abs(dfile.cursorx() - mx()) + 1;
    selrecth = Math.abs(dfile.cursory() - my()) + 1;
    selrectx = Math.min(dfile.cursorx(), mx());
    selrecty = Math.min(dfile.cursory(), my());
    println(selrectx, selrecty, selrectw, selrecth);
  }
}


void mouseClicked() {
  if (!mouseInZeddyScreen()) return;

  if (ctrl) {
    updateBit(DFileZX81.XOR);
  } else {
    dfile.setcurpos(mx(), my());
  }
}


void keyPressed() {
  ctrl = key==CODED && keyCode == CONTROL;
  if (ctrl) return;

  if (key == CODED) return;

  if (key == BACKSPACE) {
    dfile.cursorback();
    dfile.putc(' ');
    dfile.cursorback();
    return;
  }

  dfile.putc(key);
}


void keyReleased() {
  if (key==CODED && keyCode == CONTROL) {
    ctrl = false;
  }
}