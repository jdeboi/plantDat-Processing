boolean TESTING = false;
int MAX_SPAWNED = 20;

PGraphics canvas;

PVector test;
void setup() {
  test = new PVector(0, 0);
  size(1920, 1280, P3D);
  //fullScreen(P3D);

<<<<<<< HEAD:plantDat_Processing.pde
  initScreens();
  initServer();
=======
  initScreens(width, height);
  //initServer();
>>>>>>> a9e61387c55095bb83902c3c451f51abbb0bd060:plantDat_Carroll.pde

  // plant files
  initBeauty();
  initStokes();
  initLizard();
  initClasping();
  initObedient();
  initSpawned();



  // the elements
  initBackground();
  initTerrain();
  initDrops();

<<<<<<< HEAD:plantDat_Processing.pde
  //spawnFakePlants();
  
=======
  // permanent plants
  initGrasses();
  initPermPlants();

  //spawnFakePlants();

>>>>>>> a9e61387c55095bb83902c3c451f51abbb0bd060:plantDat_Carroll.pde
  if (TESTING) {
    //spawnFakePlants();
    testingVals();
  }

  smooth(4);
}

void draw() {
  background(0);



  canvas.smooth(8);
  canvas.beginDraw();
  canvas.smooth(8);
  canvas.background(getBackground());

  displayHouse(canvas, int(getBackWater()) -100);


  // ground
  displayGroundTerrain(canvas, -650);


  // plants
  displayGrass(canvas, grasses);
  displayGrass(canvas, grassesLeft);
  displayGrass(canvas, grassesRight);
  displaySpawned(canvas);
  displayPermanent(canvas);
  //displayLiveSpawn(canvas);

  // utility
  if (TESTING) {
    displayBoundaries(canvas);
    displayWaterCells(canvas);
  }

  // water
  displayWater(canvas, -370);


  // weather
  //displayClouds(canvas, -1570);
  displayRain(canvas);

  canvas.endDraw();

  image(canvas, 0, 0);

  //renderScreens();
  update();

  if (TESTING) displayFrames();
}

void update() {
  // plants
  //checkForSpawned(1000);
  grasses.grow();
  grassesLeft.grow();
  grassesRight.grow();
  removeDeadPlants();
<<<<<<< HEAD:plantDat_Processing.pde
  spawnRecurringPlants(1000*15);
=======
  spawnRecurringPlants(1000*3);
>>>>>>> a9e61387c55095bb83902c3c451f51abbb0bd060:plantDat_Carroll.pde

  // the elements
  checkThunder();
  checkRain();
  setWater();
  //waterOff();
  setGridTerrain();
  wind();
  playSounds();
}

void displayFrames() {
  fill(0);
  stroke(255, 0, 0);
  text(frameRate, 10, 50);
}

//void keyPressed() {
//  if (key == 'c')
//    toggleCalibration();
//  else if (key == 's') {
//    saveKeystone();
//    //mask.saveMask();
//    //saveMappedLines();
//  } else if (key == 'l')
//    loadKeystone();
//}

void testingVals() {
  lifeTimeSeconds = 10;
  rainLasts = 10*1000;
  sunLasts = 10*1000;
}
