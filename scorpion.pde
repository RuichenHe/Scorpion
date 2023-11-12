//Inverse Kinematics
//CSCI 5611 IK [Solution]
// Stephen J. Guy <sjguy@umn.edu>

/*
INTRODUCTION:
Rather than making an artist control every aspect of a characters animation, we will often specify 
key points (e.g., center of mass and hand position) and let an optimizer find the right angles for 
all of the joints in the character's skelton. This is called Inverse Kinematics (IK). Here, we start 
with some simple IK code and try to improve the results a bit to get better motion.

TODO:




CHALLENGE:

1. Go back to the 3-limb arm, can you make it look more human-like. Try adding a simple body to 
   the scene using circles and rectangles. Can you make a scene where the character picks up 
   something and moves it somewhere?
2. Create a more full skeleton. How do you handle the torso having two different arms?

*/
float l0 = 10; 
float a0 = 0.3; //Shoulder joint

//Lower Arm
float l1 = 10;
float a1 = 0.3; //Elbow joint

//Hand
float l2 = 10;
float a2 = 0.3; //Wrist joint

float l3 = 10;
float a3 = 0.3; //Wrist joint

float l4 = 10;
float a4 = 0.3; //Elbow joint

float l5 = 10;
float a5 = 0.3; //Elbow joint

float l6 = 80;
float a6 = 0.3; //Elbow joint

float l7 = 25;
float a7 = 1; //Elbow joint

float l8 = 25;
float a8 = 0.3; //Elbow joint

float l9 = 50;
float a9 = 0.3; //Elbow joint

float[] lengths = {l0, l1, l2, l3, l4, l5, l5, l5, l6, l7, l8, l9};
float[] angles = {a0, a1, a2, a3, a4, a5, a5, a5, a6, a7, -a8, -a9};
Camera camera;
ArrayList<Node> nodes = new ArrayList<Node>();
ArrayList<Node> endEffector = new ArrayList<Node>();
float joint_speed_limit = radians(0.1);
float joint_limit = radians(30);
boolean MOVE_UP, MOVE_DOWN, MOVE_LEFT, MOVE_RIGHT, CATCH_TOGETHER;
float vel = 50;
float scene_scale = width / 10.0f;
Vec2 goal = new Vec2(160, 160);

void setup(){
  size(600, 600, P3D);
  camera = new Camera();
  MOVE_UP = false;
  MOVE_DOWN = false;
  MOVE_LEFT = false;
  MOVE_RIGHT = false;
  CATCH_TOGETHER = false;
  Vec2 rootLocation = new Vec2(0,0);
  surface.setTitle("Inverse Kinematics [CSCI 5611 Example]");
  Node prevNode = new Node(0, 0, joint_speed_limit, -joint_limit, joint_limit);
  for (int i = 0; i < lengths.length; i++){
    if (i == 0){
      Node root = new Node(angles[i], lengths[i], radians(1), radians(-180), radians(180));
      root.location = rootLocation;
      root.type = "Root";
      nodes.add(root);
      prevNode = root;
    } else {
      Node newNode = new Node(angles[i], lengths[i], joint_speed_limit, -joint_limit, joint_limit);
      prevNode.AddChildren(newNode);
      newNode.parent = prevNode;
      newNode.type = "node";
      nodes.add(newNode);
      prevNode = newNode;
    }
  }
  Node newNode = new Node(-1, -1, joint_speed_limit, -joint_limit, joint_limit);
  prevNode.AddChildren(newNode);
  newNode.parent = prevNode;
  newNode.type = "End";
  nodes.add(newNode);
  endEffector.add(newNode);
  
  float[] lengths_2 = {l7, l8, l9};
  float[] angle_2 = {-a7, a8, a9};
  prevNode = nodes.get(8);
  nodes.get(9).joint_limit_min = radians(60); 
  nodes.get(9).joint_limit_max = radians(90);
  nodes.get(10).joint_limit_min = radians(-60); 
  nodes.get(10).joint_limit_max = radians(0);
  nodes.get(11).joint_limit_min = radians(-90); 
  nodes.get(11).joint_limit_max = radians(-60);
  for (int i = 0; i < lengths_2.length; i++){
    newNode = new Node(angle_2[i], lengths_2[i], joint_speed_limit, -joint_limit, joint_limit);
    prevNode.AddChildren(newNode);
    newNode.parent = prevNode;
    newNode.type = "node";
    nodes.add(newNode);
    prevNode = newNode;
  }
  nodes.get(13).joint_limit_min = radians(-90); 
  nodes.get(13).joint_limit_max = radians(-60);
  nodes.get(14).joint_limit_min = radians(0); 
  nodes.get(14).joint_limit_max = radians(60);
  nodes.get(15).joint_limit_min = radians(60); 
  nodes.get(15).joint_limit_max = radians(90);
  
  newNode = new Node(-1, -1, joint_speed_limit, -joint_limit, joint_limit);
  prevNode.AddChildren(newNode);
  newNode.parent = prevNode;
  newNode.type = "End";
  nodes.add(newNode);
  endEffector.add(newNode);
  nodes.get(0).fk(0);
  //background(250,250,250);
  fill(210, 180, 140);
  //nodes.get(0).display(0);
}

//Root


//Upper Arm

float armW = 20;

void updateRoot(float dt){
  Vec2 dir = new Vec2(0, 0);
  for (Node n: endEffector){
    dir.add(n.location.minus(nodes.get(0).location).normalized());
  }
  dir.normalize();
  Vec2 dir_per = new Vec2(-dir.y, dir.x);
  if (cross(dir, dir_per) > 0){
    dir_per = new Vec2(-dir_per.x, -dir_per.y);
  }
  
  
  Vec2 velocity = new Vec2(0, 0);
  if (MOVE_UP) {
    velocity.add(dir.times(vel));
  }
  if (MOVE_DOWN) {
    velocity.subtract(dir.times(vel));
  }
  if (MOVE_LEFT) {
    velocity.add(dir_per.times(vel));
  }
  if (MOVE_RIGHT) {
    velocity.subtract(dir_per.times(vel));
  }
  nodes.get(0).location.add(velocity.times(dt));
  
}

void drawGoal(){
  if (goal.minus(endEffector.get(0).location).length() < 5 || goal.minus(endEffector.get(1).location).length() < 5){
    fill(25, 52, 255);
  } else {
    fill(255, 25, 52);
  }
  
  pushMatrix();
  translate(goal.x, 10 * scene_scale - 10, goal.y);
  box(10, 10, 10);
  popMatrix();
}

void draw(){
  background(255, 255, 255);
  lights();
  ambientLight(255, 221, 0);
  camera.Update(1.0/frameRate);
  updateRoot(1.0/frameRate);
  nodes.get(0).fk(0);
  
  int closestId = -1;
  float closestDis = Float.MAX_VALUE;
  for (int i = 0; i < endEffector.size(); i++){
    float currentDis = goal.minus(endEffector.get(i).location).length();
    if (currentDis < closestDis){
      closestId = i;
      closestDis = currentDis;
    }
  }
  if (CATCH_TOGETHER){
    for (Node n: endEffector){
      n.ik(goal, nodes.get(0), n);
    }
  } else {
    endEffector.get(closestId).ik(goal, nodes.get(0), endEffector.get(closestId));
  }
  
  fill(48, 25, 52);
  nodes.get(0).display(0);
  stroke(0);
  fill(233, 116, 81);
  pushMatrix();
  Vec3 floor_pos = new Vec3(0, 10, 0);
  translate(floor_pos.x * scene_scale, floor_pos.y * scene_scale, floor_pos.z * scene_scale );
  box(5000, 5, 5000);
  popMatrix();
  drawGoal();
  
  
}

void keyPressed()
{
  camera.HandleKeyPressed();
  if (key == 'i') {
    MOVE_UP = true;
  }
  if (key == 'k') {
    MOVE_DOWN = true;
  }
  if (key == 'j') {
    MOVE_LEFT = true;
  }
  if (key == 'l') {
    MOVE_RIGHT = true;
  }
  if (key == 't') {
    CATCH_TOGETHER = !CATCH_TOGETHER;
  }
  if (key == 'r'){
    int randomInt = (int)random(30);
    Vec2 target;
    if (randomInt < 10){
      println("root");
      target = new Vec2(nodes.get(0).location.x, nodes.get(0).location.y);
      goal = new Vec2(random(-160, 160) + target.x, random(-160, 160) + target.y);
      while (goal.minus(nodes.get(0).location).length() < 50){
        goal = new Vec2(random(-160, 160) + target.x, random(-160, 160) + target.y);
      }
    } else if(randomInt > 20){
      println("end1");
      target = new Vec2(endEffector.get(0).location.x, endEffector.get(0).location.y);
      goal = new Vec2(random(-50, 50) + target.x, random(-50, 50) + target.y);
      while (goal.minus(nodes.get(0).location).length() > 160){
        goal = new Vec2(random(-50, 50) + target.x, random(-50, 50) + target.y);
      }
    } else {
      println("end2");
      target = new Vec2(endEffector.get(1).location.x, endEffector.get(1).location.y);
      goal = new Vec2(random(-50, 50) + target.x, random(-50, 50) + target.y);
      while (goal.minus(nodes.get(0).location).length() > 160){
        goal = new Vec2(random(-50, 50) + target.x, random(-50, 50) + target.y);
      }
    }
  }
}

void keyReleased()
{
  camera.HandleKeyReleased();
  if (key == 'i') {
    MOVE_UP = false;
  }
  if (key == 'k') {
    MOVE_DOWN = false;
  }
  if (key == 'j') {
    MOVE_LEFT = false;
  }
  if (key == 'l') {
    MOVE_RIGHT = false;
  }
}
