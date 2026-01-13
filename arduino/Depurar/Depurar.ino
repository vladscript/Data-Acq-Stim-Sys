/////////////////////////////////////////////////////////////////SOLENOID & LICK PINS
int rewPin = 4;     //  Valve output
int lickPin = 12;   // Lick input
int state= 1;       // initialize state as closed
//////////////////////////////////////////////////////////////SETUP
void setup()                   
{
  pinMode(rewPin, OUTPUT);  // Open vlave is 12V OUTPUT
  pinMode(lickPin, INPUT); // Optic lick port INPUT
  Serial.begin(9600);    // initialize serial for output to Processing sketch
  randomSeed(analogRead(3));
}
//////////////////////////////////////////////////////////////LOOP
void loop(){
  state=digitalRead(lickPin);
  if(state==1) {
   openV();     
    }
    else{closeV();}
    }

///////////////////////////////////////////////////////////FUNCTIONS
void openV() {
    digitalWrite(rewPin, HIGH);    // open solenoid while state=1
}
void closeV() {
    digitalWrite(rewPin, LOW); // close solenoid while state=0
}