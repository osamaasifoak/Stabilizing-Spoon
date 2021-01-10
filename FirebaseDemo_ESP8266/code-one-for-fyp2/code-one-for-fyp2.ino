#include <Servo.h>
#include "I2Cdev.h"
#include "MPU6050_6Axis_MotionApps20.h"
#include "Wire.h"
#define LED_PIN 13
bool blinkState = true;
Servo Servo1; // First Servo off the chassis
Servo Servo2; // Second Servo off the chassis
int Servo1Pos = 0;
int Servo2Pos = 0;
float mpuPitch = 0;
float mpuRoll = 0;
float mpuYaw = 0;
const int MPU_addr=0x68; // I2C address of the MPU-6050
int16_t AcX,AcY,AcZ,Tmp,GyX,GyY,GyZ;
float BOX;
// define MPU instance
MPU6050 mpu; // class default I2C address is 0x68;
//specific I2C addresses may be passed as a parameter here
// MPU control/status vars
uint8_t mpuIntStatus; // holds actual interrupt status byte from MPU
uint8_t devStatus; // return status after each device operation (0 = success, !0 = error)
uint16_t packetSize; // expected DMP packet size (default is 42 bytes)
uint16_t fifoCount; // count of all bytes currently in FIFO
uint8_t fifoBuffer[64]; // FIFO storage buffer
// orientation/motion vars
Quaternion q; // [w, x, y, z] quaternion container
VectorInt16 aa; // [x, y, z] accel sensor measurements
VectorInt16 aaReal; // [x, y, z] gravity-free accel sensor
//measurements
VectorInt16 aaWorld; // [x, y, z] world-frame accel sensor
//measurements
VectorFloat gravity; // [x, y, z] gravity vector
float ypr[3]; // [yaw, pitch, roll] yaw/pitch/roll container and gravity vector
// relative ypr[x] usage based on sensor orientation when mounted, e.g. ypr[PITCH]
#define PITCH 1 // defines the position within ypr[x] variable for
#define ROLL 2 // defines the position within ypr[x] variable for ROLL;
#define YAW 0 // defines the position within ypr[x] variable for YAW;
void setup()
{
Servo1.attach(10); // attaches the servo on D11 to the servo object
Servo2.attach(11); // Second servo on D11
Wire.begin();
#if ARDUINO >= 157
Wire.setClock(400000UL); // Set I2C frequency to 400kHz
#else
TWBR = ((F_CPU / 400000UL) - 16) / 2;

#endif
Wire.beginTransmission(MPU_addr);
Wire.write(0x6B); // PWR_MGMT_1 register
Wire.write(0); // set to zero (wakes up the MPU-6050)
Wire.endTransmission(true);
Serial.begin(115200);
delay(5);
//setup starting angle
Wire.beginTransmission(MPU_addr);
Wire.write(0x3B); //3 starting with register 0x3B (ACCEL_XOUT_H)
Wire.endTransmission(false);
Wire.requestFrom(MPU_addr,14,true); // request a total of 14 registers
AcX=Wire.read()<<8|Wire.read(); // 0x3B (ACCEL_XOUT_H) & 0x3C (ACCEL_XOUT_L)
AcY=Wire.read()<<8|Wire.read(); // 0x3D (ACCEL_YOUT_H) & 0x3E (ACCEL_YOUT_L)
AcZ=Wire.read()<<8|Wire.read(); // 0x3F (ACCEL_ZOUT_H) & 0x40 (ACCEL_ZOUT_L)
Tmp=Wire.read()<<8|Wire.read(); // 0x41 (TEMP_OUT_H) & 0x42 (TEMP_OUT_L)
GyX=Wire.read()<<8|Wire.read(); // 0x43 (GYRO_XOUT_H) & 0x44 (GYRO_XOUT_L)
GyY=Wire.read()<<8|Wire.read(); // 0x45 (GYRO_YOUT_H) & 0x46 (GYRO_YOUT_L)
GyZ=Wire.read()<<8|Wire.read(); // 0x47 (GYRO_ZOUT_H) & 0x48 (GYRO_ZOUT_L)
while (!Serial); // wait for Leonardo enumeration, others continue
//immediately
// initialize device
Serial.println(F("Initializing I2C devices..."));
mpu.initialize();
// verify connection
Serial.println(F("Testing device connections..."));
Serial.println(mpu.testConnection() ? F("MPU6050 connection successful")
: F("MPU6050 connection failed"));
// load and configure the DMP
Serial.println(F("Initializing DMP"));
devStatus = mpu.dmpInitialize();
// INPUT CALIBRATED OFFSETS HERE; SPECIFIC FOR EACH UNIT AND EACH
//MOUNTING CONFIGURATION!!!!
mpu.setXGyroOffset(118);
mpu.setYGyroOffset(-44); //-44
mpu.setZGyroOffset(337);
mpu.setXAccelOffset(-651);
mpu.setYAccelOffset(670); //670
mpu.setZAccelOffset(1895);
// make sure it worked (returns 0 if so)
if (devStatus == 0)
{
// turn on the DMP, now that it’s ready
Serial.println(F("Enabling DMP"));
mpu.setDMPEnabled(true);
// enable Arduino interrupt detection
Serial.println(F("Enabling interrupt detection (Arduino external interrupt 0)"));
mpuIntStatus = mpu.getIntStatus();
// get expected DMP packet size for later comparison
packetSize = mpu.dmpGetFIFOPacketSize();
}
else
{
// ERROR!
// 1 = initial memory load failed, 2 = DMP configuration updates
// failed (if it’s going to break, usually the code will be 1)
Serial.print(F("DMP Initialization failed code = "));
Serial.println(devStatus);
}
// configure LED for output
pinMode(LED_PIN, OUTPUT);
} // setup()
// ================================================================
// === MAIN PROGRAM LOOP ===
// ================================================================
void loop(void)
{
// Get INT_STATUS byte
mpuIntStatus = mpu.getIntStatus();
// get current FIFO count
fifoCount = mpu.getFIFOCount();
// check for overflow (this should never happen unless our code is too

if ((mpuIntStatus & 0x10) || fifoCount == 1024)
{
// reset so we can continue cleanly
mpu.resetFIFO();
Serial.println(F("FIFO overflow!"));
return;
}
if (mpuIntStatus & 0x02) // otherwise continue processing
{
// check for correct available data length
if (fifoCount < packetSize)
return; // fifoCount = mpu.getFIFOCount();
// read a packet from FIFO
mpu.getFIFOBytes(fifoBuffer, packetSize);
// track FIFO count here in case there is > 1 packet available
fifoCount -= packetSize;
// flush buffer to prevent overflow
mpu.resetFIFO();
// display Euler angles in degrees
mpu.dmpGetQuaternion(&q, fifoBuffer);
mpu.dmpGetGravity(&gravity, &q);
mpu.dmpGetYawPitchRoll(ypr, &q, &gravity);
mpuRoll = ypr[PITCH] * 180 / M_PI;
mpuYaw = ypr[YAW] * 180 / M_PI;
// flush buffer to prevent overflow
mpu.resetFIFO();
// blink LED to indicate activity
blinkState = !blinkState;
digitalWrite(LED_PIN, blinkState);
// flush buffer to prevent overflow
mpu.resetFIFO();
Wire.beginTransmission(MPU_addr);
Wire.write(0x3B); // starting with register 0x3B (ACCEL_XOUT_H)
Wire.endTransmission(false);
Wire.requestFrom(MPU_addr,14,true); // request a total of 14 registers
AcX=Wire.read()<<8|Wire.read(); // 0x3B (ACCEL_XOUT_H) & 0x3C (ACCEL_XOUT_L)
AcY=Wire.read()<<8|Wire.read(); // 0x3D (ACCEL_YOUT_H) & 0x3E (ACCEL_YOUT_L)

AcZ=Wire.read()<<8|Wire.read(); // 0x3F (ACCEL_ZOUT_H) & 0x40 (ACCEL_ZOUT_L)
GyX=Wire.read()<<8|Wire.read(); // 0x43 (GYRO_XOUT_H) & 0x44 (GYRO_XOUT_L)
GyY=Wire.read()<<8|Wire.read(); // 0x45 (GYRO_YOUT_H) & 0x46 (GYRO_YOUT_L)
GyZ=Wire.read()<<8|Wire.read(); // 0x47 (GYRO_ZOUT_H) & 0x48 (GYRO_ZOUT_L)
//Locking motion for the pitch when tilting the spoon rear-downward.
if ((ypr[ROLL] * 180 / M_PI)+90 > 120 and (ypr[ROLL] * 180 / M_PI)+90 < 180)
{
mpuPitch = ypr[ROLL] * 180 / M_PI;
if (AcY > 28152)
{
mpuPitch = 173 - 90;
}
}
//Incrementation of degrees for the pitch motion.
mpuPitch = floor(mpuPitch);
if (135 <= (mpuPitch + 90) && (mpuPitch + 90) < 140)
{
BOX = 2;
}
if (135 <= (mpuPitch + 90) && (mpuPitch + 90) < 140)
{
BOX = 4;
}
if (140 <= (mpuPitch + 90) && (mpuPitch + 90) < 145)
{
BOX = 6;
}
if (145 <= (mpuPitch + 90) && (mpuPitch + 90) < 148)
{
BOX = 7;
}
if (148 <= (mpuPitch + 90) && (mpuPitch + 90) < 150)
{
BOX = 8;
}
else if (150 <= (mpuPitch + 90) && (mpuPitch + 90) < 155)
{
BOX = 11;
}
else if (155 <= (mpuPitch + 90) && (mpuPitch + 90) < 158)
{
BOX =13;
}
else if (158 <= (mpuPitch + 90) && (mpuPitch + 90) < 160)
{
BOX =15;
}
else if (160 <= (mpuPitch + 90) && (mpuPitch + 90) < 165)
{
BOX =17;
}
else if (165 <= (mpuPitch + 90) && (mpuPitch + 90) < 168)
{
BOX =19;
}
else if (168 <= (mpuPitch + 90) && (mpuPitch + 90) < 170)
{
BOX =21;
}
else if (170 <= (mpuPitch + 90))
{
BOX =23;
}
//Command the servo motors
Servo2.write(mpuPitch + BOX-20);
Servo1.write(-mpuRoll + 100);
// flush buffer to prevent overflow
mpu.resetFIFO();
}
}
