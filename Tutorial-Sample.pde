//ball
PVector ballPos;
PVector velocity;
PVector direction;
float speed;
int diameter;

//paddle
PVector paddlePos;
PVector paddleSize;

//game state
boolean playing;
int bounceCount;

void setup() {
  playing = false;
  size(600, 350);
  speed = 5;
  diameter = 60;

  ballPos = new PVector(width/2, 0);
  direction = new PVector(0, 1);
  velocity = PVector.mult(direction, speed);
  paddleSize = new PVector(120, 14);
  paddlePos = new PVector(width/2, height - paddleSize.y*2);
  bounceCount = 0;
}

void draw() {
  //physics
  if (playing) {
    UpdatePhysics();
  }

  HandleInput();
  HandleBounce();

  //graphics
  background(0);

  DrawBall();
  DrawPaddle();
  DrawScore();
}

void UpdatePhysics() {
  ballPos = PVector.add(ballPos, velocity);
}

void HandleBounce() {

  if (ballPos.y < 0) {
    velocity.y = speed;
  }

  if (ballPos.x < 0) {
    float absX = abs(velocity.x);
    velocity.x = absX;
  }

  if (ballPos.x > width) {
    float absX = abs(velocity.x);
    velocity.x = -absX;
  }

  HandlePaddleCollision();

  if (ballPos.y > paddlePos.y + paddleSize.y ) {
    //game over
    velocity = new PVector(0, 0);
  }
}

void HandlePaddleCollision() {
  //paddle extents
  float halfWidth = (paddleSize.x/2);
  float paddleLeft = paddlePos.x - halfWidth;
  float paddleRight = paddlePos.x + halfWidth;

  //ball extents
  float ballRadius = diameter/2f;
  float ballLeft = ballPos.x - ballRadius;
  float ballRight = ballPos.x + ballRadius;

  boolean ballInPaddleX = ballRight > paddleLeft && ballLeft < paddleRight;
  boolean ballInPaddleY = ballPos.y + ballRadius > paddlePos.y && velocity.y > 0;

  if (ballInPaddleX && ballInPaddleY) {
    Bounce();
  }
}

void Bounce() {
  bounceCount++;
  speed = speed + 0.66f;
  velocity.y = -speed;
  float paddleBallDelta = ballPos.x - paddlePos.x;
  velocity.x = paddleBallDelta /3;
  velocity.x += random(-1, 1);
}

void DrawBall() {
  colorMode(HSB);
  float hue = GetScoreColor(bounceCount);
  fill(hue, 200, 256);
  circle(ballPos.x, ballPos.y, diameter);
}

float GetScoreColor(float score) {
  return 180-(score*3);
}

void DrawScore() {
  fill(255);
  textSize(22);
  text(bounceCount, 22, 22 );
}

void DrawPaddle() {
  fill(255);
  rectMode(CENTER);
  rect(paddlePos.x, paddlePos.y, paddleSize.x, paddleSize.y);
}

void HandleInput() {
  paddlePos.x = mouseX;
  // paddlePos.y = mouseY;
}

void mousePressed() {
  if (playing == false) {
    playing = true;
    velocity = PVector.mult(direction, speed);
  } else {
    setup();
  }
}


