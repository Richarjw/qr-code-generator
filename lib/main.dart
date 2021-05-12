import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScreenshotController screenshot = ScreenshotController();

  String content;

  @override
  void initState() {
    super.initState();
    isLight = true;
  }

  bool isLight;

  double get height => 100;
  double get size => 200;

  Color get bgLight => Color(0xffecf0f3);
  Color get bgDark => Color(0xff292d32);

  BoxShadow get shadow1 => BoxShadow(
      blurRadius: 30, offset: Offset(18, 18), color: Color(0xffd1d9e6));

  BoxShadow get shadow2 => BoxShadow(
      blurRadius: 30, offset: Offset(-18, -18), color: Color(0xffffffff));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isLight ? bgLight : bgDark,
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(16),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: getImageContainer(),
            ),
            Positioned(bottom: 20, left: 0, right: 0, child: buttonbar)
          ],
        ),
      )),
    );
  }

  getNeomorphic(IconData icon, Function onPressed) {
    return Container(
        child: IconButton(icon: Icon(icon), onPressed: onPressed),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            boxShadow: [shadow1, shadow2],
            borderRadius: BorderRadius.circular(8),
            color: isLight ? bgLight : bgDark));
  }

  get buttonbar {
    return ButtonBar(
        buttonHeight: height,
        alignment: MainAxisAlignment.spaceAround,
        children: [
          getNeomorphic(Icons.share, onSharePressed),
          getNeomorphic(Icons.paste, onPastePressed)
        ]);
  }

  get uuid => Uuid().v1();

  onSharePressed() async {
    Uint8List image = await screenshot.capture();

    final directory = (await getApplicationDocumentsDirectory()).path;

    try {
      File file = new File('$directory/$uuid.png');

      file = await file.writeAsBytes(image);

      await Share.shareFiles([file.path]);
    } catch (error) {
      throw (error);
    }
    try {} catch (error) {
      throw (error);
    }
  }

  onPastePressed() async {
    var paste = await FlutterClipboard.paste();
    setState(() {
      content = paste;
    });
  }

  getImage() {
    return content == null
        ? Container(
            width: size,
            height: size,
            child: Text("COPY A URL"),
            alignment: Alignment.center,
          )
        : QrImage(
            data: content,
            version: QrVersions.auto,
            size: size,
          );
  }

  getImageContainer() {
    return Container(
      child: Screenshot(
        child: getImage(),
        controller: screenshot,
      ),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          boxShadow: [shadow1, shadow2],
          borderRadius: BorderRadius.circular(8),
          color: isLight ? bgLight : bgDark),
    );
  }
}
