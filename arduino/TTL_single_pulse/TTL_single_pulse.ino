String Command;
const int outputPin = 10;
int sensorValue = 3;


void setup() {
  // put your setup code here, to run once:
  pinMode(outputPin, OUTPUT);
  Serial.begin(9600);
  Serial.println("<Enter X to send pulse");
}

void loop() {
  // sensorValue = analogRead(analogInPin);
  // float voltage= sensorValue * (5.0 / 1023.0);
  // Serial.print("V: ");
  if(Serial.available()>0){
    Command=Serial.readStringUntil('\n');
    Command.trim();
    Serial.println(Command);
    if (Command.equals("X")){
      Serial.println("pulse");
      //For ---
      delay(250);
      digitalWrite(outputPin, HIGH);
      // sensorValue = analogRead(analogInPin);
      // Serial.println(sensorValue);
      delay(1250);
      // sensorValue = analogRead(analogInPin);
      // Serial.println(sensorValue);
      digitalWrite(outputPin, LOW);
      delay(5000);
      // sensorValue = analogRead(analogInPin);
      // Serial.println(sensorValue);
      // delay(500);
      // sensorValue = analogRead(analogInPin);
      // Serial.println(sensorValue);
      // Serial.println('666');
      // matlabinst=0;
    }
  }
}
