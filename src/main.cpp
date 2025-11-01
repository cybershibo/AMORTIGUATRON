#include <Arduino.h>
#include "Adafruit_VL53L0X.h"

#define XSHUT1 PA0
#define XSHUT2 PA1

Adafruit_VL53L0X lox1 = Adafruit_VL53L0X();
Adafruit_VL53L0X lox2 = Adafruit_VL53L0X();

bool sensor1_ok = false;
bool sensor2_ok = false;

void setup() {
  Serial.begin(115200);
  // Esperar solo un tiempo limitado por si el puerto no está conectado
  // pero no bloquear indefinidamente
  unsigned long startTime = millis();
  while (!Serial && (millis() - startTime < 3000)) {
    delay(10);
  }

  pinMode(XSHUT1, OUTPUT);
  pinMode(XSHUT2, OUTPUT);

  // Apagar ambos sensores primero
  digitalWrite(XSHUT1, LOW);
  digitalWrite(XSHUT2, LOW);
  delay(10);

  // --- Inicializar Sensor 1 ---
  digitalWrite(XSHUT1, HIGH);
  delay(10);
  if (lox1.begin(0x30)) {
    sensor1_ok = true;
    lox1.startRangeContinuous();
    Serial.println(F("Sensor 1 listo"));
  } else {
    Serial.println(F("Error al iniciar Sensor 1"));
  }

  // --- Inicializar Sensor 2 ---
  digitalWrite(XSHUT2, HIGH);
  delay(10);
  if (lox2.begin(0x31)) {
    sensor2_ok = true;
    lox2.startRangeContinuous();
    Serial.println(F("Sensor 2 listo"));
  } else {
    Serial.println(F("Error al iniciar Sensor 2 (no conectado)"));
  }

  if (!sensor1_ok && !sensor2_ok) {
    Serial.println(F("Ningún sensor detectado, deteniendo programa."));
    while (1);
  }
}

void loop() {
  uint16_t d1 = 0, d2 = 0;
  bool data_ready = false;

  // Leer Sensor 1
  if (sensor1_ok && lox1.isRangeComplete()) {
    d1 = lox1.readRange();
    if (d1 > 8200 || d1 == 65535) {
      d1 = 0;
    } else {
      data_ready = true;
    }
  }

  // Leer Sensor 2
  if (sensor2_ok && lox2.isRangeComplete()) {
    d2 = lox2.readRange();
    if (d2 > 8200 || d2 == 65535) {
      d2 = 0;
    } else {
      data_ready = true;
    }
  }

  // Enviar datos solo si hay al menos un sensor operativo
  // Verificar que Serial esté disponible antes de escribir
  if ((sensor1_ok || sensor2_ok) && Serial) {
    Serial.print(d1);
    Serial.print(",");
    Serial.println(d2);
    // Forzar envío inmediato para evitar pérdida de datos en caso de reset
    Serial.flush();
  }

  delay(25); // evita saturación del bus y del puerto serie
}
