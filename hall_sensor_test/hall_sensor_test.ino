/*
  A simple test program to read the value of a hall effect sensor
  Part used is Honeywell SS461C - Farnell part # 181-1311
*/

int analogPin = 0;  // the pint that the hall sensor is connected to
int val = 0;        // a var to store the sensor value in

void setup()
{
  Serial.begin(9600);  // serial setup
}

void loop()
{
  val = analogRead(analogPin);  // read the sensor value
  Serial.println(val);          // print the value to the serial port
}
