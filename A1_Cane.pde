PlantFile[] caneFlowers;
PlantFile caneStem;

void initCane() {
  caneFlowers = new PlantFile[2];
  caneFlowers[0] = new PlantFile("cane/flower/0.svg", false, 2300, 1000, 0.013, radians(90));
  caneFlowers[1] = new PlantFile("cane/flower/1.svg", false, 500, 2700, 0.02, 0);
  caneStem = new PlantFile("cane/stem/0.svg", false, 400, 2400, 0.04, radians(-6));
}

class Cane extends Plant {
  color strokeCol;

  int numFlowers = 0;
  Cane(PVector loc, float age, boolean dies) {
    this(loc, age, -1);
    this.dies = dies;
  }

  Cane(PVector loc, float age, int code) {
    super(loc, age, code);
    branching = true;
    hasLeaves = true;
    growthScaler = 70;
    //col = color(55, 125, 34);
    col = color(60, 68, 31);
    strokeCol = col;
  }

  void display(PGraphics s) {
    yoff += 0.005;
    //println(seed);
    randomSeed(seed);
    s.strokeWeight(1*plantHeight);
    s.fill(col);
    //s.noStroke();
    s.stroke(strokeCol);
    s.pushMatrix();
    s.translate(x, y, z);
    float angle = stemAngle + windAngle/3.0;
    angle = constrain(angle, -10, 10);
    s.rotate(angle);
    s.pushMatrix();
    s.popMatrix();


    numFlowers = 0;
    numBranch = 0;
    branch(s, 0, 0, plantHeight*growthScaler, 0);
    s.popMatrix();
  }

  void leaf(int div, int num, int nn, PGraphics s) {
    s.pushMatrix();
    s.translate(0, 0, 2);

    float leafScale = getLeafScale(div, 3);

    float rot = map(div, 0, 3, radians(10), radians(-30));
    boolean flip = nn%2 == 0;

    displayLeaf(div, rot, leafScale, (pID+div)%2==0, s); //z


    s.popMatrix();
  }

  float getLeafScale(int div, int numDivs) {
    return map(div, 0, numDivs, .8, 0.3);
  }
  
  float getStemScale(int div) {
    return pow(.9, div);
  }

  void displayLeaf(int div, float r, float sc, boolean isShort, PGraphics s) {
    r += radians(90);
    float w = 15*plantHeight*getStemScale(div);
    caneStem.display(w, 0, r, plantHeight*sc, false, s);
    caneStem.display(-w, 0, -r, plantHeight*sc, false, s);

    if (!isShort) {
      //sc =1;
      s.pushMatrix();
      s.translate(2*x, 0);
      //caneStem.display(0, 0, radians(0), plantHeight*sc, false, s);
      //caneStem.display(0, 0, radians(180), plantHeight*sc, false, s);
      s.popMatrix();

      s.pushMatrix();
      s.translate(-x, 0);
      //caneStem.display(x*sc, 0, radians(mouseX/2), plantHeight*sc, false, s);
      //caneStem.display(-x*sc, 0, -radians(mouseX/2), plantHeight*sc, false, s);
      s.popMatrix();
    }
    //displayLeaf2(r, sc, isShort, s);
    //println("d2222");
  }

  void displayLeaf2(float r, float sc, boolean isShort, PGraphics s) {
    randomSeed(pID);
    float w = 75*plantHeight*sc;
    if (isShort) w*=.7;
    float h = 15*plantHeight;
    s.stroke(strokeCol);
    s.strokeWeight(2*plantHeight);
    s.fill(col);

    s.pushMatrix();
    s.rotate(r);
    s.rect(h/2, 0, w, h, h);

    // prickles
    float num = map(sc, 1, 0.2, 5, 1);
    s.stroke(255);
    for (float i = w*.1; i < w; i+= 8*plantHeight) {
      s.strokeWeight(1*plantHeight);
      //float y = map(i, 0, 4, -w/2, w/3);
      float ang = random(-7, 7)*plantHeight;
      float tw = 15*plantHeight;
      s.line(i, h/2, i+ang, h/2+tw);
      i+= 4*plantHeight;
      ang = random(-7, 7)*plantHeight;
      s.line(i, h/2, i+ang, h/2-tw);
    }
    s.popMatrix();


    // other branch
    s.pushMatrix();
    s.scale(-1, 1);
    //s.translate(-w+h, 0);
    s.rotate(r);
    s.stroke(strokeCol);
    s.rect(0, 0, w, h, h);

    // prickles
    s.stroke(255);
    for (float i = w*.1; i < w*.95; i+= 8*plantHeight) {
      s.strokeWeight(1*plantHeight);
      //float y = map(i, 0, 4, -w/2, w/3);
      float tw = 15*plantHeight;
      float ang = random(-7, 7)*plantHeight;
      s.line(i, h/2, i+ang, h/2+tw);
      i+= 4*plantHeight;
      ang = random(-7, 7)*plantHeight;
      s.line(i, h/2, i+ang, h/2-tw);
    }
    s.popMatrix();
  }

  // Daniel Shiffman Nature of Code http://natureofcode.com
  void branch(PGraphics s, int div, int nn, float h, float xoff) {
    int numDivs = 3;
    numBranch++;
    // thickness of the branch is mapped to its length
    //float sw = map(div, 0, numDivs, 15*plantHeight, 10*plantHeight);
    float sw = 15*plantHeight;

    s.strokeWeight(2*plantHeight);
    // Draw the branch
    s.stroke(strokeCol);
    s.pushMatrix();
    s.translate(0, 0, -1*(nn+1));

    caneStem.display(0, 0, 0, plantHeight*getStemScale(div), false, s);

    //s.beginShape(QUADS);
    //s.vertex(0, 0);
    //s.vertex(sw, 0);
    //s.vertex(sw, -h);
    //s.vertex(0, -h);
    //s.endShape(CLOSE);

    ////prickles
    //s.stroke(255);
    //for (float i = -h*.1; i > -h; i-= 8*plantHeight) {
    //  s.strokeWeight(1*plantHeight);
    //  //float y = map(i, 0, 4, -w/2, w/3);
    //  float ang = random(-7, 7)*plantHeight;
    //  s.line(sw/2, i, sw/2+sw, i);
    //  i-= 4*plantHeight;
    //  ang = random(-7, 7)*plantHeight;
    //  s.line(sw/2, i+ang, sw/2-sw, i+ang);
    //}

    s.popMatrix();

    // Move along to end
    //s.translate(0, -h/3);
    //leaf(div, 1, nn, s);
    //s.translate(0, -h/3);
    //leaf(div, 2, nn, s);
    s.translate(0, -h);
    leaf(div, 3, nn, s);


    // Each branch will be 2/3rds the size of the previous one
    float per = 0.9;
    h *= per;
    // Move along through noise space
    xoff += 0.1;

    if (div < numDivs) {
      // Random number of branches
      float branchSpreadMax = map(div, 0, numDivs, 3, 1);
      int n = int(random(1, branchSpreadMax));

      for (int i = 0; i < n; i++) {

        // Here the angle is controlled by perlin noise
        // This is a totally arbitrary way to do it, try others!
        float thetaSpread = map(div, 0, numDivs, PI/3, PI/5);
        //float thetaSpread = PI/4;
        float theta;
        //float theta = map(noise(xoff+i, yoff), 0, 1, -thetaSpread, thetaSpread);
        if (i%2 == 0) theta =  map(noise(xoff+i, yoff), 0, 1, 0, thetaSpread);
        else theta = map(noise(xoff+i, yoff), 0, 1, -thetaSpread, 0);

        s.pushMatrix();      // Save the current state of transformation (i.e. where are we now)
        s.rotate(theta);     // Rotate by theta
        branch(s, div+1, i, h, xoff);   // Ok, now call myself to branch again
        s.popMatrix();       // Whenever we get back here, we "pop" in order to restore the previous matrix state
      }
      if (numFlowers == 0) {
        if (isFlowering) flower(s, div, age, true);
      }
    } else {
      float ag = age + random(-.4, .2);
      ag = constrain(ag, 0, age);
      if (isFlowering) flower(s, div, ag, false);
    }
  }

  void flower(PGraphics s, int div, float stemAge, boolean needsStem) {
    int num = getFlowerIndex(stemAge);
    if (needsStem) {
      //s.strokeWeight(2);
      //s.line(0, 0, 0, -30*plantHeight);
      displayLeaf(div, PI/2, .7, true, s);
      s.translate(0, -30*plantHeight);
    }
    caneFlowers[getFlowerIndex(stemAge)].display(0, 0, 0, plantHeight, false, s); //
    numFlowers++;
  }

  int getFlowerIndex(float stemAge) {
    int num = int(map(stemAge, bloomAge, 1, 0, caneFlowers.length));
    num = constrain(num, 0, caneFlowers.length-1);
    return num;
  }
}

//class Cane extends Plant {

//  Cane(PVector loc, float age, boolean dies) {
//    this(loc, age, -1);
//    this.dies = dies;
//  }

//  Cane(PVector loc, float age, int code) {
//    super(loc, age, code);
//    branching = true;
//    hasLeaves = true;
//    growthScaler = 100;

//    col = color(60, 68, 31);
//  }

//  void display(PGraphics s) {
//    yoff += 0.005;
//    randomSeed(seed);
//    s.strokeWeight(plantHeight);
//    s.fill(col);
//    s.stroke(255);
//    s.pushMatrix();
//    s.translate(x, y, z);
//    float angle = stemAngle + windAngle/3.0;
//    angle = constrain(angle, -10, 10);
//    s.rotate(angle);
//    s.pushMatrix();
//    s.popMatrix();



//    numBranch = 0;
//    branch(s, 0, 0, plantHeight*growthScaler, 0);
//    s.popMatrix();
//  }

//  void leaf(int div, int nn, PGraphics s) {
//    s.pushMatrix();
//    s.translate(plantHeight*15/2, 0, 2);
//    float leafScale = map(div, 0, 2, 1, 0.6);

//    float rot = map(div, 0, 2, radians(10), radians(-30));
//    boolean flip = nn%2 == 0;

//    displayLeaf(rot, leafScale, (pID+div)%2==0, s);

//    s.pushMatrix();
//    //s.translate(0, plantHeight*growthScaler);
//    //displayLeaf(rot, leafScale, true, s);
//    s.popMatrix();

//    s.popMatrix();
//  }

//  void displayLeaf(float r, float sc, boolean isShort, PGraphics s) {

//    float w = 75*plantHeight*sc;
//    if (isShort) w = 35*plantHeight*sc;
//    float h = 15*plantHeight;
//    s.noStroke();
//    s.fill(col);

//    s.pushMatrix();
//    s.rotate(r);
//    s.rect(0, 0, w, h, h);


//    // sidenubs
//    if (!isShort) {
//      float ang = map(mouseX, 0, width/2, -PI, PI);
//      s.translate(50*plantHeight*sc, h/2);
//      s.pushMatrix();
//      s.rotate(-PI/2);
//      s.rect(0, 0, w*.3, h, h);
//      s.popMatrix();

//      s.pushMatrix();
//      s.rotate(PI/2);
//      s.rect(0, -h, w*.3, h, h);
//      s.popMatrix();
//    }

//    s.popMatrix();


//    // other branch
//    s.pushMatrix();
//    s.translate(0, w/2, 0);
//    s.rotate(-r);
//    s.rect(0, 0, -w, h, h);

//    // sidenubs
//    if (!isShort) {
//      s.translate(-50*plantHeight*sc, h/2);
//      s.pushMatrix();
//      s.rotate(-PI/2);
//      s.rect(0, 0, w*.3, h, h);
//      s.popMatrix();

//      s.pushMatrix();
//      s.rotate(PI/2);
//      s.rect(0, -h, w*.3, h, h);
//      s.popMatrix();
//    }
//    s.popMatrix();
//  }

//  // Daniel Shiffman Nature of Code http://natureofcode.com
//  void branch(PGraphics s, int div, int nn, float h, float xoff) {
//    int numDivs = 3;
//    numBranch++;
//    // thickness of the branch is mapped to its length
//    //float sw = map(div, 0, numDivs, 15*plantHeight, 1);
//    float sw = 15*plantHeight;
//    //s.strokeWeight(sw);
//    // Draw the branch
//    s.noStroke();
//    //s.stroke(lerpColor(col, color(255), .5));
//    s.pushMatrix();
//    s.translate(0, 0, -1*(nn+1));
//    s.beginShape(QUADS);
//    //s.fill(constrain(numDivs*40, 0, 255), 255, 0);

//    s.vertex(0, 0);
//    s.vertex(sw, 0);
//    s.vertex(sw, -h);
//    s.vertex(0, -h);
//    s.endShape(CLOSE);
//    s.popMatrix();

//    // Move along to end
//    s.translate(0, -h);

//    // Each branch will be 2/3rds the size of the previous one
//    float per = 0.9;
//    h *= per;
//    // Move along through noise space
//    xoff += 0.1;

//    if (div < numDivs) {
//      // Random number of branches
//      float branchSpreadMax = map(div, 0, numDivs, 3, 1);
//      int n = int(random(0, branchSpreadMax));
//      //if (n == 0 || n == 1) leaf(div, nn, s);
//      leaf(div, nn, s);
//      for (int i = 0; i < n; i++) {
//        // Here the angle is controlled by perlin noise
//        // This is a totally arbitrary way to do it, try others!
//        float thetaSpread = map(div, 0, numDivs, PI/3, PI/5);
//        //float thetaSpread = PI/4;
//        float theta;
//        //float theta = map(noise(xoff+i, yoff), 0, 1, -thetaSpread, thetaSpread);
//        if (i%2 == 0) theta =  map(noise(xoff+i, yoff), 0, 1, 0, thetaSpread);
//        else theta = map(noise(xoff+i, yoff), 0, 1, -thetaSpread, 0);
//        //float theta = PI/4;
//        //if (n%2==0) theta *= -1;

//        s.pushMatrix();      // Save the current state of transformation (i.e. where are we now)
//        s.rotate(theta);     // Rotate by theta
//        branch(s, div+1, i, h, xoff);   // Ok, now call myself to branch again
//        s.popMatrix();       // Whenever we get back here, we "pop" in order to restore the previous matrix state
//      }
//    } else {
//      if (isFlowering) flower(s, 1.0);
//      else leaf(div, nn, s);
//    }
//  }

//  void flower(PGraphics s, float stemAge) {
//    //s.fill(255, 0, 255);
//    //s.ellipse(0, 0, 10, 10);
//    //s.fill(0);
//    //s.text(numBranch, 0, 0);
//    if (numBranch %3 == 0) caneFlowers[0].display(0, 0, 0, plantHeight, false, s);
//    else  caneFlowers[0].display(0, 0, 0, plantHeight, true, s);
//  }
//}
