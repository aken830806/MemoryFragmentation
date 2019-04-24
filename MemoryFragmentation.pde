Memory m;
PFont font;
ArrayList<Process> pList;//process list
ArrayList<Queue> qList;//queue list
boolean isStop;
boolean testMode = false;//(true/false)
int qCount;
boolean moving;
String showDescription = "";
Process removedProcess;
String mode;

RectButton AddProcessButton;
RectButton DeleteProcessButton;
RectButton PauseButton;
TextBox ProcessBox;
ArrayList<RectButton> bList;//button list
Navbar bar;

void setup(){
  // 設定視窗
  size(600, 700);
  smooth(10); // anti-aliased
  // 建立字體
  font = createFont("Arial",1);
  bar = new Navbar();
  init();
}
void draw(){
  noStroke();
  fill(235, 240, 242);
  rect(0, 0, width, height);
  
  if(mode != null){
    if(mode.equals("select")){
      for(RectButton button:bList){
        button.display();
      }
    }else{//example or custom
        pushMatrix();
        translate(width*0.5,10);
        m.display();

        // 如果非為移動中 且 list中還有操作 且不為暫停狀態 
        if(!moving && qCount < qList.size() && !isStop){
          qList.get(qCount).execute(); // 執行該操作
        }

        if(mode.equals("custom")){
          // 操作佇列
          textFont(font,16);
          for(int i= qCount + 1;i<qList.size();i++){
            text(qList.get(i).description,-250,20 + i*20);
          }
        }
        for(Process p:pList){
        // update pos
        if(!isStop)
          p.move();
        // update畫面
          p.display();
        }
        // 如果移除
        if(removedProcess != null && !isStop)
          removedProcess.move();
        if(removedProcess != null)
          removedProcess.display();

        fill(0);
        textFont(font,20);
        
        if(!moving)
          text(showDescription +"\n Click to next step.",m.width/2-50,600);
        else
          text(showDescription ,m.width/2-50,600);
        
        popMatrix();
        if(mode.equals("custom")){//custom
          stroke(255);
          // Button
          AddProcessButton.display(mouseX,mouseY);
          DeleteProcessButton.display(mouseX,mouseY);
          PauseButton.display(mouseX,mouseY);
          // InputBox
          ProcessBox.display(mouseX,mouseY);
        }
        // 操作結束
        if(qCount+1 >= qList.size())
          isStop = true;
        bar.display();
    }
  }else{
    bList = new ArrayList<RectButton>();
    bList.add(new RectButton(50,250,200,100,color(200),color(150),"example"));
    bList.add(new RectButton(350,250,200,100,color(200),color(150),"custom"));
    mode = "select";
  }
}
void mousePressed(){
  if(mode != null){
    if(mode.equals("select")){
      for(RectButton button:bList){
        if(button.getRectOver()){
          switch(button.Text){
            case "example":
              initExample();
              mode = "example";
              break;
            case "custom":
              initCustom();
              mode = "custom";
              break;
          }
        }
      }
    }else if(mode.equals("example")){
      if(isStop){
        isStop = false;
      }else{
        isStop = true;
      }
    }else if(mode.equals("custom")){
      if(isStop && PauseButton.getRectOver()){ // 進行下一步或恢復播放
        //loop();
        isStop = false;
      if(PauseButton.Text == "Start"){
        qList.add(new Queue("f",""));
        AddProcessButton.enabled = false;
        DeleteProcessButton.enabled = false;
      }
      PauseButton.Text = "Pause";
      if(moving == false)
        qCount += 1;
      }else if( PauseButton.getRectOver() ){ // 暫停
        //noLoop();
        isStop = true;
        PauseButton.Text = "Play";
      }
      
      if(AddProcessButton.getRectOver()){
        qList.add(new Queue("+",ProcessBox.Text));
      }
      if(DeleteProcessButton.getRectOver()){
        qList.add(new Queue("-",ProcessBox.Text));
      }
    }
    bar.mousePressed();
  }
}
void init(){
  isStop = true;
  moving = false;
  showDescription = "";
}
void initExample(){
  qCount = 0;
  m = new Memory();
  pList = new ArrayList<Process>();
  qList = new ArrayList<Queue>();
  qList.add(new Queue("+","24"));
  qList.add(new Queue("+","48"));
  qList.add(new Queue("+","72"));
  qList.add(new Queue("+","96"));
  qList.add(new Queue("+","320"));
  qList.add(new Queue("-","P3"));
  qList.add(new Queue("-","P4"));
  qList.add(new Queue("+","56"));
  qList.add(new Queue("+","120"));
  qList.add(new Queue("-","P4"));
  qList.add(new Queue("f",""));
}
void initCustom(){
  qCount = -1;
  // 記憶體區塊
  m = new Memory();
  // 行程list
  pList = new ArrayList<Process>();
  // 新增process按鈕
  AddProcessButton = new RectButton(10,500,70,35,color(200),color(150));
  AddProcessButton.Text = "Add";
  DeleteProcessButton = new RectButton(90,500,85,35,color(200),color(150));
  DeleteProcessButton.Text = "Release";
  PauseButton = new RectButton(10,560,80,35,color(200),color(150));
  PauseButton.Text = "Start";
  // Input Box
  ProcessBox = new TextBox(10,450,100,30);
  qList = new ArrayList<Queue>();
} 
void keyPressed() {
  if(mode.equals("custom"))
    ProcessBox.KeyPressed(key,keyCode);
}
void showPlist(){
  println("======");
  for(Process p:pList){
    println(p.title);
  }
  println("======");
}
