
// Original source code: https://wiki.keyestudio.com/KS0429_keyestudio_TDS_Meter_V1.0#Test_Code
// Project details: https://RandomNerdTutorials.com/arduino-tds-water-quality-sensor/

#include <Arduino.h>
#include <SPFD5408_Adafruit_GFX.h>    // Core graphics library
#include <SPFD5408_Adafruit_TFTLCD.h> // Hardware-specific library
#include <SPFD5408_TouchScreen.h>     // Touch library
//#include <EEPROM.h>
#include "GravityTDS.h"


#define Rled 43


//These are the pins for the shield!
#define YP A1 
#define XM A2 
#define YM 7  
#define XP 6 
// Buttons
#define BUTTONS 3
#define BUTTON_CLEAR 0
#define BUTTON_SHOW 1
#define BUTTON_RESET 2
// LCD Pin
#define LCD_CS A3
#define LCD_CD A2
#define LCD_WR A1
#define LCD_RD A0
#define LCD_RESET A4 // Optional : otherwise connect to Arduino's reset pin


#define turbidityPin A10
#define TdsSensorPin A15
#define SensorPin A12
#define DO_PIN A13
 // connect ir sensor module to Arduino pin 41
int LED = 30;
int trigPin = 37;    // TRIG pin
int echoPin = 36;

byte statusLed    = 7;
byte sensorInterrupt = 0;  // 0 = digital pin 2
byte sensorPin= 50;

#define VREF 5.0              // analog reference voltage(Volt) of the ADC
#define SCOUNT  30    // ECHO pin
float duration_us, distance_cm;
#define VREF 5000    //VREF (mv)
#define ADC_RES 1024 //ADC Resolution
//Single-point calibration Mode=0
//Two-point calibration Mode=1
#define TWO_POINT_CALIBRATION 0
#define READ_TEMP (25) //Current water temperature ℃, Or temperature sensor function
//Single point calibration needs to be filled CAL1_V and CAL1_T
#define CAL1_V (131) //mv
#define CAL1_T (25)   //℃
//Two-point calibration needs to be filled CAL2_V and CAL2_T
//CAL1 High temperature point, CAL2 Low temperature point
#define CAL2_V (1300) //mv
#define CAL2_T (15)   //℃
 
const uint16_t DO_Table[41] = {
    14460, 14220, 13820, 13440, 13090, 12740, 12420, 12110, 11810, 11530,
    11260, 11010, 10770, 10530, 10300, 10080, 9860, 9660, 9460, 9270,
    9080, 8900, 8730, 8570, 8410, 8250, 8110, 7960, 7820, 7690,
    7560, 7430, 7300, 7180, 7070, 6950, 6840, 6730, 6630, 6530, 6410};
 
uint8_t Temperaturet;
uint16_t ADC_Raw;
uint16_t ADC_Voltage;
uint16_t DO;
 
int16_t readDO(uint32_t voltage_mv, uint8_t temperature_c)
{
#if TWO_POINT_CALIBRATION == 00
  uint16_t V_saturation = (uint32_t)CAL1_V + (uint32_t)35 * temperature_c - (uint32_t)CAL1_T * 35;
  return (voltage_mv * DO_Table[temperature_c] / V_saturation);
#else
  uint16_t V_saturation = (int16_t)((int8_t)temperature_c - CAL2_T) * ((uint16_t)CAL1_V - CAL2_V) / ((uint8_t)CAL1_T - CAL2_T) + CAL2_V;
  return (voltage_mv * DO_Table[temperature_c] / V_saturation);
#endif
}
 

// the pH meter Analog output is connected with the Arduino’s Analog
unsigned long int avgValue;  //Store the average value of the sensor feedback
float b;
int buf[10],temp;
// sum of sample point

// The hall-effect flow sensor outputs approximately 4.5 pulses per second per
// litre/minute of flow.
float calibrationFactor = 4.5;
volatile byte pulseCount;  
float flowRate;
unsigned int flowMilliLitres;
unsigned long totalMilliLitres;
unsigned long oldTime;

int analogBuffer[SCOUNT];     // store the analog value in the array, read from ADC
int analogBufferTemp[SCOUNT];
int analogBufferIndex = 0;
int copyIndex = 0;

float averageVoltage = 0;
float tdsValue = 0;
float temperature = 16;       // current temperature for compensation

// median filtering algorithm
int getMedianNum(int bArray[], int iFilterLen){
  int bTab[iFilterLen];
  for (byte i = 0; i<iFilterLen; i++)
  bTab[i] = bArray[i];
  int i, j, bTemp;
  for (j = 0; j < iFilterLen - 1; j++) {
    for (i = 0; i < iFilterLen - j - 1; i++) {
      if (bTab[i] > bTab[i + 1]) {
        bTemp = bTab[i];
        bTab[i] = bTab[i + 1];
        bTab[i + 1] = bTemp;
      }
    }
  }
  if ((iFilterLen & 1) > 0){
    bTemp = bTab[(iFilterLen - 1) / 2];
  }
  else {
    bTemp = (bTab[iFilterLen / 2] + bTab[iFilterLen / 2 - 1]) / 2;
  }
  return bTemp;
}


// LCD Display Stuff


// Calibrates value
#define SENSIBILITY 300
#define MINPRESSURE 10
#define MAXPRESSURE 1000

/*
//Macros replaced by variables
#define TS_MINX 150
#define TS_MINY 120
#define TS_MAXX 920
#define TS_MAXY 940
*/
short TS_MINX=150;
short TS_MINY=120;
short TS_MAXX=920;
short TS_MAXY=940;

// Init TouchScreen:

TouchScreen ts = TouchScreen(XP, YP, XM, YM, SENSIBILITY);

// Assign human-readable names to some common 16-bit color values:
#define BLACK   0x0000
#define BLUE    0x001F
#define RED     0xF800
#define GREEN   0x07E0
#define CYAN    0x07FF
#define MAGENTA 0xF81F
#define YELLOW  0xFFE0
#define WHITE   0xFFFF

// Init LCD

Adafruit_TFTLCD tft(LCD_CS, LCD_CD, LCD_WR, LCD_RD, LCD_RESET);

// Dimensions

uint16_t width = 0;
uint16_t height = 0;
uint8_t border = 10;



Adafruit_GFX_Button buttons[BUTTONS];

uint16_t buttons_y = 0;


void setup(){
  Serial.begin(115200);
  tft.reset();
  tft.begin(0x9341);
  tft.setRotation(45); // Need for the Mega, please changed for your choice or rotation initial
  width = tft.width() - 1;
  height = tft.height() - 1;
  drawBorder();
  // Initial screen
  tft.setCursor (30, 50);
  tft.setTextSize (3);
  tft.setTextColor(BLACK);
  tft.println("Water");
  tft.setCursor (30, 85);
  tft.println("Treatment");
  tft.setCursor (30, 150);
  tft.println("System");
  tft.setCursor (30, 180);
  tft.setTextSize (2);
  tft.println("Fetching info ");
  tft.setTextSize (2);
   pinMode(TdsSensorPin,INPUT);
   pinMode(4,OUTPUT);
  
   pinMode(LED, OUTPUT); 

   pinMode(trigPin, OUTPUT);
  // configure the echo pin to input mode
  pinMode(echoPin, INPUT);
  pinMode(Rled, OUTPUT);
  pinMode(statusLed, OUTPUT);
   digitalWrite(statusLed, HIGH);  // We have an active-low LED attached
   pinMode(sensorPin, INPUT);
   digitalWrite(sensorPin, HIGH);

   /*GravityTds.setPin(TdsSensorPin);
    GravityTds.setAref(5.0);  //reference voltage on ADC, default 5.0V on Arduino UNO
    GravityTds.setAdcRange(1024);*/
   pulseCount        = 0;
   flowRate          = 0.0;
   flowMilliLitres   = 0;
   totalMilliLitres  = 0;
   oldTime           = 0;
  // // The Hall-effect sensor is connected to pin 2 which uses interrupt 0.
  // // Configured to trigger on a FALLING state change (transition from HIGH
  // state to LOW state)
   attachInterrupt(sensorInterrupt, pulseCounter, FALLING);

  
}

void loop(){
  static unsigned long analogSampleTimepoint = millis();
  if(millis()-analogSampleTimepoint > 40U){     //every 40 milliseconds,read the analog value from the ADC
    analogSampleTimepoint = millis();
    analogBuffer[analogBufferIndex] = analogRead(TdsSensorPin);    //read the analog value and store into the buffer
    analogBufferIndex++;
    if(analogBufferIndex == SCOUNT){ 
      analogBufferIndex = 0;
    }
  }   
  
  static unsigned long printTimepoint = millis();
  if(millis()-printTimepoint > 800U){
    printTimepoint = millis();
    for(copyIndex=0; copyIndex<SCOUNT; copyIndex++){
      analogBufferTemp[copyIndex] = analogBuffer[copyIndex];
    
      // read the analog value more stable by the median filtering algorithm, and convert to voltage value
      averageVoltage = getMedianNum(analogBufferTemp,SCOUNT) * (float)VREF / 1024.0;
      
      //temperature compensation formula: fFinalResult(25^C) = fFinalResult(current)/(1.0+0.02*(fTP-25.0)); 
      float compensationCoefficient = 1.0+0.02*(temperature-25.0);
      //temperature compensation
      float compensationVoltage=averageVoltage/compensationCoefficient;
      
      //convert voltage value to tds value
      tdsValue=((133.42*compensationVoltage*compensationVoltage*compensationVoltage - 255.86*compensationVoltage*compensationVoltage + 857.39*compensationVoltage)*0.5)/10000*1000;
      
      //Serial.print("voltage:");
      //Serial.print(averageVoltage,2);
      //Serial.print("V   ");
      // Serial.print("TDS Value:");
      // Serial.print(tdsValue,0);
      // Serial.println("ppm");
    }
  }
  
for(int i=0;i<10;i++)       //Get 10 sample value from the sensor for smooth the value
  {
    buf[i]=analogRead(SensorPin);
    delay(10);
  }
  for(int i=0;i<9;i++)        //sort the analog from small to large
  {
    for(int j=i+1;j<10;j++)
    {
      if(buf[i]>buf[j])
      {
        temp=buf[i];
        buf[i]=buf[j];
        buf[j]=temp;
      }
    }
  }
  avgValue=0;
  for(int i=2;i<8;i++)                      //take the average value of 6 center sample
    avgValue+=buf[i];
  float phValue=(float)avgValue*5.0/1024/6; //convert the analog into millivolt
  phValue=3.5*phValue;                      //convert the millivolt into pH value
  
  digitalWrite(4, HIGH);       
  delay(800);
  digitalWrite(4, LOW);

  if((millis() - oldTime) > 1000)    // Only process counters once per second
  { 
    // Disable the interrupt while calculating flow rate and sending the value to
    // the host
    detachInterrupt(sensorInterrupt); 
   
    flowRate = ((1000.0 / (millis() - oldTime)) * pulseCount) / calibrationFactor;
   
    oldTime = millis();
    // Divide the flow rate in litres/minute by 60 to determine how many litres have
    // passed through the seor in this 1 second interval, then multiply by 1000 to
    // convert to millilitres.
    flowMilliLitres = (flowRate / 60) * 1000;
    
    // Add the millilitres passed in this second to the cumulative total
    totalMilliLitres += flowMilliLitres;
      
    unsigned int frac;
   
    // Reset the pulse counter so we can start incrementing again
    pulseCount = 0;
    // Enable the interrupt again now that we've finished sending output
    attachInterrupt(sensorInterrupt, pulseCounter, FALLING);
  }
  int volte = analogRead(turbidityPin); // Read the analog value from the sensor
 float turbidityValue = volte * (5.0 / 1024.0);
  // Serial.print("Turbidity: ");
  // Serial.println(turbidityValue); // Print the turbidity value to the serial monitor
  //delay(1000);

 
  
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  // measure duration of pulse from ECHO pin
  duration_us = pulseIn(echoPin, HIGH);
  // calculate the distance
  distance_cm = 0.017 * duration_us;
 

Temperaturet = (uint8_t)READ_TEMP;
  ADC_Raw = analogRead(DO_PIN);
  ADC_Voltage = uint32_t(VREF) * ADC_Raw / ADC_RES;
 
 
 
  String jsonString = "{\"DO\":" + String(totalMilliLitres/1000) +
                      ",\"TDS\":" + String(tdsValue) + // Include two decimal places for TDS
                      ",\"Turb\":" + String(turbidityValue) + // Include one decimal place for Turb
                      ",\"depth\":" + String(distance_cm) +
                      ",\"flow\":" + String(flowMilliLitres) +
                      ",\"ph\":" + String(phValue) + ",\"working\":true}";
  Serial.println(jsonString);
  drawBorder();
  parseAndDisplay(jsonString);
  // Add a delay to make it readable in the Serial monitor
if(turbidityValue<=4.9){
//digitalWrite(Gled,HIGH);
digitalWrite(Rled,LOW);
}
else{
//digitalWrite(Gled,LOW);
digitalWrite(Rled,HIGH);
}
  delay(2000);                    
  
}

void parseAndDisplay(String jsonString) {
  // You can use a JSON library for a more robust solution,
  // but for simplicity, we'll use string manipulation here.
  int colonIndex, commaIndex;
  String key, valueStr;
  float value;

  tft.setCursor(30, 0);

  // Start parsing from the first character after the opening curly brace
  int index = 1;

  while (true) {
    // Find the colon and comma indices
    colonIndex = jsonString.indexOf(':', index);
    commaIndex = jsonString.indexOf(',', colonIndex);

    // If no more key-value pairs, exit the loop
    if (colonIndex == -1 || commaIndex == -1) {
      break;
    } 

    // Extract key and value strings
    key = jsonString.substring(index + 1, colonIndex - 1);
    valueStr = jsonString.substring(colonIndex + 1, commaIndex);

    // Convert value string to float
    value = valueStr.toFloat();

    // Display on TFT
    tft.setCursor(30, tft.getCursorY() + 26);
    tft.print(key + " : ");
    tft.print(value);

    // Move to the next key-value pair
    index = commaIndex + 1;
  }

  // Delay for visibility, adjust as needed
}

void drawBorder () {

  uint16_t width = tft.width() - 1;
  uint16_t height = tft.height() - 1;
  uint8_t border = 10;

  tft.fillScreen(CYAN);
  tft.fillRect(border, border, (width - border * 2), (height - border * 2), WHITE);
  
}

void pulseCounter()
{
  pulseCount++;
}
