public class CollissionlessRRT extends RRT {
 public boolean collides(PVector sample){
    if (sample.x>width || sample.x<0) {
	  //println("to high");
      return true;
    }   
    if (sample.y>height|| sample.y<0) {
	  //println("to wide");
      return true;
     }
     for (Obstacle obstacle: obst) {
      if (obstacle.intersects(sample)) {
        //println("intersects");
        return true;
      }
     }
     return false;
 }

  public void advance() {
    PVector targetVec = nextSample();	  
    Node nn = null ;
    while(1==1) {
      PVector sample = nextSample();	  

      nn = this.getNearestNeighbor(sample);
      
      //println("pair:("+sample+")--("+nn.pos.x+","+nn.pos.y+")");
      targetVec = vecBetween(nn.pos, sample, setp_size);
      
      if (!collides(targetVec)) {
        break;
      }else{
        circle(targetVec.x, targetVec.y, 50);
      }
    }
    Node newNode = new Node(targetVec);
    
    //println("=>("+newNode.pos.x+","+newNode.pos.y+")");
    nn.addNeighbour(newNode);
    newNode.setDepth(nn.depth+1);
    
    nodes.add(newNode);
  }

    public CollissionlessRRT(PVector startNode, int livetime) {
	    super(startNode, livetime);
    }
}



public class UnbalancedRTT extends RRT{
  public void advance() {
    PVector sample = nextSample();	  

    Node nn = this.getNearestNeighbor(sample);
    
    //println("pair:("+sample+")--("+nn.pos.x+","+nn.pos.y+")");
    //int len = floor((1.0/(nn.depth+1))*setp_size);
    //int len = floor(map(nn.depth, 0,100,width/4,10));
    int len = floor((1.0/(nn.depth+1))*(height/3));
    //println("len:"+len);
    PVector targetVec = vecBetween(nn.pos, sample, len);
    Node newNode = new Node(targetVec);
    
    //println("=>("+newNode.pos.x+","+newNode.pos.y+")");
    nn.addNeighbour(newNode);
    newNode.setDepth(nn.depth+1);
    
    nodes.add(newNode);
  }

  public UnbalancedRTT(PVector startNode, int livetime) {
	  super(startNode, livetime);
  }
}

public class RRT {
  ArrayList<Node> nodes = new ArrayList<Node>();
  int ttl = 20;
  int livetime;
  boolean growth_stop = false;
  float MATURED_FACTOR = 0.2;


  public RRT(PVector startNode, int livetime) {
    nodes.add(new Node(startNode, 20));
    this.ttl = livetime;
    this.livetime = livetime;
  }
  
  public Node getNearestNeighbor(PVector sample) {
      float min_dist = 2*max(width, height);
      Node nn = null; //nearest neighbor
      for (Node contestant : this.nodes) {
        float dist = contestant.pos.dist(sample);
        //println(dist +"<"+mindist +"=>"+ (dist<mindist) +"="+nearestNeighbor);
        if (dist <= min_dist) { 
          min_dist = dist; 
          nn = contestant; 
        }
      }
      //println(min_dist + ": nearest =>"+nn);
      assert(nn != null);
      return nn;
  }

  public void stop_growth() {
    for (Node node : this.nodes) {
      node.die(max(1,this.ttl/10));
    }
    growth_stop = false;
  }

  
  public void act() {
    if (this.isDead()) {
      return ;
    }

    if (matured()) { 
      if (!growth_stop) {
        stop_growth();
      }
      //println(ttl+"/"+livetime+"=>killing + "+ this.ttl);
    } else {
      this.advance();
    }
    this.ttl--;
  }

  public boolean matured() {
    return this.ttl <  MATURED_FACTOR * this.livetime;
  }

  public boolean isDead() {
    return this.ttl < 0;
  }

  public void render() {
    if (this.isDead()) {
      return;
    }

    for (Node node : this.nodes) {
      node.render();
    }
  }


  public PVector nextSample() {
    int x = (int)random(width);
    int y = (int)random(height);
    
    PVector sample = new PVector(x, y);
    return sample;
  }

  public void advance() {
    PVector sample = nextSample();	  
    Node nn = this.getNearestNeighbor(sample);
    
    //println("pair:("+sample+")--("+nn.pos.x+","+nn.pos.y+")");
    PVector targetVec = vecBetween(nn.pos, sample, setp_size);
    Node newNode = new Node(targetVec);
    
    //println("=>("+newNode.pos.x+","+newNode.pos.y+")");
    nn.addNeighbour(newNode);
    newNode.setDepth(nn.depth+1);
    
    nodes.add(newNode);
  }
}

public PVector vecTowards(PVector base, PVector target) {
    float dx = target.x-base.x;
    float dy = target.y-base.y;
    PVector newVec = new PVector(dx, dy);
    return newVec;
 }
  
public PVector vecBetween(PVector base, PVector target, int len) {
    PVector towards = vecTowards(base, target);
    //println(towards);
    towards.setMag(len);
    towards.add(base);
    return towards;
}
