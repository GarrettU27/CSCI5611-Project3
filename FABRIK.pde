public class FABRIK {
  Vec2[] positions;
  float[] distances;
  
  public FABRIK(Vec2[] positions, float[] distances) {
    this.positions = positions;
    this.distances = distances;
  }
  
  public void solve(Vec2 target) {
    Vec2 root = positions[0];
    float dist = root.distanceTo(target);
    
    float armLength = 0;
    for (int i = 0; i < distances.length; i++) {
      armLength += distances[i];
    }
    
    // target is unreachable
    if (dist > armLength) {
      for (int i = 0; i < distances.length; i++) {
        float r = positions[i].distanceTo(target);
        float lambda = distances[i]/r;
        positions[i+1] = positions[i].times(1 - lambda).plus(target.times(lambda));
      }
    }
    //target is reachable
    else {
      Vec2 b = positions[0];
      
      float difference = positions[positions.length - 1].distanceTo(target);
      while (difference > tolerance) {
        positions[positions.length - 1] = target;
        for (int i = distances.length - 1; i >= 0; i--) {
          float r = positions[i + 1].distanceTo(positions[i]);
          float lambda = distances[i]/r;
          positions[i] = positions[i+1].times(1-lambda).plus(positions[i].times(lambda));
        }
        
        positions[0] = b;
        for (int i = 0; i < distances.length; i++) {
          float r = positions[i + 1].distanceTo(positions[i]);
          float lambda = distances[i]/r;
          positions[i+1] = positions[i].times(1-lambda).plus(positions[i+1].times(lambda));
        }
        
        difference = positions[positions.length - 1].distanceTo(target);
      }
    }
  }
  
  public void draw() {
    Vec2 target = new Vec2(mouseX, mouseY);

    if (!paused) {
      this.solve(target);
    }

    strokeWeight(2);
    stroke(0);

    fill(180, 20, 40); //Root
    pushMatrix();
    translate(positions[0].x, positions[0].y);
    rect(-20, -20, 40, 40);
    popMatrix();

    fill(10, 150, 40);
    for (int i = 0; i < positions.length - 1; i++) {
      line(positions[i].x, positions[i].y, positions[i+1].x, positions[i+1].y);
      circle(positions[i+1].x, positions[i+1].y, 10);
    }

    strokeWeight(0);
  }
}
