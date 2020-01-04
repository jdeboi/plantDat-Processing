
PlantFile[] blueFlowers;

void initBlue() {
}

class Blue extends Plant {
  color col2;

  Blue(PVector loc, float age, boolean dies) {
    this(loc, age, -1);
    this.dies = dies;
  }

  Blue(PVector loc, float age, int code) {
    super(loc, age, code);
    //leaves = new ArrayList<BeautyLeaf>();
    growthScaler = 200;
    branching = false;
    hasLeaves = true;

    //numBranches = int(random(0, 3));
    //branchDeg = random(8, 15);
    //if (Math.random() > -0.5) branchDeg *= -1;
    col = color(75, 94, 80  );
    col2 = color(66, 34, 51); //col2 = color(147,126,150  );
  }

  void display(PGraphics s) {
    //s.stroke(col);
    randomSeed(pID);
    int numBlades = int(random(14, 30));
    s.pushMatrix();
    s.translate(x, y, z);
    //s.rotateX(radians(25));
    float angle = stemAngle + windAngle/3.0;
    angle = constrain(angle, -10, 10);
    s.rotate(angle);

    numBranch = 0;
    totLen = leafSpacing;
    currentLen = leafSpacing;


    //    stem(s, plantHeight*growthScaler, 0, age, false, pID%2 == 0);
    //    // possibly flowering
    //    int neg = pID%3==0?1:-1;
    //    boolean isLeaf = (pID+1)%4 != 0;
    //    stem(s, plantHeight*growthScaler*.7, radians(10*neg), age, isLeaf, neg==1?true:false);


    // pure leaves
    //neg = pID%2==0?1:-1;
    stem(s, plantHeight*growthScaler*.2, radians(-20), age, true, true);
    stem(s, plantHeight*growthScaler*.2, radians(19), age, true, false);
    stem(s, plantHeight*growthScaler*.3, radians(-24), age, true, true);
    stem(s, plantHeight*growthScaler*.4, radians(23), age, true, false);

    for (int i = 0; i < numBlades; i++) {
      float deg = map(i, 0, numBlades-1, -12, 12); 
      float gr = centerMap(i, 0, numBlades-1, 1, .5);
      stem2(s, plantHeight*growthScaler*gr, radians(deg+random(-3, 3))+noise(i, flyingTerr), age, pID%4 != 0, true);
    }

    s.popMatrix();
  }

  void flower(PGraphics s, float stemAge, boolean isLeft) {
    if (stemAge > bloomAge) isFlowering = true;
    else isFlowering = false;
    isFlowering = true;
    int num =   millis()/5000%blueFlowers.length; //getBlueIndex(stemAge);
    if (isFlowering) {
      if (num > 2) blueFlowers[2].display(0, 0, 0, plantHeight, isLeft, s); 
      float r = 0;
      if (num == 3) r = radians(-65);
      blueFlowers[num].display(0, 0, r, plantHeight, isLeft, s); //pID%2 ==0
    }
  }

  void leaf(int segment, PGraphics s) {
  }

  int getBlueIndex(float stemAge) {
    int num = int(map(stemAge, bloomAge, 1, 0, blueFlowers.length));
    num = constrain(num, 0, blueFlowers.length-1);
    return num;
  }


  void stem(PGraphics s, float plantH, float ang, float stemAge, boolean isLeaf, boolean isLeft) {
    s.pushMatrix();
    //while (len > 2) {

    float len = 1.3* plantH / numSegments; 
    s.translate(0, len);
    for (int i = 0; i < numSegments; i++) {

      //s.pushMatrix();  
      s.translate(0, -len);
      //len *= 0.66;
      float angle = curveAngle + windAngle + ang;
      angle = constrain(angle, -PI/15, PI/15);
      s.rotate(angle);   
      float sw = map(i, 0, numSegments, 5, 1)*plantHeight;
      sw = constrain(sw, 1, 5);
      color c = lerpColor(col, color(0), .1);
      s.noStroke();
      s.beginShape(QUADS);
      s.fill(c);
      //s.stroke(0);
      s.vertex(-sw/2, 0);
      s.vertex(sw/2, 0);
      s.vertex(sw/2, -len);
      s.vertex(-sw/2, -len);
      s.endShape(CLOSE);
    }
    //if (isFlowering && !isLeaf) {
    //  s.translate(0, -len);
    //  s.pushMatrix();
    //  s.translate(0, 0, 3);
    //  flower(s, stemAge, !isLeft);
    //  s.popMatrix();
    //}
    s.popMatrix();
  }

  void stem2(PGraphics s, float plantH, float ang, float stemAge, boolean isLeaf, boolean isLeft) {
    s.pushMatrix();
    //while (len > 2) {

    float len = 1.3* plantH / numSegments; 
    //s.translate(0, len);


    s.noStroke();

    float angle = curveAngle + windAngle/2 + ang;
    //angle = constrain(angle, -PI/7, PI/7);
    s.rotate(angle);   

    s.beginShape(QUAD_STRIP); 


    color intermed = color(116, 127, 141); //color(142, 153, 158 )
    for (int i = 0; i < numSegments; i++) {
      float sw = map(i, 0, numSegments, 5, 1)*plantHeight;
      color c = lerpColor(col, col2, map(i, 0, numSegments, 0, 1)); 
      //if (i == 0) c = col;
      if (i < 2) c = lerpColor(col, intermed , map(i, 0, 2, 0, 1));
      else if (i < 4) c = lerpColor(intermed, col2, map(i, 2, 4, 0, 1));
      else c = col2;
      s.fill(c);
      sw = constrain(sw, 1, 5);
      s.vertex(-sw/2, -len*i);
      s.vertex(sw/2, -len*i);
      s.vertex(sw/2, -len*(i+1));
      s.vertex(-sw/2, -len*(i+1));
    }
    s.endShape(CLOSE);
    //if (isFlowering && !isLeaf) {
    //  s.translate(0, -len);
    //  s.pushMatrix();
    //  s.translate(0, 0, 3);
    //  flower(s, stemAge, !isLeft);
    //  s.popMatrix();
    //}
    s.popMatrix();
  }
}
