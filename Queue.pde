class Queue{
  String action;
  String description;
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
        setDescription("Add process "+pLength/2+"K");
        break;
      case "-":
        m.removeProcess(pTitle);
        setDescription("Release process "+pTitle);
        break;
    }
  }
  void setDescription(String description){
    this.description = description;
  }
}
