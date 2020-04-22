final int GAME_START = 0, GAME_RUN = 1, GAME_OVER = 2;
int gameState = 0;

final float GRID_LENGTH  = 80;
float soilY = 160;

final int LIFE_X       = 10;
final int LIFE_Y       = 10;
final int LIFE_SPACE   = 20;
final int LIFE_W       = 50;
final int LIFE_ST_N    = 2;
int lifeN              = LIFE_ST_N;

final int GRASS_HEIGHT   = 15;
final int START_BUTTON_W = 144;
final int START_BUTTON_H = 60;
final int START_BUTTON_X = 248;
final int START_BUTTON_Y = 360;

final int GROUNDHOG_W  = 80;
final int GROUNDHOG_H  = 80;
final float GROUNDHOG_ST_X  = GRID_LENGTH*4;
final float GROUNDHOG_ST_Y  = 160-GRID_LENGTH;
float groundhogX = GROUNDHOG_ST_X;
float groundhogY = GROUNDHOG_ST_Y;

int groundhogState = 0;
final int STAY     = 0;
final int GO_DOWN  = 1;
final int GO_LEFT  = 2;
final int GO_RIGHT = 3;

boolean downPressed  = false;
boolean leftPressed  = false;
boolean rightPressed = false;

int frame = 0;

PImage title, gameover, startNormal, startHovered, restartNormal, restartHovered;
PImage bg, soil8x24, soil0, soil1, soil2, soil3, soil4, soil5, life;
PImage stone1, stone2;
PImage groundhogIdle, groundhogDown, groundhogLeft, groundhogRight;

// For debug function; DO NOT edit or remove this!
int playerHealth = 0;
float cameraOffsetY = 0;
boolean debugMode = false;

void setup() {
	size(640, 480, P2D);
	// Enter your setup code here (please put loadImage() here or your game will lag like crazy)
	bg             = loadImage("img/bg.jpg");
	title          = loadImage("img/title.jpg");
	gameover       = loadImage("img/gameover.jpg");
	startNormal    = loadImage("img/startNormal.png");
	startHovered   = loadImage("img/startHovered.png");
	restartNormal  = loadImage("img/restartNormal.png");
	restartHovered = loadImage("img/restartHovered.png");
	soil8x24       = loadImage("img/soil8x24.png");
  soil0          = loadImage("img/soil0.png");
  soil1          = loadImage("img/soil1.png");
  soil2          = loadImage("img/soil2.png");
  soil3          = loadImage("img/soil3.png");
  soil4          = loadImage("img/soil4.png");
  soil5          = loadImage("img/soil5.png");
  stone1         = loadImage("img/stone1.png");
  stone2         = loadImage("img/stone2.png");
  life           = loadImage("img/life.png");
  groundhogIdle  = loadImage("img/groundhogIdle.png");
  groundhogDown  = loadImage("img/groundhogDown.png");
  groundhogLeft  = loadImage("img/groundhogLeft.png");
  groundhogRight = loadImage("img/groundhogRight.png");
  
  
}

void draw() {
    /* ------ Debug Function ------ 

      Please DO NOT edit the code here.
      It's for reviewing other requirements when you fail to complete the camera moving requirement.

    */
    if (debugMode) {
      pushMatrix();
      translate(0, cameraOffsetY);
    }
    /* ------ End of Debug Function ------ */

    
	switch (gameState) {

		case GAME_START: // Start Screen
		image(title, 0, 0);

		if(START_BUTTON_X + START_BUTTON_W > mouseX
	    && START_BUTTON_X < mouseX
	    && START_BUTTON_Y + START_BUTTON_H > mouseY
	    && START_BUTTON_Y < mouseY) {

			image(startHovered, START_BUTTON_X, START_BUTTON_Y);
			if(mousePressed){
				gameState = GAME_RUN;
				mousePressed = false;
			}

		}else{

			image(startNormal, START_BUTTON_X, START_BUTTON_Y);

		}
		break;

		case GAME_RUN: // In-Game

		// Background
		image(bg, 0, 0);

		// Sun
	    stroke(255,255,0);
	    strokeWeight(5);
	    fill(253,184,19);
	    ellipse(590,50,120,120);

		// Grass
		fill(124, 204, 25);
		noStroke();
		rect(0, soilY - GRASS_HEIGHT, width, GRASS_HEIGHT);

		// Soil - REPLACE THIS PART WITH YOUR LOOP CODE!
		//image(soil8x24, 0, 160);
    for(int j=0; j<24; j++){
      for (int i=0; i<8; i++){
        if(j/4>=0 && j/4<1)  image(soil0, i*GRID_LENGTH, soilY+j*GRID_LENGTH);
        if(j/4>=1 && j/4<2)  image(soil1, i*GRID_LENGTH, soilY+j*GRID_LENGTH);
        if(j/4>=2 && j/4<3)  image(soil2, i*GRID_LENGTH, soilY+j*GRID_LENGTH);
        if(j/4>=3 && j/4<4)  image(soil3, i*GRID_LENGTH, soilY+j*GRID_LENGTH);
        if(j/4>=4 && j/4<5)  image(soil4, i*GRID_LENGTH, soilY+j*GRID_LENGTH);
        if(j/4>=5 && j/4<6)  image(soil5, i*GRID_LENGTH, soilY+j*GRID_LENGTH);
        
        // stone - layer 1~8
        if(j>=0 && j<8){
          if(i == j){
            image(stone1, i*GRID_LENGTH, soilY+j*GRID_LENGTH);
          }
        }
        // stone - layer 9~16
        if (j>=8 && j<16){
          if((j%4==0 || j%4==3) && (i%4==1 || i%4==2))
            image(stone1, i*GRID_LENGTH, soilY+j*GRID_LENGTH);
          if((j%4==1 || j%4==2) && (i%4==0 || i%4==3))
            image(stone1, i*GRID_LENGTH, soilY+j*GRID_LENGTH);
        }
        // stone - layer 17~24
        if (j>=16 && j<24){
          if(j%3 == 1){
            if(i%3 != 0) image(stone1, i*GRID_LENGTH, soilY+j*GRID_LENGTH);
            if(i%3 == 2) image(stone2, i*GRID_LENGTH, soilY+j*GRID_LENGTH);
          }
          if(j%3 == 2){
            if(i%3 != 2) image(stone1, i*GRID_LENGTH, soilY+j*GRID_LENGTH);
            if(i%3 == 1) image(stone2, i*GRID_LENGTH, soilY+j*GRID_LENGTH);
          }
            
          if(j%3 == 0){
            if(i%3 != 1) image(stone1, i*GRID_LENGTH, soilY+j*GRID_LENGTH);
            if(i%3 == 0) image(stone2, i*GRID_LENGTH, soilY+j*GRID_LENGTH);
          }
        }
        
      }
      
    }

	// Player
	switch (groundhogState){
        
        case STAY:  
          image(groundhogIdle, groundhogX, groundhogY);         
          if (downPressed)  groundhogState = GO_DOWN;          
          if (leftPressed)  groundhogState = GO_LEFT;          
          if (rightPressed) groundhogState = GO_RIGHT;
          
          // debug
          //if (downPressed) println(groundhogY, soldierY);
          //if (leftPressed) println(groundhogX);
          //if (rightPressed) println(groundhogX);
          
          break;
          
        case GO_DOWN:
          image(groundhogDown, groundhogX, groundhogY);
          if (frame < 15 && soilY>160-20*GRID_LENGTH){
            soilY -= GRID_LENGTH/15;
            frame ++;
          }
          else if (frame < 15 && soilY<=160-20*GRID_LENGTH && groundhogY < height-GROUNDHOG_H){
            groundhogY += GRID_LENGTH/15;
            frame ++;
          }
          else groundhogState = STAY;
                    
          if (frame == 15){
            frame = 0;  // reset frame
            groundhogState = STAY;
            soilY = round(soilY);
            groundhogY = round(groundhogY);  // avoid the problem of indivisible - GRID_LENGTH/15
          } 
          
          downPressed = false;
          break;
          
        case GO_LEFT:
          image(groundhogLeft, groundhogX, groundhogY);
          if (frame < 15 && groundhogX > 0){
            groundhogX -= (float)GRID_LENGTH/15; 
            frame ++;
          }
          else groundhogState = STAY;
          
          if (frame == 15){
            frame = 0;
            groundhogState = STAY;
            groundhogX = round(groundhogX);
          }     
          
          leftPressed = false;
          
          break;
          
        case GO_RIGHT:
          image(groundhogRight, groundhogX, groundhogY);
          if (frame < 15 && groundhogX < width-GROUNDHOG_W){
            groundhogX += GRID_LENGTH/15; 
            frame ++;
          }
          else groundhogState = STAY;
          
          if (frame == 15){
            frame = 0;
            groundhogState = STAY;
            groundhogX = round(groundhogX);            
          }     
          
          rightPressed = false;
          
          break;
          
        default:
          println("error_groundhogState");
          break;      
      }


		// Health UI
    for (int i=0; i<lifeN; i++){    
      if(i<5){
        image(life, LIFE_X+(LIFE_W+LIFE_SPACE)*i, LIFE_Y);
      }
    }
      
    // life become zero
      if (lifeN == 0){
        gameState = GAME_OVER;
      }  
      
    

		break;

		case GAME_OVER: // Gameover Screen
		image(gameover, 0, 0);
		
		if(START_BUTTON_X + START_BUTTON_W > mouseX
	    && START_BUTTON_X < mouseX
	    && START_BUTTON_Y + START_BUTTON_H > mouseY
	    && START_BUTTON_Y < mouseY) {

			image(restartHovered, START_BUTTON_X, START_BUTTON_Y);
			if(mousePressed){
        lifeN = LIFE_ST_N;
        groundhogX = GROUNDHOG_ST_X;
        groundhogY = GROUNDHOG_ST_Y;
        soilY = 160;
        frame    = 0;  
				gameState = GAME_RUN;
				mousePressed = false;
				// Remember to initialize the game here!
			}
		}else{

			image(restartNormal, START_BUTTON_X, START_BUTTON_Y);

		}
		break;
		
	}

    // DO NOT REMOVE OR EDIT THE FOLLOWING 3 LINES
    if (debugMode) {
        popMatrix();
    }
}

void keyPressed(){
	// Add your moving input code here
  if (key == CODED){  
    switch (keyCode){
      case DOWN:
        downPressed = true;
        break;
      case LEFT:
        leftPressed = true;
        break;
      case RIGHT:
        rightPressed = true;
        break;
      default:
        println("error_keyPressed");
        break;
    }
  }

	// DO NOT REMOVE OR EDIT THE FOLLOWING SWITCH/CASES
    switch(key){
      case 'w':
      debugMode = true;
      cameraOffsetY += 25;
      break;

      case 's':
      debugMode = true;
      cameraOffsetY -= 25;
      break;

      case 'a':
      if(lifeN > 0) lifeN --;  // changed playerHealth to lifeN
      break;

      case 'd':
      if(lifeN < 5) lifeN ++;
      break;
    }
}

void keyReleased(){
  if (key == CODED){  
  switch (keyCode){
    case DOWN:
      downPressed = false;
      break;
    case LEFT:
      leftPressed = false;
      break;
    case RIGHT:
      rightPressed = false;
      break;
    default:
      println("error_keyReleased");
      break;
    }
  }
}
