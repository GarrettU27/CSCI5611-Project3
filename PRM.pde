Vec2 generateRandomPosition() {
  return new Vec2(random(width), random(height));
}

//Generate non-colliding PRM nodes
void generateRandomNodes(int numNodes, Vec2[] circleCenters, float[] circleRadii) {
  for (int i = 0; i < numNodes; i++) {
    Vec2 randPos = generateRandomPosition();
    boolean insideAnyCircle = pointInCircleList(circleCenters, circleRadii, numObstacles, randPos, 2);

    while (insideAnyCircle) {
      randPos = generateRandomPosition();
      insideAnyCircle = pointInCircleList(circleCenters, circleRadii, numObstacles, randPos, 2);
    }
    nodePos[i] = randPos;
  }
}

void placeRandomObstacles(int numObstacles) {
  //Initial obstacle position
  for (int i = 0; i < numObstacles; i++) {
    circlePos[i] = generateRandomPosition();
    circleRad[i] = (20+40*pow(random(1), 3));

    // if in another circle, retry
    if (circleIntersectsCircleList(circlePos, circleRad, i, circlePos[i], circleRad[i])) {
      i--;
      continue;
    }

    circleRad[i] += agentRad; // the agentRad is accounted for in calculations, but I don't want it accounted for in placement
    // as they are drawn without the agent radius
  }
  circleRad[0] = 30 + agentRad; //Make the first obstacle big
}


void createGraph() {
  placeRandomObstacles(numObstacles);
  generateRandomNodes(numNodes, circlePos, circleRad);
  connectNeighbors(circlePos, circleRad, numObstacles, nodePos, numNodes);

  for (int i = 0; i < numberOfAgents; i++) {
    startPos[i] = sampleFreePos();
    currentPos[i] = startPos[i].times(1);
    goalPos[i] = sampleFreePos();
    curPath[i] = planPath(startPos[i], goalPos[i], circlePos, circleRad, numObstacles, nodePos, numNodes);
    currentVel[i] = new Vec2(0, 0);
    goalVel[i] = new Vec2(0, 0);
    agentsGoalPos[i] = new Vec2(0, 0);
  }
}

Vec2 sampleFreePos() {
  Vec2 randPos = generateRandomPosition();
  boolean insideAnyCircle = pointInCircleList(circlePos, circleRad, numObstacles, randPos, 2);
  while (insideAnyCircle) {
    randPos = generateRandomPosition();
    insideAnyCircle = pointInCircleList(circlePos, circleRad, numObstacles, randPos, 2);
  }
  return randPos;
}

void moveAgents(float dt) {
  for (int i = 0; i < numberOfAgents; i++) {
    if (isMovementPossible(currentPos[i], goalPos[i])) {
      agentsGoalPos[i] = goalPos[i];
    } else if (curPath[i].size() == 1 && curPath[i].get(0) == -1) { //No path found
      agentsGoalPos[i] = startPos[i];
    } else {
      for (int j = curPath[i].size()-1; j >= 0; j--) {
        Vec2 curPathNode = nodePos[curPath[i].get(j)];
        if (isMovementPossible(currentPos[i], curPathNode)) {
          agentsGoalPos[i] = curPathNode;
          break;
        }
      }
    }

    goalVel[i] = agentsGoalPos[i].minus(currentPos[i]);

    if (goalVel[i].length() >= maxVelocity) {
      goalVel[i].setToLength(maxVelocity);
    } else if (goalVel[i].length() <= minVelocity && goalVel[i].length() != 0) {
      goalVel[i].setToLength(minVelocity);
    }

    Vec2 currentAcc = goalVel[i].minus(currentVel[i]);
    if (currentAcc.length() > 5) {
      currentAcc.setToLength(maxAcceleration);
      currentVel[i].add(currentAcc.times(dt));
    }

    float distanceToGoal = currentPos[i].distanceTo(agentsGoalPos[i]);
    if (distanceToGoal < currentVel[i].times(dt).length()) {
      currentPos[i] = agentsGoalPos[i].times(1);
    } else {
      currentPos[i].add(currentVel[i].times(dt));
    }

    currentAngle[i] = atan2(currentVel[i].y, currentVel[i].x) + PI/2;
  }
}

boolean isMovementPossible(Vec2 initialPos, Vec2 finalPos) {
  Vec2 dir = finalPos.minus(initialPos).normalized();
  float distBetween = initialPos.distanceTo(finalPos);
  hitInfo circleListCheck = rayCircleListIntersect(circlePos, circleRad, numObstacles, initialPos, dir, distBetween);
  return !circleListCheck.hit;
}

public class PRM {
  public void setup() {
    size(2048, 1536, P2D);

    for (int i = 0; i < numberOfAgents; i++) {
      startPos[i] = new Vec2(0, 0);
      currentPos[i] = new Vec2(0, 0);
      goalPos[i] = new Vec2(0, 0);
      currentVel[i] = new Vec2(0, 0);
      goalVel[i] = new Vec2(0, 0);
      agentsGoalPos[i] = new Vec2(0, 0);
    }

    createGraph();
  }

  public void draw() {
    strokeWeight(0);
    stroke(0, 0, 0);
    fill(0, 0, 0, 80);

    //Draw the circle obstacles
    for (int i = 0; i < numObstacles; i++) {
      Vec2 c = circlePos[i];
      float r = circleRad[i] - agentRad;

      circle(c.x, c.y, r*2);
    }

    //Draw PRM Nodes
    fill(0);
    for (int i = 0; i < numNodes; i++) {
      circle(nodePos[i].x, nodePos[i].y, 5);
    }

    //Draw graph
    stroke(50, 50, 50);
    strokeWeight(1);
    for (int i = 0; i < numNodes; i++) {
      for (int j : neighbors[i]) {
        line(nodePos[i].x, nodePos[i].y, nodePos[j].x, nodePos[j].y);
      }
    }

    stroke(255, 255, 255);
    strokeWeight(5);
    for (int i = 0; i < numNodes; i++) {
      point(nodePos[i].x, nodePos[i].y);
    }

    if (!paused) {
      moveAgents(1.0/frameRate);
    }

    for (int i = 0; i < numberOfAgents; i++) {
      float PHI = (1 + sqrt(5))/2;
      float n = i * PHI - floor(i * PHI);
      colorMode(HSB, 255, 255, 255);

      stroke(0, 0, 0);
      strokeWeight(1);
      color colorToUse = color(floor(n*256), 128, 255);
      colorMode(RGB, 255, 255, 255);

      //Draw Start and Goal
      fill(colorToUse);
      circle(startPos[i].x, startPos[i].y, 20);

      fill(colorToUse);
      circle(goalPos[i].x, goalPos[i].y, 20);

      if (curPath[i].size() >0 && curPath[i].get(0) == -1) continue; //No path found

      //Draw Planned Path
      stroke(colorToUse);
      strokeWeight(5);
      if (curPath[i].size() == 0) {
        line(startPos[i].x, startPos[i].y, goalPos[i].x, goalPos[i].y);
        return;
      }
      line(startPos[i].x, startPos[i].y, nodePos[curPath[i].get(0)].x, nodePos[curPath[i].get(0)].y);
      for (int j = 0; j < curPath[i].size()-1; j++) {
        int curNode = curPath[i].get(j);
        int nextNode = curPath[i].get(j+1);
        line(nodePos[curNode].x, nodePos[curNode].y, nodePos[nextNode].x, nodePos[nextNode].y);
      }
      line(goalPos[i].x, goalPos[i].y, nodePos[curPath[i].get(curPath[i].size()-1)].x, nodePos[curPath[i].get(curPath[i].size()-1)].y);

      //Draw moving agents
      stroke(colorToUse);
      strokeWeight(2);
      fill(colorToUse, 70);
      circle(currentPos[i].x, currentPos[i].y, agentRad*2);
    }

    strokeWeight(0);
  }
}
