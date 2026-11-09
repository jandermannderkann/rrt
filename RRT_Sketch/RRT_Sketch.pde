boolean debug = false;
int setp_size = 20;
color bgcol = color(00);
color c1 = color(20,50,150);
color c2 = color(200,50,100);

ArrayList<RRT> trees =  new ArrayList<RRT>();

int livetime = 8000;
PVector centerP;
Obstacle b1;
int mode = 1;


void setup() {
  size(1920, 1080);
  background(bgcol);
  centerP= new PVector(width/2, height/2);
  b1 = new CircObstacle(new PVector(20,20),new PVector(30,30));
  trees.add(new CollissionlessRRT(centerP, livetime));
}

int i =0;

void render() {
  for (Obstacle obstacle : obst) {
    obstacle.render();
  }

  for (RRT tree : trees) {
    tree.render();
  }
  b1.render();
}

public void act() {
  for (RRT tree: trees) {
    tree.act();
  }
}

void draw() {
  background(bgcol);
  if (i > livetime * 1.2) {
    delay(400);
    i = 0;
    trees.add(new CollissionlessRRT(centerP, livetime));

    return;
  }

  act();
  render();
  
  i++;
  //delay(50);
}

ArrayList<Obstacle> obst =  new ArrayList<Obstacle>();
PVector firstClick;

public void mouseClicked() {
  if (mode == 1) {
    create_obst();
  } else if (mode == 2) {
    create_tree();
  }
  checkButton(); 
}

public void checkButton() {
  PVector click =  new PVector(mouseX, mouseY);
  if (b1.intersects(click)) {
    if (mode == 1) {
      mode = 2;
    } else {
      mode =1;
    }

  }
}

public void create_tree() {
  trees.add(new CollissionlessRRT(new PVector(mouseX, mouseY), livetime));
}

public void create_obst() {
  
  if (firstClick != null) {
    PVector secondClick = new PVector(mouseX, mouseY);
    obst.add(new CircObstacle(firstClick, secondClick));

    firstClick = null;
    return;
  }
  firstClick = new PVector(mouseX, mouseY);
}
