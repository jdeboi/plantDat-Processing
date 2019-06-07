boolean flipScreen = false;

PGraphics canvas;
float windAngle = 0;
float windNoise = 0;
float groundRot = -45;

//Beauty[] beauty;
//Stokes[] stokes;
//Lizard[] lizards;
//Clasping[] clasping;
//Obedient[] obedient;


void setup() {
  //size(1200, 900, P3D);
  fullScreen(P3D);

  canvas = createGraphics (width, height, P3D);
  initScreens();
  initServer();

  // plant files
  initBeauty();
  initStokes();
  initLizard();
  initClasping();
  initObedient();
  initSpawned();

  // permanent plants
  initGrasses();
  initPermPlants();

  // the elements
  initBackground();
  initTerrain();
  initDrops();


  smooth(4);
}

void draw() {
  background(0);



  canvas.smooth(8);
  canvas.beginDraw();
  canvas.smooth(8);
  if (flipScreen) {
    canvas.translate(canvas.width/2, canvas.height/2);
    canvas.rotateZ(radians(180));
    canvas.translate(-canvas.width/2, -canvas.height/2);
  }
  canvas.background(getBackground());

  displayHouse(canvas, -1800);


  // ground
  displayGroundTerrain(canvas, -650);


  // plants
  displayGrass(canvas, grasses);
  displaySpawned(canvas);
  displayPermanent(canvas);
  displayLiveSpawn(canvas);

  // utility
  displayBoundaries(canvas);

  // water
  displayWater(canvas, -370);


  // weather
  //displayClouds(canvas, -1570);
  displayRain(canvas);

  canvas.endDraw();

  renderScreens();
  update();

  displayFrames();
}

void update() {
  // plants
  checkForSpawned(1000);
  grasses.grow();
  removeDeadPlants();

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
