// A class to represent a unit of space that a "person" may occupy

class Cell {
  // pixel coordinates for drawing
  private int px;
  private int py;
  private int cw;
  private int ch;

  // coordinates within grid
  private int x;
  private int y;

  // cell state
  private int state;
  public static final int EMPTY = 0;
  public static final int HEALTHY = 1;
  public static final int INFECTED = 2;
  public static final int CARRIER = 3;

  public static final int NUM_STATES = CARRIER+1;

  // cell age
  private int age;

  // did a death occur in this cell?
  private boolean deathOccurred;
  
  public Cell(int px, int py, int cw, int ch, int x, int y, int state) {
    this.px = px;
    this.py = py;
    this.cw = cw;
    this.ch = ch;
    this.x = x;
    this.y = y;
    this.state = state;
    this.age = 0;
    this.deathOccurred = false;
  }

  public void show() { 
    switch (this.state) {
    case EMPTY:
      fill(backgroundColor);
      break;
    case HEALTHY:
      fill(healthyColor);
      break;
    case INFECTED:
      fill(infectedColor);
      break;
    case CARRIER:
      fill(carrierColor);
      break;
    default:
      fill(backgroundColor);
      break;
    }

    rect(this.px, this.py, this.cw, this.ch);
    
    if (deathOccurred) {
      int alpha = (this.state == EMPTY ? 255 : 192);
      fill(deadColor, alpha);
      rect(this.px, this.py, this.cw, this.ch);
    }
  }

  public int getState() {
    return this.state;
  }

  public void setState(int state) {
    this.state = state;
  }

  public boolean isDeathOccurred() {
    return this.deathOccurred;
  }

  public void setDeathOccurred() {
    this.deathOccurred = true;
  }

  public void incrementAge() {
    this.age++;
  }

  public void resetAge() {
    this.age = 0;
  }

  public int getAge() {
    return this.age;
  }

  public void setAge(int age) {
    this.age = age;
  }

  public int getX() {
    return this.x;
  }

  public int getY() {
    return this.y;
  }

  public void infect() {
    if (random(1.0) < carrierRate) {
      this.state = CARRIER;
    } else {
      this.state = INFECTED;
    }
  }
}
