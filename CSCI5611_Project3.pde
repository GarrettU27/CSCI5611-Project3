// Perhaps I should make it so hitting a target would re-root the arm?

void setup() {
  size(640, 480);
  surface.setTitle("Inverse Kinematics [CSCI 5611 Project 3]");

  Vec2 position = root;
  Vec2[] positions = new Vec2[numberOfPoints];
  float[] distances = new float[numberOfPoints - 1];

  for (int i = 0; i < numberOfPoints; i++) {
    positions[i] = position;
    position = new Vec2(cos(0)*lengthOfPoints, sin(0)*lengthOfPoints).plus(position);
  }
  
  for (int i = 0; i < numberOfPoints - 1; i++) {
    distances[i] = lengthOfPoints;
  }

  f = new FABRIK(positions, distances);  
  prm.setup();
}

void draw() {
  background(255, 255, 255);

  prm.draw();
  f.draw();
 
  fill(0, 0, 0); //Goal/mouse
  pushMatrix();
  translate(mouseX, mouseY);
  circle(0, 0, 20);
  popMatrix();
}

void keyPressed(){
  if (key == 'r'){
    createGraph();
  } else if (key == ' ') {
    paused = !paused;
  }
}
