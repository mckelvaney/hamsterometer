//arduino bike speedometer w serial.print()
//by Amanda Ghassaei 2012
//http://www.instructables.com/id/Arduino-Bike-Speedometer/

/*
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
*/

//calculations
//tire radius ~ 13.5 inches
//circumference = pi*2*r =~85 inches
//max speed of 35mph =~ 616inches/second
//max rps =~7.25

#define hallSensor A0 //pin connected to hall sensor

//storage variables
int hallVal;
long timer;// time between one full rotation (in ms)
float mph;
float radius = 2.5;// tire radius (in inches)
float circumference;
float best = 0;

int maxReedCounter = 100;//min time (in ms) of one rotation (for debouncing)
int reedCounter;


void setup(){
  
  reedCounter = maxReedCounter;
  circumference = 2*3.14*radius;
  pinMode(hallSensor, INPUT);
  
  // TIMER SETUP- the timer interrupt allows precise timed measurements of the reed switch
  //for more info about configuration of arduino timers see http://arduino.cc/playground/Code/Timer1
  cli();//stop interrupts

  //set timer1 interrupt at 1kHz
  TCCR1A = 0;// set entire TCCR1A register to 0
  TCCR1B = 0;// same for TCCR1B
  TCNT1  = 0;
  // set timer count for 1khz increments
  OCR1A = 1999;// = (1/1000) / ((1/(16*10^6))*8) - 1
  // turn on CTC mode
  TCCR1B |= (1 << WGM12);
  // Set CS11 bit for 8 prescaler
  TCCR1B |= (1 << CS11);   
  // enable timer compare interrupt
  TIMSK1 |= (1 << OCIE1A);
  
  sei();//allow interrupts
  //END TIMER SETUP
  
  Serial.begin(9600);
}


ISR(TIMER1_COMPA_vect) {//Interrupt at freq of 1kHz to measure reed switch
  int hallVal = analogRead(hallSensor);//get val of A0
  if (hallVal > 520 && hallVal < 575){  // if sensor value is above 520 (510 is value when no magnetic field) and less than 575 (575 is the max value when wheel is parked)
    if (reedCounter == 0){//min time between pulses has passed
      mph = (56.8*float(circumference))/float(timer);//calculate miles per hour
      timer = 0;//reset timer
      reedCounter = maxReedCounter;//reset reedCounter
    }
    else{
      if (reedCounter > 0){//don't let reedCounter go negative
        reedCounter -= 1;//decrement reedCounter
      }
    }
  }
  else{//if reed switch is open
    if (reedCounter > 0){//don't let reedCounter go negative
      reedCounter -= 1;//decrement reedCounter
    }
  }
  if (timer > 2000){
    mph = 0;//if no new pulses from reed switch- tire is still, set mph to 0
  }
  else{
    timer += 1;//increment timer
  } 
}

void displayMPH(){
  Serial.println(mph);
}

void displayBest()
{
  digitalWrite(13, HIGH);
  delay(50);
  digitalWrite(13, LOW);
  delay(50);
  digitalWrite(13, HIGH);
  delay(50);
  digitalWrite(13, LOW);
  delay(50);
  digitalWrite(13, HIGH);
  delay(50);
  digitalWrite(13, LOW);
  delay(50);
  digitalWrite(13, HIGH);
  delay(50);
  digitalWrite(13, LOW);
  delay(50);
  digitalWrite(13, HIGH);
  delay(50);
  digitalWrite(13, LOW);
  
  //Serial.print("NEW RECORD");
  //Serial.print("\t");
  //Serial.print(best);
  //Serial.print("\n");
}

void loop(){
  //print mph once a second
  displayMPH();
  if (mph > best)
  {
    best = mph;
    //displayBest();
  }
  else if(mph > 8.80)
  {
    best = 0;
    //Serial.print("Best reset\n");
  }
  delay(1000);
}



