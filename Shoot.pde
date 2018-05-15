class  Shoot {

  PImage b;
  Date dateNow;
  SimpleDateFormat  sdfNow;
  String now = "";
  String facesPath;
  String bufferP;

  Shoot(String facesPath_, String bufferpath_) {
    facesPath = facesPath_;
    bufferP = bufferpath_;
    sdfNow = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

 
  }

  void saveBuffer() {
    saveFrame(bufferP+"buffer.jpg");
  }

  void saveFace() {
    PImage b = loadImage(bufferPath+"buffer.jpg");
    String fileName = now;
    //String facePathAndName = path+fileName;
    b.save(facesPath+fileName+".jpg");
    //println(b.save(facesPath+fileName));
  }

  void updateTime() {
    dateNow = new Date();
    now = sdfNow.format(dateNow);
  }
  
  void showPic(){
    PImage pic = loadImage(bufferP+"buffer.jpg");
    image(pic,0,0,pic.width,pic.height);
  }
}