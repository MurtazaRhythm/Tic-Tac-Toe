import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Cells[][] grid; // Define a 2D array to store the cells of the game grid

int cols = 3; // Number of columns in the grid
int rows = 3; // Number of rows in the grid
int turn = 0; // Variable to keep track of whose turn it is (0 for Player O, 1 for Player X)
boolean done = false; // Flag to indicate whether a move has been made

Minim myMinim; // Object for Minim audio library
AudioPlayer overCell, mouseClick, winnerDing, Draw, bgMusic; // Audio players for different game sounds

void setup() {
  textAlign(CENTER); // Set text alignment to center
  size(900, 900); // Set the size of the window
  grid = new Cells[cols][rows]; // Initialize the grid array
  
  // Create cells and populate the grid
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      grid[i][j] = new Cells(i*300, j*300, 300, 300); // Create a new cell at position (i*300, j*300)
    }
  }
  
  myMinim = new Minim(this); // Initialize Minim library
  // Load audio files
  mouseClick = myMinim.loadFile("mouseClick.mp3");
  overCell = myMinim.loadFile("ButtonToggle.mp3");
  winnerDing = myMinim.loadFile("Ding.mp3");
  Draw = myMinim.loadFile("Draw.mp3");
  bgMusic = myMinim.loadFile("bgMusic.mp3");
  bgMusic.play(); // Start background music
}

void draw() {
  printGrid(); // Draw the game grid
}

void mouseClicked() {
  // Iterate over each cell in the grid
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      // Check if the mouse click occurred within a cell's boundaries
      if (grid[i][j].click(turn)) {
        mouseClick.play(); // Play mouse click sound
        mouseClick.rewind(); // Rewind the audio player to the beginning
        done = true; // Set the flag to indicate that a move has been made
        break; // Exit the loop if a move has been made
      }
    }
    if (done)
      break; // Exit the outer loop if a move has been made
  }
  
  // Switch players' turn if a move has been made
  if (done) {
    turn = (turn + 1) % 2; // Alternate between Player O (0) and Player X (1)
    done = false; // Reset the flag for the next move
  }

  // Check for a winner or draw
  int winner = checkTiles();
  if (winner == 1) {
    printGrid();
    displayWinner("O");
    winnerDing.play(); // Play winner sound
    bgMusic.pause(); // Pause background music
    stop(); // Stop the program
  } else if (winner == 2) {
    printGrid();
    displayWinner("X");
    winnerDing.play(); // Play winner sound
    bgMusic.pause(); // Pause background music
    stop(); // Stop the program
  } else if (checkDraw()) {
    printGrid();
    pushMatrix();
    rectMode(CENTER);
    stroke(0);
    fill(255);
    rect(width/2, height/2 - 120, 700, 100);
    fill(0);
    textSize(80);
    text("DRAW!", width/2, height/2 - 100);
    popMatrix();
    bgMusic.pause(); // Pause background music
    Draw.play(); // Play draw sound
    stop(); // Stop the program
  }
}

// Function to check for a winner
int checkTiles() {
  // Check rows for a win
  for (int i = 0; i < 3; i++) {
    if (grid[i][0].state == grid[i][1].state && grid[i][1].state == grid[i][2].state && grid[i][0].state != 0) {
      return grid[i][0].state;
    }
  }
  // Check columns for a win
  for (int i = 0; i < 3; i++) {
    if (grid[0][i].state == grid[1][i].state && grid[1][i].state == grid[2][i].state && grid[0][i].state != 0) {
      return grid[0][i].state;
    }
  }
  // Check diagonals for a win
  if (grid[0][0].state == grid[1][1].state && grid[1][1].state == grid[2][2].state && grid[0][0].state != 0) {
    return grid[0][0].state;
  }
  if (grid[2][0].state == grid[1][1].state && grid[1][1].state == grid[0][2].state && grid[2][0].state != 0) {
    return grid[2][0].state;
  }
  return -1; // Return -1 if there is no winner
}

// Function to draw the game grid
void printGrid() {
  background(0); // Set background color to black
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      grid[i][j].display(); // Display each cell in the grid
    }
  }
}

// Function to check for a draw
boolean checkDraw() {
  // If any cell is empty, the game is not a draw
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      if (grid[i][j].state == 0) {
        return false;
      }
    }
  }
  return true; // If all cells are filled, the game is a draw
}

// Function to display the winner
void displayWinner(String player) {
  pushMatrix();
  rectMode(CENTER);
  stroke(0);
  fill(255);
  rect(width/2, height/2 - 120, 700, 100);
  fill(0);
  textSize(80);
  text("WINNER: " + player + " PLAYER!", width/2, height/2 - 100);
  popMatrix();
}

// Function to check if the mouse is over a rectangle
boolean isMouseOver(float x, float y, float w, float h) {
  if (mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h) {
    return true;
  }
  return false;
}
