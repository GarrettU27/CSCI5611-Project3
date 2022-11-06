public class Arm {
  Joint[] joints;
  Vec2 endEffector;

  public Arm(Joint[] joints, Vec2 endEffector) {
    this.joints = joints;
    this.endEffector = endEffector;
  }

  public void updateAngles(Vec2 target) {
    for (int i = joints.length - 1; i >= 0; i--) {
      Vec2 start = joints[i].position;

      Vec2 startToTarget = target.minus(start);
      Vec2 startToEndEffector = this.endEffector.minus(start);
      float dotProd = dot(startToTarget.normalized(), startToEndEffector.normalized());

      // ANGULAR SPEED LIMITS WOULD BE SET IN THIS CHUNK
      dotProd = clamp(dotProd, -1, 1);

      if (cross(startToTarget, startToEndEffector) < 0)
        joints[i].angle += acos(dotProd);
      else
        joints[i].angle -= acos(dotProd);

      // ROTATIONAL LIMITS
      if (joints[i].angle > PI/2) {
        joints[i].angle = PI/2;
      } else if (joints[i].angle < -PI/2) {
        joints[i].angle = -PI/2;
      }

      this.updatePositions();
    }
  }

  public void updatePositions() {
    float totalAngle = 0;
    for (int i = 1; i < joints.length; i++) {
      Joint prevJoint = this.joints[i-1];
      totalAngle += prevJoint.angle;
      float prevLength = prevJoint.length;
      Vec2 prevPos = prevJoint.position;

      this.joints[i].position = new Vec2(cos(totalAngle)*prevLength, sin(totalAngle)*prevLength).plus(prevPos);
    }

    Joint prevJoint = this.joints[joints.length - 1];
    totalAngle += prevJoint.angle;
    float prevLength = prevJoint.length;
    Vec2 prevPos = prevJoint.position;

    this.endEffector = new Vec2(cos(totalAngle)*prevLength, sin(totalAngle)*prevLength).plus(prevPos);
  }

  public void draw() {
    Vec2 target = new Vec2(mouseX, mouseY);

    if (!paused) {
      this.updateAngles(target);
      this.updatePositions();
    }


    strokeWeight(2);
    stroke(0);

    fill(180, 20, 40); //Root
    pushMatrix();
    translate(joints[0].position.x, joints[0].position.y);
    rect(-20, -20, 40, 40);
    popMatrix();

    fill(10, 150, 40);
    float totalAngle = 0;
    for (int i = 0; i < joints.length; i++) {
      totalAngle += joints[i].angle;
      pushMatrix();
      translate(joints[i].position.x, joints[i].position.y);
      rotate(totalAngle);
      quad(0, -armW/2, joints[i].length, -.1*armW, joints[i].length, .1*armW, 0, armW/2);
      popMatrix();
    }

    strokeWeight(0);
  }
}
