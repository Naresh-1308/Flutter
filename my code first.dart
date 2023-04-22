main.dart file is downside

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _loading;
  File _image;
  List _outputs;
  final _imagePicker = ImagePicker();

  void initState() {
    super.initState();
      _loading = true;

      loadModel().then((value) {
        setState( () {
          _loading = false;
        });
      });
  }
  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  pickImage() async {
    var image = await _imagePicker.getImage(source: ImageSource.camera);
    if (image == null) return null;
    setState(() {
      _loading = true;
      _image = File(image.path);
    });
    classifyImage(_image);
  }

  // Classify the image selected

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    setState(() {
      _loading = false;
      // Declare List _outputs in the class which will be used to show the classified class name and confidence
      _outputs = output;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Food Image Recogniser"),
      ),
      body: _loading
          ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
      )
    : Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image == null
            // if image is null then will show a empty container
                ? Container(
                    child: Text("Please choose a valid image"),
            )
                : Container(
                    child: Image.file(_image),
                    height: 500,
                    width: MediaQuery.of(context).size.width,
                  ),
            SizedBox(
              height: 20,
            ),
            _outputs != null
                ? Text(
                    "${_outputs[0]["label"]}".replaceAll(RegExp(r'[0-10]'), ''),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      background: Paint()..color = Colors.white,
                      fontWeight: FontWeight.bold
                    ),
            )
                : Text("WAITING")
          ],
        ),
      ) ,
    floatingActionButton: FloatingActionButton(
      onPressed: pickImage,
      tooltip: 'Increment',
      child: Icon(Icons.add),
    ),
    );
  }
}



ERRORS

The plugin `tflite` uses a deprecated version of the Android embedding.
To avoid unexpected runtime failures, or future build failures, try to see if this plugin supports the Android V2 embedding. Otherwise, consider removing it since a future release of Flutter will remove these deprecated APIs.
If you are plugin author, take a look at the docs for migrating the plugin to the V2 embedding: https://flutter.dev/go/android-plugin-migration.
Launching lib\main.dart on M2007J20CI in debug mode...
Running Gradle task 'assembleDebug'...
lib/main.dart:77:18: Error: A value of type 'List<dynamic>?' can't be assigned to a variable of type 'List<dynamic>' because 'List<dynamic>?' is nullable and 'List<dynamic>' isn't.
 - 'List' is from 'dart:core'.
      _outputs = output;
                 ^
lib/main.dart:31:8: Error: Field '_loading' should be initialized because its type 'bool' doesn't allow null.
  bool _loading;
       ^^^^^^^^
lib/main.dart:32:8: Error: Field '_image' should be initialized because its type 'File' doesn't allow null.
 - 'File' is from 'dart:io'.
  File _image;
       ^^^^^^
lib/main.dart:33:8: Error: Field '_outputs' should be initialized because its type 'List<dynamic>' doesn't allow null.
 - 'List' is from 'dart:core'.
  List _outputs;
       ^^^^^^^^
Target kernel_snapshot failed: Exception


FAILURE: Build failed with an exception.

* Where:
Script 'C:\src\flutter_windows_3.7.7-stable\flutter\packages\flutter_tools\gradle\flutter.gradle' line: 1151

* What went wrong:
Execution failed for task ':app:compileFlutterBuildDebug'.
> Process 'command 'C:\src\flutter_windows_3.7.7-stable\flutter\bin\flutter.bat'' finished with non-zero exit value 1

* Try:
> Run with --stacktrace option to get the stack trace.
> Run with --info or --debug option to get more log output.
> Run with --scan to get full insights.

* Get more help at https://help.gradle.org

BUILD FAILED in 41s
Exception: Gradle task assembleDebug failed with exit code 1
