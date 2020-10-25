#include <FS.h>                   //this needs to be first, or it all crashes and burns...

#include <ESP8266WiFi.h>          //https://github.com/esp8266/Arduino
#include <ESP8266HTTPClient.h>

#include <DNSServer.h>
#include <ESP8266WebServer.h>
#include <WiFiManager.h>          //https://github.com/tzapu/WiFiManager

#define mla 14
#define mlb 12
#define tmp 3000

WiFiManager wifiManager;
std::unique_ptr<ESP8266WebServer> server;

const char* endpoint = "http://177.44.248.9:9000/dados";

unsigned long lastTime = 0;
unsigned long timerDelay = 5000;

unsigned long luminosity;
unsigned long temperature;
unsigned long moisture;

void handleRoot() {
  server->send(200, "text/plain", "hello from esp8266!");
}

void handleTurnRight() {
  Serial.println("Gira para direita");
  digitalWrite(mla, LOW);
  digitalWrite(mlb, HIGH);
  delay(tmp);

  Serial.println("Para");
  digitalWrite(mla, LOW);
  digitalWrite(mlb, LOW);
  delay(100);

  server->send(200, "text/plain", "girou para direita");
}

void handleTurnLeft() {
  Serial.println("Gira para esquerda");
  digitalWrite(mla, LOW);
  digitalWrite(mlb, HIGH);
  delay(tmp);

  Serial.println("Para");
  digitalWrite(mla, LOW);
  digitalWrite(mlb, LOW);
  delay(100);

  server->send(200, "text/plain", "girou para esquerda");
}

void wifiConnect() {
  Serial.println();

  // exit after config instead of connecting
  wifiManager.setBreakAfterConfig(true);

  // set Wifi ID and password
  if (!wifiManager.autoConnect("APPID")) {
    Serial.println("failed to connect, we should reset as see if it connects");
    delay(3000);
    ESP.reset();
    delay(5000);
  }

  Serial.print("Connected to WiFi with IP Address: ");
  Serial.println(WiFi.localIP());
}

void startServer() {
  server.reset(new ESP8266WebServer(WiFi.localIP(), 80));

  server->on("/", handleRoot);
  server->on("/giraDireita", handleTurnRight);
  server->on("/giraEsquerda", handleTurnLeft);

  server->begin();
  Serial.println("HTTP server started");
  Serial.println(WiFi.localIP());
}

void resetSettings() {
  Serial.println("Reseted");
  wifiManager.resetSettings();
  wifiConnect();
}

void sendStatus() {
  if(WiFi.status()== WL_CONNECTED){
    HTTPClient http;

    http.begin(endpoint);

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

void setup() {
  Serial.begin(115200);

  pinMode(0, INPUT_PULLUP);
  pinMode(mla, OUTPUT);
  pinMode(mlb, OUTPUT);

  digitalWrite(mla, LOW);
  digitalWrite(mlb, LOW);

  wifiConnect();
  startServer();
}

void loop() {
  if (digitalRead(0) == LOW) {
    resetSettings();
  }

  if ((millis() - lastTime) > timerDelay) {
    sendStatus();
  }

  server->handleClient();
}
