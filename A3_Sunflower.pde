PlantFile[] sunflowerFlowers;
PlantFile sunflowerLeaf;



void initSunflower() {  
  sunflowerFlowers = new PlantFile[4];
  float[] sunflowerScales = {0.04, 0.045, .045, .022};
  boolean[] sunflowerFlipped = {false, true, false, false};
  float[] sunflowerRot = {0, 0, 0, 0};
  PVector[] sunflowerSnaps = {new PVector(380, 450), new PVector(600, 750), new PVector(800, 800), new PVector(1400, 2000)};

  sunflowerLeaf = new PlantFile("sunflower/leaves/0.svg", false, 4, 131, 0.06, 0);
  for (int i = 0; i < sunflowerFlowers.length; i++) {
    sunflowerFlowers[i] = new PlantFile("sunflower/flower/" + i + ".svg", sunflowerFlipped[i], sunflowerSnaps[i].x, sunflowerSnaps[i].y, sunflowerScales[i], sunflowerRot[i]);
  }
}


class Sunflower extends Plant {

  int numBranches;
  int numStems;
  float branchDeg;

  Sunflower(PVector loc, float age, boolean dies) {
    this(loc, age, -1);
    this.dies = dies;
  }

  Sunflower(PVector loc, float age, int code) {
    super(loc, age, code);
    //leaves = new ArrayList<BeautyLeaf>();
    growthScaler = 500;
    branching = true;
    isFlowering = true;
    hasLeaves = true;

    numBranches = int(random(0, 3));
    numStems = int(random(2, 4));
    branchDeg = random(4, 10);
    if (Math.random() > -0.5) branchDeg *= -1;
    col = color(#4EBD00);
  }

  void display(PGraphics s) {
    //s.stroke(col);
    s.pushMatrix();
    s.translate(x, y, z);
    float angle = stemAngle + windAngle/3.0;
    angle = constrain(angle, -10/2, 10/2);
    s.rotate(angle);


    totLen = leafSpacing;
    currentLen = leafSpacing;

    s.stroke(0);
    s.fill(col);

    randomSeed(11);
    for (int i = 0; i < numStems; i++) {
      s.translate(i*7+random(3, 5), 0, 0);
      numBranch = 0;
      float ag = age * random(.7, 1.1);
      ag = constrain(ag, 0, age);
      stem(s, i, plantHeight*growthScaler*random(.7, 1), radians(0), ag);
    }

    s.popMatrix();
  }


  void stem(PGraphics s, int numStem, float plantH, float ang, float stemAge) {
    s.pushMatrix();
    s.strokeWeight(1);
    //while (len > 2) {
    float len = 1.0* plantH / numSegments; 
    for (int i = 0; i < numSegments; i++) {


      //s.pushMatrix();  
      s.translate(0, -len);
      //len *= 0.66;
      float angle = curveAngle + windAngle;
      angle = constrain(angle, -PI/20, PI/20)+ang;
      s.rotate(angle);   
      float sw = map(i, 0, numSegments, 8, 1)*plantHeight;
      sw = constrain(sw, 1, 8);
      //s.noStroke();
      s.strokeWeight(1*plantHeight);
      s.stroke(getStemStroke());
      s.beginShape(QUADS);
      s.fill(getStemFill(numBranch));
      //s.stroke(0);
      s.vertex(-sw/2, 0);
      s.vertex(sw/2, 0);
      s.vertex(sw/2, -len);
      s.vertex(-sw/2, -len);
      s.endShape(CLOSE);

      //if (branching) {
      //  branchOut(s, i, numStem, numBranch, stemAge);
      //}

      // secondary flowers
      if (isFlowering && ((i == numSegments-1 && (numStem+pID)%2==0) || (i == numSegments-3 && numStem == 0)) ) {
        s.pushMatrix();
        s.stroke(getStemFill(0));
        s.strokeWeight(4*plantHeight);
        float xx = 25*plantHeight;
        if ((pID+numStem)%2 == 0) {

          s.line(0, 0, xx, -xx);
          s.translate(xx, -xx, 2);
          float ag = stemAge*random(.3, .9);
          sunflowerFlowers[getFlowerIndex(ag)].display(0, 0, 0, plantHeight, true, s);
        } else {
          s.line(0, 0, -xx, -xx);
          s.translate(-xx, -xx, 2);
          float ag = stemAge*random(.3, .9);
          sunflowerFlowers[getFlowerIndex(ag)].display(0, 0, 0, plantHeight, false, s);
        }
        s.popMatrix();
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

  void flower(PGraphics s, float stemAge) {
    s.pushMatrix();
    s.translate(0, 0, 2);
    //if (stemAge > bloomAge) isFlowering = true;
    //else isFlowering = false;
    //isFlowering = true;
    //s.translate(0, 0, 5);
    sunflowerFlowers[getFlowerIndex(stemAge)].display(0, 0, 0, plantHeight, false, s);
    s.popMatrix();
  }


  void leaf(int segment, PGraphics s) {
    //super.leaf(segment, s);
    s.pushMatrix();
    float leafScale = map(segment, 0, 5, .7, 0.1);
    if (segment %2 == 0) sunflowerLeaf.display(0, 0, 0, plantHeight*leafScale, false, s);
    else sunflowerLeaf.display(0, 0, 0, plantHeight*leafScale, true, s);
    s.popMatrix();
  }

  int getFlowerIndex(float stemAge) {
    int num = int(map(stemAge, bloomAge, 1, 0, 4));
    num = constrain(num, 0, 3);
    return num;
  }

  void branchOut(PGraphics s, int numStem, int segment, int branch, float stemAge) {
    if (segment == 2 && branch == 0) {
      numBranch++;
      stem(s, numStem, plantHeight*growthScaler, radians(branchDeg), stemAge*.8);  // /2
    }
  }

  color getStemStroke() {
    return 0;
  }

  color getStemFill(int numBranch) {
    //return color(constrain(numBranch*40, 0, 255), 255, 0);
    return color(25, 66, 8 );
  }
}
