class Ball {
  //ball
  PVector pos;
  PVector velocity;
  PVector direction;
  float diameter;

  public Ball(PVector position_, float diameter_, float speed_) {
    pos = position_;
    diameter = diameter_;
    direction = new PVector(0, 1);
    velocity = PVector.mult(direction, speed_);
  }

  void Draw() {
    colorMode(HSB);
    // float hue = GetScoreColor(score);
    fill(255);//hue, 200, 256);
    circle(pos.x, pos.y, diameter);
  }

  void Bounce(PVector newVelocity) {
    ball.velocity = newVelocity;
    float speed = ball.velocity.mag() + 0.1f;
    ball.velocity = ball.velocity.normalize().mult(speed);
  }

  void HandleWallCollision() {

    if (pos.y < 0) {
      Bounce(new PVector(ball.velocity.x, abs(ball.velocity.y)));
    }

    if (pos.x < 0) {
      Bounce(new PVector(abs(ball.velocity.x), ball.velocity.y));
    }

    if (pos.x > width) {
      Bounce(new PVector(-abs(ball.velocity.x), ball.velocity.y));
    }
  }

  void HandlePaddleCollision(Rect rect) {

    if (rect.IntersectsCircle(pos, diameter /2f)) {

      Bounce(rect.ResolveCollisionVector(pos, velocity));

      //adjust direction based on where we hit on the paddle
      float prevMagnitude = velocity.mag();
      float paddleBallDelta = pos.x - rect.pos.x;

      velocity.x = paddleBallDelta /6;
      velocity.x += random(-1, 1);

      //return magnitude to where it was so speed doesn't go up based on bad angle
      velocity = velocity.normalize().mult(prevMagnitude);
    }
  }

  void UpdatePhysics() {
    pos = PVector.add(pos, velocity);
  }
}
