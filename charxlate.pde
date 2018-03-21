class Charxlate
{
  Charxlate() {
  }

  int ascii2zeddy(char ascii) {
    String zeddycs = " ??????????\"£$:?()><=+-*/;,.0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    String s = new String();
    s += ascii;
    s = s.toUpperCase();
    return zeddycs.indexOf(s);
  }
}