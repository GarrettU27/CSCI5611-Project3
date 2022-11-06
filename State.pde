Arm arm;
PRM prm = new PRM();

//Root
Vec2 root = new Vec2(50, 50);

boolean paused = true;

float armW = 20;

int numberOfJoints = 15;
float lengthOfJoints = 100;


float maxVelocity = 200;
float minVelocity = 50;
float maxAcceleration = 300;

int strokeWidth = 2;

// PRM STATE
int numObstacles = 10;
int numNodes  = 200;

static int maxNumObstacles = 1000;
Vec2 circlePos[] = new Vec2[maxNumObstacles]; //Circle positions
float circleRad[] = new float[maxNumObstacles];  //Circle radii

float agentRad = 20;
int numberOfAgents = 1;

Vec2[] startPos = new Vec2[numberOfAgents];
Vec2[] currentPos = new Vec2[numberOfAgents];
float[] currentAngle = new float[numberOfAgents];
Vec2[] goalPos = new Vec2[numberOfAgents];
ArrayList<Integer>[] curPath = new ArrayList[numberOfAgents];

static int maxNumNodes = 1000;
Vec2[] nodePos = new Vec2[maxNumNodes];

Vec2[] currentVel = new Vec2[numberOfAgents];
Vec2[] goalVel = new Vec2[numberOfAgents];
Vec2[] agentsGoalPos = new Vec2[numberOfAgents];

float[] PRMWidthRange = {width/4, 3*width/4};
float [] PRMHeightRange = {height/4, 3*height/4};
