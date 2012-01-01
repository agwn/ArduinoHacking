#include <UNIO.h>

//.............................................................................
//                            GLOBAL CONSTANTS
//.............................................................................
#define  STRSZ   0x1A          // size of string = 26 bytes

#define  ADDR0  0x0000         // initialization of the address
#define  RND_MODE   0          // random byte access mode
#define  PG_MODE    1          // page access mode

int access_mode = RND_MODE;    // set the access mode to RAND
//int access_mode =  PG_MODE;  // set the access mode to PAGE 
int adr_cnt;                   // address counter
char ch_cnt;                   // character counter inside  strings
char src_str[STRSZ];
char dst_str[STRSZ];           // destination string,read from the eep   
char fillChar;

int greenLedPin = 13;
int redLedPin = 12;
int scioPin = 2;


UNIO f(scioPin);

void setup(void) {
  pinMode(greenLedPin, OUTPUT);
  pinMode(redLedPin, OUTPUT);
  digitalWrite(scioPin, LOW);
  pinMode(scioPin, OUTPUT);
  Serial.begin(9600);
  f.ini_unio();
}

void loop(void) {

  digitalWrite(scioPin, HIGH);
  delay(500);

//  fillChar = 'A';
//  for (int i=0; i<STRSZ; i++)
//  {
//    src_str[i] = fillChar++;
//  }
//  
//  Serial.print("Write: ");
//  for(ch_cnt=0; ch_cnt<STRSZ; ch_cnt++)
//  {  
//    Serial.print(src_str[ch_cnt]);
//  }
//  Serial.println(" #");
//
//  //¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
//  // WRITE SOURCE STRING IN EEPROM
//  //............................................................................
//  if(RND_MODE==access_mode) // if RANDOM MODE
//  {
//    ch_cnt=0;
//    adr_cnt=ADDR0; // initialize char & address counters
//    while(ch_cnt<STRSZ) // repeat till the end of the string
//    {
//      f.wrbyte(adr_cnt,src_str[ch_cnt]); // write a random byte
//      ch_cnt++;
//      adr_cnt++;
//    }
//  }  // increment both counters
//  else // if PAGE MODE
//  {
//    f.wrstr(src_str,ADDR0,STRSZ);
//  } // write (page mode) from the source
//  // string, beginning from ADDR0 address
//  // length of the string = STRSZ


  //¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
  // READ EEPROM IN THE DESTINATION STRING
  // ............................................................................ 
  if(RND_MODE==access_mode) // in RANDOM MODE
  {
    ch_cnt=0;
    adr_cnt=ADDR0; // init both counters: char & address
    while(ch_cnt < STRSZ) // repeat till the end of the string
    {
      f.rdbyte(adr_cnt,dst_str+ch_cnt); // fill the destination string with chrs
      ch_cnt++;
      adr_cnt++;
    }
  } // increment both counters (chr&address)
  else
  {
    f.rdstr(dst_str,ADDR0,STRSZ);
  } // in PAGE MODE, sequential read

  //¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
  // COMPARE SOURCE & DESTINATION STRINGS
  //............................................................................     
  Serial.print(" Read: ");
  for(ch_cnt=0; ch_cnt<STRSZ; ch_cnt++)
  {
    Serial.print(dst_str[ch_cnt],HEX);
  } // repeat till the end of the string
  Serial.println(" #");

//  for(ch_cnt=0; ch_cnt<STRSZ; ch_cnt++)
//  {
//    if((*(dst_str+ch_cnt)) != (*(src_str+ch_cnt))) // compare the 2 strings(source & dest)
//    {
//      while(1) // in case of mismatch
//      {
//        digitalWrite(redLedPin, HIGH);  // set the LED on
//        delay(1000);                    // wait for a second
//        digitalWrite(redLedPin, LOW);   // set the LED off
//        delay(1000);                    // wait for a second
//      }
//    }
//    else
//    {
//      Serial.print(dst_str[ch_cnt]);
//      digitalWrite(greenLedPin, HIGH);   // sets the LED on
//      delay(15);                        // waits for a second
//      digitalWrite(greenLedPin, LOW);    // sets the LED off
//      delay(15);                        // waits for a second
//    }
//  } // repeat till the end of the string
//  Serial.println(" #");

  Serial.println("UNIO read compleated.");
  Serial.println();
  delay(500);
}


