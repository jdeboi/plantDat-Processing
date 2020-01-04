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

  permPlants.add(new Cane(getSpawnedXY(20, 0), 1.0, false));
  permPlants.add(new Cane(getSpawnedXY(22, 0), 1.0, false));
}

void displaySpawned(PGraphics s) {
  for (int i = 0; i < spawnedPlants.size(); i++) {
    spawnedPlants.get(i).display(s);
    spawnedPlants.get(i).grow();
  }
}

void displayPermanent(PGraphics s) {
  for (int i = 0; i < permPlants.size(); i++) {
    permPlants.get(i).display(s);
    permPlants.get(i).grow();
  }
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
      //println("removed old plant");
      // can forsee an issue where time delay means plant will respawn, flash, based on timing differences of web app and this program
      //spawnedPlantIDs.remove(code);
    } else {
      i++;
    }
  }
  //}
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
    } else {
      //println(code, " already exists");
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
  PVector xy = getStreetSpawn(x, y);

  if (name.equals("Blue")) {
    spawnedPlants.add(new Blue(xy, age, code));
    println("added new plant", name);
  } else if (name.equals("Spoon")) {
    spawnedPlants.add(new Spoon(xy, age, code));
    println("added new plant", name);
  } 

  println("Num spawned plants: ", spawnedPlants.size());
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


// remeber that y is zero at the top of the screen...
PVector getSpawnedXY(float x, float y) {
  float zMin = getBackWater()-500;
  float zMax = -50;
  float newZ = map(y, 0, 100, zMin, zMax);
  float newY =  map(y, 100, 0, canvas.height+10, 200);
  //float newX = map(x, 0, 100, newZ*.8 + 15, canvas.width-newZ*.8-70);
  float newX = map(x, 0, 100, newZ + 15, canvas.width-newZ-70);
  //println("spawned x " + x + "y" + y + " dx " + newX + " dy " + newY + " dz " + newZ);
  return new PVector(newX, newY, newZ);
}


PVector getStreetSpawn(float x, float y) {
  float xval1 = 63-(rowsTerr -y)*.26;
  float xval2 = 80-(rowsTerr -y)*.35;
  float mid = (xval2+xval1)/2;
  if (x > xval1 && x <= mid)  return getSpawnedXY(random(0, xval1), y);
  else if (x > mid && x < xval2) return getSpawnedXY(random(xval2, 100), y);
  return getSpawnedXY(x, y);
}

float getSpawnedY(float z) {
  float zMin = getBackWater()-500;
  float zMax = -50;
  float newY =  map(z, zMax, zMin, canvas.height+10, 200);
  return newY;
}

void spawnFakePlants() {
  for (int x = 0; x <= 100; x += 25) {
    for (int y = 0; y <= 100; y+= 25) {
      PVector temp = getSpawnedXY(x, y);
      //int i = int(random(5));
      //if (i == 0) permPlants.add(new Spoon(temp, 0, -1));
      //else if (i == 1) permPlants.add(new Cane(temp, 0, -1));
      //else if (i == 2) permPlants.add(new Blue(temp, 0, -1));
      //else if (i == 3) permPlants.add(new Sunflower(temp, 0, -1));
      //else if (i == 4) permPlants.add(new Milkweed(temp, 0, -1));
      permPlants.add(new Sunflower(temp, 0, -1));
    }
  }

  //for (int y = 0; y < 100; y+= 10) {
  //  float x = 63-(rowsTerr -y)*.26;;
  //  PVector temp = getSpawnedXY(x, y);
  //  permPlants.add(new Spoon(temp, 0, -1));

  //  x = 80-(rowsTerr -y)*.35;;
  //  temp = getSpawnedXY(x, y);
  //  permPlants.add(new Spoon(temp, 0, -1));
  //}

  // for (int y = 0; y < 100; y+= 20) {
  //  float x = 85 - 1*y;
  //  PVector temp = getSpawnedXY(x, y);
  //  permPlants.add(new Spoon(temp, 0, -1));
  //}
}

long recurringPlantTime = 0;
void spawnRecurringPlants(int delayt) {
  randomSeed(millis());
  int i = int(random(5));
  if (millis() - recurringPlantTime > delayt) {
    recurringPlantTime = millis();
    PVector temp = getStreetSpawn(random(100), random(100));
    if (i == 0) permPlants.add(new Spoon(temp, 0, -1));
    else if (i == 1) permPlants.add(new Cane(temp, 0, -1));
    else if (i == 2) permPlants.add(new Blue(temp, 0, -1));
    else if (i == 3) permPlants.add(new Sunflower(temp, 0, -1));
    else if (i == 4) permPlants.add(new Milkweed(temp, 0, -1));
  }
}

void displayBoundaries(PGraphics s) {
  PVector temp;
  for (int x = 0; x <= 100; x += 25) {
    for (int y = 0; y <= 100; y+= 25) {
      temp = getSpawnedXY(x, y);
      s.pushMatrix();
      s.fill(255, 0, y*100);
      s.translate(temp.x, temp.y, temp.z);
      reduceWater(temp.x, temp.y, temp.z, 1.0);
      //println("tz" + temp.z);
      //PVector temp2 = getWaterLoc(temp.x, temp.y, temp.z);
      //reduceWater(int(temp2.x), int(temp2.y), 1);
      //reduceWater(int(temp.x), int(temp.y), 1);
      //println(temp.x + " " + temp.y + " " + temp.z);
      s.ellipse(0, 0, 30, 30);
      s.popMatrix();
    }
  }
}
