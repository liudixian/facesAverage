/* 人脸识别-拍照程序 //<>//
  问题：识别人脸有点闪烁
*/

import processing.net.*;
import controlP5.*;
import java.util.*;
import java.text.*;
import java.text.SimpleDateFormat;
import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import processing.serial.*;


Capture video;
OpenCV opencv;
ControlP5 cp5;
Accordion accordion;
Shoot shoot;
Timer timer;
Server server;

boolean ifShoot = false;
String bufferPath = "data/";
String facesPath = "newpic/";
boolean ifSure = false;
boolean ifshow = false;
boolean notSure = false;
boolean timebegin = false;
boolean ifthanks = false;
PFont mono, fz;
String incomeMessage= "";

void setup() {
  size(640, 480);
  //gui();
  video = new Capture(this, width, height);
  opencv = new OpenCV(this, width, height);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  video.start();
  shoot = new Shoot(facesPath, bufferPath);      //照相器
  mono = createFont("04b24-48", 32);
  //fz = loadFont("SimHei-48.vlw",48);
  fz = createFont("04b24-48", 32);
  timer = new Timer();
  server = new Server(this, 6200);
  textFont(fz);
}

void draw() {

  //显示
  display();
  //判断是否有人
  Rectangle[] faces = opencv.detect();
  if (faces.length != 0  ) {
    //显示提醒界面
    if(ifShoot ==false)
    showTip();
    
    if (ifShoot || ifshow) {
      //倒计时画面
      //缓存图片
      if (ifShoot) {
        timer.update('s');
        if (timer.shedule(3000) ) {
          //int t = savetime - passedtime;
          //println(passedtime, savetime, millis());
          fill(255,80);
          stroke(255);
          //rect(30, 30, 50, 50);
          textSize(56);
          if (timer.getSheduleT()<1000) {
            text("3", width/2, height/2);
          } else if (timer.getSheduleT() < 2000 && timer.getSheduleT()>=1000) {
            text("2", width/2, height/2);
          } else if ( timer.getSheduleT()>=2000 &&  timer.getSheduleT()<3000 ) {
            text("1", width/2, height/2);
          }
        }else {
           println(timer.getSheduleT());
            shoot.saveBuffer();
            ifShoot = false;
            ifshow = true;
            //想客户端发送'已存入'消息
             sendMessageToClient();
        }
      }
    //显示拍下的照片
    showBuffer(ifshow);

      //}
    } else if (ifSure || timer.shedule(2000)) {
      if(ifSure){
      shoot.updateTime();
      shoot.saveFace();
      shoot.showPic();
      ifSure = false;
      }
      //显示上传成功！
      timer.update('y');
      if(timer.shedule(2000)){
      stroke(255);
      fill(255);
      rect(0, 0, width*2, height*2);
      fill(0);
      textSize(34);
      text("上传成功！谢谢！", width/2, height/2);
      }
    }
  } else if (faces.length >=2) {
    //显示文字
    textSize(32);
    text("请确保镜头内只有一人！",width/2,height/2);
  } else {
    //默认事件
  }
  
  //println(faces.length);
}

void serverEvent(Server server, Client client){
  incomeMessage = "new Client connected: " + client.ip();
  println(incomeMessage);
  
}


void sendMessageToClient(){
   Client client = server.available();
            if(client != null){
            server.write("seved!\n");
            println("已存入库！");
            }
}


void showBuffer(boolean ifshow_) {
  //覆盖video
  if (ifshow_) {
    //显示缓存图片
    shoot.showPic();
    //显示选项
    pushMatrix();
    translate(width/2, height/2);
    textAlign(CENTER, BOTTOM);
    fill(255);
    textSize(14);
    text("确定上传这张吗？", 0, height/2-10);
    fill(255, 0, 0);
    text("Y", 104, height/2-10);
    text("N", -104, height/2-10);
    popMatrix();
  }
}


void showTip() {
  if (!keyPressed) {
    pushMatrix();
    translate(width/2, height/2);
    fill(255);
    textAlign(CENTER);
    textSize(14);
    text("按's'键以拍照", 0, height/2-10);
    rectMode(CENTER);
    noFill();
    stroke(0, 0, 0, 80);
    strokeWeight(4);
    rect(0, 0, 300, 360);
    popMatrix();
  }
}
void keyPressed() {
  if (key=='s') {
    ifShoot = true;
    //ifshow = true;
  } else if ( key == 'y') {
    ifSure = true;
    ifshow = false;
  } else if (key == 'n') {
    ifshow = false;
    notSure = true;
  }
}


void display() {
  opencv.loadImage(video);
  image(video, 0, 0);
  //drawShape(20, 20, 300, 300);
}

void captureEvent(Capture c) {
  c.read();
}

//void drawShape(int x, int y, int x0, int y0) {
//  rect(0, 0, x, y+y0);
//  rect(x, 0, width, y);
//  rect(x+x0, y, width, height);
//  rect(0, y+y0, x+x0, height);
//}

/////////////////////////////////////////////-----------------图形界面------------------////////////////////////////////////////////

//void gui() {
//  cp5 = new ControlP5(this);

//  Group g1 = cp5.addGroup("camera")
//    .setBackgroundColor(color(0, 64))
//    .setBackgroundHeight(50)
//    ;
//  cp5.addSlider("面积")
//    .setPosition(50, 10)
//    .setSize(60, 20)
//    .setRange(0, 150)
//    .setValue(110)
//    .moveTo(g1)
//    ;

//  cp5.addRadioButton("time")
//    .setPosition(0, 10)
//    .setSize(20, 20)
//    .addItem("3秒", 0)
//    .addItem("5秒", 1)
//    .addItem("8秒", 2)
//    .addItem("10秒", 3)
//    .activate(1)
//    .moveTo(g1)
//    ;




//  accordion = cp5.addAccordion("acc")
//    .setPosition(20, 20)
//    .setWidth(150)
//    .addItem(g1)
//    ;

//  //accordion.open(0, 1, 2);
//  //accordion.setCollapseMode(Accordion.MULTI);
//}

//void time(int time) {
//  switch(time) {
//    case(0):
//    t=3000;
//    break;
//    case(1):
//    t=5000;
//    break;
//    case(2):
//    t=8000;
//    break;
//    case(3):
//    t=10000;
//    break;
//  }
//} 
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////