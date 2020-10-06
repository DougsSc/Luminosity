#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
#include <WiFiClient.h>

const char* ssid = "";
const char* password = "";

const char* serverName = "http://177.44.248.9:9000/dados";

unsigned long lastTime = 0;
unsigned long timerDelay = 5000;

unsigned long luminosity;
unsigned long temperature;
unsigned long moisture;

void setup() {
  Serial.begin(115200);

  WiFi.begin(ssid, password);
  Serial.println("Connecting");
  while(WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.print("Connected to WiFi with IP Address: ");
  Serial.println(WiFi.localIP());
 
  Serial.println("Waiting...");
}

void loop() {
  if ((millis() - lastTime) > timerDelay) {
    if(WiFi.status()== WL_CONNECTED){
      HTTPClient http;
      
      http.begin(serverName);

      luminosity = random(0, 99);
      temperature = random(0, 50);
      moisture = random(0, 99);
      
      http.addHeader("Content-Type", "application/json");
      String json = "{\"luminosity\":"+(String)luminosity+",\"temperature\":"+(String)luminosity+",\"moisture\":"+(String)moisture+"}";
      int httpResponseCode = http.POST(json);
     
      Serial.print("HTTP Response code: ");
      Serial.println(httpResponseCode);
      
      http.end();
    } else {
      Serial.println("WiFi Disconnected");
    }
    lastTime = millis();
  }
}
