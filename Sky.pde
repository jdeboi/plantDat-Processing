int rainLasts = 1*10*1000;
int sunLasts = 1*10*1000;
long lastRainTime = 0;

PImage shotgun1, shotgun2;
PImage cement;
PImage fence;

PImage plants[];
PShape plants2[];

boolean isRaining = true;
boolean thunder = false;
boolean  thundering = false;
long lastThundering = 0;
long lastThunder = 0;
int thunderNum = 0;
long ranTime = 0;
int tTime = 20;

color cementColor = color(170);

import ddf.minim.*;
Minim minim;
AudioPlayer player;

color getBackground() {
  //s.background(#6965D6);
  if (thunder) {
    //s.noStroke();
    //fill(255,200);
    //rect(0, 0, width, height);
    return color(255);
  } else {
    color c;
    long timeP = millis() - lastRainTime;
    if (timeP < rainLasts*.7) {
      c = color(50);
      println("raining");
    } else if (timeP < rainLasts) {
      float per = map(timeP, rainLasts*.7, rainLasts, 0, 1);
      c = lerpColor(color(50), color(#6965D6), per);
      //println("raining but letting up");
    } else if (timeP < rainLasts + sunLasts *.7) {
      c = color(#6965D6);
      println("nice sky");
    } else {
      float per = map(timeP, rainLasts + sunLasts *.7, rainLasts + sunLasts, 0, 1);
      c = lerpColor(color(#6965D6), color(50), per);
      println("not raining but getting closer");
    }
    return c;
  }
}

void checkThunder() {
  if (isRaining) {
    if (!thundering) {
      if (millis() - lastThundering > 1000 + ranTime) {
        thundering = true;
        lastThundering = millis();
      }
    } else if (thundering) {
      if (!thunder) {
        if (thunderNum == 0) {
          thunder = true;
          lastThunder = millis();
          thunderNum++;
          tTime += 50;
        } else if (millis() - lastThunder > 50) {
          thunder = true;
          lastThunder = millis();
        }
      } else if (thunder) {
        if (millis() - lastThunder > tTime) {
          lastThunder = millis();
          thunder = false;
          thunderNum++;
          if (thunderNum == 5) {
            thundering = false;
            thunderNum = 0;
            tTime = 20;
            lastThundering = millis();
            ranTime = int(random(8000));
          }
        }
      }
    }
  }
}


void initBackground() {

  shotgun1 = loadImage("images/sidehousepaint1.png");
  shotgun2 = loadImage("images/sidehousepaint2.png");
  plants = new PImage[5];
  plants2 = new PShape[5];
  for (int i = 0; i < 5; i ++) {
    plants[i] = loadImage("testing/" + i + ".png");
    plants2[i] = loadShape("testing/" + i + ".svg");
  }

  cement = loadImage("images/driveway.jpg");
  fence = loadImage("images/fence.png");
}

void displayFakePlants(PGraphics s) {
  //s.blendMode(MULTIPLY);
  float w = 50.0;
  for (int i = 0; i < 40; i ++) {
    float factor = w/plants2[i%plants2.length].width;
    s.pushMatrix();
    s.translate(noise(i+1)*width*1.5-300, s.height-plants2[i%plants2.length].height*factor, noise(i*50)*500*-1);

    //s.image(plants[i], 0, 0, 100, plants[i].height*factor);
    plants2[i%plants2.length].disableStyle();
    s.noStroke();
    s.strokeWeight(1);
    s.fill(0, noise(i*40)*200+50, 0);
    s.shape(plants2[i%plants2.length], 0, 0, w, plants2[i%plants2.length].height*factor);
    //s.beginShape();
    //s.textureMode(NORMAL);
    //s.texture(plants[i]);
    //s.vertex(0, 0, 0, 0);
    //s.vertex(100, 0, 1.0, 0);
    //s.vertex(100, plants[i].height*factor, 1.0, 1.0);
    //s.vertex(0, plants[i].height*factor, 0, 1.0);
    //s.endShape();
    s.popMatrix();
  }
  s.blendMode(BLEND);
}

void displayHouse(PGraphics s, int z ) {
  s.pushMatrix();
  //s.scale(2);

  float w = 2000;
  float factor = w/shotgun2.width;
  float h = shotgun2.height*factor;

  s.translate(0, s.height-h-150, z);

  displayCement(s, z-1);


  //for (int i = -s.width; i < s.width*2; i+= cement.width) {
  //  s.image(cement, i, 300);
  //}

  s.pushMatrix();
  s.translate(-900, -200);
  s.rotate(radians(0));
  s.image(shotgun1, 0, 0, w, h);
  s.popMatrix();

  s.pushMatrix();
  s.translate(300, -200);
  s.rotate(radians(0));
  s.image(shotgun2, 0, 0, w, h);
  s.popMatrix();

  //drawFence(s, z);

  s.popMatrix();
}

void drawFence(PGraphics s, int z) {
  s.pushMatrix();
  s.translate(0, -200);
  float fenceH = 400;
  float factor = fenceH/fence.height;
  for (int i = int(s.width); i < s.width*2; i+= fence.width*factor) {
    s.image(fence, i, shotgun1.height*2-fenceH, fence.width*factor, fenceH);
  }
  //for (int i = ; i < -1000; i+= fence.width*factor) {
  s.pushMatrix();
  //s.scale(-1, 1);
  s.image(fence, z-fence.width*factor*.8, shotgun1.height*2-fenceH, fence.width*factor, fenceH);
  s.popMatrix();
  //}
  s.popMatrix();
}

void checkRain() {

  if (millis() - lastRainTime < rainLasts) {
    isRaining = true;
  } else {
    isRaining = false;
  }

  if (millis() - lastRainTime > rainLasts + sunLasts) {
    lastRainTime = millis();
  }
}

void displaySky(PGraphics s) {
  s.noStroke();
  for (int i = 0; i < 5; i++) {
    s.pushMatrix();
    s.translate(-s.width*2 + i*s.width, -200, -800);
    color c1 = color(#6965D6);
    color c2 = color(#FFADFB);
    color c3 = color(#FFDAAD);

    float per = 0.6;
    int screenH = int(s.height*2.5);
    s.beginShape();
    s.fill(c1);
    s.vertex(0, 0);
    s.vertex(s.width, 0);
    s.fill(c2);
    s.vertex(s.width, screenH*per);
    s.vertex(0, screenH*per);
    s.endShape();

    s.beginShape();
    s.fill(c2);
    s.vertex(0, screenH*per);
    s.vertex(s.width, screenH*per);
    s.fill(c3);
    s.vertex(s.width, screenH);
    s.vertex(0, screenH);
    s.endShape();
    s.popMatrix();
  }

  displayHouse(s, -1300);
}

void displayCement(PGraphics s, int z) {
  s.pushMatrix();
  s.translate(-s.width, s.height*.4, z);
  s.noStroke();
  //s.rotateX(radians(90));
  s.fill(cementColor);
  //s.textureWrap(REPEAT);
  //s.textureMode(NORMAL);
  s.beginShape();
  //s.texture(cement);
  s.vertex(-s.width, 0, 0, 0);
  s.vertex(s.width*4, 0, 1, 0);
  s.vertex(s.width*4, s.height*2, 1, 1);
  s.vertex(-s.width, s.height*2, 0, 1);
  s.endShape();
  s.popMatrix();
}

Drop[] drops;
int dropIndex = 0;
long dropTime = 0;
long dropSpawnTime = 5;

void initDrops() {
  drops = new Drop[200];
  for (int i = 0; i < drops.length; i++) {
    drops[i] = new Drop();
  }
}

boolean getRaining() {
  if (millis() - lastRainTime < rainLasts) {
    return true;
  }
  return false;
}

void displayRain(PGraphics s) {
  if (isRaining) {
    //if (millis() - dropTime > dropSpawnTime) {
    //  drops[dropIndex].spawn();
    //  drops[dropIndex+1].spawn();
    //  drops[dropIndex+2].spawn();
    //  dropIndex+=3;
    //  if (dropIndex >= drops.length-3) dropIndex = 0;
    //  dropTime = millis();
    //}
    int amt = 1;
    if (millis() - lastRainTime > rainLasts *.8) amt = int(map(millis()-lastRainTime, rainLasts*.7, rainLasts, 1, 8));
    for (int i = 0; i < drops.length; i+=amt) {
      drops[i].fall(20);
      drops[i].display(s);
    }
  }
}

class Drop {
  int x, y, yMax, len;

  Drop() {
    x = int(random(width));
    y = int(random(-1000, 0));

    len = int(random(8, 20));
    yMax = int(map(len, 8, 20, height*.4, height));
  }

  void fall(int speed) {

    //if (y > -100) y += speed;
    //if (y > yMax) {
    //  y = -100;
    //}
    if (isRaining) {
      y += speed;
      if (y > yMax) {
        y = -100;
      }
    } else {
      if (y > -20) {
        y += speed;
        if (y > yMax) {
          y = -100;
        }
      }
    }
  }

  void spawn() {
    y = -20;
  }

  void display(PGraphics s) {
    s.stroke(200);
    int sw = int(map(len, 8, 20, 1, 4));
    s.strokeWeight(sw);
    s.fill(255);
    //ellipse(x, y, 100, 100);
    s.line(x, y, x, y-len);
  }
}

float waterY = 0;
void waterOff() {
  waterY = -150;
}
void setWater() {
  incSpawnedFloat();
  float lowestSea = -150;
  //float maxSea = 200;
  //waterMax = int(35 + 300*sin(millis()/1000.0));
  float maxs = 250;
  float maxSea = map(spawnedFloat, 0, 14, maxs, -120);
  maxSea = constrain(maxSea, -100, maxs);
  if (isRaining) {

    waterY = map(millis() - lastRainTime, 0, rainLasts, lowestSea, maxSea);
    waterY = constrain(waterY, lowestSea, maxSea);
  } else {
    if (millis() - lastRainTime >  rainLasts+sunLasts*.3) {
      waterY = map(millis() - lastRainTime, rainLasts+sunLasts*.3, rainLasts+sunLasts*.7, maxSea, lowestSea);
      waterY = constrain(waterY, lowestSea, maxSea);
    }
  }
}


void wind() {
  //float windForce = map(mouseX, 0, width, -PI/7, PI/7);
  float windForce = map(noise(0, flyingTerr), 0, 1, -PI/7, PI/7);
  //windAngle =  windForce + windForce/4 * 2*PI * sin(mouseX/1000.0);
  windAngle =  windForce + windForce/4 *sin(map(noise(0, flyingTerr), 0, 1, 0, width)/1000.0);
}