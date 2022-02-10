import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';

//Widget _buildCropImage(imageFile) {
//  return Container(
//    color: Colors.black,
//    padding: const EdgeInsets.all(20.0),
//    child: Crop(
//      key: cropKey,
//      image: Image.file(imageFile),
//      aspectRatio: 4.0 / 3.0,
//    ),
//  );
//}

Future<File> croppedImage(imageFile) async {
  File croppedFile = await ImageCropper.cropImage(
    sourcePath: imageFile.path,
    androidUiSettings: AndroidUiSettings(
      toolbarTitle: 'Crop',
      toolbarColor: Colors.deepOrange,
      toolbarWidgetColor: Colors.white,
      initAspectRatio: CropAspectRatioPreset.original,
      lockAspectRatio: true,
    ),
    aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
    iosUiSettings: IOSUiSettings(
      minimumAspectRatio: 1.0,
    ),
  );

  return croppedFile;
}
