class Rect {
  PVector pos;
  PVector size;

  float halfW;
  float halfH;

  public Rect (PVector position_, PVector size_) {
    pos = position_;
    size = size_;
    halfW = size.x/2f;
    halfH = size.y/2f;
  }

  public Rect(float x, float y, float w, float h) {
    pos = new PVector(x, y);
    size = new PVector(w, h);
  }

  boolean IntersectsCircle(PVector circlePos, float circleRadius) {
    //a ball collision is basically saying:
    // the distance from the rectangle to the circle position is shorder than the radius
    float clampedX = constrain(circlePos.x, pos.x - halfW, pos.x + halfW);
    float clampedY = constrain(circlePos.y, pos.y - halfH, pos.y + halfH);

    float distanceToRectangle = PVector.dist(new PVector(clampedX, clampedY), circlePos);
    boolean isInRadius = distanceToRectangle < circleRadius;

    return isInRadius;
  }


  PVector ResolveCollisionVector(PVector point, PVector velocity) {
    if (CollidesVertically(point)) {//y axis
      boolean movingDownTowards = velocity.y < 0 && point.y > pos.y;
      boolean movingUpTowards = velocity.y > 0 && point.y < pos.y;

      if (movingUpTowards || movingDownTowards) {
        return new PVector(velocity.x, -velocity.y);
      }
    } else {//x axis

      boolean movingRightTowards = velocity.x > 0 && point.x < pos.x;
      boolean movingLeftTowards = velocity.x < 0 && point.x > pos.x;

      if (movingRightTowards || movingLeftTowards) {
        return new PVector(-velocity.x, velocity.y);
      }
    }

    return velocity;
  }

  boolean CollidesVertically(PVector point) {
    float xDist = abs(pos.x - point.x) * (size.y / size.x);//aspect ratio
    float yDist = abs(pos.y - point.y);
    return xDist < yDist;
  }


  void Draw() {
    rectMode(CENTER);
    rect(pos.x, pos.y, size.x, size.y);
  }
}
