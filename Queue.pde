class Queue{
  String action;
  String pTitle;
  float pLength;
  
  Queue(String action,float pLength){
    this.action = action;
    this.pLength = pLength;
  }
  Queue(String action,String pTitle){
    this.action = action;
    this.pTitle = pTitle;
  }
  void execute(){
    moving = true;
    switch(action){
      case "+":
        m.addProcess(pLength);
        break;
      case "-":
        m.removeProcess(pTitle);
        break;
    }
  }
}
