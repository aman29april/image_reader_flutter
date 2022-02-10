import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagereader/edit_text_screen.dart';
import 'package:imagereader/utils/crop_image.dart';
import 'package:imagereader/utils/export_image.dart';
import 'package:imagereader/utils/scanner_utils.dart';
import 'package:recase/recase.dart';
import 'dart:io';
import 'components/btns.dart';
import 'filters.dart';
import "utils/string_extension.dart";

import 'package:screenshot/screenshot.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image to Text',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Image to Text'),
    );
  }
}

enum TextCase { sentence, title, upper, lower }

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int _counter = 0;
  CameraController _camera;
  bool _isDetecting = false;

//  VisionText _textScanResults;

//  int _cameraOcr = FlutterMobileVision.CAMERA_BACK;
  bool _autoFocusOcr = true;
  bool _torchOcr = false;
  bool _multipleOcr = false;
  bool _waitTapOcr = false;
  bool _showTextOcr = true;
  bool colorVisibility = false;
  Size _previewOcr;
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Colors.black;
  Color backgroundColor = Colors.transparent;
  List currentAlignment;
//  List<OcrText> _textsOcr = [];
  bool _isEditingText = false;
  TextEditingController _editingController = TextEditingController(text: '');
  Offset offset = Offset(70, 70);
  double textSize = 12;
  ScreenshotController screenshotController = ScreenshotController();
  bool isBold, isItalic, isQuoted;
  List<String> backgroundImages = [
    'assets/images/kindle.jpg',
  ];
  List alignments = [
    [FontAwesomeIcons.alignLeft, TextAlign.left],
    [FontAwesomeIcons.alignCenter, TextAlign.center],
    [FontAwesomeIcons.alignRight, TextAlign.right],
  ];
//  TextRecognizer _textRecognizer = FirebaseVision.instance.textRecognizer();

  TabController _controller;
  double paintAreaHeight;
  double settingsHeight;
  CameraLensDirection _direction = CameraLensDirection.back;
  File pickedImage;
  var text = '';
  bool imageLoaded = false;
  int currentCaseIndex = 0;
  List currentCase;
  List allCases = [
    ['Sentence case', TextCase.sentence],
    ['Title Case', TextCase.title],
    ['UPPER CASE', TextCase.upper],
    ['lower case', TextCase.lower]
  ];

  List allFonts = [
    ['Roboto', TextCase.sentence],
    ['Lato', TextCase.title],
    ['Lora', TextCase.upper],
    ['Concert One', TextCase.lower],
    ['Gravitas One'],
    ['Anton'],
    ['Shadows Into Light'],
    ['Qwigley'],
    ['Lobster'],
    ['Six Caps'],
    ['Sail'],
    ['Cormorant Garamond'],
    ['Varela Round'],
    ['Permanent Marker'],
    ['Shrikhand'],
    ['Hind'],
    ['Yatra One'],
    ['Special Elite'],
    ['Lekton'],
    ['Courier Prime'],
    ['Cutive Mono']
  ];
  List currentFont;
  String currentImage;

  @override
  void initState() {
    _editingController = TextEditingController(text: text);
    currentAlignment = alignments[0];
    currentCase = allCases[0];
    isBold = isItalic = isQuoted = false;
    _controller = new TabController(length: 2, vsync: this);
    currentImage = backgroundImages[0];

    for (int i = 1; i <= 34; i++) {
      backgroundImages.add('assets/images/image$i.jpg');
    }

//    paintAreaHeight = MediaQuery.of(context).size.width;
    settingsHeight = 250;
//    settingsHeight = MediaQuery.of(context).size.height - paintAreaHeight;
    currentFont = allFonts[0];
    super.initState();

//    _initializeCamera();

//    FlutterMobileVision.start().then((previewSizes) => setState(() {
////      _previewBarcode = previewSizes[_cameraBarcode].first;
//          _previewOcr = previewSizes[_cameraOcr].first;
////      _previewFace = previewSizes[_cameraFace].first;
//        }));
  }

  void _initializeCamera() async {
//    final CameraDescription description =
//        await ScannerUtils.getCamera(_direction);

//    _camera = CameraController(
//      description,
//      ResolutionPreset.high,
//    );

    await _camera.initialize();

    _camera.startImageStream((CameraImage image) {
      // Here we will scan the text from the image
      // which we are getting from the camera.
      if (_isDetecting) return;

      setState(() {
        _isDetecting = true;
      });

//      ScannerUtils.detect(
//        image: image,
//        detectInImage: _getDetectionMethod(),
//        imageRotation: description.sensorOrientation,
//      ).then(
//        (results) {
//          setState(() {
//            if (results != null) {
//              setState(() {
////                _textScanResults = results;
//              });
//            }
//          });
//        },
//      ).whenComplete(() => _isDetecting = false);
    });
//    });
  }

//  Future<VisionText> Function(FirebaseVisionImage image) _getDetectionMethod() {
//    return _textRecognizer.processImage;
//  }

  void _incrementCounter() {
//    _initializeCamera();
//    _read();
    pick();
//    setState(() {
//      // This call to setState tells the Flutter framework that something has
//      // changed in this State, which causes it to rerun the build method below
//      // so that the display can reflect the updated values. If we changed
//      // _counter without calling setState(), then the build method would not be
//      // called again, and so nothing would appear to happen.
//      _counter++;
//    });
  }

  Future<void> pick() async {
    var awaitImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    pickedImage = awaitImage;
    imageLoaded = true;

    FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(pickedImage);

    TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
    VisionText visionText = await textRecognizer.processImage(visionImage);
    text = '';
    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          setState(() {
            text = text + word.text + ' ';
          });
        }
        text = text + '\n';
      }
      _editingController.text = text;
    }
    textRecognizer.close();

    setState(() {});
  }

  ///
  /// OCR Method
  ///
//  Future<Null> _read() async {
//    List<OcrText> texts = [];
//    try {
//      texts = await FlutterMobileVision.read(
//        flash: _torchOcr,
//        autoFocus: _autoFocusOcr,
//        multiple: _multipleOcr,
//        waitTap: _waitTapOcr,
//        showText: _showTextOcr,
//        preview: _previewOcr,
//        camera: _cameraOcr,
//        fps: 2.0,
//      );
//    } on Exception {
//      texts.add(OcrText('Failed to recognize text.'));
//    }
//
//    if (!mounted) return;
//
//    setState(() => _textsOcr = texts);
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            tooltip: 'Edit',
            icon: const Icon(Icons.edit),
            //Don't block the main thread
            onPressed: () async {
              String str = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditTextScreen(text: text),
                ),
              );
              text = str ?? '';
              setState(() {
                text = text.capitalize();
              });
            },
          ),
          IconButton(
            tooltip: 'Edit',
            icon: const Icon(Icons.keyboard_arrow_right),
            //Don't block the main thread
            onPressed: () async {
              await saveWidgetAsImg(screenshotController);
              setState(() {});
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Screenshot(
              controller: screenshotController,
              child: Container(
                constraints: BoxConstraints.expand(
                  height: MediaQuery.of(context).size.width,
                ),
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage(currentImage),
                        colorFilter: ColorFilter.mode(
                          Colors.black54.withOpacity(0.0),
                          BlendMode.hardLight,
                        ),
                        fit: BoxFit.cover,

//                      colorBlendMode: BlendMode.overlay,
//                      filterQuality: FilterQuality.high,
                      )),
                    ),
                    Positioned(
                      left: offset.dx,
                      top: offset.dy,
                      width: MediaQuery.of(context).size.width,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(
                            () {
                              Offset _offset = Offset(
                                  offset.dx + details.delta.dx,
                                  offset.dy + details.delta.dy);

//                              if (_offset.dx >= 30 && _offset.dy >= 30)
                              offset = _offset;
//                              print(offset);
                            },
                          );
                        },
                        child: buildSelectableText(),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
//              margin: EdgeInsets.only(top: 15),
//              padding: EdgeInsets.only(left: 15, right: 15, top: 10),
//              decoration: BoxDecoration(
//                  border: Border(
//                top: BorderSide(width: 0.5, color: Colors.grey),
//              )),
//              height: 40,
              child: Container(
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).size.width -
                    100,
                child: Navigator(
                  onGenerateRoute: (RouteSettings settings) {
                    return new MaterialPageRoute(builder: (context) {
                      return MaterialApp(
                        home: Scaffold(
                            backgroundColor: Colors.transparent,
                            body: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Flexible(
                                      flex: 1,
                                      child: IconButton(
                                        icon: Icon(FontAwesomeIcons.arrowLeft),
                                        onPressed: () {
                                          if (Navigator.of(context).canPop())
                                            Navigator.of(context).pop();
                                        },
                                      ),
                                    ),
                                    Flexible(
                                      flex: 5,
                                      child: TabBar(
                                        controller: _controller,
                                        indicatorSize: TabBarIndicatorSize.tab,
                                        indicatorColor: Colors.blueGrey,
                                        labelColor: Colors.blueGrey,
                                        tabs: <Widget>[
                                          Tab(
                                            text: 'Background',
                                          ),
                                          Tab(
                                            text: 'Text',
                                          ),
                                        ], //Widget
                                      ),
                                    )
                                  ],
                                ),
                                Expanded(
                                  child: TabBarView(
                                      physics: NeverScrollableScrollPhysics(),
                                      controller: _controller,
                                      children: [
                                        Container(
                                          child: Container(
                                            child: GridView.count(
                                              crossAxisCount: 4,
                                              padding: EdgeInsets.all(10),
                                              children: backgroundGridItems(),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(15),
                                          child: Column(
                                            children: <Widget>[
                                              Visibility(
                                                visible: colorVisibility,
                                                child: Column(
                                                  children: <Widget>[
                                                    Container(
                                                      height: 120,
                                                      child:
                                                          MaterialColorPicker(
                                                        circleSize: 30,
                                                        onColorChange:
                                                            (Color color) {
                                                          // Handle color changes
                                                          currentColor = color;
                                                          setState(() {});
                                                        },
                                                        selectedColor:
                                                            currentColor,
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 25,
                                                      child: IconButton(
                                                        icon: Icon(
                                                          FontAwesomeIcons
                                                              .solidStickyNote,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            colorVisibility =
                                                                false;
                                                          });
                                                        },
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                visible: !colorVisibility,
                                                child: Row(
                                                  children: <Widget>[
                                                    Flexible(
                                                      flex: 1,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            colorVisibility =
                                                                true;
                                                          });
                                                        },
                                                        child: Container(
                                                          constraints:
                                                              BoxConstraints
                                                                  .expand(
                                                            width: 25,
                                                            height: 25,
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                            color: currentColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Flexible(
                                                      flex: 6,
                                                      child: Container(
                                                        child: Row(
                                                          children: <Widget>[
                                                            Flexible(
                                                              child: Slider(
                                                                min: 1,
                                                                max: 34,
                                                                value: textSize,
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    textSize =
                                                                        value;
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                            Container(
                                                              width: 20,
                                                              child: Text(
                                                                textSize
                                                                    .toInt()
                                                                    .toString(),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                visible: !colorVisibility,
                                                child: Row(
                                                  children: <Widget>[
                                                    Flexible(
                                                      flex: 2,
                                                      child: DropdownButton(
                                                        value: currentCase,
                                                        underline: SizedBox(),
                                                        onChanged: (value) {
                                                          currentCase = value;
                                                          switch (
                                                              currentCase[1]) {
                                                            case TextCase.lower:
                                                              text = text
                                                                  .toLowerCase();
                                                              break;
                                                            case TextCase.upper:
                                                              text = text
                                                                  .toUpperCase();
                                                              break;
                                                            case TextCase
                                                                .sentence:
                                                              text = ReCase(
                                                                      text)
                                                                  .sentenceCase;
                                                              break;
                                                            case TextCase.title:
                                                              text = ReCase(
                                                                      text)
                                                                  .titleCase;
                                                              break;
                                                          }
                                                          setState(() {});
                                                        },
                                                        items: allCases
                                                            .map(
                                                              (t) =>
                                                                  DropdownMenuItem(
                                                                value: t,
                                                                child:
                                                                    Text(t[0]),
                                                              ),
                                                            )
                                                            .toList(),
                                                      ),
                                                    ),
                                                    Flexible(
                                                      flex: 1,
                                                      child: Container(
                                                        child: SelectButton(
                                                          icon: FontAwesomeIcons
                                                              .bold,
                                                          isOn: isBold,
                                                          onColor: Colors
                                                              .blueAccent
                                                              .shade100,
                                                          offColor: Colors
                                                              .transparent,
                                                          onTap: () {
                                                            setState(() {
                                                              isBold = !isBold;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    Flexible(
                                                      flex: 1,
                                                      child: Container(
                                                        child: SelectButton(
                                                          icon: FontAwesomeIcons
                                                              .italic,
                                                          isOn: isItalic,
                                                          onColor: Colors
                                                              .blueAccent
                                                              .shade100,
                                                          offColor: Colors
                                                              .transparent,
                                                          onTap: () {
                                                            setState(() {
                                                              isItalic =
                                                                  !isItalic;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    Flexible(
                                                      flex: 1,
                                                      child: Container(
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            int index = alignments
                                                                    .indexOf(
                                                                        currentAlignment) +
                                                                1;
                                                            int i = index >=
                                                                    alignments
                                                                        .length
                                                                ? 0
                                                                : index;
                                                            currentAlignment =
                                                                alignments[i];
                                                            setState(() {});
                                                          },
                                                          child: Icon(
                                                              currentAlignment[
                                                                  0]),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                visible: !colorVisibility,
                                                child: Row(
                                                  children: <Widget>[
                                                    Flexible(
                                                      flex: 2,
                                                      child: DropdownButton(
                                                        value: currentFont,
                                                        underline: SizedBox(),
                                                        onChanged: (value) {
                                                          currentFont = value;

                                                          setState(() {});
                                                        },
                                                        items: allFonts
                                                            .map(
                                                              (t) =>
                                                                  DropdownMenuItem(
                                                                value: t,
                                                                child: Text(
                                                                  t[0],
                                                                  style: GoogleFonts
                                                                      .getFont(
                                                                    t[0],
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                            .toList(),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ]),
                                ),
                              ],
                            )), //TabBarView
                      );
                    });
                  },
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  List<Widget> backgroundGridItems() {
    List<Widget> items = [];
    items.add(
      GestureDetector(
        onTap: () async {
          var awaitImage =
              await ImagePicker.pickImage(source: ImageSource.gallery);
          if (awaitImage == null) return;

          File croppedFile = await croppedImage(awaitImage);
          if (croppedFile == null) return;
          currentImage = croppedFile.path;
          setState(() {});
        },
        child: Container(
          child: Container(
            height: 20,
            width: 10,
            padding: EdgeInsets.all(25),
            child: SvgPicture.asset(
              'assets/images/icons/add-image.svg',
              fit: BoxFit.contain,
              width: 20,
              semanticsLabel: 'Add image',
            ),
          ),
        ),
      ),
    );

    items.add(GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FilterScreen(),
          ),
        );
        setState(() {});
      },
      child: Container(
        padding: EdgeInsets.all(30),
        child: SvgPicture.asset('assets/images/icons/filters.svg',
            semanticsLabel: 'Add image'),
      ),
    ));

    items.addAll(backgroundImages
        .map(
          (image) => GestureDetector(
            onTap: () {
              currentImage = image;
              setState(() {});
            },
            child: Container(
              padding: EdgeInsets.all(5),
              child: Image(
                image: AssetImage(image),
                fit: BoxFit.fill,
                width: double.infinity,
              ),
            ),
          ),
        )
        .toList());
    return items;
  }

  void setCase(value) {
    setState(() {
      currentCase = value;
      switch (value[1]) {
        case TextCase.lower:
          text = text.toLowerCase();
          break;
        case TextCase.upper:
          text = text.toUpperCase();
          break;
        case TextCase.sentence:
          text = ReCase(text).sentenceCase;
          break;
        case TextCase.title:
          text = ReCase(text).titleCase;
          break;
      }
    });
  }

  Widget buildSelectableText() {
    if (_isEditingText)
      return Container(
        height: 200,
        width: 250,
        child: TextField(
          onSubmitted: (newValue) {
            setState(() {
              text = newValue;
              _isEditingText = false;
            });
          },
          autofocus: true,
          controller: _editingController,
          maxLines: 20,
        ),
      );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
//        Row(
//          mainAxisAlignment: MainAxisAlignment.start,
//          children: <Widget>[
//            Container(
//              child: Icon(FontAwesomeIcons.quoteLeft),
////              width: MediaQuery.of(context).size.width,
//              alignment: Alignment.topLeft,
//            )
//          ],
//        ),
        Wrap(
          direction: Axis.horizontal,
          children: <Widget>[
            RichText(
                textAlign: currentAlignment[1],
                softWrap: true,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: text,
                      style: GoogleFonts.getFont(
                        currentFont[0],
                        color: currentColor,
                        fontSize: textSize,
                        fontWeight:
                            isBold ? FontWeight.bold : FontWeight.normal,
                        fontStyle:
                            isItalic ? FontStyle.italic : FontStyle.normal,
                        backgroundColor: backgroundColor,
                      ),
                    )
                  ],
                )),
          ],
        ),

//        Row(
//          mainAxisAlignment: MainAxisAlignment.end,
//          children: <Widget>[
//            Container(
////              margin: EdgeInsets.only(right: 105),
//              child: Icon(FontAwesomeIcons.quoteRight),
//              alignment: Alignment.topRight,
//            )
//          ],
//        )
      ],
    );
  }

  void changeColor(Color color) {
    setState(() => currentColor = color);
  }

  void _openMainColorPicker() async {
    _openDialog(
      "Main Color picker",
      MaterialColorPicker(
        selectedColor: currentColor,
        allowShades: false,
        onMainColorChange: (color) => setState(() => currentColor = color),
      ),
    );
  }

  void _openDialog(String title, Widget content) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text(title),
          content: content,
          actions: [
            FlatButton(
              child: Text('CANCEL'),
              onPressed: Navigator.of(context).pop,
            ),
            FlatButton(
              child: Text('SUBMIT'),
              onPressed: () {
                Navigator.of(context).pop();
//                setState(() => currentColor = _tempMainColor);
////                setState(() => _shadeColor = _tempShadeColor);
              },
            ),
          ],
        );
      },
    );
  }
}
