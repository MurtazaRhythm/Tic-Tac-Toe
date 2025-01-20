class Cells {
  float x, y, w, h; // Position (x, y) and size (width, height) of the cell
  int state; // State of the cell (0 for empty, 1 for O, 2 for X)

  // Constructor to initialize the cell with position and size
  Cells(float tempX, float tempY, float tempW, float tempH) {
    x = tempX;
    y = tempY;
    w = tempW;
    h = tempH;
  }

  // Function to check if the mouse is over a rectangle
  boolean isMouseOver(float x, float y, float w, float h) {
    if (mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h) {
      return true; // Return true if mouse is over the rectangle
    }
    return false; // Return false otherwise
  }

  // Function to handle mouse click on the cell
  boolean click(int turn) {
    if (isMouseOver(x, y, w, h)) { // Check if the mouse is over the cell
      if (state == 0) { // Check if the cell is empty
        if (turn == 0)
          state = 1; // Set the state to O if it's Player O's turn
        else if (turn == 1)
          state = 2; // Set the state to X if it's Player X's turn
        return true; // Return true to indicate a successful click
      }
    }
    return false; // Return false if the cell is not empty or mouse is not over the cell
  }

  // Function to display the cell
  void display() {
    strokeWeight(1); // Set stroke weight for cell border
    stroke(0); // Set stroke color for cell border
    fill(255); // Set fill color for cell background
    rect(x, y, w, h); // Draw cell background rectangle

    if (isMouseOver(x, y, w, h)) { // Check if the mouse is over the cell
      stroke(252, 36, 3); // Set stroke color for highlighted cell border
      strokeWeight(5); // Set stroke weight for highlighted cell border
      rect(x, y, w, h); // Draw highlighted cell background rectangle
    }

    if (state == 1) { // If cell state is O
      strokeWeight(0); // Set stroke weight to 0 for drawing circle
      fill(5, 28, 110); // Set fill color for circle (blue)
      ellipse(x+w/2, y+h/2, 150, 150); // Draw circle inside the cell
    }
    if (state == 2) { // If cell state is X
      stroke(5, 110, 50); // Set stroke color for X (green)
      strokeWeight(5); // Set stroke weight for drawing X
      line(x +40, y+40, x+260, y+260); // Draw first line of X
      line(x + 260, y+40, x+40, y+260); // Draw second line of X
    }
  }
}
