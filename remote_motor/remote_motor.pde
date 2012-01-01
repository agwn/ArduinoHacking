/*
  Remote Control a motor
 */

#include <Servo.h>

Servo myservo;

const int MINDELAY = 2;
const int MAXDELAY = 24;
const int ONTIME = 250;
const int OFFTIME = 250;

const int greenLed = 13;
const int redLed = 12;

int byteCnt = -1;
int ctrlBytes[8] = {
  0, 0, 0, 0, 0, 0, 0};  // incoming serial byte

int lastCmd = 0;

const int sweepRange = 180;
int delayTime = MAXDELAY;

int pos = 0;

void setup()
{
  // initialize the digital pins as an output.
  pinMode(greenLed, OUTPUT);  // green led
  pinMode(redLed, OUTPUT);    // red led

  myservo.attach(9);

  // start serial port at 19200 bps:
  Serial.begin(19200);
}


void loop()
{
  int inByte = 0x00;

  // if we get a valid byte, read the byte:
  if (Serial.available() > 0) {
    // read the incoming byte:
    inByte = Serial.read();

    // say what you got:
    if ((byteCnt < 0) && (inByte != 0xFF)) {
      // sync to signal to signal
      Serial.println(inByte, HEX);
    } 
    else {
      byteCnt++;
      if (byteCnt < 6) {
        ctrlBytes[byteCnt] = inByte;
        //Serial.print(inByte, HEX);
      } 
      else {
        int ctrlValue;

        ctrlBytes[byteCnt] = inByte;
        //Serial.println(inByte, HEX);

        ctrlValue = (ctrlBytes[5]<<8) | ctrlBytes[6];
        //Serial.println(ctrlValue);
        switch (ctrlValue) {
        case 0x01FA:
          Serial.println("Play/Pause.");
          if (lastCmd != ctrlValue) {
            if (digitalRead(redLed) || digitalRead(greenLed)) {
              digitalWrite(greenLed, LOW);   // set the Green LED off
              digitalWrite(redLed, LOW);     // set the Red LED off
            } 
            else {
              digitalWrite(greenLed, HIGH);  // set the Green LED on
              digitalWrite(redLed, HIGH);    // set the Red LED on
            }
            pos = sweepRange/2;
            myservo.write(pos);
            delay(MAXDELAY);
          }
          break;

        case 0x08F3:
          Serial.println("FastForward.");
          if (lastCmd != ctrlValue) {
            digitalWrite(redLed, HIGH);      // set the Red LED on
            for( ; pos>=1; pos-=1) {    // goes from 180 degrees to 0 degrees
              myservo.write(pos);
              delay(delayTime);
            }
          }
          break;

        case 0x10EB:
          Serial.println("Rewind.");
          if (lastCmd != ctrlValue) {
            for( ; pos < sweepRange; pos += 1) { // goes from 0 degrees to 180 degrees
              myservo.write(pos);
              delay(delayTime);
            }
            digitalWrite(redLed, LOW);      // set the Red LED off
          }
          break;

        case 0x02F9:
          Serial.println("VolumeUp.");
          if (lastCmd != ctrlValue) {
            delayTime > MINDELAY ? delayTime -= 2 : delayTime = MINDELAY;
            Serial.println(delayTime);
          }
          break;

        case 0x04F7:
          Serial.println("VolumeDown.");
          if (lastCmd != ctrlValue) {
            delayTime < MAXDELAY ? delayTime += 2 : delayTime = MAXDELAY;
            Serial.println(delayTime);
          }
          break;

        case 0x00FB:
          Serial.println("Release.");
          break;

        default:
          Serial.println("Unknown.");
          break;
        }

        lastCmd = ctrlValue;

        // do cleanup
        byteCnt = -1;
        for (int i=0; i<6; i++) {
          ctrlBytes[i] = 0;
        }
      }
    }
  }
}

