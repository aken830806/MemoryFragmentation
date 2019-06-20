class Navbar{
  float y;
  float h =50;
  ArrayList<RectButton> bList;//button list
  float button;
  
  Navbar(){
    y = height-h;
    bList = new ArrayList<RectButton>();
    bList.add(new RectButton(50,height-50,100,35,color(255),color(97,91,166),"範例模式"));
    bList.add(new RectButton(250,height-50,100,35,color(255),color(97,91,166),"自訂模式"));
    bList.add(new RectButton(450,height-50,100,35,color(255),color(97,91,166),"隨機模式"));
  }
  void display(){
    for(RectButton button:bList){
      button.display();
    }
  }
  void mousePressed(){
    for(RectButton button:bList){
      if(button.getRectOver()){
        init();
        switch(button.Text){
          case "範例模式":
            initExample();
            mode = "example";
            break;
          case "自訂模式":
            initCustom();
            mode = "custom";
            break;
          case "隨機模式":
            initRandom();
            mode = "random";
            break;
        }
      }
    }
  }
}
