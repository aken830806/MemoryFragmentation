Memory m;
ArrayList<Process> pList;
ArrayList<Queue> qList;
PFont font;
boolean isStop = true;
boolean testMode = false;//(true/false)
int qCount = -1;
boolean moving = false;
String showDescription = "";
Process removedProcess;

RectButton AddProcessButton;
RectButton DeleteProcessButton;
RectButton PauseButton;
TextBox ProcessBox;


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
  if(!moving)
	text(showDescription +"\n Click to next step.",m.width/2-50,600);
  else
    text(showDescription ,m.width/2-50,600);
  popMatrix();
  stroke(255);
  // Button
  AddProcessButton.display(mouseX,mouseY);
  DeleteProcessButton.display(mouseX,mouseY);
  PauseButton.display(mouseX,mouseY);
  // InputBox
  ProcessBox.display(mouseX,mouseY);
  // 操作結束
  if(qCount+1 >= qList.size())
    isStop = true;
}
void mousePressed(){
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
	// string to Char array to get ascii code in js
	// 直接用charAt(i)會得到值為0
	int[] AddInput = int( ProcessBox.Text.toCharArray() );
	for(int i =0;i<ProcessBox.Text.length();i++){
		if(AddInput[i] < '0' || AddInput[i] > '9' ){
			break;
		}
	}
	if(i == ProcessBox.Text.length() && ProcessBox.Text.length() > 0){
		qList.add(new Queue("+",ProcessBox.Text));
		ProcessBox.Text = ""; // 清空
	}
	else{
		showDescription = "Only digital!" ;
	}
  }
  if(DeleteProcessButton.getRectOver()){
	ProcessBox.Text = ProcessBox.Text.toUpperCase();
	int[] DeleteInput = int( ProcessBox.Text.toCharArray() );
	for(int i=0;i<ProcessBox.Text.length();i++){
		if(i==0 && DeleteInput[i] != 'P')
			break;
		else if( i!=0 && (DeleteInput[i] < '0' || DeleteInput[i] > '9') ){
			break;
		}
	}
	if(i == ProcessBox.Text.length() && ProcessBox.Text.length() > 1 ){
		qList.add(new Queue("-",ProcessBox.Text));
		ProcessBox.Text = ""; // 清空
	}
	else
		showDescription = "Only Process!";
  }
  
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
