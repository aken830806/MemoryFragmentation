class Process {
  String title = "";
  float space;
  float y;
  float currentX = m.width/2;
  float end;
  boolean moved;

  Process(float space,float y) {
    this.space = space;
    this.y = y;
    end = y + space;
  }
  void display() {
    if (title.equals("Free"))
      fill(235, 240, 242);
    else
      fill(255);
    rect(currentX, y, m.width, space);

    fill(0);
    textFont(font, 14);
    float textY = 16;
    if (space/2 > textY)
      textY = space/2;
    text(title + " " + space/2 + "K", currentX, y+textY);
  }
  void move(){
    if(!moved){
      if (currentX > -m.width/2){
        currentX -= 2;
      }else{
        isStop = true;
        moved = true;
        moving = false;
        qCount += 1;
        noLoop();
      }
    }
  }
  void setY(float y){
    this.y = y;
    moved = false;
  }
}
