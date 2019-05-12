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
int process_index = 0;

RectButton addProcessButton;
RectButton deleteProcessButton;
RectButton pauseButton;
RectButton randomButton;
TextBox processBox;
ArrayList<RectButton> bList;//button list
Navbar bar;
ProgressBar loadBar;
int loadWait = 150;
boolean loading = true;

ButtonGroup modeGroup ;
ListBox processList;
void setup(){
  // 設定視窗
  size(600, 700);
  smooth(10); // anti-aliased
  // 建立字體
  font = createFont("Arial",1);
  bar = new Navbar();
  loadBar = new ProgressBar(125,347,350,6);
  init();
}
void draw(){
  if(loading){
    LoadBar();
    return;
  }
  noStroke();
  fill(235, 240, 242);
  rect(0, 0, width, height);
  
  if(mode != null){
    if(mode.equals("select")){
      for(RectButton button:bList){
        button.display();
      }
    }
    else{//example or custom
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
        if(p.y + p.space*2 > 280*2  ){ // 記憶體外部碎片問題偵測
          String message;
          message = "碎裂問題產生: \n";
          message += "Total Free Space: " + (m.free+p.space) + "k" + "\n";
          float maxcontinuum_space = (m.space*2 - p.y)/2; // 預設最後一段為最大連續記憶體
          for(int i=0;i<pList.size();i++){
            if(pList.get(i).title == "Free" && pList.get(i).space > maxcontinuum_space)
               maxcontinuum_space = pList.get(i).space;
          }
          message += "最大連續記憶體空間: "+maxcontinuum_space + "k\n";
          fill(10);
          textFont(font,18); 
          text(message ,m.width/2+5,180);
          isStop = true;
          pauseButton.enabled = false;
        }
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
          // mode選擇
          if(modeGroup.getFirstSelected() == 0){ // add mode
          addProcessButton.visible = true;
          processBox.visible = true;
          processList.visible = false;
          deleteProcessButton.visible = false;
          }
          else if(modeGroup.getFirstSelected() == 1){ // release mode
          addProcessButton.visible = false;
          processBox.visible = false;
          processList.visible = true;
          deleteProcessButton.visible = true;
          }
          else{
          addProcessButton.visible = false;
          processBox.visible = false;
          processList.visible = false;
          deleteProcessButton.visible = false;
          }
          stroke(255);
          // Button
          addProcessButton.display(mouseX,mouseY);
          deleteProcessButton.display(mouseX,mouseY);
          pauseButton.display(mouseX,mouseY);
          randomButton.display(mouseX,mouseY);
          // InputBox
          processBox.display(mouseX,mouseY);
          // radio button group
          modeGroup.display(mouseX,mouseY);
          // ProcessList
          processList.display(mouseX,mouseY);
      
        }
        // 操作結束
        if(qCount+1 >= qList.size()){
          if(mode.equals("custom") && !addProcessButton.enabled){
            isStop = true;
            pauseButton.enabled = false;
          }else{
            isStop = true;
          }
        }
        bar.display();
    }
  }
  else{
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
    }
    else if(mode.equals("example")){
      if(isStop){
        isStop = false;
      }else{
        isStop = true;
      }
    }
    else if(mode.equals("custom")){
      if(isStop && pauseButton.getRectOver()){ // 進行下一步或恢復播放
        //loop();
        isStop = false;
      if(pauseButton.Text == "Start"){
        qList.add(new Queue("f",""));
        addProcessButton.enabled = false;
        deleteProcessButton.enabled = false;
      }
      pauseButton.Text = "Pause";
      if(moving == false)
        qCount += 1;
      }else if( pauseButton.getRectOver() ){ // 暫停
        //noLoop();
        isStop = true;
        pauseButton.Text = "Play";
      }
      
      if(addProcessButton.getRectOver()){
        // string to Char array to get ascii code in js
        // 直接用charAt(i)會得到值為0
        int[] AddInput = int( processBox.Text.toCharArray() );
        int i;
        if(processBox.Text.length() > 0){ // 增加process
          qList.add(new Queue("+",processBox.Text));
          processList.add("P" + process_indexInQueue + " - " + processBox.Text + "k");
          processBox.Text = ""; // 清空
        }
        else{
          showDescription = "Wrong !" ;
        }
      }
      if(deleteProcessButton.getRectOver()){
        if(processList.getSelected() > 0){
      String releaseProcess = processList.getValue(processList.getSelected());
      int end = 1;
      while( releaseProcess.charAt(end) <='9' && releaseProcess.charAt(end) >='0'){end++;} // list中分割字串得到process名稱 
          qList.add( new Queue("-", releaseProcess.substring(0,end)) );
          processList.remove(processList.getSelected());
        }
      }
    if(randomButton.getRectOver()){
    RandomTestCase();
    }
      modeGroup.mousePressed();
      processList.mousePressed();
    }
    bar.mousePressed();
  }
  
}

void init(){
  isStop = true;
  moving = false;
  showDescription = "";
}
void LoadBar(){
  // Load effect
  if(loadWait > 0){
    background(0);
    loadBar.display();
    if(loadBar.value < 100){
      loadBar.value += 0.2;
    }
    else
      loadWait--;
  }
  else
    loading = false;
  // load end
}

void initExample(){
  qCount = 0;
  m = new Memory();
  pList = new ArrayList<Process>();
  qList = new ArrayList<Queue>();
  qList.add(new Queue("+","12"));
  qList.add(new Queue("+","24"));
  qList.add(new Queue("+","36"));
  qList.add(new Queue("+","48"));
  qList.add(new Queue("+","160"));
  qList.add(new Queue("-","P3"));
  qList.add(new Queue("-","P4"));
  qList.add(new Queue("+","28"));
  qList.add(new Queue("+","60"));
  qList.add(new Queue("-","P4"));
  qList.add(new Queue("f",""));
}
void initCustom(){
  qCount = -1;
  process_index = 0;
  process_indexInQueue = 0;
  // 記憶體區塊
  m = new Memory();
  // 行程list
  pList = new ArrayList<Process>();
  qList = new ArrayList<Queue>();
  // 新增process按鈕
  addProcessButton = new RectButton(140,370,70,35,color(200),color(150));
  addProcessButton.Text = "Add";
  deleteProcessButton = new RectButton(40,370,145,35,color(200),color(150));
  deleteProcessButton.Text = "Release";
  // Play 按鈕
  pauseButton = new RectButton(225,585,80,35,color(200),color(150));
  pauseButton.Text = "Start";
  pauseButton.enabled = true;
  // random button
  randomButton = new RectButton(100,560,80,35,color(200),color(150));
  randomButton.Text = "Random";
  // Input Box
  processBox = new TextBox(20,372,110,30);
  // play/release mode選擇按鈕
  RadioButton PlayRadioButton,ReleaseRadioButton;
  PlayRadioButton = new RadioButton(40,350,5,3,color(255),color(30));
  PlayRadioButton.Text = "Add";
  PlayRadioButton.TextSize = 16;
  
  ReleaseRadioButton = new RadioButton(120,350,5,3,color(255),color(30));
  ReleaseRadioButton.Text = "Rlease";
  ReleaseRadioButton.TextSize = 16;
  modeGroup = new ButtonGroup();
  modeGroup.add(PlayRadioButton);
  modeGroup.add(ReleaseRadioButton);
  
  processList = new ListBox(35,420,160,30,color(220),color(240));
  processList.TextSize = 16;

  showDescription = "Click to Start";
} 
void keyPressed() {
  if(mode.equals("custom"))
    processBox.KeyPressed(key,keyCode);
}
void showPlist(){
  println("======");
  for(Process p:pList){
    println(p.title);
  }
  println("======");
}

void RandomTestCase(){
  int add = 0; // add指令數量
  int release = 0; // release指令數量
  float space = m.space; // 尚餘空間
  int process_num = 0; // 當前process數量
  int []process =  new int[11]; // 是否已被釋放
  initCustom();
  process[0] = 1;
  while(add + release < 10){
    if(process_num == 0 ){ // 當前不存在process 進行新增
      float newprocess_space = (int)random(12,space+1);
      qList.add(new Queue("+",str(newprocess_space)));
      space -= newprocess_space;
      add++;
      process_num++;
    }
    else{
      int mode = (int)random(0,4); // 3/4 新增
      if(mode < 3 && space >= 12){ // add 剩餘需大於12k
        float newprocess_space = (int)random(12,space+1);
        qList.add(new Queue("+",str(newprocess_space)));
        space -= newprocess_space;
        add++;
        process_num++;
      }
      else{ // release
        int release_process = 0;
        while(process[release_process]==1){ // 檢查是否已釋放
          release_process = (int)random(1,add+1);
        }
        process[release_process] = 1; // 設定已釋放
        int process_index = 0; // 釋放process在qList中的index
        for(int i=0;i<qList.size();i++){ // 根據編號尋找
          if(qList.get(i).pTitle.equals(str(release_process)) ) 
            process_index = i;
        }
        space += qList.get(process_index).pSpace;
        qList.add(new Queue("-","P" + (release_process) ));
        release++;
        process_num--;
      }
    }
  }
}
