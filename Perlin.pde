
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

  //maskGraphics = createGraphics(screenG.width, screenG.height);
  //tempGraphics = createGraphics(screenG.width, screenG.height);
  maskGraphics = createGraphics(screen.width, screen.height);
  tempGraphics = createGraphics(screen.width, screen.height);
}
//void initTerrainCenter() {
//  int w = 1440; 
//  int h = 900; 
//  int spacing = 20;
//  this.colsTerr = w/spacing;
//  this.rowsTerr = h/spacing;
//  this.spacingTerr = spacing;
//  terrain = new float[colsTerr][rowsTerr];
//  groundTerrain = new float[colsTerr][rowsTerr];
//  initGroundTerrain();
//}


void setSinGrid(float per) {
  for (int y = 0; y < rowsTerr; y++) {
    for (int x = 0; x < colsTerr; x++) {
      terrain[x][y] = 10* sin(per*2*PI + y*5.0);
    }
  }
}




void initGroundTerrain() {
  float yoff = flyingTerr;

  for (int y = 0; y < rowsTerr; y++) {
    float xoff = 0;
    for (int x = 0; x < colsTerr; x++) {
      if (y > rowsTerr - 4) {
      } else {
        groundTerrain[x][y] = map(noise(xoff, yoff), 0, 1, groundMin, groundMax);
      }
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


void displayGroundTerrain(PGraphics s, int screenNum, int z) {
  s.pushMatrix();
  s.pushMatrix();
  //s.scale(sc, 1);
  //s.translate(xt, 0, 0);
  s.translate(650, s.height, z);
  s.rotateX(radians(90));
  s.rotateZ(radians(12));
  //s.fill(155, 70);

  s.noStroke();
  s.strokeWeight(3);

// street
//  s.pushMatrix();
//s.translate(s.width*1.7, -1500);
//  s.rotateZ(radians(45));
  
//  s.beginShape(QUAD);
//  s.fill(0);
//  s.vertex(0, 0);
//  s.vertex(800, 0);
//  s.vertex(800, 3000);
//  s.vertex(0, 3000);
//  s.endShape();
//  s.popMatrix();

  s.translate(-colsTerr*spacingTerr/2, -rowsTerr*spacingTerr/2);
  //s.colorMode(HSB, 255);
  for (int y = 0; y < rowsTerr-1; y++) {

    s.beginShape(TRIANGLE_STRIP);
    //s.texture(cement);
    s.textureMode(IMAGE);
    s.textureWrap(REPEAT);
    for (int x = 0; x < colsTerr; x++) {
      int alpha = 255;
      int min = groundMin;
      int max = groundMax;
      if (screenNum == 0) {
        s.fill(cementColor);
        //s.fill(255, 0, 0);
        //if (y > 16) s.fill(0);
        //else if (y > 14 || (x >= 10 && x <14)|| (x >= 24 && x <28)) s.fill(150);
        s.fill(getCementFill(groundTerrain[x][y], color(60), cementColor, min, max,x,  y, alpha));
        s.vertex(x * spacingTerr, y * spacingTerr, groundTerrain[x][y], x*spacingTerr, y*spacingTerr);
        s.fill(getCementFill(groundTerrain[x][y+1], color(60), cementColor, min, max,x, y, alpha));
        s.vertex(x * spacingTerr, (y+1) * spacingTerr, groundTerrain[x][y+1], x*spacingTerr, (y+1)*spacingTerr);
      } else {
        //s.fill(getVertexHeight(groundTerrain[colsTerr-x-1][y], color(#12EDFF), color(#FF00FB), min, max, alpha));
        s.vertex(x * spacingTerr, y * spacingTerr, groundTerrain[colsTerr-x-1][y]);
        //s.fill(getVertexHeight(groundTerrain[colsTerr-x-1][y+1], color(#12EDFF), color(#FF00FB), min, max, alpha));
        s.vertex(x * spacingTerr, (y+1) * spacingTerr, groundTerrain[colsTerr-x-1][y+1]);
      }
    }
    s.endShape();
  }
  s.popMatrix();
  s.popMatrix();
}


void displayFloorWave(PGraphics s) {
  s.beginDraw();
  s.background(0);
  drawWave(s, 45, 0, int(-s.width*.7), 1.2);
  drawWave(s, 0, 0, -10, 0.3);
  drawWave(s, 90, -s.height/2, -s.width, 0.3);
  s.endDraw();
}

void drawWave(PGraphics s, int rz, int x, int y, float multip) {
  s.pushMatrix();
  s.rotate(radians(rz));
  s.translate(x, y);
  //s.background(255, 255, 0);
  s.noStroke();
  //s.fill(0, 150, 255, 170);
  s.fill(255, 230);
  s.rect(0, -s.height, s.width, s.height);
  s.beginShape();
  s.vertex(0, 0);
  for (int i = 0; i < s.width; i+=5) {
    float period = i * PI/s.width;
    float period1 = s.width/300.0;
    float period2 = s.width/100.0;
    float period3 = s.width/1000.0;
    float amplitude = multip*300 * abs(sin(millis()/2000.0)); 
    //amplitude += multip*10 * sin(period1 + period + millis()/3000.0);
    //amplitude += multip*50 * sin(period2 + period+ millis()/1000.0);
    //amplitude += multip*10 * sin(period3 + period);

    float y1 = amplitude * sin(period)+30;
    //period = (i+1)* PI/s.width;
    //float y2 = amplitude * sin(period);
    //s.line(i, y1+100*noise(i/1000.0) , i+1+100*noise((i+1)/1000.0), y2);

    //s.ellipse(i, y1 + 100 * noise(i/300.0 + inc), 5, 5);
    s.vertex(i, y1);
  }
  s.vertex(s.width, 0);
  s.endShape(CLOSE);
  s.popMatrix();
}

void displayFloorTerrain(PGraphics s) {
  s.pushMatrix();
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
      if (screenNum == 0) {

        s.fill(getVertexHeight(groundTerrain[x][y], c1, c2, min, max, alpha));
        s.vertex(x * spacingTerr, y * spacingTerr, groundTerrain[x][y]);
        s.fill(getVertexHeight(groundTerrain[x][y+1], c1, c2, min, max, alpha));
        s.vertex(x * spacingTerr, (y+1) * spacingTerr, groundTerrain[x][y+1]);
      } else {
        s.fill(getVertexHeight(groundTerrain[colsTerr-x-1][y], c1, c2, min, max, alpha));
        s.vertex(x * spacingTerr, y * spacingTerr, groundTerrain[colsTerr-x-1][y]);
        s.fill(getVertexHeight(groundTerrain[colsTerr-x-1][y+1], c1, c2, min, max, alpha));
        s.vertex(x * spacingTerr, (y+1) * spacingTerr, groundTerrain[colsTerr-x-1][y+1]);
      }
    }
    s.endShape();
  }
  s.popMatrix();
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

void displayClouds(PGraphics s, int z) {
  s.pushMatrix();
  s.pushMatrix();
  s.translate(s.width/2, 0, z);
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
      //s.fill(map(terrain[x][y], -100, 100, 0, 255), 255, 255);  // rainbow
      s.fill(getVertexHeight(terrain[x][y], color(255), color(255), min, max, alpha));
      s.vertex(x * spacingTerr, y * spacingTerr, terrain[x][y]);
      s.fill(getVertexHeight(terrain[x][y+1], color(255), color(255), min, max, alpha));
      s.vertex(x * spacingTerr, (y+1) * spacingTerr, terrain[x][y+1]);
    }
    s.endShape();
  }
  s.popMatrix();
  s.popMatrix();
}

void displayWater(PGraphics s, int screenNum, int z) {

  s.pushMatrix();
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
      if (screenNum == 0) {
        //s.fill(map(terrain[x][y], -100, 100, 0, 255), 255, 255);  // rainbow
        s.fill(getVertexHeight(terrain[x][y], color(0, 0, 255), color(0, 255, 255), min, max, alpha));
        s.vertex(x * spacingTerr, y * spacingTerr, terrain[x][y]);
        s.fill(getVertexHeight(terrain[x][y+1], color(0, 0, 255), color(0, 255, 255), min, max, alpha));
        s.vertex(x * spacingTerr, (y+1) * spacingTerr, terrain[x][y+1]);
      } else {
        s.fill(getVertexHeight(terrain[colsTerr-x-1][y], color(0, 0, 255), color(0, 255, 255), min, max, alpha));
        s.vertex(x * spacingTerr, y * spacingTerr, terrain[colsTerr-x-1][y]);
        s.fill(getVertexHeight(terrain[colsTerr-x-1][y+1], color(0, 0, 255), color(0, 255, 255), min, max, alpha));
        s.vertex(x * spacingTerr, (y+1) * spacingTerr, terrain[colsTerr-x-1][y+1]);
      }
    }
    s.endShape();
  }
  s.popMatrix();
  s.popMatrix();
}

void displayFloorWater(PGraphics s) {

  s.background(#FFDAAD);
  s.pushMatrix();
  s.pushMatrix();
  //s.translate(1200, -450, 0);
  //s.rotateX(radians(90));
  s.noFill();
  s.fill(0, 0, 255, 170);
  //s.stroke(0, 0, 255, 90);
  s.stroke(#FF00EF, 0);
  s.strokeWeight(1);

  s.translate(-colsTerr*spacingTerr/2, -rowsTerr*spacingTerr/2, -waterMax-1);
  //s.colorMode(HSB, 255);
  for (int y = 0; y < rowsTerr-1; y++) {
    s.beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < colsTerr; x++) {
      int alpha = 155;
      int min = waterMin;
      int max = waterMax;

      //s.fill(map(terrain[x][y], -100, 100, 0, 255), 255, 255);  // rainbow
      
      s.fill(getVertexHeight(terrain[x][y], color(0, 0, 255), color(0, 255, 255), min, max, alpha));
      s.vertex(x * spacingTerr, y * spacingTerr, terrain[x][y]);
      s.fill(getVertexHeight(terrain[x][y+1], color(0, 0, 255), color(0, 255, 255), min, max, alpha));
      s.vertex(x * spacingTerr, (y+1) * spacingTerr, terrain[x][y+1]);
    }
    s.endShape();
  }
  s.popMatrix();
  s.popMatrix();
}
