import java.util.*;
String url = "http://www.plantdat.com/";
ArrayList<Plant> spawnedPlants;
Map spawnedPlantIDs;
int lastSpawnCheck = 0;
float spawnedFloat = 0;
PImage shovel;

PVector getSpawnedXY(float x, float y) {
  float zMin = -1120;
  float zMax = 0;
  if (x < 50) {
    zMax = map(x, 0, 50, -220, 0);
  }
  float newZ = map(y, 0, 100, zMin, zMax);
  float newX = map(x, 0, 100, newZ*.85, width-newZ*.85);
  //s.fill(255, 0, 0);
  
  //s.pushMatrix();
  //s.translate(newX, s.height*.99, newZ);
  //s.ellipse(0, 0, 40, 40);
  //s.popMatrix();
  
  //int z = -230;
  //s.translate(z*.85, s.height*.99, z);
  //s.ellipse(0, 0, 40, 40);
  //s.popMatrix();
  
  //s.pushMatrix();
  //s.translate(s.width, s.height, 0);
  //s.ellipse(0, 0, 40, 40);
  //s.popMatrix();
  return new PVector(newX, newZ);
}

void incSpawnedFloat() {
  int spz = spawnedPlants.size();
  if (spawnedFloat < spz) {
    spawnedFloat += 0.01;
  } else if (spawnedFloat > spz) {
    spawnedFloat -= 0.01;
  }
}

void initSpawned() {
  spawnedPlants = new ArrayList<Plant>();
  spawnedPlantIDs = new HashMap();
  checkForSpawned(0);
  shovel = loadImage("images/shovel.png");
}

void  checkForSpawned(int delayT) {
  if (millis() - lastSpawnCheck > delayT) {
    thread("requestData");
    lastSpawnCheck = millis();
  }
}

// This happens as a separate thread and can take as long as it wants
void requestData() {
  JSONArray sp = loadJSONArray(url + "api/allspawned");
  for (int i = 0; i < sp.size(); i++) {
    JSONObject pObj = sp.getJSONObject(i); 
    JSONObject plant = pObj.getJSONObject("plant");
    int code = plant.getInt("code");
    if (!spawnedPlantIDs.containsKey(code)) {
      addNewPlant(pObj);
      spawnedPlantIDs.put(code, 1);
    }
  }
}

void addNewPlant(JSONObject pObj) {
  float age = pObj.getFloat("age");
  JSONObject plant = pObj.getJSONObject("plant");
  String name = plant.getString("plantType"); 
  int x = plant.getInt("x");
  int y = plant.getInt("y");
  PVector xy = getSpawnedXY(x, y);
  if (name.equals("Lizard's Tail") || name.equals("Stokes Aster") || name.equals("Obedient Plant")) {
    spawnedPlants.add(new Lizard(xy, age));
  } else if (name.equals("Beauty Berry") || name.equals("Clasping Cone Flower")) {
    spawnedPlants.add(new Beauty(xy, age));
  }
  println("added new plant", name);
}

void displaySpawnedPlants(PGraphics s) {
  if (spawnedPlants != null) {
    for (Plant p : spawnedPlants) {
      //p.display(s);
    }
  }
}
