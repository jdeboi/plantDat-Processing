color cementColor = color(170);

//////////////////////////////////////////////////////////////////////////////////
// PERLIN NOISE
//////////////////////////////////////////////////////////////////////////////////
int spacingTerr, colsTerr, rowsTerr;
float[][] terrain, groundTerrain;
float flyingTerr = 0;
float flyingTerrInc = 0.005;
boolean flyingTerrOn = true;
float xoffInc = 0.2;
boolean acceleratingTerr = true;
int lastCheckedTerr = 0;
boolean beginningTerrain = false;

int groundMin = -80;
int groundMax = 5;
int waterMin = 0;
int waterMax = 70;

float inc = 0;
float incAmt = 0.005;
PGraphics maskGraphics, tempGraphics;

void initTerrain() {
  //int w = 1840; 
  //int h = 1400; 
  int w = int(width*3);
  int h = height*2;
  int spacing = 80;
  this.colsTerr = w/spacing;
  this.rowsTerr = h/spacing;
  this.spacingTerr = spacing;
  terrain = new float[colsTerr][rowsTerr];
  groundTerrain = new float[colsTerr][rowsTerr];
  initGroundTerrain();

  //maskGraphics = createGraphics(canvas.width, canvas.height);
  //tempGraphics = createGraphics(canvas.width, canvas.height);
}




void initGroundTerrain() {
  float yoff = flyingTerr;

  for (int y = 0; y < rowsTerr; y++) {
    float xoff = 0;
    for (int x = 0; x < colsTerr; x++) {
      //if (y > rowsTerr - 4) {
      //} else {
        groundTerrain[x][y] = map(noise(xoff, yoff), 0, 1, groundMin, groundMax);
      //}
      xoff += xoffInc;
    }
    yoff += xoffInc;
  }
}

void setGridTerrain() {
  //if (flyingTerrOn) 
  //flyingTerrInc = 0.01 *sin(millis()/1000.0);
  flyingTerr -= flyingTerrInc;

  float yoff = flyingTerr;

  for (int y = 0; y < rowsTerr; y++) {
    float xoff = 0;
    for (int x = 0; x < colsTerr; x++) {
      terrain[x][y] = map(noise(xoff, yoff), 0, 1, waterMin, waterMax);
      xoff += xoffInc;
    }
    yoff += xoffInc;
  }
}


void displayGroundTerrain(PGraphics s, int z) {
  s.pushMatrix();
  s.translate(650, s.height, z);
  s.rotateX(radians(90));
  s.rotateZ(radians(12));
  //s.fill(155, 70);

  s.noStroke();
  s.strokeWeight(3);

  s.translate(-colsTerr*spacingTerr/2, -rowsTerr*spacingTerr/2);
  for (int y = 0; y < rowsTerr-1; y++) {

    s.beginShape(TRIANGLE_STRIP);
    //s.texture(cement);
    s.textureMode(IMAGE);
    s.textureWrap(REPEAT);
    for (int x = 0; x < colsTerr; x++) {
      int alpha = 255;
      int min = groundMin;
      int max = groundMax;
      s.fill(cementColor);
      s.fill(getCementFill(groundTerrain[x][y], color(60), cementColor, min, max, x, y, alpha));
      s.vertex(x * spacingTerr, y * spacingTerr, groundTerrain[x][y], x*spacingTerr, y*spacingTerr);
      s.fill(getCementFill(groundTerrain[x][y+1], color(60), cementColor, min, max, x, y, alpha));
      s.vertex(x * spacingTerr, (y+1) * spacingTerr, groundTerrain[x][y+1], x*spacingTerr, (y+1)*spacingTerr);
    }
    s.endShape();
  }
  s.popMatrix();
}




void displayFloorTerrain(PGraphics s) {
  s.pushMatrix();
  //s.scale(sc, 1);
  //s.translate(xt, 0, 0);
  s.translate(s.width/2, s.height, 200);
  //s.rotateX(radians(90));
  s.fill(155, 70);

  //s.noStroke();
  s.strokeWeight(1);

  s.translate(-colsTerr*spacingTerr/2, -rowsTerr*spacingTerr/2);
  //s.colorMode(HSB, 255);
  for (int y = 0; y < rowsTerr-1; y++) {
    s.beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < colsTerr; x++) {
      int alpha = 255;
      int min = groundMin;
      int max = groundMax;
      color c1 = color(#FFE283);
      color c2 = color(#FFBB83);

      s.fill(getVertexHeight(groundTerrain[x][y], c1, c2, min, max, alpha));
      s.vertex(x * spacingTerr, y * spacingTerr, groundTerrain[x][y]);
      s.fill(getVertexHeight(groundTerrain[x][y+1], c1, c2, min, max, alpha));
      s.vertex(x * spacingTerr, (y+1) * spacingTerr, groundTerrain[x][y+1]);
    }
    s.endShape();
  }
  s.popMatrix();
}

color getCementFill(float h, color start, color end, int min, int max, int x, int y, int alpha) {
  float per = map(h, min, max, 0, 1);
  color newc = lerpColor(start, end, per);
  float yper = map(y, 0, 10, 1, 0);
  newc = lerpColor(newc, cementColor, yper);
  int xstart = 10;
  int xend = xstart + 12;
  if (x < xstart) newc = cementColor;
  float xper = map(x, xstart, xend, 1, 0);
  newc = lerpColor(newc, cementColor, xper);
  newc = color(red(newc), green(newc), blue(newc), alpha);
  return newc;
}

color getVertexHeight(float h, color start, color end, int min, int max, int alpha) {
  float per = map(h, min, max, 0, 1);
  color newc = lerpColor(start, end, per);
  newc = color(red(newc), green(newc), blue(newc), alpha);
  return newc;
}

void displayWater(PGraphics s, int z) {

  s.pushMatrix();
  s.translate(s.width/2, s.height-30-waterY, z);
  s.rotateX(radians(90));
  s.noFill();
  s.fill(255, 170);
  //s.stroke(0, 0, 255, 90);
  s.stroke(#FF00EF, 0);
  s.strokeWeight(1);

  s.translate(-colsTerr*spacingTerr/2, -rowsTerr*spacingTerr/2);
  //s.colorMode(HSB, 255);
  for (int y = 0; y < rowsTerr-1; y++) {
    s.beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < colsTerr; x++) {
      int alpha = 155;
      int min = waterMin;
      int max = waterMax;
      s.fill(getVertexHeight(terrain[x][y], color(0, 0, 255), color(0, 255, 255), min, max, alpha));
      s.vertex(x * spacingTerr, y * spacingTerr, terrain[x][y]);
      s.fill(getVertexHeight(terrain[x][y+1], color(0, 0, 255), color(0, 255, 255), min, max, alpha));
      s.vertex(x * spacingTerr, (y+1) * spacingTerr, terrain[x][y+1]);
    }
    s.endShape();
  }
  s.popMatrix();
}
