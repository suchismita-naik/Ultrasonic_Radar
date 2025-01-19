#include <Servo.h>
Servo shr;
int trigpin = 7;
int echopin = 8;
float dist;

void setup() {
  Serial.begin(9600);
  shr.attach(12);
  pinMode(trigpin, OUTPUT);
  pinMode(echopin, INPUT);
}

float calculatedist() {
  digitalWrite(trigpin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigpin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigpin, LOW);

  long time = pulseIn(echopin, HIGH);
  dist = time * 0.0343 / 2;

  if (dist < 2 || dist > 400) {
    dist = 400;
  }
  return dist;
}

void loop() {
  for (int i = 0; i <= 180; i++) {
    shr.write(i);
    delay(70);
    dist = calculatedist();
    Serial.print(i);
    Serial.print(",");
    Serial.print(dist);
    Serial.println(".");
  }

  for (int i = 180; i >= 0; i--) {
    shr.write(i);
    delay(70);
    dist = calculatedist();
    Serial.print(i);
    Serial.print(",");
    Serial.print(dist);
    Serial.println(".");
  }
}

