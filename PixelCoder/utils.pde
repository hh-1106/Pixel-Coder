import drop.*;


void dropEvent(DropEvent theDropEvent) {

  if ( theDropEvent.isImage() ) {
    println("--- loading image ---");
    srcImg = theDropEvent.loadImage();

    delay(DROP_IMG_DELAY);

    println("img size:", srcImg.width, srcImg.height);
    //srcImg.resize(PREV_PG_MAX_WIDTH, 0);
    srcImg.resize(1920, 0);

    previewPG = createGraphics(srcImg.width, srcImg.height);
    UIM.onPixelateChange( PAG.scl );
  }
}
