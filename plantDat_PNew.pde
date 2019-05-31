

PGraphics canvas;
float windAngle = 0;
float windNoise = 0;

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
  initGrasses();
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


  smooth(4);
}

void draw() {
  background(255);



  canvas.smooth(4);
  canvas.beginDraw();

  canvas.background(getBackground());

  displayHouse(canvas, -1300);

  canvas.pushMatrix();
  canvas.rotateX(radians(-25));
  canvas.translate(0, 0, 300);

  // ground
  displayGroundTerrain(canvas, -650);
  displayGrass(canvas, grasses);

  // plants
  for (int i = 0; i < spawnedPlants.size(); i++) {
    spawnedPlants.get(i).display(canvas);
    spawnedPlants.get(i).grow();
  }


  displayLiveSpawn(canvas);
  displayBoundaries(canvas);
  
  // water
  displayWater(canvas, -370);

  canvas.popMatrix();


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
  setGridTerrain();
  wind();
  playSounds();
}

void displayFrames() {
  fill(0);
  stroke(255, 0, 0);
  text(frameRate, 10, 50);
}
