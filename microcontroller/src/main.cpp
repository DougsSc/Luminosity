#include <FS.h>                   //this needs to be first, or it all crashes and burns...

#include <ESP8266WiFi.h>          //https://github.com/esp8266/Arduino
#include <ESP8266HTTPClient.h>

#include <DNSServer.h>
#include <ESP8266WebServer.h>
#include <WiFiManager.h>          //https://github.com/tzapu/WiFiManager

#include <ArduinoJson.h>

#define PADDLE_RIGHT 14
#define PADDLE_LEFT  12

WiFiManager wifiManager;
std::unique_ptr<ESP8266WebServer> server;

const String ENDPOINT = "http://177.44.248.9:9000";

unsigned long lastStatusTime   = 0;
unsigned long statusTimerDelay = 5000;

unsigned long lastActionTime   = 0;
unsigned long actionTimerDelay = 1000;

unsigned long luminosity;
unsigned long temperature;
unsigned long moisture;

void handleRoot() {
  server->send(200, "text/plain", "hello from esp8266!");
}

void turnPaddleRight(int tmp) {
  Serial.println("Gira para direita");
  digitalWrite(PADDLE_LEFT,  LOW);
  digitalWrite(PADDLE_RIGHT, HIGH);
  delay(tmp);

  Serial.println("Para");
  digitalWrite(PADDLE_LEFT,  LOW);
  digitalWrite(PADDLE_RIGHT, LOW);
  delay(100);

  // server->send(200, "text/plain", "girou para direita");
}

void turnPaddleLeft(int tmp) {
  Serial.println("Gira para esquerda");
  digitalWrite(PADDLE_RIGHT, LOW);
  digitalWrite(PADDLE_LEFT,  HIGH);
  delay(tmp);

  Serial.println("Para");
  digitalWrite(PADDLE_RIGHT, LOW);
  digitalWrite(PADDLE_LEFT,  LOW);
  delay(100);

  // server->send(200, "text/plain", "girou para esquerda");
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
  // server->on("/giraDireita", handleTurnRight);
  // server->on("/giraEsquerda", handleTurnLeft);

  server->begin();
  Serial.println("HTTP server started");
  Serial.println(WiFi.localIP());
}

void resetSettings() {
  Serial.println("Reseted");
  wifiManager.resetSettings();
  wifiConnect();
}

void sendData() {
  if(WiFi.status() == WL_CONNECTED) {
    Serial.println("Sending Data");

    HTTPClient http;

    http.begin(ENDPOINT + "/data");

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
}

void requestAction() {
  if(WiFi.status() == WL_CONNECTED){
    Serial.println("Requesting Action");

    HTTPClient http;

    http.begin(ENDPOINT + "/action");

    int httpResponseCode = http.GET();
    Serial.print("HTTP Response code: ");
    Serial.println(httpResponseCode);

    DynamicJsonDocument res(2048);
    deserializeJson(res, http.getStream());

    String motor = res["motor"].as<String>();
    String direction = res["direction"].as<String>();
    int time = res["time"].as<int>();

    if (motor.equals("paddles")) {
      if (direction.equals("right")) {
        turnPaddleRight(time);
      } else if (direction.equals("left")) {
        turnPaddleLeft(time);
      }
    }

    http.end();
  } else {
    Serial.println("WiFi Disconnected");
  }
}

void setup() {
  Serial.begin(115200);

  pinMode(0, INPUT_PULLUP);
  pinMode(PADDLE_LEFT,  OUTPUT);
  pinMode(PADDLE_RIGHT, OUTPUT);

  digitalWrite(PADDLE_LEFT,  LOW);
  digitalWrite(PADDLE_RIGHT, LOW);

  wifiConnect();
  // startServer();
}

void loop() {
  if (digitalRead(0) == LOW) {
    resetSettings();
  }

  if ((millis() - lastStatusTime) > statusTimerDelay) {
    sendData();
  }

  if ((millis() - lastActionTime) > actionTimerDelay) {
    requestAction();
  }

  lastActionTime = lastStatusTime = millis();

  // server->handleClient();
}
