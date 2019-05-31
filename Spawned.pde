import java.util.*;
String url = "http://www.plantdat.com/";
ArrayList<Plant> spawnedPlants;
ArrayList<Plant> permPlants;
Map spawnedPlantIDs;
int lastSpawnCheck = 0;
float spawnedFloat = 0;
PShape shovel;

void initPermPlants() {
  permPlants = new ArrayList<Plant>();
  permPlants.add(new Lizard(getSpawnedXY(85, 0), 1.0, false));
  permPlants.add(new Lizard(getSpawnedXY(80, 0), 1.0, false));
  permPlants.add(new Lizard(getSpawnedXY(85, 0), 1.0, false));
  permPlants.add(new Stokes(getSpawnedXY(90, 0), 1.0, false));
}

//long lastPlantRemoval = 0;
void removeDeadPlants() {
  //if (millis() - lastPlantRemoval > delay) {
  //lastPlantRemoval = millis();
  int i = 0;
  while (i < spawnedPlants.size()) {
    if (!spawnedPlants.get(i).alive) {
      //int code = spawnedPlants.get(i).id;
      spawnedPlants.remove(i);
      // can forsee an issue where time delay means plant will respawn, flash, based on timing differences of web app and this program
      //spawnedPlantIDs.remove(code);
    } else {
      i++;
    }
  }
  //}
}

void displayPermPlants() {
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
  shovel = loadShape("images/shovel.svg");
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
      addNewPlant(pObj, code);
      spawnedPlantIDs.put(code, 1);
    }
  }
}

void addNewPlant(JSONObject pObj, int code) {
  float age = pObj.getFloat("age");
  //age = constrain(age, 0, 1);
  JSONObject plant = pObj.getJSONObject("plant");
  String name = plant.getString("plantType"); 
  int x = plant.getInt("x");
  int y = plant.getInt("y");
  PVector xy = getSpawnedXY(x, y);
  if (name.equals("Lizard's Tail") || name.equals("Beauty Berry")) {
    spawnedPlants.add(new Lizard(xy, age, code));
  } else if (name.equals("Beauty Berry")) {
    spawnedPlants.add(new Beauty(xy, age, code));
  } else if (name.equals("Clasping Cone Flower")) {
    spawnedPlants.add(new Clasping(xy, age, code));
  } else if (name.equals("Obedient Plant")) {
    spawnedPlants.add(new Obedient(xy, age, code));
  } else if (name.equals("Stokes Aster")) {
    spawnedPlants.add(new Stokes(xy, age, code));
  }
  println("added new plant", name);
}

void displaySpawnedPlants(PGraphics s) {

  if (spawnedPlants != null) {

    for (int i = 0; i < spawnedPlants.size(); i++) {
      try {
        spawnedPlants.get(i).display(s);
      }
      catch(Exception e) {
        println(e);
        println("spawned plants is an issue...");
      }
    }
  }
}

PVector getSpawnedXY(float x, float y) {
  float zMin = -1120;
  float zMax = 0;
  float newZ = map(y, 0, 100, zMin, zMax);
  float newX = map(x, 0, 100, newZ*.85, width-newZ*.85);
  return new PVector(newX, newZ);
}

void displayBoundaries(PGraphics s) {
  PVector temp;
  temp = getSpawnedXY(0, 0);
  s.fill(255, 0, 0);
  s.pushMatrix();
  s.translate(temp.x, s.height - 20, temp.y);
  s.ellipse(0, 0, 30, 30);
  s.popMatrix();

  temp = getSpawnedXY(100, 0);
  s.pushMatrix();
  s.translate(temp.x, s.height - 20, temp.y);
  s.ellipse(0, 0, 30, 30);
  s.popMatrix();
  temp = getSpawnedXY(100, 100);
  s.pushMatrix();
  s.translate(temp.x, s.height - 20, temp.y);
  s.ellipse(0, 0, 30, 30);
  s.popMatrix();
  temp = getSpawnedXY(0, 100);
  s.pushMatrix();
  s.translate(temp.x, s.height - 20, temp.y);
  s.ellipse(0, 0, 30, 30);
  s.popMatrix();
  temp = getSpawnedXY(50, 50);
  s.pushMatrix();
  s.translate(temp.x, s.height - 20, temp.y);
  s.ellipse(0, 0, 30, 30);
  s.popMatrix();
  temp = getSpawnedXY(50, 0);
  s.pushMatrix();
  s.translate(temp.x, s.height - 20, temp.y);
  s.ellipse(0, 0, 30, 30);
  s.popMatrix();
  temp = getSpawnedXY(50, 100);
  s.pushMatrix();
  s.translate(temp.x, s.height - 20, temp.y);
  s.ellipse(0, 0, 30, 30);
  s.popMatrix();
}
