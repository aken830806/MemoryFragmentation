class Navbar{
  float y;
  float h =50;
  ArrayList<RectButton> bList;//button list
  float button;
  
  Navbar(){
    y = height-h;
    bList = new ArrayList<RectButton>();
    bList.add(new RectButton(50,height-50,100,35,color(255),color(97,91,166),"Example"));
    bList.add(new RectButton(250,height-50,100,35,color(255),color(97,91,166),"Custom"));
    bList.add(new RectButton(450,height-50,100,35,color(255),color(97,91,166),"Random"));
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
          case "Example":
            initExample();
            mode = "example";
            break;
          case "Custom":
            initCustom();
            mode = "custom";
            break;
          case "Random":
            initRandom();
            mode = "random";
            break;
        }
      }
    }
  }
}
