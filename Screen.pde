import deadpixel.keystone.*;  

float scaleFactor = 1.1;
int screenW = 1440;
int screenH = 900;


Keystone ks;
int keystoneNum = 0;
CornerPinSurface surface;
PGraphics screen;

//CornerPinSurface surfaceL;
//PGraphics screenL;

//CornerPinSurface surfaceR;
//PGraphics screenR;

//CornerPinSurface surfaceG;
//PGraphics screenG;

boolean isCalibrating = true;

void initScreens() {
  ks = new Keystone(this);
  
  surface = ks.createCornerPinSurface(screenW, screenH, 20);
  screen = createGraphics(screenW, screenH, P3D);

  //surfaceL = ks.createCornerPinSurface(screenW/2, screenH/2, 20);
  //screenL = createGraphics(screenW/2, screenH/2, P3D);

  //surfaceR = ks.createCornerPinSurface(screenW/2, screenH/2, 20);
  //screenR = createGraphics(screenW/2, screenH/2, P3D);
  
  //surfaceG = ks.createCornerPinSurface(screenW/2, screenH/2, 20);
  //screenG = createGraphics(screenW/2, screenH/2, P3D);
}


void saveKeystone() {
  ks.save("data/keystone/keystone.xml");
}

void loadKeystone() {
  ks.load("data/keystone/keystone.xml");
}

void renderScreens() {
  surface.render(screen);
  //surfaceL.render(screenL);
  //surfaceR.render(screenR);
  //surfaceG.render(screenG);
}



void toggleCalibration() {
  isCalibrating = !isCalibrating;
  if (isCalibrating) ks.startCalibration();
  else ks.stopCalibration();
}
