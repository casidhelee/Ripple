// Configurable values
final int X_SECTIONS = 9;  // Number of columns of responders
final int Y_SECTIONS = 5;  // Number of rows of responders
final int RADIUS = 24;     // Dormant size of responder
final int ON_RADIUS = 36;  // "Activated" size of responder

Responder[][] responders = new Responder[X_SECTIONS][Y_SECTIONS];

void setup(){
  size(750, 524);
  noStroke();
  frameRate(60);
  
  int visibleWidth = width - 2 * ON_RADIUS;
  int visibleHeight = height - 2 * ON_RADIUS;
  
  // Initialize all responders
  for (int i = 0; i < responders.length; i++) {
    for (int j = 0; j < responders[i].length; j++) {
      
      // Put responder
      int x = visibleWidth / (X_SECTIONS - 1) * i + ON_RADIUS;
      int y = visibleHeight / (Y_SECTIONS - 1) * j + ON_RADIUS;
      responders[i][j] = new Responder(x, y, RADIUS, ON_RADIUS);
      
      // Calculate the "box" around a responder
      int boxIMin = Math.max(i - 1, 0);
      int boxIMax = Math.min(i + 1, responders.length - 1);
      int boxJMin = Math.max(j - 1, 0);
      int boxJMax = Math.min(j + 1, responders[i].length - 1);
      
      // Set those responders in box as neighbors
      for (int n = boxIMin; n <= boxIMax; n++) {
        for (int m = boxJMin; m <= boxJMax; m++) {
          if (responders[n][m] != null && !(i == n && j == m)) {
            responders[i][j].addNeighbor(responders[n][m]);
            responders[n][m].addNeighbor(responders[i][j]);
          }
        }
      }
    }
  }
}

void draw() {
  background(255);  
  for (int i = 0; i < responders.length; i++)
  {
    for (int j = 0; j < responders[i].length; j++) {
      responders[i][j].display();
    }
  }
}

void mousePressed() {
  for (int i = 0; i < responders.length; i++)
  {
    for (int j = 0; j < responders[i].length; j++) {
       if (responders[i][j].inResponder(mouseX, mouseY)) {
         responders[i][j].activate();
       }
    }
  }
}

