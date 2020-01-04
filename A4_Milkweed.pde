PlantFile[] milkweedLeaves;
PlantFile[] milkweedFlowers;

void initMilkweed() {
  float[] milkweedScales = {0.4, 0.3};
  boolean[] milkweedFlipped = {false, false};
  float[] milkweedRot = {0, 0};
  PVector[] milkweedSnaps = {new PVector(25, 142), new PVector(60, 300)};

  milkweedFlowers = new PlantFile[2];
  for (int i = 0; i < milkweedFlowers.length; i++) {
    milkweedFlowers[i] = new PlantFile("milkweed/flower/" + i + ".svg", milkweedFlipped[i], milkweedSnaps[i].x, milkweedSnaps[i].y, milkweedScales[i], milkweedRot[i]);
  }

  float[] milkweedScalesL = {0.3};
  boolean[] milkweedFlippedL = {false};
  float[] milkweedRotL = {radians(0)};
  PVector[] milkweedSnapsL = {new PVector(250, 60)};

  milkweedLeaves = new PlantFile[1];
  for (int i = 0; i < milkweedLeaves.length; i++) {
    milkweedLeaves[i] = new PlantFile("milkweed/leaves/" + i + ".svg", milkweedFlippedL[i], milkweedSnapsL[i].x, milkweedSnapsL[i].y, milkweedScalesL[i], milkweedRotL[i]);
  }
}

class Milkweed extends Plant {

  Milkweed(PVector loc, float age, boolean dies) {
    this(loc, age, -1);
    this.dies = dies;
  }

  Milkweed(PVector loc, float age, int code) {
    super(loc, age, code);
    //leaves = new ArrayList<BeautyLeaf>();
    growthScaler = 200;
    branching = false;
    hasLeaves = true;

    //numBranches = int(random(0, 3));
    //branchDeg = random(8, 15);
    //if (Math.random() > -0.5) branchDeg *= -1;
  }

  void display(PGraphics s) {
    //s.stroke(col);
    s.pushMatrix();
    s.translate(x, y, z);
    //s.rotateX(radians(25));
    float angle = stemAngle + windAngle/3.0;
    angle = constrain(angle, -10, 10);
    s.rotate(angle);

    //numBranch = 0;
    //totLen = leafSpacing;
    //currentLen = leafSpacing;

    //stem(s, plantHeight*growthScaler, 0, age);

    s.popMatrix();
  }

  void flower(PGraphics s, float stemAge) {
    if (stemAge > bloomAge) isFlowering = true;
    else isFlowering = false;
    isFlowering = true;
    if (isFlowering) milkweedFlowers[getFlowerIndex(stemAge)].display(0, 0, 0, plantHeight, false, s);
  }

  void leaf(int segment, PGraphics s) {
    float scal = map(numBranch, 0, 15, 1.0, .3)*plantHeight;
    float leafScale = map(segment, 0, numSegments, 1.0, 0.4);
    if (segment > 0) {
      milkweedLeaves[0].display(0, 0, 0, scal*leafScale, false, s);
    }
    if (segment < 4) {
      s.pushMatrix();
      s.translate(0, -plantHeight*20);
      milkweedLeaves[0].display(0, 0, 0, scal*leafScale, true, s);
      s.popMatrix();
    }
  }

  int getFlowerIndex(float stemAge) {
    int num = int(map(stemAge, bloomAge, 1, 0, milkweedFlowers.length));
    num = constrain(num, 0, milkweedFlowers.length-1);
    return num;
  }


  void stem(PGraphics s, float plantH, float ang, float stemAge) {
    s.pushMatrix();
    s.strokeWeight(1);
    //while (len > 2) {
    float len = 1.0* plantH / numSegments; 
    for (int i = 0; i < numSegments; i++) {
      numBranch++;

      //s.pushMatrix();  
      s.translate(0, -len);
      //len *= 0.66;
      float angle = curveAngle + windAngle + ang;
      angle = constrain(angle, -PI/7, PI/7);
      s.rotate(angle);   
      float sw = map(i, 0, numSegments, 10, 1)*plantHeight;
      sw = constrain(sw, 1, 10);
      //s.noStroke();
      s.stroke(getStemStroke());
      s.beginShape(QUADS);
      s.fill(getStemFill(numBranch));
      //s.stroke(0);
      s.vertex(-sw/2, 0);
      s.vertex(sw/2, 0);
      s.vertex(sw/2, -len);
      s.vertex(-sw/2, -len);
      s.endShape(CLOSE);

      if (branching) {
        branchOut(s, stemAge);
      }
      if (hasLeaves) {
        s.pushMatrix();
        s.translate(0, -len);
        leaf(i, s);
        s.popMatrix();
      }
    }
    if (isFlowering) {
      s.translate(0, -len);
      flower(s, stemAge);
    }
    s.popMatrix();
  }
  
  color getStemStroke() {
    return 0;
  }

  color getStemFill(int numBranch) {
    return color(constrain(numBranch*40, 0, 255), 255, 0);
  }
}
