int rainLasts = 1*60*1000;
int sunLasts = 1*60*1000;
long lastRainTime = 0;

PImage shotgun1, shotgun2;
PImage cement;
PImage fence;

PImage plants[];

boolean isRaining = true;
boolean thunder = false;
boolean  thundering = false;
long lastThundering = 0;
long lastThunder = 0;
int thunderNum = 0;
long ranTime = 0;
int tTime = 20;

float windAngle = 0;
float windNoise = 0;


color startDayColor, midDayColor, endDayColor;


import ddf.minim.*;
Minim minim;
AudioPlayer thunderSound;
AudioPlayer rainSound;
AudioPlayer windSound;

boolean rainEnding = false;

void playSounds() {
  if (thundering) {
    if (!thunderSound.isPlaying()) thunderSound.play(0);
    rainSound.setGain(0);
    windSound.setGain(-100);
  }
  if (isRaining) {
    // this will work as long as the rain soundfile is longer than the time rain lasts
    if (!rainSound.isPlaying()) rainSound.play(0);
    if (millis() - lastRainTime > rainLasts - 4000) {
      rainSound.shiftGain(rainSound.getGain(), -100, 4000);
      windSound.setGain(-4);
    }
  }
}

void stop() {
  windSound.close();
  thunderSound.close();
  rainSound.close();
  minim.stop();
}



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
      //println("raining");
    } else if (timeP < rainLasts) {
      float per = map(timeP, rainLasts*.7, rainLasts, 0, 1);
      //c = lerpColor(color(50), startDayColor, per);
      c = lerpColor(color(50), endDayColor, per);
      //println("raining but letting up");
    } else if (timeP < rainLasts + sunLasts *.7) {
      //float per = map(timeP, rainLasts, rainLasts + sunLasts *.7, 0, 1.0);
      //if (per < 0.5) c = startDayColor;
      //else if (per < 0.6) {
      //  float per2 = map(per, .5, .6, 0, 1);
      //  c = lerpColor(startDayColor, midDayColor, per2);
      //} else if (per < 0.7) {
      //  float per2 = map(per, .6, .7, 0, 1);
      //  c = lerpColor(midDayColor, endDayColor, per2);
      //}
      //else {
      //  c = endDayColor;
      //}
      c = endDayColor;
      //println("nice sky");
    } else {
      float per = map(timeP, rainLasts + sunLasts *.7, rainLasts + sunLasts, 0, 1);
      c = lerpColor(endDayColor, color(50), per);
      //println("not raining but getting closer");
    }
    return c;
  }
}

void checkThunder() {
  if (isRaining) {
    // if it's about to stop raining, let's just not thunder
    if ( millis() - lastRainTime > rainLasts - 7000) {
      thundering = false;
      thunder = false;
    } else if (!thundering) {
      if (millis() - lastThundering > ranTime) {
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
            ranTime = int(random(8000, 16000));
          }
        }
      }
    }
  } else {
    thundering = false;
    thunder = false;
  }
}

void initBackground() {
  plantColor = color(#11BB7C);
  stemStroke = color(0, 50, 0);
  startDayColor = color(#BCF5FF);
  midDayColor = color(#FFB4EE);
  endDayColor = color(#6965D6);

  shotgun1 = loadImage("images/sidehousepaint1.png");
  shotgun2 = loadImage("images/sidehousepaint2.png");

  fence = loadImage("images/fence.png");

  minim = new Minim(this);
  thunderSound = minim.loadFile("sounds/thunderSound.mp3");
  rainSound = minim.loadFile("sounds/rainSound.mp3");
  windSound = minim.loadFile("sounds/windSound.mp3");
  windSound.loop();
}

void displayHouse(PGraphics s, int z ) {
  s.pushMatrix();

  float w = s.width*1.45;
  float down = -650;
  float factor = w/shotgun2.width;
  float h = shotgun2.height*factor;

  s.translate(0, down, z);

  displayCement(s, z-1);
  //drawFence(s, z);

  s.pushMatrix();
  s.translate(-s.width*.7, down);
  s.rotate(radians(0));
  s.image(shotgun1, 0, 0, w, h);
  s.popMatrix();

  // right shotgun
  s.pushMatrix();
  s.translate(s.width*.3, down);
  s.rotate(radians(0));
  s.image(shotgun2, 0, 0, w, h);
  s.popMatrix();



  s.popMatrix();
}

void drawFence(PGraphics s, int z) {
  s.pushMatrix();
  s.translate(0, -750);
  float fenceH = 170;
  float factor = fenceH/fence.height;
  for (int i = int(s.width*1.4); i < s.width*2; i+= fence.width*factor) {
    s.image(fence, i, shotgun1.height*2-fenceH, fence.width*factor, fenceH);
  }
  for (int i = -1500; i < 300; i+= fence.width*factor) {
    s.image(fence, i, shotgun1.height*2-fenceH, fence.width*factor, fenceH);
  }
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


  //displayHouse(s, 0);
}

void displayCement(PGraphics s, int z) {
  int gradStarts = 450;
  s.pushMatrix();
  s.translate(-s.width*2, -150, z);
  s.noStroke();
  //s.rotateX(radians(90));
  //s.fill(0);
  //s.textureWrap(REPEAT);
  //s.textureMode(NORMAL);
  s.beginShape();
  //s.texture(cement);
  s.fill(100);
  s.vertex(-s.width, 0, 0, 0);
  float inc = 0;
  for (int i = -s.width; i <= s.width*6; i+= 50) {
    //s.fill((i+s.width)*1.0/(s.width*7) * 255);
    s.vertex(i, noise(inc += 0.05)*150, (i+s.width)*1.0/(s.width*7), 0);
  }
  s.fill(cementColor);
  s.vertex(s.width*6, gradStarts, 1, 0);
  //s.vertex(s.width*6, s.height*2, 1, 1);
  //s.vertex(-s.width, s.height*2, 0, 1);
  s.vertex(-s.width, gradStarts, 0, 0);
  s.endShape();
  s.rect(-s.width, gradStarts, s.width*7,  s.height*2);
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
  //incSpawnedFloat();
  float lowestSea = -150;
  float maxs = 200;


  if (TESTING) {
    maxs = 30;
    lowestSea = -60;
  }

  //float maxSea = map(spawnedFloat, 0, MAX_SPAWNED, maxs, -120);
  //maxSea = constrain(maxSea, -100, maxs);
  float maxSea = maxs;
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
  float windForce = map(noise(0, flyingTerr), 0, 1, -PI/15, PI/15);
  //windAngle =  windForce + windForce/4 * 2*PI * sin(mouseX/1000.0);
  windAngle =  windForce + windForce/4 *sin(map(noise(0, flyingTerr), 0, 1, 0, width)/1000.0);
}
