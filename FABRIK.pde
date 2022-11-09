public class FABRIK {
  Vec3[] positions;
  float[] distances;
  
  public FABRIK(Vec3[] positions, float[] distances) {
    this.positions = positions;
    this.distances = distances;
  }
  
  public void solve(Vec3 target) {
    Vec3 root = positions[0];
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
      Vec3 b = positions[0];
      
      float difference = positions[positions.length - 1].distanceTo(target);
      while (difference > tolerance) {
        //forward search
        positions[positions.length - 1] = target;
        for (int i = distances.length - 1; i >= 0; i--) {
          float r = positions[i + 1].distanceTo(positions[i]);
          float lambda = distances[i]/r;
          positions[i] = positions[i+1].times(1-lambda).plus(positions[i].times(lambda));
          
          if (i < distances.length - 1) {
            Vec3 previousLink = positions[i+2].minus(positions[i+1]);
            Vec3 nextLink = positions[i].minus(positions[i+1]);
            Vec3 axisOfRotation = cross(previousLink, nextLink).normalized();
            float angleBetween = acos(dot(previousLink.normalized(), nextLink.normalized()));
            
            if (angleBetween > angleUpperLimit || angleBetween < angleLowerLimit) {
              float angleDifference;
              
              if (angleBetween > angleUpperLimit) {
                angleDifference = angleUpperLimit - angleBetween;
              } else {
                angleDifference = angleBetween - angleLowerLimit;
              }
              
              // https://en.wikipedia.org/wiki/Rodrigues%27_rotation_formula
              Vec3 rotatedVector = nextLink.times(cos(angleDifference)).plus(cross(axisOfRotation, nextLink).times(sin(angleDifference))).plus(axisOfRotation.times(dot(axisOfRotation, nextLink)).times(1 - cos(angleDifference)));
              positions[i] = rotatedVector.plus(positions[i+1]);
            }
          }
        }
        
        //reverse search
        positions[0] = b;
        for (int i = 0; i < distances.length; i++) {
          float r = positions[i + 1].distanceTo(positions[i]);
          float lambda = distances[i]/r;
          positions[i+1] = positions[i].times(1-lambda).plus(positions[i+1].times(lambda));
          
          if (i > 0) {
            Vec3 previousLink = positions[i-1].minus(positions[i]);
            Vec3 nextLink = positions[i+1].minus(positions[i]);
            Vec3 axisOfRotation = cross(previousLink, nextLink).normalized();
            float angleBetween = acos(dot(previousLink.normalized(), nextLink.normalized()));
            
            if (angleBetween > angleUpperLimit || angleBetween < angleLowerLimit) {
              float angleDifference;
              
              if (angleBetween > angleUpperLimit) {
                angleDifference = angleUpperLimit - angleBetween;
              } else {
                angleDifference = angleBetween - angleLowerLimit;
              }
              
              // https://en.wikipedia.org/wiki/Rodrigues%27_rotation_formula
              Vec3 rotatedVector = nextLink.times(cos(angleDifference)).plus(cross(axisOfRotation, nextLink).times(sin(angleDifference))).plus(axisOfRotation.times(dot(axisOfRotation, nextLink)).times(1 - cos(angleDifference)));
              positions[i + 1] = rotatedVector.plus(positions[i]);
            }
          }
        }
        
        difference = positions[positions.length - 1].distanceTo(target);
      }
    }
  }
  
  public void draw() {
    Vec3 target = new Vec3(150, -150, -150);

    if (!paused) {
      this.solve(target);
    }

    strokeWeight(2);
    stroke(0);

    fill(180, 20, 40); //Root
    pushMatrix();
    translate(positions[0].x - 20, positions[0].y, positions[0].z);
    box(40);
    popMatrix();

    fill(10, 150, 40);
    for (int i = 0; i < positions.length - 1; i++) {
      line(positions[i].x, positions[i].y, positions[i].z, positions[i+1].x, positions[i+1].y, positions[i+1].z);
      pushMatrix();
      noStroke();
      translate(positions[i+1].x, positions[i+1].y, positions[i+1].z);
      sphere(10);
      stroke(strokeWidth);
      popMatrix();
    }

    strokeWeight(0);
  }
}
