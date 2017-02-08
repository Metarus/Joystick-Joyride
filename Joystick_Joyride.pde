import ddf.minim.*;
/*
Rana Lulla's Project
 I don't really have a formal name as of yet, but it's basically a joystick
 controlled game where you dodge bullets and waves of projectiles.
 */
float multiplier=0.75;
int screenState, timer, attackPattern, score;
boolean died, nightMode;
Minim minim;
AudioPlayer music;

//Declaring the player
Player player = new Player();
//Declaring all of the arraylists for all of the projectiles
ArrayList<ProjectileNormal> normalProjectiles = new ArrayList<ProjectileNormal>();
ArrayList<ProjectileHoming> homingProjectiles = new ArrayList<ProjectileHoming>();
ArrayList<ProjectileHomingAccurate> accurateHomingProjectiles = new ArrayList<ProjectileHomingAccurate>();


void setup()
{
  //Setting up the minim
  minim = new Minim(this);
  
  music = minim.loadFile("Megalovania.mp3");
  imageMode(CENTER);
  fullScreen(P2D);
  textAlign(CENTER);
  noCursor();
}
void draw()
{
  //Basic screenState switch
  switch(screenState)
  {
  case 0:
    startScreen();
    break;
  case 1:
    music.play();
    gameCode();
    if (died)
    {
      //Stopping the music if you die
      music.close();
      screenState=2;
      //Re opening it but not playing 
      music = minim.loadFile("Megalovania.mp3");
    }
    break;
  case 2:
    died();
    break;
  case 3:
    player.tutorial();
    break;
  }
  fill(0, 0, 255);
  ellipse(mouseX, mouseY, 10, 10);
  fill(255);
}
void startScreen()
{
  //Initial Screen
  background(0);
  textSize(75);
  //Night Mode button
  text("Night Mode", width/2, 200);
  if (mousePressed&&mouseX>500&&mouseX<780&&mouseY>125&&mouseY<225)
  {
    nightMode=true;
    screenState=1;
  }
  textSize(200);
  //Normal mode button
  text("Start", width/2, height/2);
  if (mousePressed&&mouseX>400&&mouseX<880&&mouseY>300&&mouseY<450)
  {
    nightMode=false;
    screenState=1;
  }
  textSize(75);
  //Tutorial button
  text("Tutorial", width/2, (height/2)+100);
  if (mousePressed&&mouseX>500&&mouseX<780&&mouseY>450&&mouseY<600)
  {
    screenState=3;
  }
}
void gameCode()
{
  //Different backgrounds based on nightMode being true/false
  if (nightMode==false)
  {
    background(255);
  }
  if (nightMode==true)
  {
    background(0);
    ellipse(player.x, player.y, 600, 600);
  }
  //Runs randomiser every 5 seconds
  if (millis()>timer)
  {
    //Sets player back to midpoint
    player.x=width/2;
    player.y=3*(height/4);
    //Random attack pattern
    attackPattern=int(random(1, 7));
    timer=millis()+5000;
    //Running the code to initialise the attacks
    switch(attackPattern)
    {
    case 1: 
      Attack1();
      break;
    case 2:
      Attack2();
      break;
    case 3:
      Attack3();
      break;
    case 4:
      Attack4();
      break;
    case 5:
      Attack5();
      break;
    case 6:
      Attack6();
      break;
    }
  }
  //Updating everything else
  attackUpdate();
  player.movementCode();
  //Updates the score and multiplier
  score++;
  multiplier+=0.00025; //Rate of 0.25 per 1000 points, just a smaller scale for more accurate updating
  textSize(10);
  //Different colored text (white for night mode and black for normal mode) for the score
  if (nightMode)
  {
    fill(255);
    text(score, 10, 10);
    text(millis()-timer, width-20, 20);
  } else
  {
    fill(0);
    text(timer-millis(), width-20, 10);
    text(score, 10, 10);
  }
}
void attackUpdate()
{
  //Runs through all of the code for updating the projectiles; collision, movement, and if it collides kill the player
  for (int i=0; i<normalProjectiles.size(); i++)
  {
    ProjectileNormal part = normalProjectiles.get(i);
    part.move();
    part.collision();
    if (part.collide)
    {
      died=true;
    }
  }
  for (int i=0; i<accurateHomingProjectiles.size(); i++)
  {
    ProjectileHomingAccurate part = accurateHomingProjectiles.get(i);
    part.move();
    part.collision();
    if (part.collide)
    {
      died=true;
    }
  }
  for (int i=0; i<homingProjectiles.size(); i++)
  {
    ProjectileHoming part = homingProjectiles.get(i);
    part.move();
    part.collision();
    if (part.collide)
    {
      died=true;
    }
  }
}
void killAll()
{
  //Clear all projectiles before every wave
  normalProjectiles.clear();
  homingProjectiles.clear();
  accurateHomingProjectiles.clear();
}
void died()
{
  //The respawn screenState
  background(0);
  killAll();
  textSize(50);
  text("You died!", width/2, height/3);
  textSize(30);
  text("Click to play again!", width/2, 2*(height/3));
  text(score, width/2, height/2);
  text("Back", 35, 30);
  if (mousePressed&&mouseX<90&&mouseY<40)
  {
    screenState=0;
    reset();
  } else if (mousePressed)
  {
    reset();
    screenState=1;
  }
}
void reset()
{
  //Sets values back to normal
  multiplier=0.75;
  player.x=width/2;
  player.y=2*(height/3);
  score=0;
  died=false;
  timer=0;
}