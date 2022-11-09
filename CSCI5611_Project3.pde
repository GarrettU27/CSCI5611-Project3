void setInitialCameraPosition() {
  camera.position.x = -100.42573;
  camera.position.y = -446.68875;
  camera.position.z = 661.2473;
  
  camera.phi = -0.6403329;
  camera.theta = -6.9920177;
}

void setInitialPositions() {
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

  f1 = new FABRIK(positions, distances, color(10, 150, 40)); 
  f2 = new FABRIK(positions.clone(), distances.clone(), color(0, 0, 255)); 
  t1 = new Target(positions[positions.length - 1], new Vec3(random(300, 2500), random(300, 2500), random(300, 2500)), 300);
  t2 = new Target(positions[positions.length - 1], new Vec3(random(300, 2500), random(300, 2500), random(300, 2500)), 300);
}

void setTargets() {
  t1.goal = new Vec3(random(300, 2500), random(300, 2500), random(300, 2500));
  t2.goal = new Vec3(random(300, 2500), random(300, 2500), random(300, 2500));
}

void setup() {
  size(1280, 960, P3D);
  surface.setTitle("Inverse Kinematics [CSCI 5611 Project 3]");

  setInitialPositions();
  camera = new Camera();
  setInitialCameraPosition();
}

float x, y;

void draw() {
  background(255, 255, 255);
  
  camera.Update(1.0/frameRate);
  
  t1.update();
  t2.update();

  f1.draw(t1.current);
  f2.draw(t2.current);
}

void keyPressed(){
  camera.HandleKeyPressed();
  
  if (key == 'r') {
    setInitialCameraPosition();
    setInitialPositions();
    setTargets();
  }
  if (key == 'f') {
    setTargets();
  }
  if (key == ' ')
    paused = !paused;
}

void keyReleased()
{
  camera.HandleKeyReleased();
}

void mouseDragged() {
}
