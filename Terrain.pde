color cementColor = color(140);

//////////////////////////////////////////////////////////////////////////////////
// PERLIN NOISE
//////////////////////////////////////////////////////////////////////////////////
int spacingTerr, colsTerr, rowsTerr;
float[][] terrain, groundTerrain, cloudTerrain;
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

int cloudMin = 0;
int cloudMax = 300;

float inc = 0;
float incAmt = 0.005;
PGraphics maskGraphics, tempGraphics;

void initTerrain() {
  //int w = 1840; 
  //int h = 1400; 
  int w = int(1440*3);
  int h = 900*3;
  int spacing = 80;
  this.colsTerr = w/spacing;
  this.rowsTerr = h/spacing;
  this.spacingTerr = spacing;
  terrain = new float[colsTerr][rowsTerr];
  groundTerrain = new float[colsTerr][rowsTerr];
  cloudTerrain = new float[colsTerr][rowsTerr];
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
      cloudTerrain[colsTerr - x - 1][rowsTerr - y - 1] =  map(noise(xoff, yoff), 0, 1, cloudMin, cloudMax);
      xoff += xoffInc;
    }
    yoff += xoffInc;
  }
  reduceWaterPlants();
}

void reduceWater(int x, int y, float plantH) {
  if (x >= 0 && y >= 0 && x < terrain.length && y < terrain[0].length) {
    float localMin = terrain[x][y]-150*plantH;
    int area = 4;
    float maxD = area/2.0 * sqrt(2);

    for (int startx = x-area/2; startx < x + area/2; startx++) {
      for (int starty = y-area/2; starty < y+area/2; starty++) {
        if (startx >= 0 && startx < terrain.length && starty < terrain[0].length && starty >= 0) {
          float temp = terrain[startx][starty];
          float dis = dist(startx, starty, x, y);
          float newVal = map(dis, 0, maxD, localMin, temp);
          terrain[startx][starty] = newVal;
        }
      }
    }
  }
}



void displayGroundTerrain(PGraphics s, int z) {
  s.pushMatrix();
  s.translate(s.width/2, s.height, 0);
  s.rotateX(radians(65));
  s.rotateZ(radians(0));
  //s.fill(155, 70);

  s.noStroke();
  s.strokeWeight(3);

  s.translate(-colsTerr*spacingTerr/2, -(rowsTerr-1)*spacingTerr);
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
  //per = constrain(per, 0, 1);
  color newc = lerpColor(start, end, per);
  float a = alpha;
  if (per < 0) {
    per = constrain(per, -1, 0);
    a = map(per, -1, 0, 10, alpha);
  }
  newc = color(red(newc), green(newc), blue(newc), a);
  return newc;
}

void displayWater(PGraphics s, int z) {

  s.pushMatrix();
  s.translate(s.width/2, s.height-30-waterY, 0);
  s.rotateX(radians(65));
  s.noFill();
  s.fill(255, 170);
  //s.stroke(0, 0, 255, 90);
  //s.stroke(#FF00EF, 0);
  s.noStroke();
  s.strokeWeight(1);

  s.translate(-colsTerr*spacingTerr/2, -rowsTerr*spacingTerr*(3.0/4));
  //s.colorMode(HSB, 255);
  for (int y = 0; y < rowsTerr-1; y++) {
    s.beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < colsTerr; x++) {
      int alpha = 155;
      int min = waterMin;
      int max = waterMax;
      s.fill(getVertexHeight(terrain[x][y], color(0, 0, 255), color(0, 255, 255), min, max, alpha));
      //if (y %2 == 0) s.fill(y*5, 0, 0);
      //if (x %2 == 0) s.fill(255, x*5, 0);
      //if (y%10 == 0) s.fill(0);
      //if (x%10 == 0) s.fill(255);
      s.vertex(x * spacingTerr, y * spacingTerr, terrain[x][y]);
      s.fill(getVertexHeight(terrain[x][y+1], color(0, 0, 255), color(0, 255, 255), min, max, alpha));
      s.vertex(x * spacingTerr, (y+1) * spacingTerr, terrain[x][y+1]);
    }
    s.endShape();
  }
  s.popMatrix();
}

float getCloudAlphaFactor() {
  long timeP = millis() - lastRainTime;
  if (timeP < rainLasts*.7) {
    return 1;
  } else if (timeP < rainLasts) {
    return map(timeP, rainLasts*.7, rainLasts, 1.0, 0);
  } else if (timeP < rainLasts + sunLasts * .7) {
    return 0;
  }
  return map(timeP, rainLasts + sunLasts*.7, rainLasts+sunLasts, 0, 1.0);
}

void displayClouds(PGraphics s, int z) {
  s.pushMatrix();
  s.translate(s.width/2, 80, z);
  s.rotateX(radians(80));
  s.fill(255, 170);
  //s.stroke(0, 0, 255, 90);
  s.stroke(#FF00EF, 0);
  s.strokeWeight(1);

  s.translate(-colsTerr*spacingTerr/2, -rowsTerr*spacingTerr/2);
  //s.colorMode(HSB, 255);
  for (int y = 0; y < rowsTerr-1; y++) {
    s.beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < colsTerr; x++) {
      int alpha = int(155*getCloudAlphaFactor());
      int min = cloudMin;
      int max = cloudMax;
      s.fill(getVertexHeight(terrain[x][y], color(255), color(100), min, max, alpha));
      s.vertex(x * spacingTerr, y * spacingTerr, cloudTerrain[x][y]);
      s.fill(getVertexHeight(terrain[x][y+1], color(255), color(100), min, max, alpha));
      s.vertex(x * spacingTerr, (y+1) * spacingTerr, cloudTerrain[x][y+1]);
    }
    s.endShape();
  }
  s.popMatrix();
}
