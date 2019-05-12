class ProgressBar{
  float value;
  int x,y,width,height;
  private int frames = 0;
  PFont font;
  ProgressBar(int x,int y,int width,int height){
    this. x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    value = 0;
    font = createFont("JF Dot Ayu Gothic 18", 48);
  }
  
  void display(){
    noFill();
    stroke(20);
    fill(50);
    rect(x, y+3, width, height, 7); // 邊框
    fill(230);
    rect(x+1, y+3, value/100*(width-1), height-2, 7); // bar
    rect(x-30, y-4, width+60, 2); // 底限
    textSize(48);
    textFont(font);
    text((int)value+"%", x - textWidth( ((int)value+"%") )  + (width+90)/2, y-6); 
    String load_message = "loading"; 
    if(value <100){ // 載入中
      if(frames > 90 ){
        load_message += "...";
      }
      else if(frames >60 ){
        load_message += "..";
      }
      else if(frames > 30){
        load_message += ".";
      }
    }
    else{ // 完成
      if( (frames > 30 &&frames < 60) || (frames > 90 && frames < 120))
        load_message = "loading completed";
      else
        load_message = "";
    }
    textFont(font);
    textSize(26);
    text(load_message, x, y+height+25); 
    frames++;
    if(frames >= 120)
      frames = 0;
  }

}
