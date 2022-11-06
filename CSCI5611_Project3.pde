// Perhaps I should make it so hitting a target would re-root the arm?

void setup() {
  size(640, 480);
  surface.setTitle("Inverse Kinematics [CSCI 5611 Project 3]");

  Joint[] joints = new Joint[numberOfJoints];
  Vec2 position = root;

  for (int i = 0; i < numberOfJoints; i++) {
    joints[i] = new Joint(position, 0.0, lengthOfJoints);
    position = new Vec2(cos(0)*lengthOfJoints, sin(0)*lengthOfJoints).plus(position);
  }

  Vec2 endPoint = new Vec2(cos(0)*lengthOfJoints, sin(0)*lengthOfJoints).plus(joints[joints.length -1].position);

  arm = new Arm(joints, endPoint);
  
  prm.setup();
}

void draw() {
  background(255, 255, 255);

  prm.draw();
  arm.draw();

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
