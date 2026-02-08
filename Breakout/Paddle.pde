class Paddle {
  //paddle
  Rect rect;

  Paddle(Rect rect_) {
    rect = rect_;
  }


  void Draw() {
    fill(255);
    rectMode(CENTER);
    rect.Draw();
  }
  void HandleInput() {
    rect.pos.x = mouseX;
  }
}
