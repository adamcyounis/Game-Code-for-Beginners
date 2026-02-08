class Brick {

  Rect rect;
  static final int width = 80;
  static final int height = 30;
  PVector colour;
  boolean struck;

  public Brick(PVector position_) {
    rect = new Rect(position_, new PVector(width, height));
    colour = new PVector(100, 200, 100);
    struck = false;
  }

  void SetColour(PVector col) {
    colour = col;
  }

  void Strike() {
    struck = true;
    SetColour(new PVector(255, 0, 0));//flash red
    ball.Bounce(rect.ResolveCollisionVector(ball.pos, ball.velocity));//bounce the ball
    score++;//tick up the game score
  }

  void Draw() {
    colorMode(RGB);
    fill(colour.x, colour.y, colour.z);
    rect.Draw();
  }
}
