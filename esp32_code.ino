#include <WiFi.h>
#include <HTTPClient.h>
#include <SPI.h>
#include <SD.h>
#include <time.h>

// ── WIFI + SUPABASE ──
const char* ssid     = "GAURI AQUAFARMS";
const char* password = "Rishi@1998";
const char* url      = "https://mpacyxzqxuswudhvpkgz.supabase.co/rest/v1/esp_data";
const char* apiKey   = "eyJhbGci...";   // JWT truncated

// ── SD CARD ──
#define SD_CS 5

// ── CO2 SENSOR (UART2) ──
// #define RXD2 16
// #define TXD2 17
// RX Connected directly to TX on esp
// TX Connected directly to RX on esp
HardwareSerial co2Serial(2);
String buffer;

#define MAX_RETRIES        3
#define DATA_SEND_INTERVAL 120000   // 2 minutes

int  latestCO2       = 0;
bool newDataAvailable = false;

// ── getTimestamp ──
String getTimestamp() {
  struct tm timeinfo;
  if (!getLocalTime(&timeinfo)) return "TIME_FAIL";
  char buf[25];
  strftime(buf, sizeof(buf), "%Y-%m-%d %H:%M:%S", &timeinfo);
  return String(buf);
}

// ── sendToDB ──
bool sendToDB(int co2) {
  HTTPClient http;
  if (!http.begin(url)) return false;
  http.addHeader("Content-Type",  "application/json");
  http.addHeader("apikey",        apiKey);
  http.addHeader("Authorization", "Bearer " + String(apiKey));
  http.addHeader("Prefer",        "return=minimal");
  String payload = "{\"dissolved_co2\":" + String(co2) + "}";
  int response = http.POST(payload);
  http.end();
  return (response == 200 || response == 201);
}

// ── sendWithRetry (blocking, 3 attempts) ──
bool sendWithRetry(int co2) {
  for (int i = 1; i <= MAX_RETRIES; i++) {
    if (sendToDB(co2)) { Serial.println("✅ Sent"); return true; }
    delay(1000);
  }
  Serial.println("❌ All retries failed");
  return false;
}

// ── saveToSD ──
void saveToSD(int co2) {
  File file = SD.open("/data.csv", FILE_APPEND);
  if (file) { file.println(getTimestamp() + "," + String(co2)); file.close(); }
}

// ── processData — filters noise (< 10) ──
void processData(String data) {
  String number = "";
  for (int i = 0; i < data.length(); i++)
    if (isDigit(data[i])) number += data[i];
  int co2 = number.toInt();
  if (co2 < 10) return;           // discard noise
  latestCO2        = co2;
  newDataAvailable = true;
}

// ── readSensor ──
void readSensor() {
  while (co2Serial.available()) {
    char c = co2Serial.read();
    if (c == '\n' || c == '\r') { processData(buffer); buffer = ""; }
    else {
      buffer += c;
      if (buffer.length() > 50) buffer = "";
    }
  }
}

// ── setup ──
void setup() {
  Serial.begin(115200);
  co2Serial.begin(9600, SERIAL_8N1, RXD2, TXD2);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) delay(300);
  configTime(0, 0, "pool.ntp.org");
  struct tm t; while (!getLocalTime(&t)) delay(500);
  SD.begin(SD_CS);
}

// ── loop ──
void loop() {
  readSensor();
  if (millis() - lastCycleStart >= DATA_SEND_INTERVAL) {
    if (newDataAvailable) {
      bool ok = (WiFi.status() == WL_CONNECTED) ? sendWithRetry(latestCO2) : false;
      if (!ok) saveToSD(latestCO2);
      newDataAvailable = false;
    }
    lastCycleStart = millis();
  }
}
