Memory m;
ArrayList<Process> pList;
PFont font;
boolean isStop = false;
boolean testMode = false;//true/false

void setup(){
  size(600, 600);
  m = new Memory();
  pList = new ArrayList<Process>();
  font = createFont("Arial",1);
}
void draw(){
  noStroke();
  fill(235, 240, 242);
  rect(0, 0, width, height);
  
  pushMatrix();
  translate(width*0.5,10);
  m.display();
  for(Process p:pList){
    p.display();
  }
  if(frameCount == 100){
    m.addProcess(24);
  }else if(frameCount == 250){
    m.addProcess(48);
  }else if(frameCount == 350){
    m.addProcess(72);
  }else if(frameCount == 450){
    m.addProcess(96);
  }else if(frameCount == 500){
    m.addProcess(320);
  }else if(frameCount == 700){
    m.removeProcess("P3");
  }else if(frameCount == 770){
    m.removeProcess("P4");
    m.addProcess(56);
  }else if(frameCount == 900){
    m.addProcess(120);
  }else if(frameCount == 1200){
    m.removeProcess("P4");
  }else if(frameCount == 1500){
    if(testMode){
      for(Process p:pList){
        println(p.title);
      }
    }
    println("Finished");
    noLoop();
  }
  if(testMode)
    println(frameCount);
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
