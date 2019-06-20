/* @pjs font="JF-Dot-Ayu18.ttf,新綜藝體.ttf"; */
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
int loadWait = 100;
boolean loading = false;
PImage backgroundImg, backgroundGaming;
PFont defaultFont;

ButtonGroup modeGroup ;
ListBox processList;
void setup() {
  // 設定視窗
  size(600, 700);
  smooth(10); // anti-aliased
  // 建立字體
  font = createFont("新綜藝體.ttf", 1);
  bar = new Navbar();
  loadBar = new ProgressBar(125, 347, 350, 6);
  backgroundImg = loadImage("background.png");
  backgroundGaming = loadImage("background-gaming.png");
  init();
}
void draw() {
  if (loading) {
    LoadBar();
    return;
  }
  noStroke();
  image(backgroundGaming, 0, 0);
  if (mode != null) {
    if (mode.equals("select")) {
      image(backgroundImg, 0, 0);
      for (RectButton button : bList) {
        button.display();
      }
    } else {//example or custom
      pushMatrix();
      translate(width*0.5, 10);
      m.display();
      // 如果非為移動中 且 list中還有操作 且不為暫停狀態 
      if (!moving && qCount < qList.size() && !isStop) {
        qList.get(qCount).execute(); // 執行該操作
      }
      if (mode.equals("custom") || mode.equals("random")) {
        // 操作佇列
        textFont(font, 16);
        for (int i= qCount + 1; i<qList.size(); i++) {
          text(qList.get(i).description, -250, 20 + i*20);
        }
      }
      for (Process p : pList) {
        // update pos
        if (!isStop)
          p.move();
        // update畫面
        p.display();
        if (p.y + p.space*2 > 280*2  ) { // 記憶體外部碎片問題偵測
          String message;
          message = "碎片問題產生: \n";
          message += "Total Free Space: " + (m.free+p.space) + "k" + "\n";
          float maxcontinuum_space = (m.space*2 - p.y)/2; // 預設最後一段為最大連續記憶體
          for (int i=0; i<pList.size(); i++) {
            if (pList.get(i).title == "Free" && pList.get(i).space > maxcontinuum_space)
              maxcontinuum_space = pList.get(i).space;
          }
          message += "最大連續記憶體空間: "+maxcontinuum_space + "k\n";
          fill(10);
          textFont(font, 18); 
          text(message, m.width/2+5, 180);
          isStop = true;
          if (mode.equals("custom") || mode.equals("random"))
            pauseButton.enabled = false;
        }
      }
      // 如果移除
      if (removedProcess != null && !isStop)
        removedProcess.move();
      if (removedProcess != null)
        removedProcess.display();
      fill(0);
      textFont(font, 16); 
      if (!moving) {
        if (showDescription != "Click to Start") {
          fill(97, 91, 166);
          textFont(font, 20); 
          text("Click to next step.", m.width/2-180, 600);
        }
      }
      fill(97, 91, 166);
      textFont(font, 16);
      text(showDescription, m.width/2+10, 280);

      popMatrix();
      if (mode.equals("custom")) {//custom
        // mode選擇
        if (modeGroup.getFirstSelected() == 0) { // add mode
          addProcessButton.visible = true;
          processBox.visible = true;
          processList.visible = false;
          deleteProcessButton.visible = false;
        } else if (modeGroup.getFirstSelected() == 1) { // release mode
          addProcessButton.visible = false;
          processBox.visible = false;
          processList.visible = true;
          deleteProcessButton.visible = true;
        } else {
          addProcessButton.visible = false;
          processBox.visible = false;
          processList.visible = false;
          deleteProcessButton.visible = false;
        }
        stroke(255);
        // Button
        addProcessButton.display(mouseX, mouseY);
        deleteProcessButton.display(mouseX, mouseY);
        pauseButton.display(mouseX, mouseY);
        // InputBox
        processBox.display(mouseX, mouseY);
        // radio button group
        modeGroup.display(mouseX, mouseY);
        // ProcessList
        processList.display(mouseX, mouseY);
      } else if (mode.equals("random")) {
        processList.visible = false;
        stroke(255);
        pauseButton.display(mouseX, mouseY);
        randomButton.display(mouseX, mouseY);
        // ProcessList
        processList.display(mouseX, mouseY);
      }
      // 操作結束
      if (qCount+1 >= qList.size()) {
        if (mode.equals("custom") && !addProcessButton.enabled) {
          isStop = true;
          pauseButton.enabled = false;
        } else {
          isStop = true;
        }
      }
      bar.display();
    }
  } else {
    bList = new ArrayList<RectButton>();
    bList.add(new RectButton(200, 450, 200, 50, color(255), color(97, 91, 166), "範例模式"));
    bList.add(new RectButton(200, 520, 200, 50, color(255), color(97, 91, 166), "自訂模式"));
    bList.add(new RectButton(200, 590, 200, 50, color(255), color(97, 91, 166), "隨機模式"));
    mode = "select";
  }
}
void mousePressed() {
  if (mode != null) {
    if (mode.equals("select")) {
      for (RectButton button : bList) {
        if (button.getRectOver()) {
          switch(button.Text) {
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
    } else if (mode.equals("example")) {
      if (isStop) {
        isStop = false;
      } else {
        isStop = true;
      }
    } else if (mode.equals("custom")) {
      if (isStop && pauseButton.getRectOver()) { // 進行下一步或恢復播放
        //loop();
        isStop = false;
        if (pauseButton.Text == "Start") {
          qList.add(new Queue("f", ""));
          addProcessButton.enabled = false;
          deleteProcessButton.enabled = false;
        }
        pauseButton.Text = "Pause";
        if (moving == false)
          qCount += 1;
      } else if ( pauseButton.getRectOver() ) { // 暫停
        //noLoop();
        isStop = true;
        pauseButton.Text = "Play";
      }

      if (addProcessButton.getRectOver()) {
        // string to Char array to get ascii code in js
        // 直接用charAt(i)會得到值為0
        int[] AddInput = int( processBox.Text.toCharArray() );
        int i;
        if (processBox.Text.length() > 0) { // 增加process
          qList.add(new Queue("+", processBox.Text));
          processList.add("P" + process_indexInQueue + " - " + processBox.Text + "k");
          processBox.Text = ""; // 清空
        } else {
          showDescription = "Wrong !" ;
        }
      }
      if (deleteProcessButton.getRectOver()) {
        if (processList.getSelected() > 0) {
          String releaseProcess = processList.getValue(processList.getSelected());
          int end = 2;
          while ( releaseProcess.charAt(end) <='9' && releaseProcess.charAt(end) >='0') {
            end++;
          } // list中分割字串得到process名稱 
          qList.add( new Queue("-", releaseProcess.substring(0, end)) );
          processList.remove(processList.getSelected());
        }
      }
      if (randomButton.getRectOver()) {
        RandomTestCase();
      }
      modeGroup.mousePressed();
      processList.mousePressed();
    } else if (mode.equals("random")) {
      if (isStop && pauseButton.getRectOver()) { // 進行下一步或恢復播放
        isStop = false;
        if (pauseButton.Text == "Start") {
          qList.add(new Queue("f", ""));
        }
        pauseButton.Text = "Pause";
        if (moving == false)
          qCount += 1;
      } else if ( pauseButton.getRectOver() ) { // 暫停
        isStop = true;
        pauseButton.Text = "Play";
      }
      if (randomButton.getRectOver()) {
        RandomTestCase();
      }
      processList.mousePressed();
    }
    bar.mousePressed();
  }
}

void init() {
  isStop = true;
  moving = false;
  showDescription = "";
}
void LoadBar() {
  // Load effect
  if (loadWait > 0) {
    background(0);
    loadBar.display();
    if (loadBar.value < 100) {
      loadBar.value += 1;
    } else
      loadWait--;
  } else
    loading = false;
  // load end
}

void initExample() {
  init();
  qCount = 0;
  m = new Memory();
  pList = new ArrayList<Process>();
  qList = new ArrayList<Queue>();
  qList.add(new Queue("+", "12"));
  qList.add(new Queue("+", "24"));
  qList.add(new Queue("+", "36"));
  qList.add(new Queue("+", "48"));
  qList.add(new Queue("+", "160"));
  qList.add(new Queue("-", "P3"));
  qList.add(new Queue("-", "P4"));
  qList.add(new Queue("+", "28"));
  qList.add(new Queue("+", "60"));
  qList.add(new Queue("-", "P4"));
  qList.add(new Queue("f", ""));
}
void initCustom() {
  init();
  qCount = -1;
  process_index = 0;
  process_indexInQueue = 0;
  // 記憶體區塊
  m = new Memory();
  // 行程list
  pList = new ArrayList<Process>();
  qList = new ArrayList<Queue>();
  // 新增process按鈕
  addProcessButton = new RectButton(140, 370, 70, 35, color(255), color(97, 91, 166));
  addProcessButton.Text = "Add";
  deleteProcessButton = new RectButton(40, 370, 145, 35, color(255), color(97, 91, 166));
  deleteProcessButton.Text = "Release";
  // Play 按鈕
  pauseButton = new RectButton(420, 50, 100, 50, color(255), color(97, 91, 166));
  pauseButton.Text = "Start";
  pauseButton.enabled = true;
  // random button
  randomButton = new RectButton(100, 560, 100, 50, color(255), color(97, 91, 166));
  randomButton.Text = "Random";
  // Input Box
  processBox = new TextBox(20, 372, 110, 30);
  // play/release mode選擇按鈕
  RadioButton PlayRadioButton, ReleaseRadioButton;
  PlayRadioButton = new RadioButton(40, 350, 5, 3, color(255), color(97, 91, 166));
  PlayRadioButton.Text = "Add";
  PlayRadioButton.TextSize = 16;

  ReleaseRadioButton = new RadioButton(120, 350, 5, 3, color(255), color(97, 91, 166));
  ReleaseRadioButton.Text = "Rlease";
  ReleaseRadioButton.TextSize = 16;
  modeGroup = new ButtonGroup();
  modeGroup.add(PlayRadioButton);
  modeGroup.add(ReleaseRadioButton);

  processList = new ListBox(35, 420, 160, 30, color(220), color(240));
  processList.TextSize = 16;

  showDescription = "Click to Start";
}
void initRandom() {
  init();
  qCount = -1;
  process_index = 0;
  process_indexInQueue = 0;
  // 記憶體區塊
  m = new Memory();
  // 行程list
  pList = new ArrayList<Process>();
  qList = new ArrayList<Queue>();
  // Play 按鈕
  pauseButton = new RectButton(225, 585, 100, 50, color(255), color(97, 91, 166));
  pauseButton.Text = "Start";
  pauseButton.enabled = true;
  // random button
  randomButton = new RectButton(60, 220, 80, 40, color(255), color(97, 91, 166));
  randomButton.Text = "Random";

  processList = new ListBox(100, 420, 160, 30, color(220), color(240));
  processList.TextSize = 16;

  showDescription = "Click to Start";
}
void keyPressed() {
  if (mode.equals("custom"))
    processBox.KeyPressed(key, keyCode);
}
void showPlist() {
  println("======");
  for (Process p : pList) {
    println(p.title);
  }
  println("======");
}

void RandomTestCase() {
  int add = 0; // add指令數量
  int release = 0; // release指令數量
  float space = m.space; // 尚餘空間
  int process_num = 0; // 當前process數量
  int []process =  new int[11]; // 是否已被釋放
  initCustom();
  process[0] = 1;
  while (add + release < 10) {
    if (process_num == 0 ) { // 當前不存在process 進行新增
      float newprocess_space = (int)random(12, space+1);
      qList.add(new Queue("+", str(newprocess_space)));
      space -= newprocess_space;
      add++;
      process_num++;
    } else {
      int mode = (int)random(0, 4); // 3/4 新增
      if (mode < 3 && space >= 12) { // add 剩餘需大於12k
        float newprocess_space = (int)random(12, space+1);
        qList.add(new Queue("+", str(newprocess_space)));
        space -= newprocess_space;
        add++;
        process_num++;
      } else { // release
        int release_process = 0;
        while (process[release_process]==1) { // 檢查是否已釋放
          release_process = (int)random(1, add+1);
        }
        process[release_process] = 1; // 設定已釋放
        int process_index = 0; // 釋放process在qList中的index
        for (int i=0; i<qList.size(); i++) { // 根據編號尋找
          if (qList.get(i).pTitle.equals(str(release_process)) ) 
            process_index = i;
        }
        space += qList.get(process_index).pSpace;
        qList.add(new Queue("-", "P" + (release_process) ));
        release++;
        process_num--;
      }
    }
  }
}
