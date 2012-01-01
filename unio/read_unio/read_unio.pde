#include <UNIO.h>

//.............................................................................
//                            GLOBAL CONSTANTS
//.............................................................................
#define READLN     0x10        // size of flash
#define ADDR0      0x0000      // initialization of the address

#define MAXPINS    7
#define MINID      3
#define MAXID      9

int adr_cnt;                   // address counter
int ch_cnt;                    // character counter inside  strings
//char dst_str[READLN];          // destination string,read from the eep   

int greenLedPin = 13;
int scioPin = MINID;

UNIO f(MINID);

void setup(void) {
  Serial.begin(9600);
  Serial.println();
  
  Serial.println("Initalizing.");
  for(int i=MINID; i<MAXID; i++) {
    Serial.print("ConfigPin: ");
    Serial.println(i);
    digitalWrite(i, LOW);
    pinMode(i, OUTPUT);
  }

  pinMode(greenLedPin, OUTPUT);

  for(int i=MINID; i<MAXID; i++) {
    f.set_dev(i);
    digitalWrite(i, HIGH);
    delay(500);
    Serial.print("Init: ");
    Serial.println(i);
    f.ini_unio();
    digitalWrite(i, LOW);
  }

  Serial.println("Init done.");
  Serial.println();
}

void loop(void) {

  char c;
  
  Serial.print("Selecting: ");
  Serial.println(scioPin);
  f.set_dev(scioPin);
  
  // bias cap and wait for it to charge
  digitalWrite(scioPin, HIGH);
  delay(1000);

  //¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
  // READ EEPROM IN THE DESTINATION STRING
  // ............................................................................ 
  ch_cnt=0;
  adr_cnt=ADDR0; // init both counters: char & address
  while(ch_cnt < READLN) // repeat till the end of the string
  {
    f.rdbyte(adr_cnt,&c); // fill the destination string with chrs
    Serial.print(c,HEX);
    ch_cnt++;
    adr_cnt++;
  }
  Serial.println();

  //¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
  // COMPARE SOURCE & DESTINATION STRINGS
  //............................................................................     
//  Serial.print(" Read: ");
//  for(ch_cnt=0; ch_cnt<READLN; ch_cnt++)
//  {
//    Serial.print(dst_str[ch_cnt],HEX);
//  } // repeat till the end of the string
//  Serial.println(" #");
  
  Serial.println("UNIO read compleated.");

  scioPin++;
  if (scioPin >= MAXID) {
    scioPin = MINID;
  }
  delay(500);
}



