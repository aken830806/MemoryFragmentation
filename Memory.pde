class Memory{
  float width = 150;
  float length = 560;
  float free = length;
  
  void display(){
    stroke(0);
    rect(-width/2,0,width,length);
    
    fill(0);
    textFont(font,30);
    text("Total free :\n"+free/2 + "K",-250,length/2);
  }
  int getIndex(float length){
    int index = 0;
    for(Process p:pList){
      if(p.title.equals("Free") && p.length > length){
        p.length -= length;
        p.y += length;
        return index;
      }else{
        index += 1;
      }
    }
    return index;
  }
  void addProcess(float length){
    float y = 0;
    int index = 0;
    boolean addInFree = false;
    for(Process p:pList){
      if(p.title.equals("Free") && p.length > length){
        y = p.y;
        p.length -= length;
        p.y += length;
        addInFree = true;
        break;
      }else{
        y += p.length;
      }
      index += 1;
    }
    if(addInFree)
      pList.add(index,new Process(length,y));
    else
      pList.add(new Process(length,y));
    free -= length;
    updateTitle();
  }
  void removeProcess(String title){
    for(Process p:pList){
      if(p.title.equals(title)){
        p.title = "Free";
        free += p.length;
        break;
      }
    }
    mergeFree();
    updateTitle();
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
          pList.get(index-1).length += p.length;
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
