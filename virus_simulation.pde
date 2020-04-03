// Virus Simulation
// Inspired by Georgia Tech CS 7492 (Simulation of Biology) WATOR Predator/Prey Simulation assignment     
// Joey Gonzales-Dones

import java.util.Collections;
import java.util.LinkedList;

// Simulation variables
boolean paused = true;
int[] sizes = new int[]{25, 50, 100, 160, 200, 400}; // possible grid sizes
int sizeIndex = 2;
int speed = 1;
int w = sizes[sizeIndex]; // grid width
int h = sizes[sizeIndex]; // grid height
Grid grid;

// Made-up numbers for now; for coronavirus, get statistics from https://www.worldometers.info/coronavirus/
float populationDensity = 0.1; // Initial ratio of living cells to empty cells
float baseInfectionRate = 0.01; // Of the initial population, what proportion starts out infected?
float carrierRate = 0.50; // Of the infected cells, what proportion are asymptomatic carriers? 
float contagiousness = 0.75; // Chance of an infected person transmitting the virus
float recoveryRate = 0.01; // Chance of an infected person recovering (recovered / total)
float deathRate = 0.0005; // Chance of an infected person dying (deaths / total)

// Display variables
boolean showHeadsUpDisplay = true;
boolean showHelp = false;
boolean showGridLines = false;

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-------~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //
// If true, scale sketch for Ultra HD (4K) resolution; otherwise, scale for Full HD (1080p) resolution //
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-------~~~~~~~~~~~~~~~~~~ //
final boolean ULTRA_HD_MODE = true; 

// Color variables
color backgroundColor = color(0, 0, 0);
color gridLineColor = color(127, 127, 127);
color healthyColor = color(0, 255, 0);
color infectedColor = color(255, 0, 0);
color carrierColor = color(255, 255, 0);
color deadColor = color(192, 192, 192);

// HUD variables
int hudTextSize = (ULTRA_HD_MODE ? 64 : 32);
float hudX = (ULTRA_HD_MODE ? 20 : 10);
float hudSpacing = (ULTRA_HD_MODE ? 20 : 10);
int hudAlpha = 160;
color hudTextColor = color(205, 205, 205);

// Help page variables
int helpTextSize = (ULTRA_HD_MODE ? 48 : 24);
float helpX = (ULTRA_HD_MODE ? 20 : 10);
float helpSpacing = (ULTRA_HD_MODE ? 20 : 10);
int helpAlpha = 160;
color helpTextColor = color(205, 205, 205);

void setup() {
  size(800, 800);
  if (ULTRA_HD_MODE) {
    surface.setSize(1600, 1600);
  }
  background(backgroundColor);
  strokeWeight(1);
  grid = new Grid(w, h);
}

void draw() {
  background(backgroundColor);
  grid.show();

  if (showHelp) {
    drawHelpPage();
  } else if (showHeadsUpDisplay) {
    drawHeadsUpDisplay();
  }

  if (!paused) {
    grid.advance(speed);
  }
}

void keyPressed() {
  if (key == 'c' || key == 'C') { // clear the grid
    grid.clear();
  }
  if (key == 'h' || key == 'H') { // Toggle the HUD
    showHeadsUpDisplay = !showHeadsUpDisplay;
  }
  if (key == 'l' || key == 'L') { // Toggle grid lines
    showGridLines = !showGridLines;
    if (!showGridLines) {
      noStroke();
    } else {
      stroke(gridLineColor);
    }
  }
  if (key == 'q' || key == 'Q') { // Quit the program
    exit();
  }
  if (key == 'r' || key == 'R') { // Reset the grid
    grid.reset();
  }
  if (key == 's' || key == 'S') { // Take a single simulation step
    grid.update();
    paused = true;
  }
  if (key == '/' || key == '?') { // Toggle the help page
    showHelp = !showHelp;
  }
  if (key == ' ') { // start/stop the simulation
    paused = !paused;
  }
  if (key == '=') { // Reset the grid and decrease its size (zoom in) 
    if (sizeIndex > 0) {
      sizeIndex--;
    }
    w = sizes[sizeIndex];
    h = sizes[sizeIndex];
    grid = new Grid(w, h);
  }
  if (key == '-') { // Reset the grid and increase its size (zoom out)
    if (sizeIndex < sizes.length-1) {
      sizeIndex++;
    }
    w = sizes[sizeIndex];
    h = sizes[sizeIndex];
    grid = new Grid(w, h);
  }
  if (key == '.') { // Increase the speed
    speed++;
  }
  if (key == ',' && speed > 0) { // Decrease the speed
    speed--;
  }
}

void hudText(String message, int line) {
  text(message, hudX, (hudTextSize*line)+(hudSpacing*line));
}

void helpText(String message, int line) {
  text(message, helpX, (helpTextSize*line)+(helpSpacing*line));
}

void drawHeadsUpDisplay() {
  textSize(hudTextSize);
  noStroke();
  fill(0, 0, 0, hudAlpha);
  rect(0, 0, width, height);
  fill(hudTextColor, hudAlpha);  
  int line = 1;

  hudText("Grid size: " + sizes[sizeIndex], line++);
  hudText("Time steps elapsed: " + grid.getTimeStep() + " (" + speed + (speed == 1 ? " step" : " steps") + " per frame)", line++);

  int[] cellCounts = grid.getCellCounts();
  int deaths = grid.getDeaths();
  int recovered = grid.getRecovered();

  hudText("Cell counts:", line++);
  hudText("    Empty - " + cellCounts[Cell.EMPTY], line++);
  hudText("    Healthy - " + cellCounts[Cell.HEALTHY], line++);
  hudText("    Infected - " + cellCounts[Cell.INFECTED], line++);
  hudText("    Carrier - " + cellCounts[Cell.CARRIER], line++);
  hudText("    Dead - " + deaths, line++);
  hudText("    Recovered - " + recovered, line++);

  hudText("Press \'?\' to toggle help text", line++);

  if (paused) {
    line++;
    hudText("PAUSED - press Space to unpause", line++);
  }
}

void drawHelpPage() {
  textSize(helpTextSize);
  noStroke();
  fill(0, 0, 0, helpAlpha);
  rect(0, 0, width, height);
  fill(helpTextColor, helpAlpha);  
  int line = 1;

  helpText("Key commands:", line++);
  helpText("C: Clear the simulation", line++);
  helpText("H: Toggle heads-up display on/off", line++);
  helpText("L: Toggle grid lines on/off", line++);
  helpText("Q: Quit the program", line++);
  helpText("R: Reset and reinitialize the simulation", line++);
  helpText("S: Take a single simulation step", line++);
  helpText("+: Reset the simulation and decrease the grid size (zoom in)", line++);
  helpText("-: Reset the simulation and increase the grid size (zoom out)", line++);
  helpText(",: Decrease the simulation speed", line++);
  helpText(".: Increase the simulation speed", line++);
  helpText("Space: pause/unpause the simulation", line++);
  helpText("?: Toggle help text", line++);
}
