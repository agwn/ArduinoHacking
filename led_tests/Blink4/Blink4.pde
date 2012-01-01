/*
  Blink
  Turns on an LED on for one second, then off for one second, repeatedly.
 
  This example code is in the public domain.
 */

#define MAXBLINK  500
#define MINBLINK  50
#define BLINKSTEP 50

int ledPin = 13;

int blinkTime = MAXBLINK;

void setup() {                
  // initialize the digital pin as an output.
  pinMode(ledPin, OUTPUT);     
}

void loop() {
  blinkTime>MINBLINK ? blinkTime -= BLINKSTEP : blinkTime = MAXBLINK; 
  digitalWrite(ledPin, LOW);    // set the LED off
  delay(blinkTime);             // wait for a second
  digitalWrite(ledPin, HIGH);   // set the LED on
  delay(blinkTime);             // wait for a second
}
