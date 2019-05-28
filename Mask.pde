Mask mask;
boolean useTestKeystone = true;
boolean editingMask = false;
MPoint selectedP = null;
boolean showMask = true;
int numPoints = 6;


class Mask {

  MPoint [] maskPoints;

  Mask() {
    maskPoints = new MPoint[numPoints];
    loadMask();
  }

  void saveMask() {
    processing.data.JSONObject json;
    json = new processing.data.JSONObject();
    processing.data.JSONArray maskList = new processing.data.JSONArray();      


    for (int i = 0; i < numPoints; i++) {
      processing.data.JSONObject maskJSON = new processing.data.JSONObject();
      maskJSON.setInt("x", maskPoints[i].x);
      maskJSON.setInt("y", maskPoints[i].y);

      maskList.setJSONObject(i, maskJSON);
    }

    json.setJSONArray("maskList", maskList);
    if (useTestKeystone) saveJSONObject(json, "data/mask/testEnv/maskPoints.json");
    else saveJSONObject(json, "data/mask/maskPoints.json");
  }

  void loadMask() {
    processing.data.JSONObject maskJson;
    if (useTestKeystone) maskJson = loadJSONObject("data/mask/testEnv/maskPoints.json");
    else maskJson = loadJSONObject("data/mask/maskPoints.json");

    processing.data.JSONArray maskArray = maskJson.getJSONArray("maskList");
    for (int i = 0; i < numPoints; i++) {
      processing.data.JSONObject m = maskArray.getJSONObject(i);
      int x = m.getInt("x");
      int y = m.getInt("y");
      maskPoints[i] = new MPoint(x, y);
    }
  }

  void move() {
    if (selectedP != null) {
      selectedP.move();
    }
  }

  void displayPoints() {
    int j = 0;
    for (MPoint mp : maskPoints) {
      mp.display();
      stroke(255);
      noFill();
      textSize(30);
      text(j++, mp.x, mp.y);
    }
  }

  void checkClick() {
    if (selectedP == null) {
      for (MPoint mp : maskPoints) {
        if (mp.mouseOver()) {
          selectedP = mp;
          return;
        }
      }
    } else selectedP = null;
  }

  void display(color c) {
    pushMatrix();
    translate(0, 0, -1);
    fill(c);
    noStroke();
    beginShape();
    vertex(0, maskPoints[0].y);
    for (int i = 0; i < 4; i++) {
      vertex(maskPoints[i].x, maskPoints[i].y);
    }
    vertex(maskPoints[3].x, height);
    vertex(width, height);
    vertex(width, 0);
    vertex(0, 0);
    vertex(0, height);
    vertex(maskPoints[5].x, height);
    vertex(maskPoints[5].x, maskPoints[5].y);
    vertex(maskPoints[0].x, maskPoints[0].y);
    endShape();
    popMatrix();
  }
}








//void snapMaskToOutline() {
//  maskPoints[0] = new MPoint(int(lines.get(0).p1.x)-5, int(lines.get(0).p1.y)-5); 
//  maskPoints[1] = new MPoint(int(lines.get(4).p1.x)-5, int(lines.get(4).p1.y)-5); 
//  maskPoints[2] = new MPoint(int(lines.get(8).p1.x)-5, int(lines.get(8).p1.y)-5); 
//  maskPoints[3] = new MPoint(int(lines.get(12).p1.x)-5, int(lines.get(12).p1.y)-5); 


//  maskPoints[4] = new MPoint(int(lines.get(12).p2.x)+5, int(lines.get(12).p2.y)-5); 
//  maskPoints[5] = new MPoint(int(lines.get(14).p1.x)+5, int(lines.get(14).p1.y)+5); 
//}


class MPoint {
  int x, y;

  MPoint(int x, int y) {
    this.x = x;
    this.y = y;
  }

  void display() {
    noFill();
    stroke(0, 255, 255);
    ellipse(x, y, 15, 15);
    fill(0, 255, 255);
    ellipse(x, y, 5, 5);
  }

  boolean mouseOver() {
    float d = dist(x, y, mouseX, mouseY);
    return d < 5;
  }

  void move() {
    x = mouseX;
    y = mouseY;
  }
}
