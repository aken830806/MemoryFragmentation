Memory m;
ArrayList<Process> pList;
ArrayList<Queue> qList;
PFont font;
boolean isStop = false;
boolean testMode = false;//(true/false)
int qCount = 0;
boolean moving = false;
String showDescription = "";
Process removedProcess;

void setup(){
  size(600, 650);
  font = createFont("Arial",1);
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
void draw(){
  noStroke();
  fill(235, 240, 242);
  rect(0, 0, width, height);
  
  pushMatrix();
  translate(width*0.5,10);
  m.display();
  
  if(!moving && qCount < qList.size()){
    qList.get(qCount).execute();
  }
  for(Process p:pList){
    p.move();
    p.display();
  }
  if(removedProcess != null)
    removedProcess.move();
  if(removedProcess != null)
    removedProcess.display();
  if(isStop){
    showDescription +="\n Click to next step.";
  }
  if(testMode){
    println(frameCount);
    println(qCount+1);
  } //<>//
  fill(0);
  textFont(font,20);
  text(showDescription,m.width/2-50,600);
  
  popMatrix();
  if(qCount+1 >= qList.size())
    noLoop();
}
void mousePressed(){
  if(isStop){
    loop();
    isStop = false;
  }else{
    noLoop();
    isStop = true;
  }
}
void showPlist(){
  println("======");
  for(Process p:pList){
    println(p.title);
    }
    println("======");
}
