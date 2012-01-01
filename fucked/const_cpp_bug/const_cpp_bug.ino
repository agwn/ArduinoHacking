/*
 Arduino preprocessor bug
 Crashes the build, repeatedly.
 
 This example code is in the public domain.
 */

typedef char fixed_t;

#define TEST_DEFS 0

#if TEST_DEFS
static const char* test[1] = {
  "test",
};
#endif

void setup() {
}

void loop() {
  delay(1000);              // wait for a second
}


