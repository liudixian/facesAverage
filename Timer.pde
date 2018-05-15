class Timer {
  int t_;    //剩余时间
  int passedtime;    
  int totaltime;      //
  boolean l;
  Timer() {
    l = false;
  }

  boolean shedule(int deTime_) {
    totaltime = deTime_;
    if (millis() -passedtime < totaltime) {
       t_ = millis()-passedtime;

      return true;
    } else {
      return false;
    }
  }

  void update(char s) {
   if(keyPressed && key == s){
     l = true;
   }
    if (l) {
      passedtime =millis();
      l = false;
    }
  }
  
  int getSheduleT(){
    return t_;
  }
}