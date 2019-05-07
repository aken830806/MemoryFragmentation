class TextBox {
   public int x = 0, y = 0, height = 35, width = 200;
   public int TextSize = 18;
   int frames = 0;
   // COLORS
   public color Background = color(150, 150, 150);
   public color Foreground = color(0, 0, 0);
   public color BackgroundSelected = color(190, 190, 190);
   public color Border = color(30, 30, 30);
   
   public boolean BorderEnable = false;
   public int BorderWeight = 1;
   
   public String Text = "";
   public int TextLength = 0;

   private boolean selected = false;
   boolean enabled = true;
   
   TextBox() {
   }
   
   TextBox(int x, int y, int w, int h) {
      this.x = x;
      this.y = y;
      this.width = w;
      this.height = h;
   }
   
   void display(int mouseX,int mouseY) {
    if(enabled == true)
     Pressed(mouseX,mouseY);
      if (selected) {
         fill(BackgroundSelected);
      } else {
         fill(Background);
      }
      
      if (BorderEnable) {
         strokeWeight(BorderWeight);
         stroke(Border);
      } else {
         noStroke();
      }
      
      rect(x, y, width, height);
      fill(Foreground);
      textSize(TextSize);
      text(Text, x + (textWidth("a") / 2), y + TextSize);
	  if(selected && frames >= 30){
        fill(color(0));
        rect(x + textWidth(Text)+textWidth("a")/2,y +textWidth("a")/2,2,textWidth("a")*2);
      }
      frames = (frames+1)%61;
	  
   }
   
   // IF THE KEYCODE IS ENTER RETURN 1
   // ELSE RETURN 0
   boolean KeyPressed(char KEY, int KEYCODE) {
    if(!enabled)
	  return false;
      if (selected) {
         if (KEYCODE == (int)DELETE) {
            BackSpace();
         } else if (KEYCODE == 32) {
            // SPACE
            addText(str(' '));
         } else if (KEY == (int)ENTER) {
            return true;
         } else {
            // CHECK IF THE KEY IS A LETTER OR A NUMBER
            boolean isKeyCapitalLetter = (KEY >= 'A' && KEY <= 'Z');
            boolean isKeySmallLetter = (KEY >= 'a' && KEY <= 'z');
            boolean isKeyNumber = (KEY >= '0' && KEY <= '9');
      
            if (isKeyCapitalLetter || isKeySmallLetter || isKeyNumber) {
               addText(str(KEY));
            }
         }
      }
      
      return false;
   }
   
   private void addText(String text) {
      // IF THE TEXT WIDHT IS IN BOUNDARIES OF THE TEXTBOX
      if (textWidth(Text + text) < width) {
         Text += text;
         TextLength++;
      }
   }
   
   private void BackSpace() { // delete 
      if (TextLength - 1 >= 0) {
         Text = Text.substring(0, TextLength - 1);
         TextLength--;
      }
   }
   
   private boolean overBox(int x, int y) {
      if (x >= this.x && x <= this.x + width) {
         if (y >= this.y && y <= this.y + height) {
            return true;
         }
      }
      return false;
   }
   void Pressed(int x, int y) {
      if (overBox(x, y)) {
         selected = true;
      } else {
         selected = false;
      }
   }
}
