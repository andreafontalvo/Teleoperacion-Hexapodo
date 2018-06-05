
// ESTE CODIGO ENVIA LA LECTURA DE LOS SENSORES CADA QUE EL COMANDO 'B' 
// ES RECIBIDO VIA COMUNICACION SERIAL
// SEPTIEMBRE 06, 2017

// MODIFICACION 
// OCTUBRE 19, 2017: SE CAMBIO EL VALOR DEL OFFSET DEL COMPASS PARA PRUEBAS EN EL 3L-UNINORTE
// OCTUBRE 24, 2017: SE INTEGRO FILTRO DE KALMAN A LECTURAS DE SENSOR LEFT Y RIGHT
// OCTUBRE 25, 2017:

#include <Wire.h>
#include <SimpleKalmanFilter.h>
#include <HMC5883L.h>
HMC5883L compass;

// FILTROS KALMAN CON VARIANZA ESTIMADA A PARTIR DE PRUEBAS
SimpleKalmanFilter filtroKalmanLeft(33.39122007,33.39122007,0.01); // IZQUIERDA
SimpleKalmanFilter filtroKalmanRight(25.38923283,25.38923283,0.01); // DERECHA
SimpleKalmanFilter filtroKalmanCompass(136.3136558,136.3136558,0.01); // COMPASS

int TrigPinLeft = 3;
int EchoPinLeft = 5;
int TrigPinRight = 6;
int EchoPinRight = 9;
int TrigPinFront = 10;
int EchoPinFront = 11;
int sign = 0;

void ReceiveCommand();
void GetSensorData();

void setup() {
  Serial.begin(9600);
  while (!compass.begin()) {
    delay(500);
    Serial.println('h');
  }
  compass.setRange(HMC5883L_RANGE_1_3GA);
  compass.setMeasurementMode(HMC5883L_CONTINOUS);
  compass.setDataRate(HMC5883L_DATARATE_30HZ);
  compass.setSamples(HMC5883L_SAMPLES_8);
  //compass.setOffset(-62, -194);
  //compass.setOffset(151, -125); // OFFSET 30º
  //compass.setOffset(115, -133); // OFFSET 10º
  //compass.setOffset(93, -180);
  // compass.setOffset(137, -217); //Casa Andrea
  compass.setOffset(134, -150);

  pinMode(TrigPinLeft, OUTPUT);
  pinMode(TrigPinRight, OUTPUT);
  pinMode(TrigPinFront, OUTPUT);
  pinMode(EchoPinLeft, INPUT);
  pinMode(EchoPinRight, INPUT);
  pinMode(EchoPinFront, INPUT);
}

void loop() {
  ReceiveCommand();
}

void ReceiveCommand() {
  while (sign == 0) {
    if (Serial.available() > 0) {
      char InChar = (char)Serial.read();
      if (isUpperCase(InChar) && InChar == 'B') {
        GetSensorData();
      }
    }
  }
}

void GetSensorData() {
  Vector norm = compass.readNormalize();
  float heading = atan2(norm.YAxis, norm.XAxis);
  float declinationAngle = (7.0 - (43.0 / 60.0)) / (180 / M_PI);
  heading += declinationAngle;
  if (heading < 0) {
    heading += 2 * PI;
  }
  if (heading > 2 * PI) {
    heading -= 2 * PI;
  }

  float headingDegrees = heading * 180 / M_PI;
  float LeftSensor = DistanceSensor(TrigPinLeft, EchoPinLeft) / 1000;
  float RightSensor = DistanceSensor(TrigPinRight, EchoPinRight) / 1000;
  float FrontSensor = DistanceSensor(TrigPinFront, EchoPinFront) / 1000;
  //  float LeftSensor = 0.01;
  //  float RightSensor = 0.01;
  //  float FrontSensor = 0.01;

  float KalmanLeft = filtroKalmanLeft.updateEstimate(LeftSensor);
  float KalmanRight = filtroKalmanRight.updateEstimate(RightSensor);
  float KalmanCompass = filtroKalmanCompass.updateEstimate(headingDegrees);

  Serial.print('I');
  Serial.print('C');
  Serial.print(headingDegrees/ 1000, 5);
  Serial.print('L');
  Serial.print(LeftSensor, 5);
  Serial.print('K');
  Serial.print(KalmanLeft, 5);
  Serial.print('R');
  Serial.print(RightSensor, 5);
  Serial.print('K');
  Serial.print(KalmanRight, 5);
  Serial.print('F');
  Serial.print(FrontSensor, 5);
  Serial.println('T');
  delay(2000);
}

float DistanceSensor(int trig, int echo) {
  digitalWrite(trig, LOW);
  delayMicroseconds(2);
  digitalWrite(trig, HIGH);
  delayMicroseconds(10);
  digitalWrite(trig, LOW);
  float duration = pulseIn(echo, HIGH);
  float distance = duration * 0.034 / 2;
  return distance;
}

