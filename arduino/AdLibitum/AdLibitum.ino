/////////////////////////////////////////////////////////////////SOLENOID & LICK PINS
String programmDescription = "Le da al agua al raton si lenguetea";
int rewPin = 4;     //  Pin de la valvula (solenoide)
int lickPin = 12;   // Lick input
int state= 0;       // incializa valvula cerrada
int ta = 2000;        // tiempo de apertura [ms]

//////////////////////////////////////////////////////////////SETUP
void setup()                   
{
  pinMode(rewPin, OUTPUT);  // Open vlave is 12V OUTPUT
  pinMode(lickPin, INPUT); // Optic lick port INPUT
  Serial.begin(9600);    // initialize serial for output to Processing sketch
  randomSeed(analogRead(3));
  // OT = millis();
}
//////////////////////////////////////////////////////////////LOOP
void loop(){
  state=digitalRead(lickPin);
  if(state==1) {
   openV();
   delay(ta);
   closeV();
   delay(ta);
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