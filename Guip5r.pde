
public class Slider {

  public float x, y, w, h;
  public float value;

  public float min, max;

  public color backcolor;
  public color topcolor;

  public int textSize;

  public boolean isActivable;

  public boolean showvalues;
  public boolean showname;

  String name;

  Slider(float _x, float _y, float _w, float _h, float _min, float _max, float _value, String _name) {

    x =_x;
    y =_y;
    w = _w;
    h = _h;
    name = _name;

    backcolor = colors[2];
    topcolor = colors[3];

    /*Color_active = color(120, 150, 255);
     Color_mouseover = color(120, 150, 160);
     Color_standart = color(120, 150, 120);*/

    min = _min;
    max = _max;
    value = _value;

    textSize = 14;
    isActivable = true;
    showname = true;
    showvalues = false;
  }

  Slider(float _x, float _y, float _w, float _h, float _min, float _max, float _value) {

    x =_x;
    y =_y;
    w = _w;
    h = _h;

    backcolor = colors[2];
    topcolor = colors[3];

    /*Color_active = color(120, 150, 255);
     Color_mouseover = color(120, 150, 160);
     Color_standart = color(120, 150, 120);*/

    min = _min;
    max = _max;
    value = _value;

    textSize = 10;
    isActivable = true;
    showname = false;
    showvalues = true;
  }

  Slider(float _x, float _y, float _w, float _h) {

    x =_x;
    y =_y;
    w = _w;
    h = _h;

    backcolor = color(255, 150, 180);
    topcolor = color(255, 100, 255);

    min = 0;
    max = 255;
    value = random(min, max);

    textSize = 10;
    isActivable = true;
    showname = false;
    showvalues = true;
  }

  public void run() {
    display();
    checkinput();
  }

  public void display() {
    strokeCap(ROUND);
    rectMode(CENTER);
    fill(backcolor);
    rect(x, y, w, h);
    fill(topcolor);
    rectMode(CORNERS);
    rect(x-w/2, y-h/2, map(value, min, max, x-w/2, x+w/2), y+h/2 );
    fill(255, 0, 0);
    rectMode(CENTER);

    if (showvalues) {
      textSize(textSize);
      textAlign(LEFT);
      text(min, x-w/2, y);
      textAlign(RIGHT);
      text(max, x+w/2, y);
      textAlign(CENTER);
      text(value, x, y);
    }

    if (showname) {
      text(name, x, y);
    }
  }

  public void checkinput() {
    if (isActivable) {
      if (mousePressed 
        && mouseX > x - w/2
        && mouseX < x + w/2
        && mouseY > y - h/2
        && mouseY < y + h/2) {
        value = map(mouseX, x-w/2, x+w/2, min, max);
      }
    }
  }

  public void setpos(float _x, float _y) {
    x = _x;
    y = _y;
  }

  boolean isMouseOverSlider() {
    if (mousePressed  && mouseX > x - w/2&& mouseX < x + w/2&& mouseY > y - h/2&& mouseY < y + h/2) {

      return true;
    } else {
      return false;
    }
  }

  boolean isPressed() {
    if (mousePressed && isMouseOverSlider()) {
      return true;
    } else {
      return false;
    }
  }
}

class slidergroup {

  ArrayList<Slider> sliders;

  slidergroup() {
    sliders = new ArrayList<Slider>();
  }

  void addSlider(float _x, float _y, float _w, float _h, float _min, float _max, float _value) {
    sliders.add(new Slider(_x, _y, _w, _h, _min, _max, _value));
  }
  void addSlider(float _x, float _y, float _w, float _h, float _min, float _max, float _value, String _name) {
    sliders.add(new Slider(_x, _y, _w, _h, _min, _max, _value, _name));
  }

  void run() {
    display();
    checkinput();
  }

  void display() {
    for (Slider p : sliders) {
      p.display();
    }
  }

  void checkinput() {
    for (Slider p : sliders) {
      p.checkinput();
    }
  }

  //Detecta si esta apretando cualquiera de todos los sliders

  boolean isSliderPressed() {
    
    boolean ispressed = false;
    for (Slider p : sliders) {
      if (mousePressed && p.isMouseOverSlider()) {
        ispressed = true;
      } 
    }
    if(ispressed){
     return true; 
    }
    else {
     return false; 
    }
  }
}


class QuadElement {

  public float x;
  public float y;
  public float w;
  public float h;

  public boolean isActive = false;
  public boolean isActivable = true; //variable to set if it can be active or not.

  public color Color_active;
  public color Color_mouseover;
  public color Color_standart;

  public boolean isShape = false;
  public PShape displayshape ;


  public boolean mouseFlag;

  QuadElement(float _x, float _y, float _w, float _h) {

    x = _x;
    y = _y;
    w = _w;
    h = _h;

    rectMode(CENTER);

    Color_active = color(120, 150, 255);
    Color_mouseover = color(120, 150, 160);
    Color_standart = color(120, 150, 120);

    displayshape = createShape();
    displayshape.beginShape();
    displayshape.vertex(w/2, -w/2 );
    displayshape.vertex(-w/2, -w/2 );
    displayshape.vertex(-w/2, w/2);
    displayshape.vertex(w/2, w/2);

    displayshape.endShape(CLOSE);
    displayshape.disableStyle();
  }

  public void run() {
    display();
    checkinput();
  }

  public void display() {

    if (isActive && isActivable) {
      stroke(Color_active);
      fill(Color_active);
    } else {
      if (isMouseOver()) {
        stroke(Color_mouseover);
        fill(Color_mouseover);
      } else {
        stroke(Color_standart);
        fill(Color_standart);
      }
    }

    displayShape();
    stroke(0);
    noStroke();
  }

  protected void displayShape() {
    if (isShape) {
      shapeMode(CORNER);
      //fill(150, 255, 255);
      shape(displayshape, x, y);
    } else {
      rect(x, y, w, h);
    }
  }

  public void checkinput() {
    if (isActivable) {
      if (mousePressed && isMouseOver() ) {
        isActive = true;
      }

      if (!mousePressed) {
        isActive = false;
      }
    }
  }

  public boolean isClick() {

    /*Esto realmente es innecesario, is active es lo mismo que is click,
     el asunto es que necesito otro metodo para manejar el header */

    if (isMouseOver() && mousePressed) {
      mouseFlag = true;
    }

    if (!mousePressed) {
      mouseFlag = false;
    }

    if (mouseFlag) {
      return  true;
    } else {
      return false;
    }
  }

  public boolean isMouseOver() {
    if ( mouseX > x - w/2
      && mouseX < x + w/2
      && mouseY > y - h/2
      && mouseY < y + h/2) {
      return true;
    } else return false;
  }

  public boolean istouchingWidget(QuadElement quad) {

    float p1a  = y + h/2;
    float p2a  = y - h/2; 

    float p3a  = x + w/2;
    float p4a  = x - w/2;

    float p1b  = quad.y + quad.h/2;
    float p2b  = quad.y - quad.h/2 ;

    float p3b  = quad.x + quad.w/2;
    float p4b  = quad.x - quad.w/2;

    if (    ((p1a > p1b &&  p1a > p2b &&  p2a > p1b && p2a > p2b) || 
      (p1a < p1b && p1a < p2b && p2a < p1b && p2a < p2b)) ||
      ((p3a > p3b && p3a > p4b && p4a > p3b && p4a > p4b) ||
      (p3a < p3b && p3a < p4b && p4a < p3b && p4a < p4b))
      ) {
      return false;
    } else {
      return true;
    }
  }

  public void setpos(float _x, float _y) {
    x = _x;
    y = _y;
  }
}


class Toogle extends QuadElement {

  String name ;
  float textsize;
  PFont font;
  protected boolean mouseflag;


  Toogle(float _x, float _y, float _w, float _h, String _name) {
    super(_x, _y, _w, _h);

    textsize = 15;
    font = createFont("Arial-Black-12.vlw", 12);
    name = _name;
    mouseflag = true;
    isActivable = true;
    isActive = false;

    Color_standart = colors[2];
    Color_mouseover = colors[3];
    Color_active = colors[4];
  }

  protected void displayShape() {
    super.displayShape();
    textAlign(CENTER, CENTER);
    fill(0);
    textFont(font);
    textSize(textsize);
    text(name, x, y);
  }

  void checkinput() {
    if (isActivable) {
      if (mousePressed && isMouseOver()) {
        isActive = true;
        mouseFlag = false;
      }

      if (!mousePressed) {
        mouseflag = true;
      }
    }
  }

  boolean isClick() {
    if (mousePressed && isMouseOver() ) {
      isActive = true;
      mouseFlag = false;
      return true;
    } else {
      mouseFlag = true;
      return false;
    }
  }
}

class ToogleGroup {

  ArrayList<Toogle>  toogles;
  int activetoogle = 0;
  ToogleGroup() {
    toogles = new ArrayList<Toogle>();
  }

  void addToogle(float _x, float _y, float _w, float _h, String _name) {

    toogles.add(new Toogle( _x, _y, _w, _h, _name));
  }

  void run() {
    display();
    checkinput();
  }

  void display() {
    for (Toogle p : toogles) {
      p.display();
    }
  }

  void checkinput() {
    for (int x=0; x<toogles.size(); x++) {
      Toogle p = toogles.get(x);


      if (p.isClick()) {
        activetoogle = x;
      }
      if (activetoogle == x) {
        p.isActive = true;
      } else {
        p.isActive = false;
      }
    }
  }
  
  boolean change(){
    
    boolean pepe = false;
    for (int x=0; x<toogles.size(); x++) {
      Toogle p = toogles.get(x);
      if (p.isClick()) {
        pepe = true;
      } 
    }
    return pepe;
  }
}

class Bang extends Toogle {


  public boolean mouseflag2; 
  Bang( float _x, float _y, float _w, float _h, String _name) {
    super(_x, _y, _w, _h, _name);
    mouseflag2 = true;

    Color_standart = colors[2];
    Color_mouseover = colors[3];
    Color_active = colors[4];
  }

  public void run() {

    super.display();
    /*Esto realmente es innecesario, is active es lo mismo que is click,
     el asunto es que necesito otro metodo para manejar el header */

    isActive = false; 
    if (!mousePressed) {
      mouseflag2 = true;
    }

    if (isMouseOver() && mousePressed && mouseflag2 && !isActive) {
      mouseflag2 = false;
      isActive = true;
    }
  }
}