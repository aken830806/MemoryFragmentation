class RectButton{
  private boolean rectOver;
  int width,height;
  int x,y;
  color normalColor,Highlight;
  color fontColor,fontHighlight;
  PFont font;
  String Text = "";
  public int TextSize = 18;
  boolean enabled = true;
  boolean visible = true;
  
  RectButton(int x,int y,int width,int height,color normalColor,color Highlight){
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.normalColor = normalColor;
    this.Highlight = Highlight;
    font = createFont("AdobeGothicStd-Bold.otf",TextSize);
  }
  RectButton(int x,int y,int width,int height,color normalColor,color Highlight,String text){
    this(x,y,width,height,normalColor,Highlight);
    this.Text = text;
  }
  
  RectButton(RectButton otherButton){
    width = otherButton.width;
    height = otherButton.height;
    x = otherButton.x;
    y = otherButton.y;
    normalColor = otherButton.normalColor;
    Highlight = otherButton.Highlight;
    font = otherButton.font;
  }
  
  protected boolean overRect(int mouseX, int mouseY)  {
    if (mouseX >= x && mouseX <= x+width && 
        mouseY >= y && mouseY <= y+height) {
      return true;
    }
    else {
      return false;
    }
  }
  void display(int mouseX,int mouseY){
    if(!visible)
      return;
      rectOver = overRect(mouseX,mouseY);
    if(!enabled)
      fill(color(125));
    else if (rectOver) {
        fill(Highlight);
    }else {
      fill(normalColor);
    }
    stroke(255);
    rect(x, y, width, height,25,25,25,25);
    
    //正面字體顏色
    if(!enabled)
      fill(color(97,91,166));
    else if (rectOver) {
        fill(color(255));
    }
    else {
      fill(color(97,91,166));
    }
    textFont(font);
    text(Text, x + width/2 - textWidth(Text)/2  ,y+height/2 + TextSize*0.6f/2);
  }
  boolean getRectOver(){ if(!enabled) return false;return rectOver; }
  void display(){
    display(mouseX,mouseY);
  }
}
