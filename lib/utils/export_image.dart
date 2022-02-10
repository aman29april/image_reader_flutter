import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:ui' as ui;

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

import 'notifications.dart';

Future saveWidgetAsImg(ScreenshotController screenshotController) async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String appDocPath = appDocDir.path;
  String fileName = DateTime.now().toIso8601String();
  String path = '$appDocPath/$fileName.png';
  bool perGranted = await Permission.storage.status.isGranted;
  if (perGranted) {
    screenshotController.capture(pixelRatio: 1.5).then((File image) async {
      await ImageGallerySaver.saveImage(
        image.readAsBytesSync(),
        quality: 100,
      );
//      showAppToast("Saved to your device.");
    });
  } else {
    bool isShown = await Permission.storage.shouldShowRequestRationale;
    if (!isShown) {
//      showAppToast("Permission not granted");
      print("Permission not granted");
    }
    print("permission issue");
  }
}

Future<Uint8List> captureImage(GlobalKey globalKey) async {
  try {
    RenderRepaintBoundary boundary =
        globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    var pngBytes = byteData.buffer.asUint8List();
    var bs64 = base64Encode(pngBytes);
    print(pngBytes);
    print(bs64);
    return pngBytes;
  } catch (e) {
    print(e);
  }
}
