int rainLasts = 1*60*1000;
int sunLasts = 2*60*1000;
long lastRainTime = 0;

//PShape adobe1;
PImage adobe1, adobe2;
PImage cement;
PImage fence;
PImage bkground;
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

Barrel barrel;

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

  adobe1 = loadImage("images/house.png");
  adobe2 = loadImage("images/house.png");
  barrel = new Barrel();
  bkground = loadImage("images/backgroundtest.png");
  fence = loadImage("images/fence.png");

  minim = new Minim(this);
  thunderSound = minim.loadFile("sounds/thunderSound.mp3");
  rainSound = minim.loadFile("sounds/rainSound.mp3");
  windSound = minim.loadFile("sounds/windSound.mp3");
  windSound.loop();
}

void displayHouse(PGraphics s, int z ) {
  s.pushMatrix();

  float w = s.width*1.75;
  float down = -s.height*.5; 
  float factor = w/adobe1.width;
  float h = adobe1.height*factor;


  //displayMountains(s, down, z*2-3);
  displayCement(s, down+100, z*2-3) ;
  //drawFence(s, z);


  s.translate(-s.width*.3, down-350, z);
  s.pushMatrix();
  //s.translate(0, 350, 0);

  barrel.display(w-350, 700, 0, s);
  s.image(adobe1, 0, 0, w, h);
  s.popMatrix();

  s.pushMatrix();
  s.translate(s.width*.6, 0);
  s.rotate(radians(0));
  //s.image(adobe2, 0, 0, w, h);
  s.popMatrix();



  s.popMatrix();
}

void drawFence(PGraphics s, int z) {
  s.pushMatrix();
  s.translate(0, -750);
  float fenceH = 170;
  float factor = fenceH/fence.height;
  for (int i = int(s.width*1.4); i < s.width*2; i+= fence.width*factor) {
    s.image(fence, i, adobe1.height*2-fenceH, fence.width*factor, fenceH);
  }
  for (int i = -1500; i < 300; i+= fence.width*factor) {
    s.image(fence, i, adobe1.height*2-fenceH, fence.width*factor, fenceH);
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

//void displaySky(PGraphics s) {
//  s.noStroke();
//  for (int i = 0; i < 5; i++) {
//    s.pushMatrix();
//    s.translate(-s.width*2 + i*s.width, -200, -800);
//    color c1 = color(#6965D6);
//    color c2 = color(#FFADFB);
//    color c3 = color(#FFDAAD);

//    float per = 0.6;
//    int screenH = int(s.height*2.5);
//    s.beginShape();
//    s.fill(c1);
//    s.vertex(0, 0);
//    s.vertex(s.width, 0);
//    s.fill(c2);
//    s.vertex(s.width, screenH*per);
//    s.vertex(0, screenH*per);
//    s.endShape();

//    s.beginShape();
//    s.fill(c2);
//    s.vertex(0, screenH*per);
//    s.vertex(s.width, screenH*per);
//    s.fill(c3);
//    s.vertex(s.width, screenH);
//    s.vertex(0, screenH);
//    s.endShape();
//    s.popMatrix();
//  }

//  displayHouse(s, -1300);
//}

void displayMountains(PGraphics s, float y, int z) {
  int gradStarts = 450;
  s.pushMatrix();
  s.translate(-s.width*2, -s.height*2.5, z);
  s.noStroke();
  //s.rotateX(radians(90));
  //s.fill(0);
  //s.textureWrap(REPEAT);
  s.fill(255);
  s.textureMode(NORMAL);
  s.beginShape();
  s.texture(bkground);
  //s.fill(darkCementColor);
  s.vertex(-s.width, 0, 0, 0);
  s.vertex(s.width*6, 0, 1, 0);
  s.vertex(s.width*6, s.height*3, 1, .95);
  s.vertex(-s.width, s.height*3, 0, .95);
  s.vertex(-s.width, 0, 0, 0);
  s.endShape();
  s.popMatrix();
}

void displayCement(PGraphics s, float y, int z) {
  int gradStarts = 450;
  s.pushMatrix();
  s.translate(-s.width*2, y, z);
  s.noStroke();
  //s.rotateX(radians(90));
  //s.fill(0);
  //s.textureWrap(REPEAT);
  //s.textureMode(NORMAL);
  s.beginShape();
  //s.texture(cement);
  s.fill(darkCementColor);
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
  s.rect(-s.width, gradStarts, s.width*7, s.height*2);
  s.popMatrix();
}

Drop[] drops = new Drop[500]; // array of drop objects

void initDrops() {
  for (int i = 0; i < drops.length; i++) { // we create the drops 
    drops[i] = new Drop();
  }
}

void rain(PGraphics s) {
  for (int i = 0; i < drops.length; i++) {
    drops[i].fall(s); // sets the shape and speed of drop
    drops[i].show(s); // render drop
  }
}

class Drop {
  float x; // x postion of drop
  float y; // y position of drop
  float z; // z position of drop , determines whether the drop is far or near
  float len; // length of the drop
  float yspeed; // speed of te drop

  //near means closer to the screen , ie the higher the z value ,closer the drop is to the screen.
  Drop() {
    x  = random(width); // random x position ie width because anywhere along the width of screen
    y  = random(-500, -50); // random y position, negative values because drop first begins off screen to give a realistic effect
    z  = random(0, 20); // z value is to give a perspective view , farther and nearer drops effect
    len = map(z, 0, 20, 10, 20); // if z is near then  drop is longer
    yspeed  = map(z, 0, 20, 1, 20); // if z is near drop is faster
  }

  void fall(PGraphics s) { // function  to determine the speed and shape of the drop 
    y = y + yspeed; // increment y position to give the effect of falling 
    float grav = map(z, 0, 20, 0, 0.2); // if z is near then gravity on drop is more
    yspeed = yspeed + grav; // speed increases as gravity acts on the drop

    if (y > s.height) { // repositions the drop after it has 'disappeared' from screen
      y = random(-200, -100);
      yspeed = map(z, 0, 20, 4, 10);
    }
  }

  void show(PGraphics s) { // function to render the drop onto the screen
    float thick = map(z, 0, 20, 1, 3); //if z is near , drop is more thicker 
    s.strokeWeight(thick); // weight of the drop
    s.stroke(155); // purple color
    s.line(x, y, x, y+len); // draws the line with two points
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
    rain(s);
  }
}



void wind() {
  //float windForce = map(mouseX, 0, width, -PI/7, PI/7);
  float windForce = map(noise(0, flyingTerr), 0, 1, -PI/20, PI/20);
  //windAngle =  windForce + windForce/4 * 2*PI * sin(mouseX/1000.0);
  windAngle =  windForce + windForce/4 *sin(map(noise(0, flyingTerr), 0, 1, 0, width)/1000.0);
}
