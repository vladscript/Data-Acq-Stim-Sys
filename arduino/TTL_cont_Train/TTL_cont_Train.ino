#include <TimerOne.h>

//Variables

const int outPin = 10; // pulse
const int inPin = 3; // reads pulse

int values = 0; // pulse value: 0 (low) or 1 (high)

void setup() {
  Serial.begin(9600);
  pinMode(outPin, OUTPUT); 
  pinMode(inPin, INPUT); 
  Timer1.initialize(50000); // t=1/fs: time interval in us
  Timer1.pwm(outPin, 204,50000); //204-20% Duty Cycñe; Periodo:50us->20 Hz
}
void loop() {
  values=digitalRead(inPin);
  Serial.print(values);
  Serial.println();
}