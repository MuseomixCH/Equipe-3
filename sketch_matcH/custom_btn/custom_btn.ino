
const int buttonPin = 2;     // the number of the pushbutton pin
const int ledPin =  13;      // the number of the LED pin

// variables will change:
int buttonState = 0;         // variable for reading the pushbutton status
boolean BUTTON_PRESSED = false;


void setup() {
  pinMode(ledPin, OUTPUT);      
  pinMode(buttonPin, INPUT);     
  
  Serial.begin(9600);
}

void loop(){
  buttonState = digitalRead(buttonPin);
  if (buttonState == HIGH && BUTTON_PRESSED == false) {         
    BUTTON_PRESSED = true;
    digitalWrite(ledPin, HIGH);
    Serial.print('B');
    delay(500);
    
  }else if(buttonState == HIGH && BUTTON_PRESSED == true){
  }else if(buttonState == LOW){
    BUTTON_PRESSED = false;
    digitalWrite(ledPin, LOW); 
  }
}
