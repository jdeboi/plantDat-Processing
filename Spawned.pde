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

  // right side plants
  permPlants.add(new Lizard(getSpawnedXY(82, -15), 1.0, false));
  permPlants.add(new Lizard(getSpawnedXY(85, 0), 1.0, false));
  permPlants.add(new Lizard(getSpawnedXY(87, -15), 1.0, false));
  permPlants.add(new Lizard(getSpawnedXY(90, 0), 1.0, false));
  permPlants.add(new Lizard(getSpawnedXY(92, -20), 1.0, false));
  permPlants.add(new Lizard(getSpawnedXY(93, -10), 1.0, false));
  permPlants.add(new Lizard(getSpawnedXY(95, 0), 1.0, false));
  permPlants.add(new Lizard(getSpawnedXY(97, -20), 1.0, false));
  permPlants.add(new Lizard(getSpawnedXY(100, 0), 1.0, false));

  // left side plants
  permPlants.add(new Lizard(getSpawnedXY(0, -15), 1.0, false));
  permPlants.add(new Lizard(getSpawnedXY(2, -20), 1.0, false));
  permPlants.add(new Lizard(getSpawnedXY(3, 0), 1.0, false));
  permPlants.add(new Lizard(getSpawnedXY(5, -15), 1.0, false));
  permPlants.add(new Lizard(getSpawnedXY(7, -5), 1.0, false));
  permPlants.add(new Lizard(getSpawnedXY(10, -10), 1.0, false));
  permPlants.add(new Lizard(getSpawnedXY(12, 0), 1.0, false));
  permPlants.add(new Lizard(getSpawnedXY(15, -12), 1.0, false));
  permPlants.add(new Lizard(getSpawnedXY(18, 0), 1.0, false));
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
      println("removed old plant");
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
  PVector xy = getSpawnedXY(x, y);

  if (name.equals("Lizard's Tail")) {
    spawnedPlants.add(new Lizard(xy, age, code));
    println("added new plant", name);
  } else if (name.equals("American Beautyberry")) {
    println("asd");
    spawnedPlants.add(new Beauty(xy, age, code));
    println("added new plant", name);
  } else if (name.equals("Clasping Cone Flower")) {
    spawnedPlants.add(new Clasping(xy, age, code));
    println("added new plant", name);
  } else if (name.equals("Correll’s Obedient Plant")) {
    spawnedPlants.add(new Obedient(xy, age, code));
    println("added new plant", name);
  } else if (name.equals("Stokes Aster")) {
    spawnedPlants.add(new Stokes(xy, age, code));
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
  float zMin = -1799;
  float zMax = 0;
  float newZ = map(y, 0, 100, zMin, zMax);
  float newY =  map(y, 100, 0, canvas.height-20, -100);
  float newX = map(x, 0, 100, newZ*.6 + 15, canvas.width-newZ*.55-80);
  return new PVector(newX, newY, newZ);
}

void reduceWaterPlants() {
  if (TESTING) {
    for (Plant p : permPlants) {
      PVector temp = getWaterLoc(p.x, p.y, p.z);
      reduceWater(int(temp.x), int(temp.y), p.plantHeight);
    }
  } else {
    for (Plant p : spawnedPlants) {
      PVector temp = getWaterLoc(p.x, p.y, p.z);
      reduceWater(int(temp.x), int(temp.y), p.plantHeight);
    }
  }
}

PVector getWaterLoc(float x, float y, float z) {
  float zMin = -1799;
  float zMax = 0;
  float minX = map(z, zMax, zMin, 22, 8);
  float maxX = map(z, zMax, zMin, 32, 45);
  float minY = 0;
  float maxY = 25;

  float newX = map(x, z*.6 + 15, canvas.width-z*.55-80, minX, maxX);
  float newY = map(z, zMax, zMin, maxY, minY);

  //float dis = sqrt(y*y + z *z);
  //float newY = map(dis, 0, rowsTerr*spacingTerr*(3.0/4.0), rowsTerr*(1.0/4), rowsTerr);
  //newY = constrain(newY, 0, rowsTerr-1);

  //float newX = colsTerr/2 - (x - canvas.width/2)*1.0/spacingTerr; 
  //newX = constrain(newX, 0, colsTerr-1);

  return new PVector(newX, newY);
}

void spawnFakePlants() {
  int i = 0;
  for (int x = 0; x <= 100; x += 25) {
    for (int y = 0; y <= 100; y+= 25) {
      if (i%5 == 0) permPlants.add(new Stokes(getSpawnedXY(x, y), 1.0, false));
      else if (i%5 == 1) permPlants.add(new Lizard(getSpawnedXY(x, y), 1.0, false));
      else if (i%5 == 2) permPlants.add(new Beauty(getSpawnedXY(x, y), 1.0, false));
      else if (i%5 == 3) permPlants.add(new Clasping(getSpawnedXY(x, y), 1.0, false));
      else if (i%5 == 4) permPlants.add(new Obedient(getSpawnedXY(x, y), 1.0, false));
      i++;
    }
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
      PVector temp2 = getWaterLoc(temp.x, temp.y, temp.z);
      //reduceWater(int(temp2.x), int(temp2.y), (millis()/4000.0)%1);
      s.ellipse(0, 0, 30, 30);
      s.popMatrix();
    }
  }
}
