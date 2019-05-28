PlantFile[] lizardLeaves;
PlantFile[] lizardFlowers;
float[] lizardScales = {0.3, 0.7, .18, .28};
boolean[] lizardFlipped = {false, false, false, false};
float[] lizardRot = {radians(220), 0, degrees(2.618), degrees(4.5379)};
PVector[] lizardSnaps = {new PVector(89, 142), new PVector(53, 81), new PVector(24, 88), new PVector(93, 38)};

void initLizard() {
  lizardFlowers = new PlantFile[1];
  lizardFlowers[0] = new PlantFile("lizard/flower/0.svg", false, 230, 300, 0.25, 0);

  lizardLeaves = new PlantFile[4];
  for (int i = 0; i < lizardLeaves.length; i++) {
    lizardLeaves[i] = new PlantFile("lizard/leaves/" + i + ".svg", lizardFlipped[i], lizardSnaps[i].x, lizardSnaps[i].y, lizardScales[i], lizardRot[i]);
  }
}

class Lizard extends Plant {

  Lizard(PVector loc, float age) {
    super(loc, age);

    branching = true;
    hasLeaves = true;
    growthScaler = 60;
  }

  void display(PGraphics s) {
    yoff += 0.005;
    randomSeed(seed);

    s.pushMatrix();
    s.translate(x, y, z);
    float angle = stemAngle + windAngle/3.0;
    angle = constrain(angle, -10, 10);
    s.rotate(angle);
    s.pushMatrix();
    //lizardLeaves[0].display(0, 0, 0, plantHeight*.8, false, s);
    ////s.translate(8*plantHeight, random(10)*plantHeight);
    //if (random(0, 1) > 0.5) lizardLeaves[1].display(0, 0, 0, plantHeight*.6, true, s);
    s.popMatrix();



    numBranch = 0;
    branch(s, 0, plantHeight*growthScaler, 0);
    s.popMatrix();
  }

  void leaf(int div, PGraphics s) {
    s.pushMatrix();
    s.translate(0, 0, 1);
    s.fill(0, 0, 255);
    s.noStroke();
    float leafScale = map(div, 0, 2, 0.5, 0.3);

    float rot =  radians(210);
    if (div < 2) rot = 0;
    if (numBranch %3 == 0) lizardLeaves[0].display(0, 0, rot, plantHeight*leafScale, false, s);
    else if (numBranch %2 == 0) lizardLeaves[1].display(0, 0, rot, plantHeight*leafScale, true, s);
    else lizardLeaves[2].display(0, 0, rot, plantHeight*leafScale, true, s);

    //s.fill(0);
    //s.text(numBranch, 0, 0);
    s.popMatrix();
  }

  // Daniel Shiffman Nature of Code http://natureofcode.com
  void branch(PGraphics s, int div, float h, float xoff) {
    int numDivs = 3;
    numBranch++;
    // thickness of the branch is mapped to its length
    float sw = map(div, 0, numDivs, 15*plantHeight, 1);
    s.strokeWeight(sw);
    // Draw the branch
    s.beginShape(QUADS);
    s.fill(constrain(numDivs*40, 0, 255), 255, 0);
    s.vertex(0, 0);
    s.vertex(sw, 0);
    s.vertex(sw, -h);
    s.vertex(0, -h);
    s.endShape(CLOSE);
    s.ellipse(sw/2, -h, sw/2, sw/2);
    // Move along to end
    s.translate(0, -h);

    // Each branch will be 2/3rds the size of the previous one
    float per = 0.9;
    h *= per;
    // Move along through noise space
    xoff += 0.1;

    if (div < numDivs) {
      // Random number of branches
      float branchSpreadMax = map(div, 0, numDivs, 3, 1);
      //float branchSpreadMin = map(numBranch, 0, numBranches, 3, 1);
      //int n = int(random(branchSpreadMin, branchSpreadMax));
      //int n = int(random(0, 4));
      //int n = 1;
      int n = int(random(0, branchSpreadMax));
      if (n == 0 || n == 1) leaf(div, s);
      //if (Math.random() > .3) {
      //  leaf(1, s);
      //}
      //else {
      //flower(s, 1.0);

      //println("eave");
      //}

      for (int i = 0; i < n; i++) {

        // Here the angle is controlled by perlin noise
        // This is a totally arbitrary way to do it, try others!
        //float thetaSpread = map(numBranch, 0, numBranches, PI/4, PI/1.5);
        float thetaSpread = PI/2;
        float theta = map(noise(xoff+i, yoff), 0, 1, -thetaSpread, thetaSpread);
        //float theta = PI/4;
        if (n%2==0) theta *= -1;

        s.pushMatrix();      // Save the current state of transformation (i.e. where are we now)
        s.rotate(theta);     // Rotate by theta
        branch(s, div+1, h, xoff);   // Ok, now call myself to branch again
        s.popMatrix();       // Whenever we get back here, we "pop" in order to restore the previous matrix state
      }
    } else {
      if (isFlowering) flower(s, 1.0);
      else leaf(div, s);
    }
  }

  void flower(PGraphics s, float stemAge) {
    //s.fill(255, 0, 255);
    //s.ellipse(0, 0, 10, 10);
    //s.fill(0);
    //s.text(numBranch, 0, 0);
    if (numBranch %3 == 0) lizardFlowers[0].display(0, 0, 0, plantHeight, false, s);
    else  lizardFlowers[0].display(0, 0, 0, plantHeight, true, s);
  }
}
