#include <FS.h>                   //this needs to be first, or it all crashes and burns...

#include <ESP8266WiFi.h>          //https://github.com/esp8266/Arduino
#include <ESP8266HTTPClient.h>

#include <DNSServer.h>
#include <ESP8266WebServer.h>
#include <WiFiManager.h>          //https://github.com/tzapu/WiFiManager

#include <Stepper.h>
#include <ArduinoJson.h>

#define STEPS  2048

#define IN1   D1   // IN1 is connected to NodeMCU pin D1 (GPIO5)
#define IN2   D2   // IN2 is connected to NodeMCU pin D2 (GPIO4)
#define IN3   D5   // IN3 is connected to NodeMCU pin D3 (GPIO0)
#define IN4   D6   // IN4 is connected to NodeMCU pin D4 (GPIO2)

#define BUTTON 0 // flash button

WiFiManager wifiManager;

Stepper stepper(STEPS, IN4, IN2, IN3, IN1);

const String ENDPOINT = "http://177.44.248.9:9000";

unsigned long lastTime   = 0;
unsigned long timerDelay = 5000;

unsigned long luminosity;
unsigned long temperature;
unsigned long moisture;

int valueOffset = 6;

int remainingSteps = 0;
int stepDirection = 0;

int maxSteps = 200;

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

void moveMotor(float value) {
  remainingSteps = abs(STEPS * value * valueOffset);
  stepDirection = value / fabs(value);
  Serial.println("Moving motor: " + (String) remainingSteps + " - " + (String) stepDirection);
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

    float value = res["value"].as<float>();

    if (value != 0) {
      moveMotor(value);
    }

    http.end();
  } else {
    Serial.println("WiFi Disconnected");
  }
}

void clickEvent() {
  Serial.println("Click");
  moveMotor(0.25);
}
void doubleClickEvent() {
  Serial.println("Double Click");
  moveMotor(-0.25);
}
void holdEvent() {
  Serial.println("Hold");
  resetSettings();
}

/**
 * 4 Way Button
 * 
 * http://jmsarduino.blogspot.com/2009/10/4-way-button-click-double-click-hold.html
 */
// Button timing variables
int debounce = 20;          // ms debounce period to prevent flickering when pressing or releasing the button
int DCgap = 250;            // max ms between clicks for a double click event
int holdTime = 2000;        // ms hold period: how long to wait for press+hold event

// Button variables
boolean buttonVal = HIGH;   // value read from button
boolean buttonLast = HIGH;  // buffered value of the button's previous state
boolean DCwaiting = false;  // whether we're waiting for a double click (down)
boolean DConUp = false;     // whether to register a double click on next release, or whether to wait and click
boolean singleOK = true;    // whether it's OK to do a single click
long downTime = -1;         // time the button was pressed down
long upTime = -1;           // time the button was released
boolean ignoreUp = false;   // whether to ignore the button release because the click+hold was triggered
boolean waitForUp = false;        // when held, whether to wait for the up event
boolean holdEventPast = false;    // whether or not the hold event happened already

int checkButton() {
    int event = 0;
    buttonVal = digitalRead(BUTTON);

    if (buttonVal == HIGH && buttonLast == HIGH)
    {
      event = -1;
    }

   // Button pressed down
   if (buttonVal == LOW && buttonLast == HIGH && (millis() - upTime) > debounce)
   {
       downTime = millis();
       ignoreUp = false;
       waitForUp = false;
       singleOK = true;
       holdEventPast = false;
       if ((millis()-upTime) < DCgap && DConUp == false && DCwaiting == true)  DConUp = true;
       else  DConUp = false;
       DCwaiting = false;
   }
   // Button released
   else if (buttonVal == HIGH && buttonLast == LOW && (millis() - downTime) > debounce)
   {        
       if (not ignoreUp)
       {
           upTime = millis();
           if (DConUp == false) DCwaiting = true;
           else
           {
               event = 2;
               DConUp = false;
               DCwaiting = false;
               singleOK = false;
           }
       }
   }
   // Test for normal click event: DCgap expired
   if ( buttonVal == HIGH && (millis()-upTime) >= DCgap && DCwaiting == true && DConUp == false && singleOK == true && event != 2)
   {
       event = 1;
       DCwaiting = false;
   }
   // Test for hold
   if (buttonVal == LOW && (millis() - downTime) >= holdTime) {
       // Trigger hold
       if (not holdEventPast)
       {
           event = 3;
           waitForUp = true;
           ignoreUp = true;
           DConUp = false;
           DCwaiting = false;
           //downTime = millis();
           holdEventPast = true;
       }
   }
   buttonLast = buttonVal;
   return event;
}

void setup() {
  pinMode(IN1, OUTPUT);
  pinMode(IN2, OUTPUT);
  pinMode(IN3, OUTPUT);
  pinMode(IN4, OUTPUT);
  stepper.setSpeed(5);

  Serial.begin(9600);

  pinMode(BUTTON, INPUT_PULLUP);

  wifiConnect();
}

void loop() {
  if (remainingSteps != 0) {
    int steps = min(remainingSteps, maxSteps);
    int move = steps * stepDirection;

    Serial.println("running - " + (String) move);
    stepper.step(move);
    digitalWrite(IN1, LOW);
    digitalWrite(IN2, LOW);
    digitalWrite(IN3, LOW);
    digitalWrite(IN4, LOW);

    delay(10);
    remainingSteps = remainingSteps - steps;
  } else if ((millis() - lastTime) > timerDelay) {
    sendData();
    delay(10);
    requestAction();
    delay(10);

    lastTime = millis();
  } else {
    int b = checkButton();

    if (b == 1) clickEvent();
    else if (b == 2) doubleClickEvent();
    else if (b == 3) holdEvent();
  }
}
