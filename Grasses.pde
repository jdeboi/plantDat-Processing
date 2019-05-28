int GRASS_ID = 0;
class Grasses {

  ArrayList<GrassBlade>grasses;
  int id;
  Grasses(int x, int y, int num, int w) {
    id = 0;
    grasses = new ArrayList<GrassBlade>();
    for (int i = 0; i < num; i++) {
      PVector loc = getSpawnedXY(random(100),random(100));
      grasses.add(new GrassBlade(int(loc.x), y, int(loc.y)));
    }
  }

  void display(PGraphics s) {
    for (int i = 0; i < grasses.size(); i++) {
      grasses.get(i).display(s);
    }
  }

  void grow() {
    for (GrassBlade g : grasses) {
      g.grow();
    }
  }
}

class GrassBlade extends Plant {

  float curveAngle;
  float stemAngle;
  color col;
  int id;
  int numBranch = 0;

  GrassBlade(int x, int y, int z) {
    super(x, y, z);
    id = GRASS_ID++;
    growthRate = random(.04, .09);
    ageGrowthStops = 0.6;
    ageDeath = random(0.8, 1.0);

    stemAngle = radians(random(-5, 5));
    curveAngle = radians(random(-10, 10));

    col = color(random(150, 255));
  }

 
  void display(PGraphics s) {
    //s.stroke(col);
    s.pushMatrix();
    s.translate(x, y, z);
    float angle = stemAngle + windAngle/3.0;
    angle = constrain(angle, -10, 10);
    s.rotate(angle);
    
    numBranch = 0;
    branch(s, plantHeight);
    
    s.popMatrix();
  }

  
  // Daniel Shiffman Nature of Code http://natureofcode.com
  void branch(PGraphics s, float len) {
    // Each branch will be 2/3rds the size of the previous one

    
    numBranch++;

    float sw = map(len, 2, 120, 1, 10);
    s.strokeWeight(sw);
    s.noStroke();
    //s.line(0, 0, 0, -len);
    s.fill(col);
    //s.rect(0, 0, sw, -len);
    s.beginShape(QUADS);
    s.fill(constrain(numBranch*40, 0, 255), 255, 0);
    s.vertex(0, 0);
    s.vertex(sw, 0);
    s.vertex(sw, -len);
    s.vertex(0, -len);
    s.endShape(CLOSE);

    //Move to the end of that line
    s.translate(0, -len);

    //float swStart = map(len, 2, 120, 1, 10);
    //for (int j = 0; j < 5; j++) {
    //  float sw = map(j, 0, 4, swStart*2, swStart);
    //  //float st = map(j, 0, 4, 40, 255);
    //  float st = j*j*1.3+50;
    //  s.stroke(255, st);
    //  s.strokeWeight(sw);

    //  s.pushMatrix();
    //  s.line(0, 0, 0, -len);
    //  s.popMatrix();
    //}
    //s.translate(0, -len);

    len *= 0.66;
    // All recursive functions must have an exit condition!!!!
    // Here, ours is when the length of the branch is 2 pixels or less
    if (len > 2) {
      s.pushMatrix();    // Save the current state of transformation (i.e. where are we now)
      float angle = curveAngle + windAngle;
      angle = constrain(angle, -PI/7, PI/7);
      s.rotate(angle);   
      branch(s, len);       // Ok, now call myself to draw two new branches!!
      s.popMatrix();     // Whenever we get back here, we "pop" in order to restore the previous matrix state
    }
    
  }
}
