#include <FS.h>                   //this needs to be first, or it all crashes and burns...

#include <ESP8266WiFi.h>          //https://github.com/esp8266/Arduino
#include <ESP8266HTTPClient.h>

#include <DNSServer.h>
#include <ESP8266WebServer.h>
#include <WiFiManager.h>          //https://github.com/tzapu/WiFiManager

WiFiManager wifiManager;

const char* endpoint = "http://177.44.248.9:9000/dados";

unsigned long lastTime = 0;
unsigned long timerDelay = 10000;

unsigned long luminosity;
unsigned long temperature;
unsigned long moisture;

void setup() {
  pinMode(0, INPUT_PULLUP);
  wifiConnect();
}

void wifiConnect() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  Serial.println();

  //wifiManager.resetSettings();

  // exit after config instead of connecting
  wifiManager.setBreakAfterConfig(true);

  // set Wifi ID and password
  if (!wifiManager.autoConnect("APPID")) {
    Serial.println("failed to connect, we should reset as see if it connects");
    delay(3000);
    ESP.reset();
    delay(5000);
  }

  Serial.println("local ip");
  Serial.println(WiFi.localIP());
}

void loop() {
  if (digitalRead(0) == LOW) {
    // Reset settings
    Serial.println("Reseted");
    wifiManager.resetSettings();
    wifiConnect();
  }
  
  if ((millis() - lastTime) > timerDelay) {
    if(WiFi.status()== WL_CONNECTED){
      HTTPClient http;
      
      http.begin(endpoint);

      luminosity = random(0, 99);
      temperature = random(0, 50);
      moisture = random(0, 99);
      
      http.addHeader("Content-Type", "application/json");
      String json = "{\"luminosity\":"+(String)luminosity+",\"temperature\":"+(String)luminosity+",\"moisture\":"+(String)moisture+"}";
      int httpResponseCode = http.POST(json);
      
      Serial.println("HTTP POST: "+(String)json);
      
      Serial.print("HTTP Response code: ");
      Serial.println(httpResponseCode);
      
      http.end();
    } else {
      Serial.println("WiFi Disconnected");
    }
    lastTime = millis();
  }
}
