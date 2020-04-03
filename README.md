# Virus Simulation (work in progress)
The coronavirus pandemic of 2020 inspired me to create this program to simulate the behavior of viruses. 
As a starting point, I modified my implementation of the [Wa-Tor predator/prey simulation](https://en.wikipedia.org/wiki/Wa-Tor)
from Georgia Tech's CS 7492: Simulation of Biology course.

![Example image of the program running](https://github.com/joeygonzalesdones/virus-simulation/blob/master/example-screenshot.png)

The cell states are as follows:
* Black - empty
* Green - healthy
* Red - infected
* Yellow - asymptomatic carrier
* Gray - dead

In the simulation, the living cells wander about randomly, and if an infected or carrier cell moves next to a healthy cell, it has a chance to spread the virus to the healthy cell. In each time step, infected cells also have a random chance of either recovering or dying. Right now, the various parameters (population densities, levels of contagiousness, death rates, recovery rates, etc.) are hardcoded in the program, but I soon plan to implement user controls to modify the parameters while the program is running. I also plan to implement features to add more realism, such as aging, birth, gained immunity/resistance from previous infections or vaccinations, and quarantining.

## Running the Program

The program is implemented using Processing, a beginner-friendly framework built on top of Java for working with computer graphics and the visual arts. To run the program, [download and install Processing](https://processing.org/download/) if it is not installed already, then open the repository with the Processing IDE.
