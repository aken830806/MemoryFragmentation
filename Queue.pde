class Queue{
  String action;
  String description;
  String pTitle;
  float pLength;
  
  Queue(String action,float pLength){
    this.action = action;
    this.pLength = pLength;
    this.description = "Add process "+pLength/2+"K";
  }
  Queue(String action,String pTitle){
    this.action = action;
    this.pTitle = pTitle;
    this.description = "Release process "+pTitle;
  }
  void execute(){
    showDescription = qCount+1+"."+qList.get(qCount).description;
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
