class Process {
  String title = "";
  float space;
  float x = -m.width/2;
  float y;
  float currentX = m.width/2;
  boolean moved;
  boolean remove = false;

  Process(float space,float y) { // 
    this.space = space;
    this.y = y;
    title = "P" + process_index;
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
	// draw 2*space 
    rect(currentX, y, m.width, space * 2);
    fill(0);
    textFont(font, 14);
    float textY = space;
    if(textY<0)
      textY *= -1;
    text(title + " " + space + "K", currentX +10 , y+textY);
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
        }else{
          moved = true;
        }
        isStop = true;
        moving = false;
        if(mode.equals("example")){
          qCount += 1;
        }else if(mode.equals("custom")){
		      pauseButton.Text = "Play";
        }
      }

    }
  }
  void setY(float y){
    this.y = y;
    moved = false;
  }
}
