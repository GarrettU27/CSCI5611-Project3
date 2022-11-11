FABRIK f1, f2;
Target t1, t2;
Target selected;
Camera camera;
float targetRadius = 30;

//Root
Vec3 root = new Vec3(50, 50, 0);

boolean paused = true;

float armW = 20;

int numberOfPoints = 25;
float lengthOfPoints = 100;

float tolerance = 10;
int strokeWidth = 2;

float angleLimit = PI/2;
float angleUpperLimit = PI + angleLimit;
float angleLowerLimit = PI - angleLimit;

int maxIterations = 1000; // if FABRIK goes over the max iterations, just output what is possible
