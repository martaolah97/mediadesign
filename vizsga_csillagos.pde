int numStars = 400;
float[][] stars;
ArrayList<float[]> placedStars = new ArrayList<float[]>();
float time = 0;

void setup() {
  size(1000, 1000);
  stars = new float[numStars][3];
  for (int i = 0; i < numStars; i++) {
    stars[i][0] = random(width); 
    stars[i][1] = random(height); 
    stars[i][2] = random(1, 3); 
  }
}

void draw() {
  drawGalaxyBackground();
  drawStars();
  drawConnections();
  time += 0.01;
}


void drawGalaxyBackground() {
  loadPixels();
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      float nx = map(x, 0, width, -2, 2);
      float ny = map(y, 0, height, -2, 2);
      float zOffset = sin(time * 0.5) * 0.5; 
      float noiseValue = noise(nx * cos(time) - (ny + zOffset) * sin(time),
                               (ny + zOffset) * cos(time) + nx * sin(time),
                               time * 0.2); 
      noiseValue = pow(noiseValue, 2.5) * 0.2; 
      color c = color(noiseValue * 255, noiseValue * 150 + 50, noiseValue * 100 + 100); 
      pixels[x + y * width] = c;
    }
  }
  updatePixels();
}

void drawStars() {
  noStroke();
  for (int i = 0; i < numStars; i++) {
    fill(255, stars[i][2] * 100);
    ellipse(stars[i][0], stars[i][1], stars[i][2], stars[i][2]);
  }
  for (float[] star : placedStars) {
    fill(255, 200);
    ellipse(star[0], star[1], 3, 3);
  }
}

void drawConnections() {
  stroke(255, 100); 
  strokeWeight(1);
  for (int i = 0; i < placedStars.size(); i++) {
    float closestDist = Float.MAX_VALUE;
    int closestIndex = -1;
    for (int j = 0; j < placedStars.size(); j++) {
      if (i != j) {
        float d = dist(placedStars.get(i)[0], placedStars.get(i)[1], placedStars.get(j)[0], placedStars.get(j)[1]);
        if (d < closestDist) {
          closestDist = d;
          closestIndex = j;
        }
      }
    }
    if (closestIndex != -1) {
      line(placedStars.get(i)[0], placedStars.get(i)[1], placedStars.get(closestIndex)[0], placedStars.get(closestIndex)[1]);
    }
  }
}

void mousePressed() {
  if (mouseButton == LEFT) {
    addStar(mouseX, mouseY);
  }
}

void addStar(float x, float y) {
  placedStars.add(new float[] {x, y});
}

void keyPressed() {
  if (key == 's' || key == 'S') {
    save("galaxy_image.png"); 
  }
}
