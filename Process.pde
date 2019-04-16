class Process {
  String title = "";
  float space;
  float x = -m.width/2;
  float y;
  float currentX = m.width/2;
  boolean moved;
  boolean remove = false;

  Process(float space,float y) {
    this.space = space;
    this.y = y;
  }
  Process(float space,float y,String title) {
    this(space,y);
    this.title = title;
    remove = true;
    currentX = x;
    x = m.width/2;
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
      if (currentX > x){
        currentX -= 2;
      }else if(currentX < x){
        currentX += 2;
      }else{
        if(remove){
          removedProcess = null;
          m.updateTitle();
        }else{
          moved = true;
        }
        isStop = true;
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
