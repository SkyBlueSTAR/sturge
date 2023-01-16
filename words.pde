String[][] words = new String[20][2];
int[] ans = new int[20];
int[] wordPos = new int[20];
int selector = -1;
int timer = 3780;
int tx = -1;
boolean endCheck = false;
boolean end = false;
boolean[] checkedAns = new boolean[20];

void setup(){
  fullScreen();
  frameRate(60);
  PFont font = createFont("Meiryo", 50);
  textFont(font);
  for(int i = 0; i < words.length; i++){
    words[i][0]="";
    words[i][1]="";
  }
  for(int i = 0; i < words.length; i++){
    JSONObject wordList = loadJSONObject("words.json");
    while(true){
      int random = int(random(wordList.getJSONArray("words").size()));
      words[i][0] = wordList.getJSONArray("words").getJSONArray(random).getString(0);
      words[i][1] = wordList.getJSONArray("words").getJSONArray(random).getString(1).replace("、","、\n");
      boolean matched = false;
      for(int j = 0; j < words.length; j++){
        if(words[j][0].equals(words[i][0])&&i!=j){
          matched = true;
        }
      }
      if(!matched)break;
    }
    while(true){
      wordPos[i] = int(random(20));
      boolean matched = false;
      for(int j = 0; j < words.length; j++){
        if(wordPos[j]==wordPos[i]&&i!=j){
          matched = true;
        }
      }
      if(!matched)break;
    }
  }
  for(int i = 0; i < ans.length; i++){
    ans[i] = -1;
  }
}

void draw(){
  background(0);
  drawLine();
  fill(240);
  if(timer>0&&timer<=3600){
    drawWords();
    fill(timer>600?0:255,0,timer>600?255:0);
    float sec = float(timer)/60;
    text("time:"+nf(sec,2,2),10,20);
  }else if(timer<-300){
    drawEnglish();
    drawAnswer();
    if(tx>=0&&!end)drawAnsWindow(tx);
    if(endCheck&&!end)drawEndCheckWindow();
    if(end){
      checkAns();
      showResult();
    }
  }
  timer--;
}

void mouseReleased() {
  if(!end&&timer<-300){
    if(endCheck){
      endCheck = false;
    } else if(tx==-1){
      selector = floor(5*mouseX/width)+5*floor(4*mouseY/height);
      tx = mouseX<width/2?3*width/5+10:10;
    } else if(mouseX>tx && mouseX<tx+2*width/5-20 && mouseY>10 && mouseY<height-10){
      ans[selector] = floor(3*(mouseX-tx)/(2*width/5-20))+3*floor(7*(mouseY-10)/(height-20));
      if(selector == 20)ans[selector]=-1;
      selector = -1;
      tx = -1;
    } else {
      selector = -1;
      tx = -1;
    }
  }
}

void keyPressed() {
  if(key==ENTER && timer > 0){
    timer = 0;
  } else if(key==ENTER&&timer<-300){
    if(!endCheck){
      endCheck = true;
    } else {
      end = true;
    }
  }
  if(keyCode=='R'){
    for(int i = 0; i < words.length; i++){
      ans[i] = -1;
      checkedAns[i] = false;
    }
    selector = -1;
    timer = 3780;
    tx = -1;
    endCheck = false;
    end = false;
  }
}

void drawLine(){
  stroke(240);
  for(int i = 1; i < 4; i++){
    line(0, i*height/4, width, i*height/4);
  }
  for(int i = 1; i < 5; i++){
    line(i*width/5, 0, i*width/5,height);
  }
}

void drawEnglish() {
  textSize(30);
  for(int i = 0; i < words.length; i++){
    text(words[i][0],10+width*(i%5)/5,height*floor(i/5)/4+height/16);
  }
}

void drawWords() {
  for(int i = 0; i < words.length; i++){
    textSize(30);
    text(words[i][0],10+width*(i%5)/5,height*floor(i/5)/4+height/16);
    textSize(20);
    text(words[i][1],10+width*(i%5)/5,height*floor(i/5)/4+height/8);
  }
}

void drawAnsWindow(int x) {
  fill(240);
  rect(x,10,2*width/5-20,height-20);
  fill(0);
  stroke(0);
  for(int i = 0; i < 4; i++){
    line(x+i*(2*width/5-20)/3,10,x+i*(2*width/5-20)/3,height-10);
  }
  for(int i = 0; i < 8; i++){
    line(x,i*(height-20)/7+10,x+2*width/5-20,i*(height-20)/7+10);
  }
  for(int i = 0; i < words.length; i++){
    text(words[intFindFromArray(wordPos,i)][1],tx+(i%3)*(2*width/5-20)/3+10,40+(height-20)*floor(i/3)/7);
  }
  noFill();
  stroke(255, 255, 0);
  rect((selector%5)*width/5,floor(selector/5)*height/4,width/5,height/4);
  noStroke();
  fill(0);
}

void drawAnswer() {
  for(int i = 0; i < words.length; i++){
    textSize(20);
    if(intFindFromArray(wordPos,ans[i])>=0){
      text(words[intFindFromArray(wordPos,ans[i])][1],10+width*(i%5)/5,height*floor(i/5)/4+height/8);
    }
  }
}

int intFindFromArray(int[] ar, int se){
  for(int i = 0; i < ar.length; i++){
    if(ar[i]==se){
      return i;
    }
  }
  return -1;
}

void drawEndCheckWindow(){
  selector=-1;
  tx=-1;
  fill(240);
  rect(width/2-160, height/2-60, 320, 120);
  fill(0);
  text("答え合わせをしますか？\nはい→enter\nいいえ→画面のどこかをクリック",width/2-150,height/2-35);
}

void checkAns(){
  for(int i = 0; i < words.length; i++){
    if(ans[i]==wordPos[i]){
      checkedAns[i]=true;
    } else {
      checkedAns[i]=false;
    }
  }
}

void showResult(){
  for(int i = 0; i < words.length; i++){
    if(checkedAns[i]){
      noFill();
      stroke(255, 0, 0);
      circle((2*(i%5)+1)*width/10,(2*floor(i/5)+1)*height/8,120);
      fill(255);
    }
  }
}
