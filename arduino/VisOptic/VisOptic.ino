String programName = "Go_No-Go_Mice.pde";
String notes = "written for new Go/No-Go task, for interaction with MATLAB Psychophysics Toolbox";
// "change lines 7 for 10, 47 and 8 = 1, and in 154 erase '+1' to make it GNG task";

/////////////////////////////////////////////////////////////////STIMULUS-RESPONSE VARIABLES
int choiceDur = 0; // Response time after stimulus ends       ****change accordingly****

/////////////////////////////////////////////////////////////////SOLENOID & LICK PINS
const int outputPin = 7; // LED MOD

int freeWater=1;
int state= 0;
int stateFreeWater=01;


/////////////////////////////////////////////////////////////////TIMERS

unsigned long trialTime = 0;
int oneLickTime=0;
int eachLick=0;
int lickSample=60;
unsigned long endTime = 0;
unsigned long startTime = 0;  // initialize times of trial start
String matlabData;
int md;
int period;
////////////////////////////////////////////////////////////LICK DETECTION

//////////////////////////////////////////////////////////////SETUP/////////////////////////////////////////////////////////////
void setup()                   
{
  //pinMode(ledPin, OUTPUT);      // sets the digital pin as LED output
  pinMode(outputPin, OUTPUT);
  Serial.begin(9600);    // initialize serial for output to Processing sketch
  randomSeed(analogRead(3));
}


//////////////////////////////////////////////////////////////LOOP/////////////////////////////////////////////////////////////
void loop(){
  // look for serial input from MATLAB/PsychToolbox
//  stateFreeWater=digitalRead(lickPin);
//  if (stateFreeWater==1) {
//    digitalWrite(rewPin1, HIGH);    // open solenoid valve for a short time
//    delay(15);                  // 8ms ~= 8uL of reward liquid (on box #4 011811)
//    digitalWrite(rewPin1, LOW);
//    delay(200);
//  }
  if(Serial.available()>0) {
    matlabData = Serial.read(); // read data
    md=matlabData.toInt();
    startTime = millis();
    
//    period=1;  
    if (md > 0){
      period=2;  /*...................//CHANGE TO 1 WHEN RESPONSE DETECTION GOES DURING VIS STIM!!!!............*/
      }
///////////////////////////////////////////////////////////////////////////////////////////BUFFER PERIOD

    trialTime=millis();
/////////////////////////////////////////////////////////////////////////////////////////////RESPONSE PERIOD
    if (period==2){// Enters the response period
    
      //trialTime=millis();
      while (millis()-trialTime <= choiceDur) { //WHILE loop counts licks during the buffer period
            
        }//END COUNTING LICKINGS
        ////////Happens if the mouse licks during response period
        if (md==1){  
          reward();
          //restart();//period=0;
        }
    }
    
    
    matlabData='0';
    md=0;
    period=0;
    
    Serial.println('1');
}/// end if(Serial.available)
} //END LOOP

/////////////////////////////////////////////////////////////////////////////////////////////REWARD FUNCTION
void reward() {
    Serial.println('6');
    digitalWrite(outputPin, HIGH);
    delay(500);
    digitalWrite(outputPin, LOW);
    delay(500);
    digitalWrite(outputPin, HIGH);
    delay(500);
    digitalWrite(outputPin, LOW);
    delay(500);
}
///////////////////////////////////////////////////////////////////////////////////////////// 