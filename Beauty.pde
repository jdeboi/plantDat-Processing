PlantFile[] beautyFiles;
float[] beautyScales = {0.78, 0.78, .95};
boolean[] beautyFlipped = {false, true, false};
float[] beautyRot = {-30, 0, -40};
PVector[] beautySnaps = {new PVector(108, 82), new PVector(3, 47), new PVector(76, 109)};


void initBeauty() {  
  beautyFiles = new PlantFile[3];
  for (int i = 0; i < beautyFiles.length; i++) {
    beautyFiles[i] = new PlantFile("beauty/leaves/" + i + ".svg", beautyFlipped[i], beautySnaps[i].x, beautySnaps[i].y, beautyScales[i], beautyRot[i]);
  }
}

class Beauty extends Plant {

  //ArrayList<BeautyLeaf> leaves;

   Beauty(PVector loc, float age) {
    super(loc, age);
    //leaves = new ArrayList<BeautyLeaf>();
    hasLeaves = true;
  }

  void display(PGraphics s) {
    //s.stroke(col);
    s.pushMatrix();
    s.translate(x, y, z);
    float angle = stemAngle + windAngle/3.0;
    angle = constrain(angle, -10, 10);
    s.rotate(angle);

    numBranch = 0;
    totLen = leafSpacing;
    currentLen = leafSpacing;

    stem(s, plantHeight*growthScaler, 0, age);
    //leaves(s);
    s.popMatrix();
  }

  void leaf(int segment, PGraphics s) {
    int numleaves = int(plantHeight*growthScaler/ leafSpacing);
    if (numBranch <= numleaves) {
      float leafScale = map(numBranch, 0, 5, .6, .2)*plantHeight;
      leafScale = constrain(leafScale, 0.1, 1.0);
      beautyFiles[1].display(0, 0, 0, leafScale, false, s);
      beautyFiles[1].display(0, 0, 0, leafScale, true, s);
      s.fill(255, 0, 255);
      float berrySize = leafScale*10;
      int berrySpacings[][] = {{0, 0}, {-10, 10}, {7, 8}, {-5, -10}, {4, -6}};
      for (int j = 0; j < berrySpacings.length; j++) {
        //PShape circ = createShape(ELLIPSE,berrySpacings[j][0]*leafScale, berrySpacings[j][1]*leafScale, berrySize, berrySize);
        //s.shape(circ);
        s.pushMatrix();
        s.translate(0, 0, 1);
        s.ellipse(berrySpacings[j][0]*leafScale, berrySpacings[j][1]*leafScale, berrySize, berrySize);
        s.popMatrix();
      }
    }
  }

  
}
