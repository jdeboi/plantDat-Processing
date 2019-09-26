import keystoneMap.*;
Keystone ks;
CornerPinSurface surface;
boolean isCalibrating = true;

void initScreens() {
  ks = new Keystone(this);
  
  surface = ks.createQuadPinSurface(800, 800, 20);
  canvas = createGraphics(800, 800, P3D);
}

void saveKeystone() {
  ks.save("data/keystone/keystone.xml");
}

void loadKeystone() {
  ks.load("data/keystone/keystone.xml");
}

void renderScreens() {
  surface.render(canvas);
}

void toggleCalibration() {
  isCalibrating = !isCalibrating;
  if (isCalibrating) ks.startCalibration();
  else ks.stopCalibration();
}
