class Memory{
  float width = 150;
  float space = 560;
  // 記憶體空間大小
  float free = space;
  
  void display(){
    stroke(0);
    rect(-width/2,0,width,space);
    
    fill(0);
    textFont(font,30);
	// 說明文字 -250,置中處
    text("Total free :\n"+free/2 + "K",-250,space/2);
  }
  void loadProcess(float space){ // 讀入行程
    float y = 0;
    int index = 0;
    boolean addInFree = false;
    for(Process p:pList){
      if(p.title.equals("Free") && p.space > space){ // 
        y = p.y;
        p.space -= space;
        p.setY(p.y +space);
        addInFree = true;
        break;
      }else{
        y += p.space;
      }
      index += 1;
    }
    if(addInFree){ // 直接加入
      pList.add(index,new Process(space,y));
      pList.get(index+1).moved = true;
    }else{ // 
      pList.add(new Process(space,y));
    }
    free -= space;
    updateTitle();
  }
  void releaseProcess(String title){
    for(Process p:pList){
      if(p.title.equals(title)){
        removedProcess = new Process(p.space,p.y,p.title);
        p.title = "Free";
        free += p.space;
        showDescription += "("+p.space/2+"K)";
        break;
      }
    }
    mergeFree();
  }
  void updateTitle(){
    int titleCount = 1;
    for(Process p:pList){
      if(!p.title.equals("Free")){
        p.title = "P"+titleCount;
        titleCount += 1;
      }
    }
  }
  void mergeFree(){
    boolean isFree = false;
    int index = 0;
    int removeIndex = -1;
    for(Process p:pList){
      if(p.title.equals("Free")){
        if(isFree){
          pList.get(index-1).space += p.space;
          removeIndex = index;
          break;
        }
        isFree = true;
      }else
        isFree = false;
      index += 1;
    }
    if(removeIndex != -1)
      pList.remove(pList.get(removeIndex));
  }
}
