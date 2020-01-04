

class Barrel {
  float waterLevel;
  PImage barrel;
  color waterColor = color(27,125,95);

  Barrel() {
    barrel = loadImage("images/barrel.png");
    barrel.resize(barrel.width*2, barrel.height*2);
  }

  void display(float x, float y, float z, PGraphics s) {
    s.pushMatrix();
    s.translate(x, y, z);

    displayWaterFaucet(s);
    displayWaterLevel(s);

    //s.image(barrel, 0, 0);
    s.popMatrix();

    setWaterLevel();
  }

  void displayWaterFaucet(PGraphics s) {
    float h  = 0;
    float w = 8;
    float y = 415;
    float x = -40;
    if (rainMode == BARREL_RAIN) h = map(millis(), startRainMode, endRainMode, 0, 1600);
    else if (rainMode == DRYING_2) {
      h = 500;
      y += map(millis(), startRainMode, endRainMode, 0, 800);
    }

    s.strokeWeight(w);
    s.stroke(waterColor);
    s.strokeCap(ROUND);
    s.line(x, y, x, y+h);
  }

  void displayWaterLevel(PGraphics s) {
    s.pushMatrix();
    s.noStroke();
    s.fill(150);
    s.translate(barrel.width*.4, barrel.height*.2, 0);
    float w = barrel.width*.5;
    float h = barrel.height*.7;
    s.rect(0, 0, w, h);
    s.fill(waterColor);
    float waterH = map(waterLevel, 0, 1, 0, h);
    s.rect(0, h, w, -waterH);
    s.popMatrix();
  }

  void setWaterLevel() {
    if (isRaining) {
      //waterLevel += 0.001;
      //waterLevel = constrain(waterLevel, 0, 1);
      waterLevel = map(millis() - lastRainTime, 0, rainLasts, 0, 1);
    } else if (rainMode == BARREL_RAIN) {
      waterLevel = map(millis(), startRainMode, endRainMode, 1, 0);
    }
  }
}
