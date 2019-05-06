class ListBox{
  protected ArrayList<String> Elements = new ArrayList<String>();
  int x,y;
  int height,width;
  color normalColor,Highlight;
  PFont font;
  public int TextSize = 18;
  int triangle_length = 10;
  
  boolean enabled = true;
  boolean expand = false;
  int overbox = -1;
  int selected = -1;
  boolean visible = true;
  
  ListBox(int x,int y,int width,int height,color normalColor,color Highlight){
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.normalColor = normalColor;
    this.Highlight = Highlight;
    font = createFont("Arial",TextSize);
    add("Pre");
  }
  
  
  public void display(int mouseX,int mouseY){
	if(!visible)
	  return;
    overbox = overListBox(mouseX,mouseY);
    if(!enabled)
      fill(color(125));
    // 繪製最上方box
    stroke(150);
    if(overbox == 0)
      fill(Highlight);
    else
      fill(normalColor);
    rect(x, y, width, height,7);
    // 框內文字
    if(selected>0){
      textFont(font);
      fill(0, 0, 0);
      textSize(TextSize);
      text(Elements.get(selected), x +width/2 - textWidth(Elements.get(selected))/2,y + height/2 + textWidth("B")/2    ); // 水平垂直至中
    }
    // 倒三角形提示圖示
    fill(color(100));
    triangle(x + width - 20, y + height/2 - 0.35*triangle_length  ,x + width - 20 + triangle_length/2, y + height/2 + 0.35*triangle_length ,x + width - 20+ triangle_length, y + height/2 - 0.35*triangle_length );
    // 展開選項繪製
    if(expand){
      for(int i=1;i<Elements.size();i++){
        stroke(150);
        if(i == overbox) // 鼠標覆蓋
          fill(0, 140, 183,150);
        else
          fill(normalColor);
        rect(x, y + (i)*height, width, height,7);
        // 文字繪製
        textFont(font);
        textSize(TextSize);
        fill(0, 0, 0);
        text(Elements.get(i), x +width/2 - textWidth(Elements.get(i))/2,y + height/2 + textWidth("B")/2  + (i)*height   ); // 水平垂直至中
      }
    }
    
  }
  
  void mousePressed(){
    if(!expand){ // 尚未展開時
      if(overbox == 0) // 點擊清單box
        expand = true;
    }
    else{ // 清單已展開
      expand = false; // 關閉清單
      if(overbox > 0) // 選擇選項
        selected = overbox;
    }
  }
  
  public int getSelected(){return selected;}
  public String getValue(int index){
	return Elements.get(index);
  }
  
  public void add(String newElement){
    Elements.add(newElement);
  }
  public void remove(String Element){
    if(Elements.size() >1)
      Elements.remove(Element);
    if(Elements.get(0)!= "Pre")
      Elements.add(0,"Pre");
	selected = -1;
  }
  public void remove(int index){
    if(index > 0 && index < Elements.size())
      Elements.remove(index);
	selected = -1;
  }
  private int overListBox(int x, int y) {
      if (x >= this.x && x <= this.x + width) {
         if (y >= this.y && y <= this.y + height*(Elements.size()) ) {
            return (int)((y-this.y)/(height));
         }
      }
      return -1;
   }

}