
import processing.serial.*;

Serial myPort;                       // The serial port

// remplacer avec les paramètres permettant l'impression depuis un terminal (invite de commande windows)
String params[] = { "say", "hello"};
//String params[] = { "lpr", "data/img.jpg"};

void setup(){
  size(200, 200);

 println(Serial.list());
  String portName = Serial.list()[3];
  myPort = new Serial(this, portName, 9600);
  
}

void draw(){
  
}

void serialEvent(Serial myPort) {
  int inByte = myPort.read();
  println(inByte);
  if (inByte == 'B') { 
     myPort.clear();       
     exec(params);
  } 

}
