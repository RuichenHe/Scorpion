public class Node {
  public Vec2 location;
  public float a;
  public float l; 
  public ArrayList<Node> children;
  public Node parent;
  public String type;
  public float joint_speed_limit;
  public float joint_limit_min;
  public float joint_limit_max;
  public Node(float a, float l, float joint_speed_limit, float joint_limit_min, float joint_limit_max){
    this.a = a;
    this.l = l;
    this.children = new ArrayList<Node>();
    this.parent = null;
    this.joint_speed_limit = joint_speed_limit;
    this.joint_limit_min = joint_limit_min;
    this.joint_limit_max = joint_limit_max;
  }
  
  public void AddChildren(Node child){
    child.parent = this;
    this.children.add(child);
  }
  
  public boolean isBase(){
    if (this.parent != null){
      return false;
    } else{
      return true;
    }
  }
  
  public boolean isEnd(){
    if (this.children.size() != 0){
      return false;
    } else{
      return true;
    }
  }
  
  public void fk_fromRoot(Node root){
    root.fk(0);
  }
  
  
  public void fk(float init_a){
    for (Node child: this.children){
      float new_a = init_a + this.a;
      child.location = new Vec2(cos(new_a)*this.l, sin(new_a)*this.l).plus(this.location);
      child.fk(new_a);
    }
  }
  
  public void display(float init_a){
    switch (this.type){
      case "End":
        break;
      case "Root":
        pushMatrix();
        translate(this.location.x, 10 * scene_scale - 30, this.location.y);
        //rotateY(-(init_a+this.a));
        //rect(0, -5, this.l, 10);
        box(10, 30, 10);
        popMatrix();
      default:
        float new_a = init_a + this.a;
        Vec2 childrenLoc = new Vec2(cos(new_a)*this.l, sin(new_a)*this.l).plus(this.location);
        pushMatrix();
        translate((this.location.x + childrenLoc.x)/2, 10 * scene_scale - 10, (this.location.y+childrenLoc.y)/2);
        rotateY(-(init_a+this.a));
        //rect(0, -5, this.l, 10);
        box(this.l, 10, 10);
        popMatrix();
        for (Node child: this.children){
          child.display(init_a+this.a);
        }
    }
  }
  
  public void ik(Vec2 goal, Node root, Node endPoint){
    if (this.type == "Root"){
      return;
    } else {
      float dotProd, angleDiff;
      Vec2 startToGoal, startToEndEffector;
      startToGoal = goal.minus(this.parent.location);
      startToEndEffector = endPoint.location.minus(this.parent.location);
      dotProd = dot(startToGoal.normalized(),startToEndEffector.normalized());
      dotProd = clamp(dotProd,-1,1);
      angleDiff = acos(dotProd);
      angleDiff = clamp(angleDiff, -this.parent.joint_speed_limit, this.parent.joint_speed_limit);
      if (cross(startToGoal,startToEndEffector) < 0)
        this.parent.a += angleDiff;
      else
        this.parent.a -= angleDiff;
      if (this.parent.type == "Root"){
      } else {
        this.parent.a = max(min(this.parent.a, this.parent.joint_limit_max), this.parent.joint_limit_min);
      }
      
      /*TODO: Wrist joint limits here*/
      
      this.fk_fromRoot(root);
      this.parent.ik(goal, root, endPoint);
    }
  }
}
  
  
  
