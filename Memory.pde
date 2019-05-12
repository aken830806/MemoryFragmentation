class Memory{
  float width = 150;
  float space = 280;
  // 記憶體空間大小
  float free = space;
  
  void display(){
    stroke(0);
	  // draw 2*space
    rect(-width/2,0,width,space*2);
    fill(0);
    textFont(font,30);
	  // 說明文字 -250,置中處
    text("Total free :\n"+free + "K",-250,space);
  }
  void loadProcess(float space){ // 讀入行程
    float y = 0;
    int index = 0;
    boolean addInFree = false;
    for(Process p:pList){
      if(p.title.equals("Free") && p.space >= space){ // 
        y = p.y;
        p.space -= space;
        p.setY(p.y +space*2);
        addInFree = true;
        break;
      }else{
        y += 2*p.space;
      }
      index += 1;
    }
    if(addInFree){ // 直接加入
      ++process_index;
      pList.add(index,new Process(space,y));
      pList.get(index+1).moved = true;
    }else{ // 
      ++process_index;
      pList.add(new Process(space,y));
    }
    free -= space;
  }
  void releaseProcess(String title){
    for(Process p:pList){
      if(p.title.equals(title)){
        removedProcess = new Process(p.space,p.y,p.title);
        p.title = "Free";
        free += p.space;
        showDescription += "("+p.space+"K)";
        break;
      }
    }
    mergeFree();
  }
  void mergeFree(){
    boolean isFree = false;
    int index = 0;
    int removeIndex = -1;
    // free空間合併
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
    // 剩下0k時自動消除
    for(int i =0;i<pList.size();i++){
      if(pList.get(i).title.equals("Free") && pList.get(i).space == 0){
          pList.remove(pList.get(i));
      }
    }
    //free空間與空白區域合併
    for(int i =0;i<pList.size();i++){
      if(pList.get(i).title.equals("Free")){ // 尋找free區域
        int j;
        for(j=0;j<pList.size();j++){ // 檢測其後方是否仍有prcoess存在
          if(pList.get(i).y < pList.get(j).y){
            break;
          }
        }
        if(j == pList.size()){ // 後方不存在其他process
          pList.remove(pList.get(i)); // 移除該free空間
          break;
        }
      }
        
    }
  }
}
