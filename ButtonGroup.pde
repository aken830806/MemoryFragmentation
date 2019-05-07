

class ButtonGroup{
  protected ArrayList<RadioButton> Buttons = new ArrayList<RadioButton>();
  boolean exclusion = true;
  boolean visible = true;
  public void display(int mouseX,int mouseY){
	if(!visible)
	  return;
    for(int i=0;i<Buttons.size();i++){
      Buttons.get(i).display(mouseX,mouseY);
    }
  }
  
  public int getFirstSelected(){
	for(int i=0;i<Buttons.size();i++){
        if (Buttons.get(i).selected){
          return i;
        }
    }
	return -1;
  }
  
  public int []getSelected(){
    int selected[] ;
    int Elements[] = new int[Buttons.size()];
    int length = 0;
    for(int i=0;i<Buttons.size();i++){
        if (Buttons.get(i).selected){
          Elements[length++] = i;
        }
    }
    selected = new int[length];
    for(int i =0;i<length;i++){
      selected[i] = Elements[i];
    }
    return selected;
  }
  
  public void add(RadioButton button){
    Buttons.add(button);
  }
  
  public void remove(int index){
    if(index > 0 && index < Buttons.size())
      Buttons.remove(index);
  }
  public void remove(RadioButton button){
    Buttons.remove(button);
  }
  
  public RadioButton getElement(int index){
    if(index > 0 && index < Buttons.size())
      return Buttons.get(index);
    return null; // error
  }
  
  
  void mousePressed(){
    if(exclusion){
      // 選取任意選項後重設其他按鈕
      int changed = -1;
      for(int i=0;i<Buttons.size();i++){
        if (Buttons.get(i).circleOver){
          Buttons.get(i).selected = true;
          changed = i;
        }
      }
      if(changed!=-1){
        for(int i=0;i<Buttons.size();i++){
          if(changed != i)
            Buttons.get(i).selected = false;
        }
      }
    }
    else{ // 不互斥
      for(int i=0;i<Buttons.size();i++){
        Buttons.get(i).mousePressed();
      }
    }
  }
}
