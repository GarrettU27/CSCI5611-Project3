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
  t1 = new Target(positions[positions.length - 1], new Vec3(random(300, 2000), random(300, 2000), random(300, 2000)), 300);
  t2 = new Target(positions[positions.length - 1], new Vec3(random(300, 2000), random(300, 2000), random(300, 2000)), 300);
}

void setTargets() {
  t1.goal = new Vec3(random(300, 2500), random(300, 1500), random(300, 1500));
  t2.goal = new Vec3(random(300, 2500), random(300, 1500), random(300, 1500));
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
  lights();
  
  camera.Update(1.0/frameRate);
  
  t1.draw();
  t2.draw();

  f1.draw(t1.current);
  f2.draw(t2.current);
  
  //pushMatrix();
  //translate(clickPosition.x, clickPosition.y, clickPosition.z);
  //sphere(10);
  //popMatrix();
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
  if (selected != null) {
    Vec3 eyePosition = getEyePosition();
    Vec3 planeNormal = eyePosition.minus(selected.goal).normalized();
    
    Vec3 newPosition = getUnProjectedPointOnFloor(mouseX, mouseY, selected.goal, planeNormal);
    selected.goal = newPosition;
  }
}

void mouseReleased() {
  selected = null;
}

void mousePressed() {
  println("CHECK");
  Vec3 eyePosition = getEyePosition();
  Vec3 clickPosition = unProject(mouseX, mouseY, -1);
  
  Vec3 direction = clickPosition.minus(eyePosition).normalized();
  
  float b = dot(direction, eyePosition.minus(t1.goal));
  //println("b1: ", b);
  float c = dot(eyePosition.minus(t1.goal), eyePosition.minus(t1.goal)) - pow(targetRadius, 2);
  //println("c1: ", c);
  float t = pow(b, 2) - c;
  //println("t1: ", t);
  
  if (t >= 0) {
    println("Hit!");
    selected = t1;
  }
  
  b = dot(direction, eyePosition.minus(t2.goal));
  //println("b2: ", b);
  c = dot(eyePosition.minus(t2.goal), eyePosition.minus(t2.goal)) - pow(targetRadius, 2);
  //println("c2: ", c);
  t = pow(b, 2) - c;
  //println("t2: ", t);
  
  if (t >= 0) {
    println("Hit!");
    selected = t2;
  }
  
  println("");
}

// Function that calculates the coordinates on the floor surface corresponding to the screen coordinates
Vec3 getUnProjectedPointOnFloor(float screen_x, float screen_y, Vec3 floorPosition, Vec3 floorDirection) {

  Vec3 f = floorPosition; // Position of the floor
  Vec3 n = floorDirection; // The direction of the floor ( normal vector )
  Vec3 w = unProject(screen_x, screen_y, -1.0); // 3 -dimensional coordinate corresponding to a point on the screen
  Vec3 e = getEyePosition(); // Viewpoint position

  // Computing the intersection of  
  f.subtract(e);
  w.subtract(e);
  w.mul( dot(n, f)/ dot(n, w) );
  w.add(e);

  return w;
}

// Function to get the position of the viewpoint in the current coordinate system
Vec3 getEyePosition() {
  PMatrix3D mat = (PMatrix3D)getMatrix(); //Get the model view matrix
  mat.invert();
  return new Vec3( mat.m03, mat.m13, mat.m23 );
}

//Function to perform the conversion to the local coordinate system ( reverse projection ) from the window coordinate system
Vec3 unProject(float winX, float winY, float winZ) {
  PMatrix3D mat = getMatrixLocalToWindow();  
  mat.invert();

  float[] in = {winX, winY, winZ, 1.0f};
  float[] out = new float[4];
  mat.mult(in, out);  // Do not use PMatrix3D.mult(PVector, PVector)

  if (out[3] == 0 ) {
    return null;
  }

  Vec3 result = new Vec3(out[0]/out[3], out[1]/out[3], out[2]/out[3]);  
  return result;
}

//Function to compute the transformation matrix to the window coordinate system from the local coordinate system
PMatrix3D getMatrixLocalToWindow() {
  PMatrix3D projection = ((PGraphics3D)g).projection; 
  PMatrix3D modelview = ((PGraphics3D)g).modelview;   

  // viewport transf matrix
  PMatrix3D viewport = new PMatrix3D();
  viewport.m00 = viewport.m03 = width/2;
  viewport.m11 = -height/2;
  viewport.m13 =  height/2;

  // Calculate the transformation matrix to the window coordinate system from the local coordinate system
  viewport.apply(projection);
  viewport.apply(modelview);
  return viewport;
}
