Memory m;
ArrayList<Process> pList;
ArrayList<Queue> qList;
PFont font;
boolean isStop = true;
boolean testMode = false;//(true/false)
int qCount = -1;
boolean moving = false;
String showDescription = "Click to Start";
Process removedProcess;

RectButton AddProcessButton;
RectButton DeleteProcessButton;
RectButton PauseButton;
TextBox ProcessBox;

ButtonGroup ModeGroup ;
ListBox ProcessList;
void setup(){
  // 設定視窗
  size(600, 650);
  smooth(10); // anti-aliased
  // 建立字體
  font = createFont("Arial",1);
  // 記憶體區塊
  m = new Memory();
  // 行程list
  pList = new ArrayList<Process>();
  // 新增process按鈕
  AddProcessButton = new RectButton(140,370,70,35,color(200),color(150));
  AddProcessButton.Text = "Add";
  DeleteProcessButton = new RectButton(40,370,145,35,color(200),color(150));
  DeleteProcessButton.Text = "Release";
  // Play 按鈕
  PauseButton = new RectButton(225,585,80,35,color(200),color(150));
  PauseButton.Text = "Start";
  // Input Box
  ProcessBox = new TextBox(20,372,110,30);
  qList = new ArrayList<Queue>();
  // play/release mode選擇按鈕
  RadioButton PlayRadioButton,ReleaseRadioButton;
  PlayRadioButton = new RadioButton(40,350,5,3,color(255),color(30));
  PlayRadioButton.Text = "Add";
  PlayRadioButton.TextSize = 16;
  
  ReleaseRadioButton = new RadioButton(120,350,5,3,color(255),color(30));
  ReleaseRadioButton.Text = "Rlease";
  ReleaseRadioButton.TextSize = 16;
  ModeGroup = new ButtonGroup();
  ModeGroup.add(PlayRadioButton);
  ModeGroup.add(ReleaseRadioButton);
  
  ProcessList = new ListBox(35,420,160,30,color(220),color(240));
  ProcessList.TextSize = 16;
}
void draw(){
  noStroke();
  fill(235, 240, 242);
  rect(0, 0, width, height);
  pushMatrix();
  translate(width*0.5,10);
  m.display();
  // 如果非為移動中 且 list中還有操作 且不為暫停狀態 
  if(!moving && qCount < qList.size() && !isStop){
    qList.get(qCount).execute(); // 執行該操作
  }
  // 操作佇列
  textFont(font,16);
  for(int i= qCount + 1;i<qList.size();i++){
	text(qList.get(i).description,-250,20 + i*20);
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
  if(testMode){
    println(frameCount);
    println(qCount+1);
  } //<>//
  fill(0);
  textFont(font,20);
  if(!moving && PauseButton.Text!="Start")
	text(showDescription +"\n Click to next step.",m.width/2-50,600);
  else
    text(showDescription ,m.width/2-50,600);
  popMatrix();
  // mode選擇
  if(ModeGroup.getFirstSelected() == 0){ // add mode
	AddProcessButton.visible = true;
	ProcessBox.visible = true;
	ProcessList.visible = false;
	DeleteProcessButton.visible = false;
  }
  else if(ModeGroup.getFirstSelected() == 1){ // release mode
	AddProcessButton.visible = false;
	ProcessBox.visible = false;
	ProcessList.visible = true;
	DeleteProcessButton.visible = true;
  }
  else{
	AddProcessButton.visible = false;
	ProcessBox.visible = false;
	ProcessList.visible = false;
	DeleteProcessButton.visible = false;
  }
  // 互動元件繪製
  stroke(255);
  // Button
  AddProcessButton.display(mouseX,mouseY);
  PauseButton.display(mouseX,mouseY);
  DeleteProcessButton.display(mouseX,mouseY);
  // InputBox
  ProcessBox.display(mouseX,mouseY);
  // radio button group
  ModeGroup.display(mouseX,mouseY);
  // ProcessList
  ProcessList.display(mouseX,mouseY);
  // 操作結束
  if(qCount+1 >= qList.size() && !AddProcessButton.enabled ){
    isStop = true;
	PauseButton.Text = "Reset";
  }
}
void mousePressed(){
  if(PauseButton.Text == "Reset"){ // 已經Finish 進行reset
	AddProcessButton.enabled = true;
	DeleteProcessButton.enabled = true;
	PauseButton.Text = "Start";
	m = new Memory();
	pList = new ArrayList<Process>();
	qList = new ArrayList<Queue>();
	ProcessList = new ListBox(35,420,160,30,color(220),color(240));
	qCount = -1;
	moving = false;
	showDescription = "Click to Start";
  }
  else if(isStop && PauseButton.getRectOver()){ // 進行下一步或恢復播放
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
  }
  else if( PauseButton.getRectOver() ){ // 暫停
    //noLoop();
    isStop = true;
	PauseButton.Text = "Play";
  }
  if(AddProcessButton.getRectOver()){ // 新增process
	// string to Char array to get ascii code in js
	// 直接用charAt(i)會得到值為0
	int[] AddInput = int( ProcessBox.Text.toCharArray() );
	int i;
	if(ProcessBox.Text.length() > 0){ // 增加process
		qList.add(new Queue("+",ProcessBox.Text));
		ProcessList.add("P" + qList.size() + " - " + ProcessBox.Text + "k");
		ProcessBox.Text = ""; // 清空
	}
	else{
		showDescription = "Wrong !" ;
	}
  }
  if(DeleteProcessButton.getRectOver()){ // 釋放process
	if(ProcessList.getSelected() > 0){
		qList.add( new Queue("-",ProcessList.getValue(ProcessList.getSelected()).substring(0,2)));
		ProcessList.remove(ProcessList.getSelected());
	}
  }
  ModeGroup.mousePressed();
  ProcessList.mousePressed();
  
}



void keyPressed() {
  ProcessBox.KeyPressed(key,keyCode);
}

void showPlist(){
  println("======");
  for(Process p:pList){
    println(p.title);
    }
    println("======");
}
