//game state
boolean playing;
int score;
Ball ball;
Paddle paddle;
Brick[] bricks;

int columns;
int rows;

boolean win;

public void settings() {
  columns = 8;
  rows = 3;
  int fullWidth = (int)(columns*Brick.width);
  size(fullWidth, 350);
}

void setup() {
  playing = false;

  //instantiate ball
  PVector ballPos = new PVector(width/2, height/2);
  ball = new Ball(ballPos, 30, 5);

  //instantiate paddle
  PVector paddleSize = new PVector(120, 14);
  PVector paddlePos = new PVector(width/2, height - paddleSize.y*2);
  paddle = new Paddle(new Rect(paddlePos, paddleSize));

  //instantiate bricks
  SetupBricks();

  score = 0;
  win = false;
}

void draw() {

  //physics
  if (playing && !win) {
    ball.UpdatePhysics();
  }

  paddle.HandleInput();
  ball.HandleWallCollision();
  ball.HandlePaddleCollision(paddle.rect);
  HandleGameOverCondition();

  //graphics
  background(0);
  UpdateBricks();
  ball.Draw();
  paddle.Draw();
  DrawScore();

  if (win) {
    DrawWinMessage();
  }
}

void SetupBricks() {
  bricks = new Brick[columns*rows];
  PVector halfSize = new PVector(Brick.width /2f, Brick.height/2f);
  int alpha = 1;
  int beta = alpha;
  alpha = 3;
  println(beta);

  for (int y = 0; y < rows; y++) { //for every row
    for (int x = 0; x < columns; x++) { //for every column
      //set the position
      PVector brickPos = new PVector(x * Brick.width, y *Brick.height );

      //offset by half, since they're drawn from the centre
      brickPos = PVector.add(brickPos, halfSize);

      //add to the array
      bricks[y*columns + x] = new Brick(brickPos);
    }
  }
}

void UpdateBricks() {
  int brokenCount = 0;

  for (int index = 0; index < bricks.length; index++) {
    Brick b = bricks[index];

    if (b.struck == false) {
      if (b.rect.IntersectsCircle(ball.pos, ball.diameter /2f)) {
        b.Strike();//bounce ball, remove brick from collision
      }
      b.Draw();
    } else {
      brokenCount++;
    }
  }
  if (brokenCount == bricks.length) {
    win = true;
  }
}

void HandleGameOverCondition() {
  if (ball.pos.y > paddle.rect.pos.y + paddle.rect.size.y) {
    //game over
    ball.velocity = new PVector(0, 0);
  }
}

float GetScoreColor(float score) {
  return 180-(score*3);
}

void DrawScore() {
  fill(255);
  stroke(0);
  textSize(22);
  textAlign(CENTER);
  text(score, paddle.rect.pos.x, paddle.rect.pos.y - paddle.rect.size.y );
}

void DrawWinMessage() {
  colorMode(RGB);
  fill(100, 255, 100);
  stroke(0);
  textSize(48);
  textAlign(CENTER);
  text("YOU WIN", width/2, height/2 );
}

void mousePressed() {
  if (playing == false) {
    playing = true;
    ball.velocity = PVector.mult(ball.direction, ball.velocity.mag());
  } else {
    setup();
  }
}

void BrickDebug() {
  Brick b = bricks[30];
  PVector mousePos = new PVector(mouseX, mouseY);
  if (b.rect.IntersectsCircle(mousePos, 1)) {

    if (b.rect.CollidesVertically(mousePos)) {
      b.SetColour(new PVector(255, 0, 0));
    } else {
      b.SetColour(new PVector(0, 0, 255));
    }
  } else {
    b.SetColour(new PVector(255, 255, 255));
  }

  b.Draw();
}
