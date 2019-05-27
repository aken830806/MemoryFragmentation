class Navbar{
  float y;
  float h = 40;
  ArrayList<RectButton> bList;//button list
  float button;
  
  Navbar(){
    y = height-h;
    bList = new ArrayList<RectButton>();
    bList.add(new RectButton(50,height-35,100,35,color(200),color(150),"example"));
    bList.add(new RectButton(250,height-35,100,35,color(200),color(150),"custom"));
    bList.add(new RectButton(450,height-35,100,35,color(200),color(150),"random"));
  }
  void display(){
    fill(0);
    rect(0,y,width,height);
    for(RectButton button:bList){
      button.display();
    }
  }
  void mousePressed(){
    for(RectButton button:bList){
      if(button.getRectOver()){
        init();
        switch(button.Text){
          case "example":
            initExample();
            mode = "example";
            break;
          case "custom":
            initCustom();
            mode = "custom";
            break;
          case "random":
            initRandom();
            mode = "random";
            break;
        }
      }
    }
  }
}
