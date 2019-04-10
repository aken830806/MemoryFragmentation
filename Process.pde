class Process {
  String title = "";
  float length;
  float y = 0;
  float currentX = m.width/2;
  float currentY = 0;
  float end;

  Process(float length,float y) {
    this.y = y;
    this.length = length;
    end = y + length;
  }
  void display() {
    if (currentY < y)
      currentY += 2;
    else if (currentX > -m.width/2)
      currentX -= 2;
      
    if (title.equals("Free"))
      fill(235, 240, 242);
    else
      fill(255);
    rect(currentX, currentY, m.width, length);

    fill(0);
    textFont(font, 14);
    float textY = 16;
    if (length/2 > textY)
      textY = length/2;
    text(title + " " + length/2 + "K", currentX, currentY+textY);
  }
}
