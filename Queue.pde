class Queue{
  String action;
  String description;
  float pSpace;
  String pTitle;
  
  Queue(String action,String variable){
    this.action = action;
    switch(action){
      case "+":
        pSpace = parseInt(variable);
        this.description = "Add process "+pSpace/2+"K";
        break;
      case "-":
        pTitle = variable;
        this.description = "Release process "+pTitle;
        break;
      case "f":
        this.description = "Finished.";
    }
  }
  void execute(){
	// 執行行程操作
    showDescription = qCount+1+"."+qList.get(qCount).description;
    moving = true;
    switch(action){ 
      case "+": // 加入
        m.loadProcess(pSpace);
        break;
      case "-": // 移除
        m.releaseProcess(pTitle);
        break;
    }
  }
}
