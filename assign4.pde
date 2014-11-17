Ship ship;
PowerUp ruby;
Bullet[] bList;
Laser[] lList;
Alien[] aList;

//Game Status
final int GAME_START   = 0;
final int GAME_PLAYING = 1;
final int GAME_PAUSE   = 2;
final int GAME_WIN     = 3;
final int GAME_LOSE    = 4;
int status;              //Game Status
int point;               //Game Score
int expoInit;            //Explode Init Size
int countBulletFrame;    //Bullet Time Counter
int bulletNum;           //Bullet Order Number

/*--------Put Variables Here---------*/
int countLaserFrame;
int laserNum;




void printText(){
  if(status==GAME_START){
    textSize(60);
    fill(95,194,226);
    text("GALIXIAN",width/4,240);
    textSize(20);
    fill(95,194,226);
    text("Press ENTER to Start",width/3,280);
  }else if(status==GAME_PAUSE){
    textSize(40);
    fill(95,194,226);
    text("PAUSE",width/2,240);
    textSize(20);
    fill(95,194,226);
    text("Press ENTER to Resume",width/2,280);
  }else if(status==GAME_WIN){
    textSize(40);
    fill(95,194,226);
    text("WINNER",width/3,300);
    textSize(20);
    fill(95,194,226);
    text("SCORE:"+point,width/3,340);
  }else if(status==GAME_LOSE){
    textSize(40);
    fill(95,194,226);
    text("BOOOM",width/3,240);
    textSize(20);
    fill(95,194,226);
    text("You are dead!!",width/3,280);
  }
}

void setup() {

  status = GAME_START;

  bList = new Bullet[30];
  lList = new Laser[30];
  aList = new Alien[100];

  size(640, 480);
  background(0, 0, 0);
  rectMode(CENTER);

  ship = new Ship(width/2, 460, 3);
  ruby = new PowerUp(int(random(width)), -10);

  reset();
}

void draw() {
  background(50, 50, 50);
  noStroke();

  switch(status) {

  case GAME_START:
    /*---------Print Text-------------*/
    //text("press enter", 320, 240); // replace this with printText
    printText();
    /*--------------------------------*/
    break;

  case GAME_PLAYING:
    background(50, 50, 50);

    drawHorizon();
    drawScore();
    drawLife();
    ship.display(); //Draw Ship on the Screen
    drawAlien();
    drawBullet();
    drawLaser();

    /*---------Call functions---------------*/
    alienShoot(50);
    checkAlienDead();/*finish this function*/
    checkShipHit();  /*finish this function*/

    countBulletFrame+=1;
    countLaserFrame+=1;


    //for(int i=0; i<aList.length-1; i++){
    //if(aList[i]==alien.die){
      //status=GAME_WIN;
    //}
    //}
    if(ship.life==0){
      status=GAME_LOSE;
    }
    
    
    
    break;

  case GAME_PAUSE:
    /*---------Print Text-------------*/
    printText();
    /*--------------------------------*/
    break;

  case GAME_WIN:
    /*---------Print Text-------------*/
    printText();
    /*--------------------------------*/
    winAnimate();
    break;

  case GAME_LOSE:
    loseAnimate();
    /*---------Print Text-------------*/
    printText();
    /*--------------------------------*/
    break;
  }
}

void drawHorizon() {
  stroke(153);
  line(0, 420, width, 420);
}

void drawScore() {
  noStroke();
  fill(95, 194, 226);
  textAlign(CENTER, CENTER);
  textSize(23);
  text("SCORE:"+point, width/2, 16);
}

void keyPressed() {
  if (status == GAME_PLAYING) {
    ship.keyTyped();
    cheatKeys();
    shootBullet(30);
  }
  statusCtrl();
}

/*---------Make Alien Function-------------*/
void alienMaker() {
  int ix=50;
  int iy=50;
  int total= 53;
  int numInRow= 12;
  int spaceOfCol= 40;
  int spaceOfRow= 50;
  
  for(int i=0; i<total; i++){
   
 
    int row = i / numInRow;
    int col = i % numInRow;
    aList[i]= new Alien(x,y);
  }
}

void drawLife() {
  fill(230, 74, 96);
  text("LIFE:", 36, 455);
  /*---------Draw Ship Life---------*/
  int x = 78;
  int y = 459;
  //int spacing = 25;
  //int count = 3;
  for(int i=0; i<ship.life*25; i+=25){
    ellipse(x+i,y,15,15);
  }
}

void drawBullet() {
  for (int i=0; i<bList.length-1; i++) {
    Bullet bullet = bList[i];
    if (bullet!=null && !bullet.gone) { // Check Array isn't empty and bullet still exist
      bullet.move();     //Move Bullet
      bullet.display();  //Draw Bullet on the Screen
      if (bullet.bY<0 || bullet.bX>width || bullet.bX<0) {
        removeBullet(bullet); //Remove Bullet from the Screen
      }
    }
  }
}

void drawLaser() {
  for (int i=0; i<lList.length-1; i++) { 
    Laser laser = lList[i];
    if (laser!=null && !laser.gone) { // Check Array isn't empty and Laser still exist
      laser.move();      //Move Laser
      laser.display();   //Draw Laser
      if (laser.lY>480) {
        removeLaser(laser); //Remove Laser from the Screen
      }
    }
  }
}

void drawAlien() {
  for (int i=0; i<aList.length-1; i++) {
    Alien alien = aList[i];
    if (alien!=null && !alien.die) { // Check Array isn't empty and alien still exist
      alien.move();    //Move Alien
      alien.display(); //Draw Alien
      /*---------Call Check Line Hit---------*/

      /*--------------------------------------*/
    }
  }
}

/*--------Check Line Hit---------*/


/*---------Ship Shoot-------------*/
void shootBullet(int frame) {
  if ( key == ' ' && countBulletFrame>frame) {
    if (!ship.upGrade) {
      bList[bulletNum]= new Bullet(ship.posX, ship.posY, -3, 0);
      if (bulletNum<bList.length-2) {
        bulletNum+=1;
      } else {
        bulletNum = 0;
      }
    } 
    /*---------Ship Upgrade Shoot-------------*/
    else {
      bList[bulletNum]= new Bullet(ship.posX, ship.posY, -3, 0); 
      if (bulletNum<bList.length-2) {
        bulletNum+=1;
      } else {
        bulletNum = 0;
      }
    }
    countBulletFrame = 0;
  }
}

/*---------Check Alien Hit-------------*/
void checkAlienDead() {
  for (int i=0; i<bList.length-1; i++) {
    Bullet bullet = bList[i];
    for (int j=0; j<aList.length-1; j++) {
      Alien alien = aList[j];
      if (bullet != null && alien != null && !bullet.gone && !alien.die // Check Array isn't empty and bullet / alien still exist
      /*--Hit detect--*/   && bullet.bX>alien.aX-alien.aSize && bullet.bX<alien.aX+alien.aSize && bullet.bY>alien.aY-alien.aSize &&  bullet.bY<alien.aY+alien.aSize ) {
        /*-------do something------*/
      removeBullet(bList[i]);
      removeAlien(aList[j]);
      point+=10;
      }
    }
  }
}

/*---------Alien Drop Laser-----------------*/
void alienShoot(int frame){
  frameRate(50);
  Alien alien = aList[int(random(53))] ;
  for (int i=0; i<lList.length-1; i++) {
    Laser laser = lList[i];

   }     
      if (alien!=null && !alien.die){     
      lList[laserNum]= new Laser(alien.aX, alien.aY);
  
 }
 if (laserNum<lList.length-1) {
     laserNum+=1; 
      }
      }
   


/*---------Check Laser Hit Ship-------------*/
void checkShipHit() {
  for (int i=0; i<lList.length-1; i++) {
    Laser laser = lList[i];
    if (laser!= null && !laser.gone // Check Array isn't empty and laser still exist/*---Hit detect---*/
    && laser.lX>ship.posX-ship.shipSize && laser.lX<ship.posX+ship.shipSize && laser.lY>ship.posY-ship.shipSize &&  laser.lY<ship.posY+ship.shipSize) {
      /*-------do something------*/
    removeLaser(lList[i]);
    ship.life-=1;
    }
  }
}

/*---------Check Win Lose------------------*/


void winAnimate() {
  int x = int(random(128))+70;
  fill(x, x, 256);
  ellipse(width/2, 200, 136, 136);
  fill(50, 50, 50);
  ellipse(width/2, 200, 120, 120);
  fill(x, x, 256);
  ellipse(width/2, 200, 101, 101);
  fill(50, 50, 50);
  ellipse(width/2, 200, 93, 93);
  ship.posX = width/2;
  ship.posY = 200;
  ship.display();
}

void loseAnimate() {
  fill(255, 213, 66);
  ellipse(ship.posX, ship.posY, expoInit+200, expoInit+200);
  fill(240, 124, 21);
  ellipse(ship.posX, ship.posY, expoInit+150, expoInit+150);
  fill(255, 213, 66);
  ellipse(ship.posX, ship.posY, expoInit+100, expoInit+100);
  fill(240, 124, 21);
  ellipse(ship.posX, ship.posY, expoInit+50, expoInit+50);
  fill(50, 50, 50);
  ellipse(ship.posX, ship.posY, expoInit, expoInit);
  expoInit+=5;
}

/*---------Check Ruby Hit Ship-------------*/


/*---------Check Level Up------------------*/


/*---------Print Text Function-------------*/


void removeBullet(Bullet obj) {
  obj.gone = true;
  obj.bX = 2000;
  obj.bY = 2000;
}

void removeLaser(Laser obj) {
  obj.gone = true;
  obj.lX = 2000;
  obj.lY = 2000;
}

void removeAlien(Alien obj) {
  obj.die = true;
  obj.aX = 1000;
  obj.aY = 1000;
}

/*---------Reset Game-------------*/
void reset() {
  for (int i=0; i<bList.length-1; i++) {
    bList[i] = null;
    lList[i] = null;
  }

  for (int i=0; i<aList.length-1; i++) {
    aList[i] = null;
  }

  point = 0;
  expoInit = 0;
  countBulletFrame = 30;
  bulletNum = 0;

  /*--------Init Variable Here---------*/
  

  /*-----------Call Make Alien Function--------*/
  alienMaker();

  ship.posX = width/2;
  ship.posY = 460;
  ship.upGrade = false;
  ruby.show = false;
  ruby.pX = int(random(width));
  ruby.pY = -10;
}

/*-----------finish statusCtrl--------*/
void statusCtrl() {
  if (key == ENTER) {
    switch(status) {

    case GAME_START:
      status = GAME_PLAYING;
      break;
   case GAME_PLAYING:
      status = GAME_PAUSE;
      break;
   case GAME_PAUSE:
      status = GAME_PLAYING;
      break;  
    
      /*-----------add things here--------*/

    }
  }
}

void cheatKeys() {

  if (key == 'R'||key == 'r') {
    ruby.show = true;
    ruby.pX = int(random(width));
    ruby.pY = -10;
  }
  if (key == 'Q'||key == 'q') {
    ship.upGrade = true;
  }
  if (key == 'W'||key == 'w') {
    ship.upGrade = false;
  }
  if (key == 'S'||key == 's') {
    for (int i = 0; i<aList.length-1; i++) {
      if (aList[i]!=null) {
        aList[i].aY+=50;
      }
    }
  }
}


 
