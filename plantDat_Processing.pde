
//Grasses grassesL, grassesR;
Grasses grasses;
float windAngle = 0;
float windNoise = 0;

import geomerative.*;

void setup() {
  fullScreen(P3D);
  //size(1200, 900, P3D);
  initScreens();


  mask = new Mask();
  initLines();
  initTerrain();
  initSpawned();
  initBackground();
  
  initBeauty();
  initLizard();

  grasses = new Grasses(-screen.width/2, screen.height, 150, screen.width*2);

  //grassesL = new Grasses(-screenL.width/2, screenL.height, 150, screenL.width*2);
  //grassesR = new Grasses(0, screenR.height, 50, screenR.width);

  initDrops();
  initServer();
  smooth(4);
}



void draw() {
  //blendMode(BLEND);
  background(0);




  setGridTerrain();

  wind();
  grasses.grow();
  //grassesL.grow();
  //grassesR.grow();

  //displayWall(screen, grassesL, 0);
  //displayWall(screenR, grassesR, 1);
  //displayFloor();

  displayWall(screen, grasses, 0);

  pushMatrix();
  translate(0, 0, -3);
  renderScreens();
  popMatrix();

  //mask.display(color(0));
  //displayLines();

  checkEditing();

  displayFrames();

  checkForSpawned(1000);
  checkThunder();
  checkRain();

  setWater();
  //waterOff();
  
  //translate(0, 0, 4);
}

void checkEditing() {
  strokeWeight(1);
  if (editingMask) {
    mask.displayPoints();
    mask.move();
  }
  if (editingLines) displayEditingLines();
}

int screenNum = 0;
void displayWall(PGraphics s, Grasses g, int screenNum) {
  s.beginDraw();
  s.background(getBackground());
  //displaySky(s);

  displayHouse(s, -1300);
  s.stroke(100);
  s.pushMatrix();
  s.translate(0, s.height, 0);
  s.rotateX(radians(-15));
  s.translate(0, -s.height, 0);

  //displayClouds(s, -500);
  displayGroundTerrain(s, screenNum, -650);


  //s.pushMatrix();
  //s.fill(0, 255, 0, 100);
  //s.translate(0, 0, -100);
  //s.rect(0, 0, s.width, s.height);
  //s.popMatrix();

  //s.pushMatrix();
  //int m = getMaxWidth(s.width, -101)/2;
  //s.fill(255, 0, 0, 100);
  //s.translate(-(m-s.width)/2, 0, -101);
  //s.rect(0, 0, m, s.height);
  //s.popMatrix();

  //flock.render(s, screenNum, -100);
  //displayGrass(s, g);
  displaySpawnedPlants(s);
  //displayFakePlants(s);
  displayGrass(s, g);
  displayLiveSpawn(s);
  displayWater(s, screenNum, -370);

  //displayRain(s);


  //s.lights();
  //displaySine(s);
  //getXYLoc(screen, 0, 0);
  //getXYLoc(screen, 100, 0);
  //getXYLoc(screen, 100, 100);
  //getXYLoc(screen, 0, 100);
  //getXYLoc(screen, 50, 50);
  //getXYLoc(screen, 50, 0);
  //getXYLoc(screen, 50, 100);
  s.popMatrix();
  displayRain(s);
  
  s.endDraw();
}



void displayGrass(PGraphics s, Grasses g) {
  g.display(s);
}




void keyPressed() {
  if (key == 'c')
    toggleCalibration();
  else if (key == 's') {
    saveKeystone();
    mask.saveMask();
    saveMappedLines();
  } else if (key == 'l')
    loadKeystone();
}

void mousePressed() {
  if (editingMask) mask.checkClick();
  //else if (editingLines) checkLineClick();
}

void mouseReleased() {
  //linesReleaseMouse();
}

void displayFrames() {
  textSize(10);
  fill(255, 0, 0);
  stroke(255, 0, 0);
  text(frameRate, 10, 10);
}
