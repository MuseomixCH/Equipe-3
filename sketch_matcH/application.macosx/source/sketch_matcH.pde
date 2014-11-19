import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

import de.voidplus.leapmotion.*;
import development.*;
import java.io.File;
import processing.serial.*;

//import processing.video.*;


//Movie intro_film;




Serial myPort;                       // The serial port
// remplacer avec les paramètres permettant l'impression depuis un terminal (invite de commande windows)
String params[] = { "say", "print"};
//String params[] = { "lpr", "data/img.jpg"};


int width_ = 600;
int height_ = 600;
int frameRate_ = 12;
int frame = 0;



LeapMotion leap;

Minim minim;
AudioPlayer player;
Minim minim_intro;
AudioPlayer intro_sound;
//AudioInput input;

String mode = "GIF";
PImage canva;


void setup(){
  size(width_, height_, OPENGL);
  background(255);
  frameRate(frameRate_);
  
  canva = loadImage("../canva_test.png");

  leap = new LeapMotion(this);
  
  minim = new Minim(this);
  player = minim.loadFile("../TEXTE 2 VERSION FINALE.WAV");
  minim_intro = new Minim(this);
  intro_sound = minim_intro.loadFile("../Voix Texte 1.WAV");
  //player.play();
  //input = minim.getLineIn();
  
  println(Serial.list());
  String portName = Serial.list()[3];
  myPort = new Serial(this, portName, 9600);
  
  PImage collective = createImage(width_, height_, ALPHA);
  collective.loadPixels();
  for(int i = 0; i< collective.pixels.length; i++){collective.pixels[i] = color(255);} 
  collective.updatePixels();
  collective.save("collectiveDrawings/0.png");
  
}

int nFrameInMode = 1;
boolean changeMode = false;
boolean saveIndivDrawing = false;
int[] XX = new int[0];
int[] YY = new int[0];
int tint = int(random(0,100));


File folder = new File("/Users/Laura/Dropbox/MUSEOMIXLEMAN2014/sketch_matcH/individualDrawings");
File[] listOfFiles = folder.listFiles();
int userNumber = listOfFiles.length - 1; 
//File folder2 = new File("/Users/Laura/Dropbox/MUSEOMIXLEMAN2014/sketch_matcH/collectiveDrawings");
//File[] listOfFiles2 = folder2.listFiles();
int collectiveNumber = userNumber; 




void draw(){
  println("mode : "+mode+" ---- frame : "+frame+" ---- nFrameInMode : "+nFrameInMode+" ---- collectiveNumber : "+collectiveNumber+" ---- userNumber : "+userNumber );
  

  if(mode.equals("GIF")){
    background(random(0,255));
    text("GIF", width_/2, height_/2);
    showAllIndiv(nFrameInMode, userNumber);
    int nFrame = max(70, userNumber);
    if(nFrameInMode > 70){changeMode = true;}
  }
  
  if(mode.equals("intro")){
    intro_sound.play();
    
    colorMode(HSB, 100);
    background(0,0,100);
    int offsetX = -50;
    int offsetY = -30;
    if((nFrameInMode>25) & (nFrameInMode<=132)){PImage image1 = loadImage("../image1.png");image(image1,offsetX,offsetY);}
    if((nFrameInMode>132) & (nFrameInMode<=230)){PImage image2 = loadImage("../image2.png");image(image2,offsetX,offsetY);}
    if(nFrameInMode>230){PImage image3 = loadImage("../image3.png");image(image3,offsetX,offsetY);}
    
    //intro_film = new Movie(this,"start.mov");  
    //intro_film.play();
    //intro_film.frameRate(frameRate_);
    //image(intro_film, 0, 0);
    
    //text("INTRO", width_/2, height_/2);
    if(nFrameInMode > 28){changeMode = true;}//280
  }
  
  if(mode.equals("draw")){
    // check for initialisation
    if(nFrameInMode == 1){
      println("DRAW MODE INIT");
      // initialisation 
      // start on white background
      background(255);
      // create an empty vector for the drawing
      XX = new int[0];
      YY = new int[0];
      
      tint = int(random(0,100));

      // update userNumber
      userNumber++;
    }
    
    //update the vector with the current position of hands from the Leap motion
    // XXX
    int x = -1000;
    int y = -1000;
    int z = 1;
    
    // ...
    int fps = leap.getFrameRate();
    ArrayList<Hand> hands = leap.getHands();
    println(hands.size());
    if(hands.size() >0){
      Hand hand = hands.get(0);
      println(hand);
      PVector hand_position = hand.getPosition();
      x = int(hand_position.x);
      y = int(hand_position.y);
      z = int(hand_position.z);
    }

    XX = append(XX,x);
    YY = append(YY,y);
    
    // display the empty canvas
    // XXX
    //image(canva, width_/4, canva.height/height_*width_/2, width_/2, canva.height/height_*width_/2);
    colorMode(HSB, 100);
    background(0,0,100);

    
    // create the image from the vector // I can directly draw on the scene; no need to create an image
    noFill();
    
    stroke(tint,100,80);
    strokeWeight(5);
    beginShape();
    curveVertex(XX[0],  YY[0]);
    for(int i = 0; i < XX.length; i++){
      if(XX[i]<=-1000){
        endShape();
        beginShape();
      }else{
        curveVertex(XX[i],  YY[i]);
      }
    }
    curveVertex(XX[XX.length-1],  YY[XX.length-1]);
    endShape(); 
    
    noStroke();
    fill(tint,100,100,70);
    ellipse(x,y,z,z);
    
    fill(tint,100,100,100);
    int nDots = 50+z;
    for(int i =0; i<nDots; i++){
      float angle = random(0,2*PI);
      float dist = 20*randomGaussian();
      //ellipse(x+dist*cos(angle), y+dist*sin(angle),2,2) ;
    }
    
    
    
  }
  
  if(mode.equals("collective")){
    player.play();
    background(50);
    if(nFrameInMode == 1){createCollectiveImage();} // in this function, the collectiveNumber is incremented
    showCollectiveImages(nFrameInMode); // in this function, all collective images are shown chronologically until the last one which stays longer
    int startBlack = max(24,collectiveNumber);
    if(nFrameInMode > startBlack){
      colorMode(HSB, 100);
      int alpha = max(0,100-(nFrameInMode-startBlack));
      println("alpha   "+alpha);
      background(0,0,alpha);  
    }
    if(nFrameInMode > 516){changeMode = true;}
  }
  

  
 
 nFrameInMode++;
 if(changeMode){
    nFrameInMode = 1;
    changeMode = false;
    
    if(mode.equals("GIF")){
      mode = "intro";
    }else if(mode.equals("intro")){
      mode = "draw";
    }else if(mode.equals("draw")){
      //save frame
      String drawingFilename = "individualDrawings/ID"+str(userNumber)+".png";
      saveFrame(drawingFilename);
      saveIndivDrawing = false;
      //print the drawing
      // XXX
      mode = "collective";
    }else if(mode.equals("collective")){
      mode = "GIF";
    }
  }
  frame++;
}


void showAllIndiv(int nFrameInMode, int userNumber){
  // display the next image in the list
  if(userNumber != 0){
    int indexOfImage = (nFrameInMode-1)%userNumber+1;
    if(indexOfImage !=0){
      String GIFFilename = "individualDrawings/ID"+str(indexOfImage)+".png";
      println(GIFFilename);
      PImage imForGIF = loadImage(GIFFilename);
      image(imForGIF,0,0);
    }
  }
}



void createCollectiveImage(){
  
  colorMode(RGB, 255);
  // load the last image from Individual
  String drawingFilename = "individualDrawings/ID"+str(userNumber)+".png";
  println(drawingFilename);
  PImage lastIndivIm = loadImage(drawingFilename);
  //load the last collective image if any
  String collectiveFilename = "collectiveDrawings/"+str(collectiveNumber)+".png";
  println(collectiveFilename);
  PImage lastColl = loadImage(collectiveFilename);

  // make the weighted sum of the two images
  PImage newColl = lastColl;
  newColl.loadPixels();
  lastIndivIm.loadPixels();
  println(green(newColl.pixels[0]));
  for(int i = 0; i < newColl.pixels.length; i++){
    float red = red(newColl.pixels[i]) * (collectiveNumber-1)/collectiveNumber +  red(lastIndivIm.pixels[i]) /collectiveNumber;
    float green = green(newColl.pixels[i]) * (collectiveNumber-1)/collectiveNumber +  green(lastIndivIm.pixels[i]) /collectiveNumber;
    float blue = blue(newColl.pixels[i]) * (collectiveNumber-1)/collectiveNumber +  blue(lastIndivIm.pixels[i]) /collectiveNumber;
    newColl.pixels[i] = color(red, green, blue) ;
  }
  newColl.updatePixels();
  
  
  collectiveNumber++;
  
  
  newColl.save("collectiveDrawings/"+str(collectiveNumber)+".png");
 
}

void showCollectiveImages(int nFrameInMode){
  // display the next image in the list
  if(collectiveNumber != 0){
    int indexOfImage = min(nFrameInMode,collectiveNumber);
    if(indexOfImage !=0){
      String GIFFilename = "collectiveDrawings/"+str(indexOfImage)+".png";
      println(GIFFilename);
      PImage imForGIF = loadImage(GIFFilename);
      image(imForGIF,0,0);
    }
  }
}


void serialEvent(Serial myPort) {
  int inByte = myPort.read();
  println(inByte);
  if (inByte == 'B') { 
     myPort.clear();       
     if(mode.equals("draw")){
        changeMode = true;
        //save the drawing
        saveIndivDrawing = true;
        exec(params);
    }
  } 
}

void mouseReleased(){
  if(mode.equals("draw")){
    changeMode = true;
    //save the drawing
    String drawingFilename = "individualDrawings/ID"+str(userNumber)+".png";
    saveFrame(drawingFilename);
    //print the drawing
    // XXX
  }
}

