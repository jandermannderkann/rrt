
public class Node {
  PVector pos;
  ArrayList<Node> neighbors = new ArrayList<Node>();
  color col;
  int size = 5;
  int depth = 0;

  int ttl;
  boolean alive = true;
  
  public void init() {
    float cval = map(depth, 50, 0, 0,1);

    this.col = lerpColor(c1,c2,cval);
  }
  
  public void label() {
    text(this.depth,pos.x+2, pos.y+2);
  }

  public void render() {
    color curr_col = this.col;

    if (!this.alive) {
      int est_depth = (int)(max(width, height)*0.3)/setp_size;
      //println("dying"+ttl +"-"+ est_depth); 
      
      float cval = map(ttl, est_depth, 0, 0,1);

      curr_col = lerpColor(this.col,bgcol,cval);
      this.ttl = this.ttl-1;
    }
    fill(curr_col);
    stroke(curr_col);
    // circle(this.pos.x, this.pos.y, this.size);
    
    for (Node neighbour : this.neighbors) {
      line(pos.x,pos.y, neighbour.pos.x, neighbour.pos.y);
    }
    if (debug) {
      label();
    }
  }
  
  public void die() {
    if (this.alive) {
      this.alive = false;
      this.ttl = depth;
    }
  }

  public void die(int decay_time) {
    if (this.alive) {
      die();
      this.ttl = decay_time*depth;
      this.ttl=depth;
    }
  }

  public void setDepth(int newDepth) {
    this.depth=newDepth;
    init();
  }
  
  public Node(PVector pos){
    this.pos = pos;
    this.init();
  }
  
  public Node(PVector pos, int size){
    this.pos = pos;
    this.size = size;
    this.init();
  }

  public void addNeighbour(Node neighbour) {
    this.neighbors.add(neighbour);
    this.render();
  }
}
