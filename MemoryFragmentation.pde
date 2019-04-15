Memory m;
ArrayList<Process> pList;
ArrayList<Queue> qList;
PFont font;
boolean isStop = false;
boolean testMode = true;//(true/false)
int qCount = 0;
boolean moving = false;
String showDescription = "";

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
  if(isStop){
    showDescription +="\n Click to next step.";
  }
  if(qCount >= qList.size()-1){
      showDescription += "\nFinished";
      noLoop();
  } //<>//
  fill(0);
  textFont(font,20);
  text(showDescription,m.width/2,600);
  
  popMatrix();
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
  for(Process p:pList){
      println(p.title);
    }
}
