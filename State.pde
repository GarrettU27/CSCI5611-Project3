FABRIK f;
Camera camera;

//Root
Vec3 root = new Vec3(50, 50, 0);

boolean paused = true;

float armW = 20;

int numberOfPoints = 25;
float lengthOfPoints = 100;

float tolerance = 1;
int strokeWidth = 2;

float angleLimit = PI/6;
float angleUpperLimit = PI + angleLimit;
float angleLowerLimit = PI - angleLimit;

int maxIterations = 1000; // if FABRIK goes over the max iterations, just output what is possible
