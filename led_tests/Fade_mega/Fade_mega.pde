/*
 Fade
 
 This example shows how to fade an LED on pin 11
 using the analogWrite() function.
 
 This example code is in the public domain.
 
 */
int brightness = 0;    // how bright the LED is
int fadeAmount = 5;    // how many points to fade the LED by

void setup() {
  // declare pin 11 to be an output:
  pinMode(5, OUTPUT);
  pinMode(13, OUTPUT);
}

void loop() {
  digitalWrite(13,digitalRead(13)^1);
  
  // set the brightness of pin 11:
  analogWrite(5, brightness);

  // change the brightness for next time through the loop:
  brightness = brightness + fadeAmount;

  // reverse the direction of the fading at the ends of the fade:
  if (brightness == 0 || brightness == 255) {
    fadeAmount = -fadeAmount;
  }
  // wait for 30 milliseconds to see the dimming effect
  delay(30);
}
