public class Target {
  public Vec3 current, goal;
  float maxVelocity;
  
  public Target(Vec3 current, Vec3 goal, float maxVelocity) {
    this.current = current;
    this.goal = goal;
    this.maxVelocity = maxVelocity;
  }
  
  public void update() {
    Vec3 direction = this.goal.minus(this.current);
    direction.clampToLength(this.maxVelocity * 1.0/frameRate);
    current = direction.plus(current);
  }
}
