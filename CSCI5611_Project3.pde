void setInitialCameraPosition() {
  camera.position.x = -100.42573;
  camera.position.y = -446.68875;
  camera.position.z = 661.2473;
  
  camera.phi = -0.6403329;
  camera.theta = -6.9920177;
}

void setup() {
  size(1280, 960, P3D);
  surface.setTitle("Inverse Kinematics [CSCI 5611 Project 3]");

  Vec3 position = root;
  Vec3[] positions = new Vec3[numberOfPoints];
  float[] distances = new float[numberOfPoints - 1];

  for (int i = 0; i < numberOfPoints; i++) {
    positions[i] = position;
    position = new Vec3(cos(0)*lengthOfPoints, sin(0)*lengthOfPoints, 0).plus(position);
  }
  
  for (int i = 0; i < numberOfPoints - 1; i++) {
    distances[i] = lengthOfPoints;
  }

  f = new FABRIK(positions, distances); 
  camera = new Camera();
  setInitialCameraPosition();
}

float x, y;

void draw() {
  background(255, 255, 255);
  
  camera.Update(1.0/frameRate);

  f.draw();
 
  //fill(0, 0, 0); //Goal/mouse
  //pushMatrix();
  //translate(mouseX, mouseY);
  //circle(0, 0, 20);
  //popMatrix();
}

void keyPressed(){
  camera.HandleKeyPressed();
  
  if (key == ' ')
    paused = !paused;
}

void keyReleased()
{
  camera.HandleKeyReleased();
}

void mouseDragged() {
}
