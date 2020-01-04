color cementColor, darkCementColor, streetColor;

//////////////////////////////////////////////////////////////////////////////////
// PERLIN NOISE
//////////////////////////////////////////////////////////////////////////////////
int spacingTerr, colsTerr, rowsTerr;
float[][] terrain, groundTerrain, cloudTerrain, mountainTerrain;
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

float angle = 65;


void initTerrain() {
  int w = int(width*3.5);
  int h = int(height*1.8);
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


  cementColor = color(214, 202, 161);
  darkCementColor = color(#9D8467);//lerpColor(cementColor, color(0), .7);
  streetColor = color(#937B5F, 50);
}

void drawDriveway(PGraphics s) {
  s.pushMatrix();
  s.rotateX(radians(-90-(90-65)));

  s.translate(s.width*.82, -s.height/2, s.height-112);
  s.noStroke();

  s.fill(50);
  s.rect(0, 0, s.width*.4, s.height*1.7);
  s.popMatrix();
}

void initGroundTerrain() {
  float yoff = flyingTerr;

  for (int y = 0; y < rowsTerr; y++) {
    float xoff = 0;
    for (int x = 0; x < colsTerr; x++) {

      groundTerrain[x][y] = map(noise(xoff, yoff), 0, 1, groundMin, groundMax);
      //groundTerrain[x][y] += getGullyDepth(x, y);
      //if (isStreet(x, y)) groundTerrain[x][y] = 10;
      //else if (isRainGarden(x, y)) groundTerrain[x][y] -= 40;
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
      if (rainMode == BARREL_RAIN || rainMode == DRYING_2) terrain[x][y] += 60*river(x, y);
      xoff += xoffInc;
    }
    yoff += xoffInc;
  }
  reduceWaterPlants();
}

void reduceWaterPlants() {
  if (TESTING) {
    for (Plant p : permPlants) {
      PVector temp = getWaterLoc(p.x, p.y, p.z);
      reduceWater(int(p.x), int(p.y), int(p.z), p.plantHeight);
    }
  } else {
    for (Plant p : spawnedPlants) {
      PVector temp = getWaterLoc(p.x, p.y, p.z);
      reduceWater(int(p.x), int(p.y), int(p.z), p.plantHeight);
    }
  }
}


int[] getRowCol(float x, float y, float z) {
  return getRowCol(int( x), int (y), int (z));
}

int[] getRowCol(int x, int y, int z) {
  PVector origin = getWaterOrigin();
  float dx = x - origin.x;
  float dy = y - origin.y;
  float dz = z - origin.z;
  float dhypo = sqrt(dz*dz + dy*dy);

  int[] rowcol = new int[2];
  rowcol[1] = round(dx / spacingTerr);
  //rowcol[1] = round(map(rowcol[1], 0, colsTerr, 2, colsTerr-3));
  rowcol[0] = round(dhypo/spacingTerr)-3;
  return rowcol;
}


void reduceWater(float x, float y, float z, float plantH) {
  reduceWater(int( x), int (y), int (z), plantH);
}


void reduceWater(int x, int y, int z, float plantH) {
  int[] rowcol = getRowCol(x, y, z);
  /// so i messed this up b/c terrain is [x][y] which maybe should be [y][x]
  int r = rowcol[1];
  int c = rowcol[0];
  if (r >= 0 && c >= 0 && r < terrain.length && c < terrain[0].length) {
    if (TESTING) plantH = 1.0;
    float localMin = terrain[r][c]-100* plantH;
    int area = 5;
    float maxD = area/2.0 * sqrt(2);

    for (int startc = c-area/2; startc < c + area/2; startc++) {
      for (int startr = r-area/2; startr < r+area/2; startr++) {
        if (startc >= 0 && startc < terrain[0].length && startr < terrain.length && startr >= 0) {
          float temp = terrain[startr][startc];
          float dis = dist(c, r, startc, startr);
          float newVal = map(dis, 0, maxD, localMin, temp);
          terrain[startr][startc] = newVal;
        }
      }
    }
  }
}




void displayGroundTerrain(PGraphics s, int z) {
  s.pushMatrix();
  s.translate(s.width/2, s.height, 0);
  s.rotateX(radians(angle));
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
      //if (isStreet(x, y)) s.fill(streetColor);
      s.fill(getCementFill(groundTerrain[x][y], darkCementColor, cementColor, min, max, x, y, alpha));
      s.vertex(x * spacingTerr, y * spacingTerr, groundTerrain[x][y], x*spacingTerr, y*spacingTerr);
      //if (isStreet(x, y)) s.fill(streetColor);
      s.fill(getCementFill(groundTerrain[x][y+1], darkCementColor, cementColor, min, max, x, y+1, alpha));
      s.vertex(x * spacingTerr, (y+1) * spacingTerr, groundTerrain[x][y+1], x*spacingTerr, (y+1)*spacingTerr);
    }
    s.endShape();
  }
  s.popMatrix();
}

boolean isStreet(int x, int y) {
  int streetX = 50;
  int streetW = 10;
  //float xval = 3*sin(PI*y/rowsTerr) + startX;
  return (x >= streetX && x < streetX+ streetW);
}


boolean isGully(int x, int y) {
  int streetX = 50;
  int streetW = 10;
  float w = 4;
  if (x > streetX - w && x < streetX) return true;
  if (x > streetX + streetW && x < streetX  + streetW + w) return true;
  return false;
}


float getGullyDepth(int x, int y) {
  float maxDepth = 15;
  int streetX = 50;
  int streetW = 10;
  float w = 4;
  if (x > streetX - w && x < streetX) {
    float dis = abs(x - streetX-w/2.0);
    return map(dis, 0, w/2, 0, -maxDepth);
  } else if (x > streetX + streetW && x < streetX  + streetW + w) {
    float dis = abs(x - (streetX+streetW+w/2.0));
    return map(dis, 0, w/2, 0, -maxDepth);
  }
  return 0;
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

void displayWater(PGraphics s) {

  s.pushMatrix();
  s.translate(s.width/2, s.height-30-waterY, 0);
  s.rotateX(radians(angle));
  s.noFill();
  s.fill(255, 170);
  //s.stroke(0, 0, 255, 90);
  //s.stroke(#FF00EF, 0);
  s.noStroke();
  s.strokeWeight(1);

  s.translate(-colsTerr*spacingTerr/2, -rowsTerr*spacingTerr*waterFactor);
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



PVector getWaterOrigin() {
  float x = canvas.width/2-colsTerr*spacingTerr/2;

  //float y = canvas.height-30-waterY;
  float z = getBackWater();
  float y = getSpawnedY(z);
  return new PVector(x, y, z);
}

float waterFactor = 7.0/10;
//float getBackWater() {
//  return -rowsTerr*spacingTerr*waterFactor;
//}
float getBackWater() {
  return -terrain[0].length*spacingTerr*waterFactor;
}
float getBackGround() {
  return -groundTerrain[0].length*spacingTerr*waterFactor;
}


float waterY = 0;
void waterOff() {
  waterY = -150;
}
void setWater() {
  incSpawnedFloat();
  float lowestSea = -200;
  float maxs = -90;
  float barrels = -150;
  float maxSea = maxs;

  // raining
  // drying1
  // dry1 
  // rain barrel
  // drying2
  // dry2
  setRainMode();
  switch(rainMode) {
  case RAINING:
    waterY = map(millis() - lastRainTime, 0, rainLasts, lowestSea, maxSea);
    break;
  case DRYING_1: 
    waterY = map(millis(), startRainMode, endRainMode, maxSea, lowestSea);
    break;
  case DRY_1:
    waterY = lowestSea;
    break;
  case BARREL_RAIN:
    waterY = map(millis(), startRainMode, endRainMode, lowestSea, barrels);
    break;
  case DRYING_2: 
    waterY = map(millis(), startRainMode, endRainMode, barrels, lowestSea);
    break;
  case DRY_2:
    waterY = lowestSea;
    break;
  }
  waterY = constrain(waterY, lowestSea, maxSea);
}

int rainMode = 0;
final int RAINING = 0;
final int DRYING_1 = 1;   // 15%
final int DRY_1 = 2;      // 15%
final int BARREL_RAIN = 3;  // 40%
final int DRYING_2 = 4;   // 15%
final int DRY_2 = 5;      // 15%
long startRainMode = 0;
long endRainMode = 0;
void setRainMode() {
  if (isRaining) rainMode = RAINING;
  else {
    if (rainMode == RAINING) {
      startRainMode = millis();
      endRainMode = startRainMode + int(.15*sunLasts);
      rainMode = DRYING_1;
      //println("drying1");
    } else if (rainMode == DRYING_1 && millis() > endRainMode) {
      rainMode = DRY_1;
      startRainMode = millis();
      endRainMode = startRainMode +  int(.15*sunLasts);
      //println("dry1");
    } else if (rainMode == DRY_1 && millis() > endRainMode) {
      rainMode = BARREL_RAIN;
      startRainMode = millis();
      endRainMode = startRainMode +  int(.4*sunLasts);
      //println("barrel");
    } else if (rainMode == BARREL_RAIN && millis() > endRainMode) {
      rainMode = DRYING_2;
      startRainMode = millis();
      endRainMode = startRainMode +  int(.15*sunLasts);
      //println("drying2");
    } else if (rainMode ==  DRYING_2 && millis() > endRainMode) {
      rainMode = DRY_2;
      startRainMode = millis();
      endRainMode = startRainMode +  int(.15*sunLasts);
      //println("dry2");
    }
  }
}

PVector getWaterLoc(float x, float y, float z) {
  float zMin = -1799;
  float zMax = 0;
  float minX = map(z, zMax, zMin, 22, 8);
  float maxX = map(z, zMax, zMin, 32, 45);
  float minY = 0;
  float maxY = 25;

  float newX = map(x, z*.6 + 15, canvas.width-z*.55-80, minX, maxX);
  float newY = map(z, zMax, zMin, maxY, minY);

  //float dis = sqrt(y*y + z *z);
  //float newY = map(dis, 0, rowsTerr*spacingTerr*(3.0/4.0), rowsTerr*(1.0/4), rowsTerr);
  //newY = constrain(newY, 0, rowsTerr-1);

  //float newX = colsTerr/2 - (x - canvas.width/2)*1.0/spacingTerr; 
  //newX = constrain(newX, 0, colsTerr-1);

  return new PVector(newX, newY);
}

void displayMountainTerrain() {

  pushMatrix();
  float z = -height*1.8;
  translate(width/2, height+sin(radians(90-angle))*z-100, z);
  rotateX(radians(angle));
  rotateZ(radians(0));
  //fill(155, 70);

  noStroke();
  strokeWeight(3);

  translate(-colsTerr*spacingTerr/2, -(rowsTerr-1)*spacingTerr);
  for (int y = 0; y < rowsTerr-1; y++) {

    beginShape(TRIANGLE_STRIP);
    //texture(cement);
    textureMode(IMAGE);
    textureWrap(REPEAT);
    for (int x = 0; x < colsTerr; x++) {
      int alpha = 255;
      int min = groundMin;
      int max = groundMax;
      stroke(0, 255, 255);
      noStroke();
      strokeWeight(1);
      fill(getMountainFill(x, y));
      vertex(x * spacingTerr, y * spacingTerr, mountainTerrain[x][y], x*spacingTerr, y*spacingTerr);
      //fill(0, 0, 255);
      vertex(x * spacingTerr, (y+1) * spacingTerr, mountainTerrain[x][y+1], x*spacingTerr, (y+1)*spacingTerr);
    }
    endShape();
  }
  popMatrix();
}

void initMountain() {
  noiseSeed(11);
  float moffInc = 0.1;
  mountainTerrain = new float[colsTerr][rowsTerr];
  float yoff = 0;
  for (int y = 0; y < rowsTerr; y++) {
    float xoff = 0;
    for (int x = 0; x < colsTerr; x++) {
      int numRamp = 8;
      mountainTerrain[x][y] = map(noise(xoff, yoff), 0, 1, 0, 1400);
      if (y > rowsTerr-numRamp) mountainTerrain[x][y] = map(y, rowsTerr-numRamp, rowsTerr, 1, 0)* mountainTerrain[x][y];
      xoff += moffInc;
    }
    yoff += moffInc;
  }
}

color getMountainFill(int x, int y) {
  color start, end;
  float per;
  if (y > rowsTerr/2) {
    per = map(y, rowsTerr, rowsTerr/2, 0, 1);
    start = cementColor;
    end = color(#D8A2D6);
  } else {
    per = map(y, rowsTerr/2, 0, 0, 1);
    start = color(#D8A2D6);
    end = color(#A2A6D6);
  }
  color c1 = lerpColor(start, end, per);
  return lerpColor(c1, color(0), .4);
}

boolean isRainGarden(int x, int y) {
  return (x> 25 && x < 42 && y > 5 && y < 18);
}

float river(int x, int y) {
  int startX = 30;
  float amp = 5;
  float period = 2*PI/10.0;
  float xx = startX + amp*sin(period*y);
  float w = 6;
  float dis = abs(x - xx);
  float h = map(dis, 0, w, 1, 0);
  h = constrain(h, 0, 1);
  return h;
}
