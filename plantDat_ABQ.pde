
boolean TESTING = true;
boolean DEBUG = false;
int MAX_SPAWNED = 20;

PGraphics canvas;


void setup() {
  //size(1600, 900, P3D);
  size(1920, 1080, P3D);
  //fullScreen(P3D);

  frameRate(20);

  initScreens();
  initServer();

  // plant files
  initBlue();
  initCane();
  initSpoon();
  initSunflower();
  initMilkweed();


  initSpawned();

  // the elements
  initBackground();
  initTerrain();
  initMountain();
  initDrops();


  // permanent plants
  initGrasses();
  initPermPlants();

  if (TESTING) {
    spawnFakePlants();
    testingVals();
  }

  smooth(4);
}

void draw() {
  background(getBackground());
  lights();
  displayMountainTerrain(); // this needs to be display on normal graphics b/c it needs lights; lights effs up plants etc.

  canvas.smooth(8);
  canvas.beginDraw();
  canvas.smooth(8);
  //canvas.background(getBackground());
  canvas.clear();


  displayHouse(canvas, int(getBackWater()) -600);


  // ground
  displayGroundTerrain(canvas, -650);
  //drawDriveway(canvas);

  // plants
  //displayGrass(canvas, grasses);
  if (!TESTING)displaySpawned(canvas);
  displayPermanent(canvas);
  displayLiveSpawn(canvas);

  // water
  displayWater(canvas);
  displayRain(canvas);

  canvas.endDraw();

  renderScreens();
  update();

  //if (TESTING)
  displayFrames();
}


void update() {

  // plants
  checkForSpawned(1000);
  grasses.grow();
  removeDeadPlants();
  if (!TESTING) spawnRecurringPlants(1000);

  // the elements
  checkThunder();
  checkRain();
  setWater();  //waterOff();
  setGridTerrain();
  wind();
  playSounds();
}

void displayFrames() {
  fill(0);
  stroke(255, 0, 0);
  text(frameRate, 10, 50);
}

void keyPressed() {
  if (key == 'c')
    toggleCalibration();
  else if (key == 's') {
    saveKeystone();
    //mask.saveMask();
    //saveMappedLines();
  } else if (key == 'l')
    loadKeystone();
}

void testingVals() {
  lifeTimeSeconds = 2;
  rainLasts = 10*1000;
  sunLasts = 10*1000;
}

float centerMap(float i, float start0, float end0, float start1, float end1) {
  float sc = map(i, start0, end0, -1, 1);
  float range2 = end1 - start1;
  return abs(sc)*range2 + start1;
}
