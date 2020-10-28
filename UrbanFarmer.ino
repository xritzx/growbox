#include<OneWire.h>
#include<DallasTemperature.h>

#include <FirebaseArduino.h>
#include <ESP8266WiFi.h>
#include <ArduinoJson.h>


#define ONE_WIRE_BUS D2
#define PELTIER_PIN D6
#define LED_PIN D7
#define AMBIENCE A0

#define WIFI_SSID "Shower when IP"
#define WIFI_PASSWORD "generic_password"
#define FIREBASE_HOST "urbanfarmer-22ea8.firebaseio.com"
#define FIREBASE_AUTH "RqMg5J2lvsZAH6c1iXQlPpWtLwwiH21F0RGKvkiw"

const String user = "xritzx";

OneWire oneWire(ONE_WIRE_BUS);
DallasTemperature sensors(&oneWire);

void setup(){
  pinMode(PELTIER_PIN, OUTPUT);
  pinMode(LED_PIN, OUTPUT);
  pinMode(AMBIENCE, INPUT);
  digitalWrite(PELTIER_PIN, HIGH);
  Serial.begin(9600);
  sensors.begin();

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting ");
  delay(1000);
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }
  Serial.print("\n Connected on ");
  Serial.println(WiFi.localIP());
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
  
  Serial.println("Firebase Connection Failed !");
  Serial.println(Firebase.failed());
  Serial.println(Firebase.error());
  delay(1000);
}

void setPeltier(float TEMP, float TARGET){
  float margin = 2.0;
  if(TEMP<TARGET){
    digitalWrite(PELTIER_PIN, HIGH);
  }
  else if(TEMP>=(TARGET+margin)){
    digitalWrite(PELTIER_PIN, LOW);
  }
}
void setLights(int dark, int getAuto){
  Serial.println(dark);
  if(getAuto == 2){
    int trigger = 600;
    if(dark<trigger)digitalWrite(LED_PIN, LOW); //ON
    else digitalWrite(LED_PIN, HIGH); //OFF
  }
  else if(getAuto == 1)digitalWrite(LED_PIN, LOW); //ON
  else digitalWrite(LED_PIN, HIGH); //OFF
}
void loop(){ 
  if(Firebase.failed()){
    Serial.println(Firebase.error());
    Serial.println("Firebase Connection Failed \n Restarting");
    delay(1000);
    ESP.reset();
  }
  sensors.requestTemperatures(); 
  float temp = sensors.getTempCByIndex(0);
  float target = Firebase.getFloat(user+"/target");
  Firebase.setFloat(user+"/temp", temp);
  // 1 => ON : 0 => OFF : 2 => AUTO
  int getLightAuto = Firebase.getFloat(user+"/autoLights");
  
  setPeltier(temp, target);
  Serial.println(temp);
  setLights(analogRead(AMBIENCE), getLightAuto);
  delay(2000);
}
