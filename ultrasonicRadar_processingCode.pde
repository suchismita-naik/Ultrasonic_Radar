import processing.serial.*;

Serial myPort;
String data = "";
int iAngle = 0, iDistance = 0;
float pixsDistance;

void setup() {
  size(1366, 768);
  smooth();
  myPort = new Serial(this, "COM5", 9600); 
  myPort.bufferUntil('.'); 
}

void draw() {
  background(0);
  drawRadar();
  drawLine();
  drawObjectAsCircle();
  drawText();
}

void serialEvent(Serial myPort) {
  data = myPort.readStringUntil('.');
  if (data != null) {
    data = data.trim(); 
    String[] splitData = data.split(",");
    if (splitData.length == 2) {
      try {
        iAngle = constrain(int(splitData[0].trim()), 0, 180); 
        iDistance = constrain(int(splitData[1].trim()), 0, 400);
      } catch (NumberFormatException e) {
        println("Invalid data: " + data);
      }
    } else {
      println("Malformed data: " + data);
    }
  }
}

void drawRadar() {
  pushMatrix();
  translate(width / 2, height - height * 0.074);
  noFill();
  strokeWeight(2);
  stroke(98, 245, 31);

  float[] arcSizes = {
    (width - width * 0.0625),
    (width - width * 0.27),
    (width - width * 0.479),
    (width - width * 0.687)
  };
  for (float size : arcSizes) {
    arc(0, 0, size, size, PI, TWO_PI);
  }

  for (int angle = 0; angle <= 180; angle += 30) {
    float x = -width / 2 * cos(radians(angle));
    float y = -width / 2 * sin(radians(angle));
    line(0, 0, x, y);
  }
  popMatrix();
}

void drawObjectAsCircle() {
  if (iDistance < 40) {
    pushMatrix();
    translate(width / 2, height - height * 0.074);
    noStroke();
    fill(255, 10, 10);
    pixsDistance = iDistance * ((height - height * 0.1666) * 0.025);
    float x = pixsDistance * cos(radians(iAngle));
    float y = -pixsDistance * sin(radians(iAngle));
    ellipse(x, y, 15, 15); 
    popMatrix();
  }
}

void drawLine() {
  pushMatrix();
  strokeWeight(9);
  stroke(30, 250, 60);
  translate(width / 2, height - height * 0.074);
  float x = (height - height * 0.12) * cos(radians(iAngle));
  float y = -(height - height * 0.12) * sin(radians(iAngle));
  line(0, 0, x, y);
  popMatrix();
}

void drawText() {
  pushMatrix();
  fill(0);
  noStroke();
  rect(0, height - height * 0.0648, width, height * 0.0648);

  fill(98, 245, 31);
  textSize(40);
  text("Angle: " + iAngle + "°", 50, height - height * 0.02);
  text("Distance: " + (iDistance < 40 ? iDistance + " cm" : "Out of Range"), 350, height - height * 0.02);

  textSize(25);
  String[] ranges = {"10cm", "20cm", "30cm", "40cm"};
  for (int i = 0; i < ranges.length; i++) {
    text(ranges[i], width * (0.3854 - i * 0.104), height - height * 0.0833);
  }

  float[] angles = {30, 60, 90, 120, 150};
  for (float angle : angles) {
    float x = width / 2 + width / 2 * cos(radians(angle));
    float y = height - height * 0.074 - width / 2 * sin(radians(angle));
    drawAngleText(x, y, angle);
  }
  popMatrix();
}

void drawAngleText(float x, float y, float angle) {
  pushMatrix();
  translate(x, y);
  rotate(-radians(angle - 90));
  textSize(25);
  fill(98, 245, 60);
  text((int) angle + "°", 0, 0);
  popMatrix();
}
