PlantFile[] spoonLeaves;
PlantFile[] spoonFlowers;


void initSpoon() {
}

class Spoon extends Plant {

  Spoon(PVector loc, float age, boolean dies) {
    this(loc, age, -1);
    this.dies = dies;
  }

  Spoon(PVector loc, float age, int code) {
    super(loc, age, code);
    //leaves = new ArrayList<BeautyLeaf>();
    growthScaler = 200;
    branching = false;
    hasLeaves = true;
    col = color(100,116, 71);
  }

  void display(PGraphics s) {
    //float stemH = growthScaler*plantHeight;
    //float stemW = growthScaler*4.0/80*plantHeight;
    int numBlades = 16;
    float bladeW = growthScaler/10*plantHeight;
    float bladeH = growthScaler*plantHeight;

    s.noFill();
    s.noStroke();
    s.pushMatrix();

    s.translate(x, y, z);
    float angle = stemAngle + windAngle/3.0;
    angle = constrain(angle, -10, 10);
    //s.rotate(angle);


    for (int j = 0; j < 6; j++) {

      s.fill(0, 25+j*50, 0);
      for (int i = 0; i < numBlades; i++) {
        s.pushMatrix();
        float minAngle = -PI/1.8;
        float maxAngle = minAngle * -1;
        float angleSpread = abs(minAngle)*2;
        float ang = minAngle + i * angleSpread / numBlades;
        if (ang < 0) angle -= map(ang, minAngle, 0, .4, 0); 
        else ang += map(angle, 0, maxAngle, 0, .4); 
        ang += (noise(ang/10) - .5)*.1;
        s.rotate(ang);

        float lenLongerInMiddle = map(abs(ang), maxAngle, 0, 0, -growthScaler/2*plantHeight);
        float widerInMiddle = map(abs(ang), maxAngle, 0, 0, growthScaler/20*plantHeight);

        //s.line(0, 0, 0, -bladeH + lenLongerInMiddle);
        //s.triangle(0-(bladeW + widerInMiddle)/2, 0, 0, -bladeH + lenLongerInMiddle, (bladeW + widerInMiddle)/2, 0);
        s.beginShape(TRIANGLES);
        s.fill(col);
        s.fill(43 , 53 , 34 );
        s.vertex(0-(bladeW + widerInMiddle)/2, 0, -1);
        s.fill(207,207,153); // light yellow
        s.vertex( 0, -bladeH + lenLongerInMiddle);
        s.fill(43 , 53 , 34 );
        s.vertex( (bladeW + widerInMiddle)/2, 0);
        s.endShape();
        s.popMatrix();
      }
      s.rotateY(PI/5);
    }
    //if (isFlowering) flower(s, age);
    s.popMatrix();
  }

  void flower(PGraphics s, float stemAge) {
    if (stemAge > bloomAge) isFlowering = true;
    else isFlowering = false;
    isFlowering = true;
    if (isFlowering) spoonFlowers[getStokesFlowerIndex(stemAge)].display(0, 0, 0, plantHeight, false, s);
  }

  void leaf(int segment, PGraphics s) {
    //s.pushMatrix();
    //s.translate(0, 0, 1);
    if (segment < 3 && segment > 0) {
      float scal = map(numBranch, 0, 15, 1.0, .3)*plantHeight;
      float leafScale = map(segment, 0, numSegments, 1.0, 0.4);
      spoonLeaves[0].display(0, 0, 0, scal*leafScale, false, s);
      //s.pushMatrix();
      //s.translate(0, -plantHeight*20);
      spoonLeaves[0].display(0, 0, 0, scal*leafScale, true, s);
      //s.popMatrix();
    }
    //s.popMatrix();
  }

  int getStokesFlowerIndex(float stemAge) {
    int num = int(map(stemAge, bloomAge, 1, 0, spoonFlowers.length));
    num = constrain(num, 0, spoonFlowers.length-1);
    return num;
  }

  int getStokesFlowerIndex() {
    int num = int(map(age, bloomAge, 1, 0, spoonFlowers.length));
    num = constrain(num, 0, spoonFlowers.length-1);
    return num;
  }


  void stem(PGraphics s, float plantH, float ang, float stemAge) {
    s.pushMatrix();
    //while (len > 2) {

    float len = 1.0* plantH / numSegments; 
    s.translate(0, len);
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
      s.stroke(0);
      s.strokeWeight(1);
      s.beginShape(QUADS);
      s.fill(constrain(numBranch*40, 0, 255), 255, 0);
      //s.stroke(0);
      s.vertex(-sw/2, 0);
      s.vertex(sw/2, 0);
      s.vertex(sw/2, -len);
      s.vertex(-sw/2, -len);
      s.endShape(CLOSE);


      if (hasLeaves) {
        s.pushMatrix();
        s.translate(0, -len, 0.1);
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
}
