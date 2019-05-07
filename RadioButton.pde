class RadioButton{
  int radius;
  int thickness;
  int x,y;
  color normalColor,Highlight;
  PFont font;
  String Text;
  public int TextSize = 18;
  boolean enabled = true;
  boolean selected = false;
  private boolean circleOver;
  
  RadioButton(int x,int y,int radius,int thickness,color normalColor,color Highlight){
    this.x = x;
    this.y = y;
    this.radius = radius;
    this.thickness = thickness;
    this.normalColor = normalColor;
    this.Highlight = Highlight;
    font = createFont("Arial",TextSize);
  }
  
  void display(int mouseX,int mouseY){
    circleOver = overCircle(mouseX,mouseY,radius*2);
    color borderColor;
    color circleColor;
    // 未啟用
    if(!enabled){
      circleColor = color(125);
      borderColor = color(255);
    }
    else if (selected ) { // 被選取
      circleColor = Highlight;
      borderColor = color(40);
      if(circleOver) // 游標覆蓋
        borderColor = color(0, 102, 153);
      // 圓圈繪製
      noStroke();
      fill(circleColor);
      ellipse(x, y, radius*2, radius*2);
    }
    else if(circleOver){ // 游標覆蓋
      borderColor = color(0, 102, 153);
    }
    else {
      circleColor = normalColor;
      borderColor = color(40);
    }
    // border繪製
    stroke(borderColor); 
    noFill();
    for(int i = radius;i<= radius + thickness;i++){
      ellipse(x, y, radius*2+i, radius*2+i);
    }
    textFont(font);
    fill(0, 0, 0);
    textSize(TextSize);
    text(Text, x + radius + thickness + 10 ,y + textWidth("B")/2   );
  }
  void mousePressed(){
    if (circleOver)
      selected = !selected;
  }
  
  protected boolean overCircle(int mouseX, int mouseY,int diameter)  {
    float disX = x - mouseX;
    float disY = y - mouseY;
    if(sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
      return true;
    }
    else {
      return false;
    }
  }
  
}
