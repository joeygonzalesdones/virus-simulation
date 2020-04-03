// A class to represent a grid of cells

class Grid {
  private Cell[] cells;
  private int w; // grid width (cells)
  private int h; // grid height (cells)
  private int cw; // cell width (pixels)
  private int ch; // cell height (pixels)
  private int timeStep;
  private int[] cellCounts;
  private int deaths;
  private int recovered;

  public Grid(int w, int h) {
    this.cells = new Cell[w*h];
    this.cw = width / w;
    this.ch = height / h;
    this.w = w;
    this.h = h;
    this.initialize();
  }

  private void initialize() {
    this.cellCounts = new int[Cell.NUM_STATES];
    this.deaths = 0;
    this.recovered = 0;
    this.timeStep = 0;
    for (int x = 0; x < w; x++) {
      for (int y = 0; y < h; y++) {
        int cx = x * cw;
        int cy = y * ch;
        if (random(1.0) < populationDensity) {
          cells[y * w + x] = new Cell(cx, cy, cw, ch, x, y, Cell.HEALTHY);
          if (random(1.0) < baseInfectionRate) {
            cells[y * w + x].infect();
          }
        } else {
          cells[y * w + x] = new Cell(cx, cy, cw, ch, x, y, Cell.EMPTY);
        }
      }
    }
  }

  public void show() {
    for (int i = 0; i < cells.length; i++) {
      cells[i].show();
    }

    if (showGridLines) {
      stroke(gridLineColor);
      for (int x = 0; x < width; x = x + cw) {
        line(x, 0, x, height);
      }
      for (int y = 0; y < height; y = y + ch) {
        line(0, y, width, y);
      }
    }
  }
  
  public void advance(int speed) {
    for (int i = 0; i < speed; i++) {
      update();
    }
  }

  public void update() {
    this.timeStep++;

    // Choose a random order to update the cells in
    LinkedList<Integer> updateOrder = new LinkedList<Integer>();
    for (int i = 0; i < cells.length; i++) {
      if (cells[i].getState() != Cell.EMPTY) {
        updateOrder.add(i);
      }
    }
    Collections.shuffle(updateOrder);

    // visit all the living cells and choose unoccupied neighbors to explore
    for (int i = 0; i < updateOrder.size(); i++) {
      Cell current = cells[updateOrder.get(i)];
      updateCell(current);
    }

    // Count up all of the cells
    for (int i = 0; i < cellCounts.length; i++) {
      cellCounts[i] = 0;
    }
    for (int i = 0; i < cells.length; i++) {
      cellCounts[cells[i].getState()]++;
    }
  }

  private void updateCell(Cell current) {
    Cell up = this.get(current.getX(), current.getY()-1);
    Cell right = this.get(current.getX()+1, current.getY());
    Cell down = this.get(current.getX(), current.getY()+1);
    Cell left = this.get(current.getX()-1, current.getY());

    current.incrementAge();

    // Check if infection spreads to neighbors, or if the infected cell dies or recovers
    if (current.getState() == Cell.CARRIER || current.getState() == Cell.INFECTED) {
      if (random(1.0) < recoveryRate) {
        current.setState(Cell.HEALTHY);
        this.recovered++;
      } else if (current.getState() == Cell.INFECTED && random(1.0) < deathRate) {
        current.setState(Cell.EMPTY);
        current.setDeathOccurred();
        this.deaths++;
      }

      if (up.getState() == Cell.HEALTHY && random(1.0) < contagiousness) {
        up.infect();
      }
      if (right.getState() == Cell.HEALTHY && random(1.0) < contagiousness) {
        right.infect();
      }
      if (down.getState() == Cell.HEALTHY && random(1.0) < contagiousness) {
        down.infect();
      }
      if (left.getState() == Cell.HEALTHY && random(1.0) < contagiousness) {
        left.infect();
      }
    }

    if (up.getState() == Cell.EMPTY || right.getState() == Cell.EMPTY || down.getState() == Cell.EMPTY || left.getState() == Cell.EMPTY) {
      // Choose a random neighbor cell to move to, or else stay still
      LinkedList<Integer> moves = new LinkedList<Integer>();
      if (up.getState() == Cell.EMPTY) {
        moves.add(0);
      } 
      if (right.getState() == Cell.EMPTY) {
        moves.add(1);
      }
      if (down.getState() == Cell.EMPTY) {
        moves.add(2);
      }
      if (left.getState() == Cell.EMPTY) {
        moves.add(3);
      }

      moves.add(-1);
      Collections.shuffle(moves);
      int move = moves.get(0);

      if (move >= 0) {
        Cell next = null;

        switch (move) {
        case 0:
          next = up;
          break;
        case 1:
          next = right;
          break;
        case 2:
          next = down;
          break;
        case 3:
          next = left;
          break;
        default:
          next = current;
          break;
        }

        // swap the two cells
        next.setState(current.getState());
        next.setAge(current.getAge());
        current.setState(Cell.EMPTY); 
        current.setAge(0);
      }
    }
  }

  // Return all cells within Manhattan distance d of the current cell
  private LinkedList<Cell> getCellsWithinDistance(Cell current, int d) {
    LinkedList<Cell> neighbors = new LinkedList<Cell>();
    int x = current.getX();
    int y = current.getY();
    for (int i = -d; i <= d; i++) {
      for (int j = -d; j <= d; j++) {
        int dist = abs(i) + abs(j);
        if (dist > 0 && dist <= d) {
          neighbors.add(this.get(x+i, y+j));
        }
      }
    }
    return neighbors;
  }

  // Reset the grid with a new random state
  public void reset() {
    this.initialize();
  } 

  public void clear() {
    for (int i = 0; i < cells.length; i++) {
      cells[i].setState(Cell.EMPTY);
      cells[i].setAge(0);
    }
  }

  public int[] getCellCounts() {
    return this.cellCounts;
  }

  public int getDeaths() {
    return this.deaths;
  }

  public int getRecovered() {
    return this.recovered;
  }

  public int getTimeStep() {
    return this.timeStep;
  }

  // Retrieve a cell using 2-D indexing and toroidal wrapping
  private Cell get(int x, int y) {
    if (x >= w) {
      x = x - w;
    } else if (x < 0) {
      x = x + w;
    }

    if (y >= h) {
      y = y - h;
    } else if (y < 0) {
      y = y + h;
    }

    return cells[y * w + x];
  }
}
