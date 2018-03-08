/*

B L A C K O U T
Danielle McPhatter | 2018 | Tracking Assignment

Tracks brightness by using the intensity of the red color value of the 
webcam feed to reveal blackout poetry selected at random from five different pieces. 

Installation requires a dark room and allows the participant to walk around with
a red lamp to uncover the poetry.
 
*/


import processing.video.*;

Capture video;

String[] poems = {"../Poems/Alone.png", "../Poems/Dark.png", "../Poems/Empty.png", "../Poems/Invisible.png", "../Poems/Reveal.png"}; 
PImage poem;
color dark = color(0);

int numPixels;
int threshold = 250;
float pixelBrightness;

boolean debug = false;

void setup() {
  //size(displayWidth, displayHeight); // 1440 x 900
  fullScreen(); //Only works with display up to 1440 x 900
  noCursor();
  smooth();
  println(displayWidth, displayHeight);

  // Randomly select and load pixels of image of blackout poem from the five options in the Poems folder
  poem = loadImage(poems[floor(random(0, 5))]);
  poem.loadPixels();

  // Create new Capture for the webcam and start stream
  video = new Capture(this, width, height);
  video.start(); 

  // Count number of pixels (to be used in for loop in draw() function)
  numPixels = video.width * video.height;
}


void draw() {
  // If webcam feed available
  if (video.available()) {
    // Read & load pixels for tracking
    video.read();
    
    video.loadPixels();
    loadPixels();
    
    // Iterate through 2D array of pixels in the video,
    for (int y=0; y<height; y++) {
      for (int x=0; x<width; x++) {
        int screenIndex = y * width + x;
        int videoIndex = (width-x-1) + y*width;
        pixelBrightness = video.pixels[videoIndex] >> 16 & 0xFF;
        // If the brightness of a pixel is below the threshold, set the color of the pixel to "dark"
        if (pixelBrightness < threshold) { 
          pixels[screenIndex] = dark;
          // Otherwise, swap out the pixel at this index to the corresponding one in the poem image
        } else {
          pixels[screenIndex] = poem.pixels[screenIndex];
        }
      }
    }
    updatePixels();

    // Debugging to monitor frame rate
    if (debug) {
      fill(255, 0, 0);
      noStroke();
      text(nf(frameRate, 0, 2) + " fps", 50, 50);
    }
  }
}


void keyPressed() {
  if (key == 'd') debug = !debug;
}