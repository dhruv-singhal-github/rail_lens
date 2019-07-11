import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as impkg;
import 'dart:async';

const _imageSizeLimit = 500000;
const int _jpgQuality = 100;


//Use the function below to call compressImageFile


///Use compute to call this function in another isolate
///The first value in filePair is the original image file
///The second value is the new file to which the compressed image
///will be written
void compressImageFile (List<File> filePair) {
  var originalImageFile = filePair[0];
  var newImageFile = filePair[1] ;
  impkg.Image image = impkg.decodeImage(originalImageFile.readAsBytesSync());
  var size = image.length;
  double resizeFactor = 1;
  if (size > _imageSizeLimit) {
    resizeFactor = size / _imageSizeLimit;
  }
  print('resize factor is $resizeFactor');
  int newHeight = image.height ~/ resizeFactor;
  var resizedImage = impkg.copyResize(image, height: newHeight);
  newImageFile
      .writeAsBytesSync(impkg.encodeJpg(resizedImage, quality: _jpgQuality));
  return;
}
